import { IsNotEmpty, IsNumber, IsPositive } from 'class-validator';

export class CreateHailingRequestDto {
  @IsNumber()
  @IsPositive()
  @IsNotEmpty()
  price: number;

  @IsNumber()
  @IsPositive()
  @IsNotEmpty()
  estimated_time_minutes: number;

  @IsNumber()
  @IsPositive()
  @IsNotEmpty()
  distance_km: number;
}

