import { Transform } from 'class-transformer';
import {
  IsBoolean,
  IsEnum,
  IsNumber,
  IsOptional,
  Min,
} from 'class-validator';
import { VehicleClass } from '../common';

const toNumber = ({ value }: { value: unknown }) =>
  typeof value === 'string' && value.trim() !== ''
    ? Number(value)
    : value;

const toBoolean = ({ value }: { value: unknown }) => {
  if (typeof value === 'string') {
    return value.toLowerCase() === 'true';
  }
  return value;
};

export class CreateHailingQuoteDto {
  @Transform(toNumber)
  @IsNumber()
  @Min(0)
  distanceKm: number;

  @Transform(toNumber)
  @IsNumber()
  @Min(0)
  estimatedTimeMinutes: number;

  @IsOptional()
  @IsEnum(VehicleClass)
  vehicleClass?: VehicleClass;

  @IsOptional()
  @Transform(toNumber)
  @IsNumber()
  @Min(0)
  extras?: number;

  @IsOptional()
  @Transform(toBoolean)
  @IsBoolean()
  priority?: boolean;
}
