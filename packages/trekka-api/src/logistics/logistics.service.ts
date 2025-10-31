import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateHailingQuoteDto, CreateHailingRequestDto, UpdateHailingRequestDto, RideActor } from './dto';
import {
  BASE_FARE,
  DEFAULT_CURRENCY,
  MIN_FARE,
  PER_KILOMETER_RATE,
  PER_MINUTE_RATE,
  PRIORITY_FEE,
  ROUNDING_INTERVAL,
  SERVICE_FEE_MAX,
  SERVICE_FEE_MIN,
  SERVICE_FEE_RATE,
  SURGE_MIN,
  VEHICLE_CLASS_MULTIPLIERS,
  VehicleClass,
} from './common';
import { PrismaService } from '../prisma/prisma.service';
import { RideStatus, RideCancellationSource } from '../generated/prisma/client';
import type { Ride } from '../generated/prisma/client';
import { EventsGateway } from '../events/events.gateway';
import { WalletsService } from '../wallets/wallets.service';
import { HederaConsensusService } from '../hedera/consensus.service';

@Injectable()
export class LogisticsService {
  private readonly RIDE_REQUEST_BUFFER_HBAR = 2;
  constructor(
    private prisma: PrismaService,
    private eventsGateway: EventsGateway,
    private walletsService: WalletsService,
    private consensusService: HederaConsensusService,
  ) {}
  calculateHailingQuote(dto: CreateHailingQuoteDto) {
    const distanceKm = Math.max(dto.distanceKm, 0);
    const timeMinutes = Math.max(dto.estimatedTimeMinutes, 0);

    const baseComponent = BASE_FARE;
    const distanceComponent = distanceKm * PER_KILOMETER_RATE;
    const timeComponent = timeMinutes * PER_MINUTE_RATE;
    const baseFare =
      baseComponent + distanceComponent + timeComponent;

    const surgeMultiplier = SURGE_MIN;
    const vehicleMultiplier = this.getVehicleMultiplier(
      dto.vehicleClass,
    );
    const extras = Math.max(dto.extras ?? 0, 0);
    const priorityFee = dto.priority ? PRIORITY_FEE : 0;

    const multipliedFare =
      baseFare * surgeMultiplier * vehicleMultiplier;
    const subtotalBeforeFees = Math.max(multipliedFare, MIN_FARE) +
      extras +
      priorityFee;

    const serviceFee = this.calculateServiceFee(subtotalBeforeFees);

    const totalBeforeRounding =
      subtotalBeforeFees + serviceFee;
    const roundedTotal = this.roundToNearest(
      totalBeforeRounding,
      ROUNDING_INTERVAL,
    );
    const recommendedPrice = Number(
      Math.max(roundedTotal, MIN_FARE).toFixed(1),
    );

    return {
      currency: DEFAULT_CURRENCY,
      recommendedPrice,
      breakdown: {
        baseComponent: Number(baseComponent.toFixed(2)),
        distanceComponent: Number(distanceComponent.toFixed(2)),
        timeComponent: Number(timeComponent.toFixed(2)),
        surgeMultiplier,
        vehicleMultiplier,
        extras: Number(extras.toFixed(2)),
        priorityFee,
        subtotalBeforeFees: Number(
          subtotalBeforeFees.toFixed(2),
        ),
        serviceFee: Number(serviceFee.toFixed(2)),
        totalBeforeRounding: Number(
          totalBeforeRounding.toFixed(2),
        ),
        roundedTotal: Number(roundedTotal.toFixed(2)),
      },
    };
  }

  private getVehicleMultiplier(vehicleClass?: VehicleClass) {
    if (!vehicleClass) {
      return VEHICLE_CLASS_MULTIPLIERS[VehicleClass.NORMAL];
    }
    return (
      VEHICLE_CLASS_MULTIPLIERS[vehicleClass] ??
      VEHICLE_CLASS_MULTIPLIERS[VehicleClass.NORMAL]
    );
  }

  private calculateServiceFee(amount: number) {
    const fee = amount * SERVICE_FEE_RATE;
    const bounded = Math.min(
      Math.max(fee, SERVICE_FEE_MIN),
      SERVICE_FEE_MAX,
    );
    return bounded;
  }

  private roundToNearest(value: number, interval: number) {
    return Math.round(value / interval) * interval;
  }

  private toCreatedHailingResponse(ride: Ride) {
    return {
      id: ride.id,
      status: ride.status.toLowerCase(),
      price: ride.price.toString(),
    };
  }

  private toUpdatedHailingResponse(ride: Ride) {
    return {
      id: ride.id,
      status: ride.status.toLowerCase(),
      reachedDestination: ride.reachedDestination,
    };
  }

  async createHailingRequest(riderId: string, dto: CreateHailingRequestDto) {
    const rideAmountHbar = Number(dto.price);
    const requiredBalance = rideAmountHbar + this.RIDE_REQUEST_BUFFER_HBAR;

    const walletBalance = await this.walletsService.getWalletBalance(riderId);

    if (walletBalance < requiredBalance) {
      throw new BadRequestException({
        code: 'INSUFFICIENT_BALANCE',
        message: 'Insufficient balance to request ride',
        requiredBalance,
        availableBalance: walletBalance,
      });
    }

    const ride = await this.prisma.ride.create({
      data: {
        riderId,
        price: dto.price,
        status: RideStatus.REQUESTED,
      },
    });

    try {
      await this.walletsService.requestRideOnChain(riderId, ride.id, rideAmountHbar);
    } catch (error) {
      await this.prisma.ride.delete({ where: { id: ride.id } }).catch(() => undefined);
      throw error;
    }

    const response = this.toCreatedHailingResponse(ride);

    this.eventsGateway.server.emit('logistics:request:created', {
      ...response,
      riderId: ride.riderId,
    });

    this.simulateMVPFlow(ride.id);

    return response;
  }

