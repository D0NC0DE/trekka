import { IsEnum, IsOptional, IsString } from 'class-validator';

export class UpdateHailingRequestDto {
  @IsEnum(['accepted', 'arrived', 'in_progress', 'completed', 'canceled'])
  @IsOptional()
  status?: string;

  @IsEnum(['rider', 'driver'])
  @IsOptional()
  initiated_by?: string;

  @IsEnum(['rider', 'driver'])
  @IsOptional()
  canceled_by?: string;

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

