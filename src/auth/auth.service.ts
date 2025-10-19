import { Injectable } from '@nestjs/common';
import { RequestEmailOtpDto, VerifyEmailOtpDto } from './dto';

@Injectable()
export class AuthService {
  authenticateWithGoogle(): string {
    return 'Google authentication endpoint reached';
  }

  requestEmailOtp(payload: RequestEmailOtpDto): string {
    return `Email OTP request endpoint reached for ${payload.email}`;
  }

  verifyEmailOtp(payload: VerifyEmailOtpDto): string {
    return `Email OTP verification endpoint reached for code ${payload.otp}`;
  }

  logout(): string {
    return 'Logout endpoint reached';
  }

  refreshToken(): string {
    return 'Token refresh endpoint reached';
  }
}
