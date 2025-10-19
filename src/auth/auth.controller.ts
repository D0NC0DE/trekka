import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RequestEmailOtpDto, VerifyEmailOtpDto } from './dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('google')
  authenticateWithGoogle(): string {
    return this.authService.authenticateWithGoogle();
  }

  @Post('email/request')
  requestEmailOtp(@Body() payload: RequestEmailOtpDto): string {
    return this.authService.requestEmailOtp(payload);
  }

  @Post('email/verify')
  verifyEmailOtp(@Body() payload: VerifyEmailOtpDto): string {
    return this.authService.verifyEmailOtp(payload);
  }

  @Post('logout')
  logout(): string {
    return this.authService.logout();
  }

  @Post('refresh')
  refreshToken(): string {
    return this.authService.refreshToken();
  }
}
