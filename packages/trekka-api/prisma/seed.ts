import {
  FuelType,
  PrismaClient,
  ServiceType,
} from '../src/generated/prisma/client';

const prisma = new PrismaClient();

async function main() {
  const driverEmail = 'driver@trekkaweb.com';
  const username = 'trekka-driver';

  const user = await prisma.user.upsert({
    where: { email: driverEmail },
    update: {
      username,
      avatar: 1,
      isEmailVerified: true,
      servicesOffered: {
        set: [ServiceType.RIDE_HAILING],
      },
    },
    create: {
      email: driverEmail,
      username,
      avatar: 1,
      isEmailVerified: true,
      servicesOffered: [ServiceType.RIDE_HAILING],
    },
  });

  await prisma.wallet.upsert({
    where: { userId: user.id },
    update: {},
    create: {
      userId: user.id,
      address: '0.0.5001',
      encryptedKey: 'encrypted-key-placeholder',
    },
  });

  await prisma.rideHailingProvider.upsert({
    where: { userId: user.id },
    update: {
      displayName: 'Trekka Pioneer Driver',
      vehiclePlate: 'TREK-001',
      vehicleModel: 'Toyota Corolla',
      vehicleFuelType: FuelType.PETROL,
    },
    create: {
      userId: user.id,
      displayName: 'Trekka Pioneer Driver',
      vehiclePlate: 'TREK-001',
      vehicleModel: 'Toyota Corolla',
      vehicleFuelType: FuelType.PETROL,
    },
  });
}

main()
  .catch((error) => {
    console.error('Seed failed', error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
