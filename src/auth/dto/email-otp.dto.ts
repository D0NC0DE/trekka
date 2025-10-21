import { IsEmail, IsString, Length } from 'class-validator';

export class RequestAuthOtpDto {
  @IsEmail()
  email: string;
}

export class VerifyAuthOtpDto {
  @IsEmail()
  email: string;
  
  @IsString()
  @Length(8, 8, { message: 'OTP must be exactly 8 digits' })
  otp: string;
}