import { IsEnum, IsOptional, IsString } from 'class-validator';

export type RideUpdateStatus = 'accepted' | 'arrived' | 'in_progress' | 'completed' | 'canceled';
export type RideActor = 'rider' | 'driver';

export class UpdateHailingRequestDto {
  @IsEnum(['accepted', 'arrived', 'in_progress', 'completed', 'canceled'])
  @IsOptional()
  status?: RideUpdateStatus;

  @IsEnum(['rider', 'driver'])
  @IsOptional()
  initiated_by?: RideActor;

  @IsEnum(['rider', 'driver'])
  @IsOptional()
  canceled_by?: RideActor;

  @IsString()
  @IsOptional()
  reason?: string;

  @IsString()
  @IsOptional()
  completion_token?: string;

  @IsString()
  @IsOptional()
  pin_code?: string;
}