  async updateHailingRequest(rideId: string, dto: UpdateHailingRequestDto) {
    const existingRide = await this.prisma.ride.findUnique({ where: { id: rideId } });

    if (!existingRide) {
      throw new NotFoundException('Ride not found');
    }

    const updateData: any = {};
    let shouldSubmitSummary = false;
    let summaryInitiatedBy: RideActor | undefined;

    if (dto.status) {
      const statusMap: Record<string, RideStatus> = {
        accepted: RideStatus.ACCEPTED,
        arrived: RideStatus.ARRIVED,
        in_progress: RideStatus.IN_PROGRESS,
        completed: RideStatus.COMPLETED,
        canceled: RideStatus.CANCELED,
      };

      if (dto.status === 'accepted') {
        throw new BadRequestException('Use the accept endpoint to accept a ride');
      }

      updateData.status = statusMap[dto.status];
    }

    if (dto.status === 'completed') {
      if (!dto.initiated_by) {
        throw new BadRequestException('initiated_by is required when completing a ride');
      }
      updateData.reachedDestination = true;
    }

    if (dto.canceled_by) {
      updateData.canceledBy = dto.canceled_by === 'rider'
        ? RideCancellationSource.RIDER
        : RideCancellationSource.DRIVER;
    }

    if (dto.status === 'canceled') {
      if (!dto.canceled_by) {
        throw new BadRequestException('canceled_by is required when canceling a ride');
      }

      const cancelerId = dto.canceled_by === 'rider' ? existingRide.riderId : existingRide.driverId;

      if (!cancelerId) {
        throw new BadRequestException('No wallet available to cancel this ride');
      }

      await this.walletsService.cancelRideOnChain(cancelerId, rideId, dto.canceled_by);

      if (dto.canceled_by === 'driver') {
        updateData.driverId = null;
      }
    }

    if (dto.status === 'completed') {
      const initiatorId = dto.initiated_by === 'driver' ? existingRide.driverId : existingRide.riderId;

      if (!initiatorId) {
        throw new BadRequestException('No wallet available to complete this ride');
      }

      await this.walletsService.completeRideOnChain(initiatorId, rideId);
      shouldSubmitSummary = true;
      summaryInitiatedBy = dto.initiated_by;
    }

    const ride = await this.prisma.ride.update({
      where: { id: rideId },
      data: updateData,
    });

    const response = this.toUpdatedHailingResponse(ride);

    this.eventsGateway.server.emit('logistics:request:updated', {
      ...response,
      driverId: ride.driverId,
    });

    if (shouldSubmitSummary) {
      const summaryPayload = {
        rideId,
        riderId: ride.riderId,
        driverId: ride.driverId,
        status: ride.status.toLowerCase(),
        initiatedBy: summaryInitiatedBy,
        amountHbar: ride.price.toString(),
        reachedDestination: ride.reachedDestination,
        completedAt: new Date().toISOString(),
      };

      try {
        await this.consensusService.submitRideSummary(summaryPayload);
      } catch (error) {
        console.error('❌ Failed to submit ride summary to Hedera Consensus Service:', error);
      }
    }

    return response;
  }

  async acceptRide(rideId: string, driverId: string) {
    const existingRide = await this.prisma.ride.findUnique({ where: { id: rideId } });

    if (!existingRide) {
      throw new NotFoundException('Ride not found');
    }

    if (existingRide.status !== RideStatus.REQUESTED) {
      throw new BadRequestException('Ride is not available for acceptance');
    }

    await this.walletsService.acceptRideOnChain(driverId, rideId);

    const ride = await this.prisma.ride.update({
      where: { id: rideId },
      data: {
        driverId,
        status: RideStatus.ACCEPTED,
      },
    });
    return ride;
  }

  async getRide(rideId: string) {
    return this.prisma.ride.findUnique({
      where: { id: rideId },
      include: {
        rider: {
          select: {
            id: true,
            username: true,
            avatar: true,
          },
        },
        driver: {
          select: {
            id: true,
            username: true,
            avatar: true,
          },
        },
      },
    });
  }

  async getDummyProvider() {
    return this.prisma.rideHailingProvider.findFirst({
      where: {
        user: {
          email: 'driver@trekkaweb.com',
        },
      },
    });
  }

  private async simulateMVPFlow(rideId: string) {
    const random = (min: number, max: number) => 
      Math.floor(Math.random() * (max - min + 1)) + min;

    setTimeout(async () => {
      const dummyProvider = await this.getDummyProvider();
      if (!dummyProvider) return;

      const ride = await this.acceptRide(rideId, dummyProvider.userId);
      // TODO: Encrypt the completion token from destLat, destLng, radius, issuedAt
      const completionToken = `token-${rideId}-${Date.now()}`;

      this.eventsGateway.server.emit('logistics:request:updated', {
        id: ride.id,
        status: ride.status.toLowerCase(),
        driverId: ride.driverId,
        completion_token: completionToken,
      });

      setTimeout(async () => {
        const arrivedRide = await this.updateHailingRequest(rideId, {
          status: 'arrived',
          initiated_by: 'driver',
        });

        setTimeout(async () => {
          await this.updateHailingRequest(rideId, {
            status: 'in_progress',
            initiated_by: 'driver',
          });
        }, random(3000, 20000));
      }, random(3000, 20000));
    }, random(3000, 20000));
  }
}
