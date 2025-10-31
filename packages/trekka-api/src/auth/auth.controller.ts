import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RequestAuthOtpDto, VerifyAuthOtpDto, RefreshTokenDto } from './dto';
import { SkipAuth } from './decorator';

@SkipAuth()
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('google')
  authenticateWithGoogle(): string {
    return this.authService.authenticateWithGoogle();
  }

  @Post('email/request')
  requestAuthOtp(@Body() payload: RequestAuthOtpDto) {
    return this.authService.requestAuthOtp(payload);
  }

  @Post('email/resend')
  resendOtp(@Body() payload: RequestAuthOtpDto) {
    return this.authService.resendAuthOtp(payload); 
  }

  @Post('email/verify')
  verifyAuthOtp(@Body() payload: VerifyAuthOtpDto) {
    return this.authService.verifyAuthOtp(payload);
  }

  @Post('logout')
  logout(@Body() body: RefreshTokenDto) {
    return this.authService.logout(body.refreshToken);
  }

  @Post('refresh')
  refreshToken(@Body() body: RefreshTokenDto) {
    return this.authService.refreshToken(body.refreshToken);
  }
}
