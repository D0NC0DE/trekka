import { BadRequestException, Injectable } from '@nestjs/common';
import { RequestAuthOtpDto, VerifyAuthOtpDto } from './dto';
import { UsersService } from 'src/users/users.service';
import { OtpPurpose } from 'src/generated/prisma/client';
import { SafeUser } from 'src/users/types';
import { Tokens } from './types';
import { OtpService } from './otp.service';
import { TokenService } from './token.service';
import { EmailService } from 'src/email/email.service';
import { WalletsService } from 'src/wallets/wallets.service';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private otpService: OtpService,
    private tokenService: TokenService,
    private emailService: EmailService,
    private walletsService: WalletsService
  ) { }
  authenticateWithGoogle(): string {
    return 'Google authentication endpoint reached';
  }

  private getExpiryMinutes(expiresAt: Date): number {
    return Math.floor((expiresAt.getTime() - Date.now()) / 60000);
  }

  async requestAuthOtp(payload: RequestAuthOtpDto): Promise<{ message: string }> {
    const existingUser = await this.usersService.findByEmail(payload.email);
    const purpose = OtpPurpose.AUTH;

    const otpData = await this.otpService.createOtpData(purpose);

    const user = existingUser
      ? await this.usersService.updateOtpParams(
        existingUser.id,
        otpData.hash,
        otpData.expiresAt,
        purpose
      )
      : await this.usersService.createWithOtp(
        payload.email,
        otpData.hash,
        otpData.expiresAt,
        purpose
      );

    // Send email in background
    this.emailService.sendOTPEmail(user.email, {
      username: user.username,
      otp: otpData.code,
      expiresInMinutes: this.getExpiryMinutes(otpData.expiresAt),
      purpose,
    })
      .then(() => console.log(`✅ Email sent to ${user.email}`))
      .catch((error) => console.error(`❌ Email failed for ${user.email}:`, error));


    return {
      message: existingUser
        ? 'Verification code sent to your email'
        : 'Account created! Verification code sent to your email',
    };
  }

  async resendAuthOtp(payload: RequestAuthOtpDto): Promise<{ message: string }> {
    const user = await this.usersService.findByEmailWithOtp(payload.email);
    if (!user || !user.otpLastSentAt) {
      throw new BadRequestException('Unable to resend verification code. Please request a new code first.');
    }

    const result = await this.otpService.regenerateOtpData(user.otpLastSentAt, OtpPurpose.AUTH);
    if (!result.success) {
      throw new BadRequestException(result.error);
    }

    await this.usersService.updateOtpParams(user.id, result.otpData.hash, result.otpData.expiresAt, OtpPurpose.AUTH);

    this.emailService.sendOTPEmail(user.email, {
      username: user.username,
      otp: result.otpData.code,
      expiresInMinutes: this.getExpiryMinutes(result.otpData.expiresAt),
      purpose: OtpPurpose.AUTH,
    });

    return {
      message: 'Verification code sent to your email',
    };
  }

  async verifyAuthOtp(payload: VerifyAuthOtpDto): Promise<{ message: string; user: SafeUser; tokens: Tokens }> {
    const user = await this.usersService.findByEmailWithOtp(payload.email);

    if (!user) {
      throw new BadRequestException('No account found with this email');
    }

    const { isValid, error } = await this.otpService.validateOtp(
      user,
      payload.otp,
      OtpPurpose.AUTH
    );

    if (!isValid) {
      await this.usersService.incrementOtpAttempt(user.id);
      throw new BadRequestException(error);
    }

    const isNewUser = !user.isEmailVerified;

    const { tokens, refreshTokenHash, refreshTokenExpiresAt } = await this.tokenService.generateAuthTokens({
      userId: user.id,
      email: user.email,
      username: user.username,
    });

    const verifiedUser = await this.usersService.completeAuth(
      user.id,
      refreshTokenHash,
      refreshTokenExpiresAt
    );

    if (isNewUser) {
      this.walletsService.createWallet(user.id)
        .then(() => console.log(`✅ Wallet created for ${user.email}`))
        .catch((error) => console.error(`❌ Wallet creation failed for ${user.email}:`, error));
    }

    this.emailService.sendWelcomeEmail(user.email, {
      username: user.username,
      isNewUser,
    })
      .then(() => console.log(`✅ Welcome email sent to ${user.email}`))
      .catch((error) => console.error(`❌ Welcome email failed for ${user.email}:`, error));

    return {
      message: 'Email verified successfully! You can now access your account.',
      user: verifiedUser,
      tokens,
    };
  }

  async logout(refreshToken: string): Promise<{ message: string }> {
    try {
      const payload = await this.tokenService.verifyRefreshToken(refreshToken);
     
      const user = await this.usersService.findByIdWithRefreshToken(payload.userId);

      if (user?.refreshTokenHash) {
        const isValid = await this.tokenService.verifyRefreshTokenHash(refreshToken, user.refreshTokenHash);
        if (isValid) {
          await this.usersService.clearRefreshToken(user.id);
        }
      }
    } catch (error) { }
    
    return { message: 'Logged out successfully' };
  }

  async refreshToken(refreshToken: string): Promise<{ accessToken: string; refreshToken: string }> {
    const payload = await this.tokenService.verifyRefreshToken(refreshToken);

    const user = await this.usersService.findByIdWithRefreshToken(payload.userId);

    if (!user) {
      throw new BadRequestException('User not found');
    }

    if (!user.refreshTokenHash) {
      throw new BadRequestException('No active session - please login');
    }

    const isValid = await this.tokenService.verifyRefreshTokenHash(refreshToken, user.refreshTokenHash);

    if (!isValid) {
      throw new BadRequestException('Invalid refresh token - please login');
    }

    if (user.refreshTokenExpiresAt && this.tokenService.isRefreshTokenExpired(user.refreshTokenExpiresAt)) {
      throw new BadRequestException('Refresh token expired - please login');
    }

    const { tokens, refreshTokenHash, refreshTokenExpiresAt } = 
      await this.tokenService.generateAuthTokens({
        userId: user.id,
        email: user.email,
        username: user.username,
      });

    await this.usersService.updateRefreshToken(user.id, refreshTokenHash, refreshTokenExpiresAt);

    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    };
  }
}
