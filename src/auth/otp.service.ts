import { Injectable } from '@nestjs/common';
import { randomBytes } from 'crypto';
import { OtpPurpose } from 'src/generated/prisma/client';
import { UserWithOtp } from 'src/users/types';
import { OtpData } from './types';
import * as argon2 from 'argon2';

@Injectable()
export class OtpService {
  private readonly OTP_LENGTH = 8;
  private readonly OTP_EXPIRY_MINUTES = 5; // 5 minutes expiry
  private readonly MAX_ATTEMPTS = 5;
  private readonly COOLDOWN_MINUTES = 2;

  generateOtp(): string {
    const bytes = randomBytes(Math.ceil(this.OTP_LENGTH / 2));
    return bytes.toString('hex').substring(0, this.OTP_LENGTH).toUpperCase();
  }

  async hashOtp(otp: string): Promise<string> {
    return await argon2.hash(otp);
  }

  async createOtpData(purpose: OtpPurpose): Promise<OtpData> {
    const code = this.generateOtp();
    const hash = await this.hashOtp(code);
    const expiresAt = new Date(Date.now() + this.OTP_EXPIRY_MINUTES * 60 * 1000);

    return {
      code,
      hash,
      expiresAt,
      purpose,
    };
  }

  isExpired(expiresAt: Date): boolean {
    return new Date() > expiresAt;
  }

  hasExceededMaxAttempts(attemptCount: number): boolean {
    return attemptCount >= this.MAX_ATTEMPTS;
  }

  private async verifyOtpHash(otp: string, hash: string): Promise<boolean> {
    return await argon2.verify(hash, otp);
  }

  async validateOtp(
    user: UserWithOtp,
    inputOtp: string,
    expectedPurpose: OtpPurpose,
  ): Promise<{ isValid: boolean; error?: string }> {
    if (!user.otpHash || !user.otpExpiresAt || user.otpPurpose !== expectedPurpose) {
      return {
        isValid: false,
        error: 'No pending verification code found. Please request a new one.'
      };
    }

    if (this.isExpired(user.otpExpiresAt)) {
      return { isValid: false, error: 'OTP has expired' };
    }

    if (this.hasExceededMaxAttempts(user.otpAttemptCount)) {
      return { isValid: false, error: 'Too many failed attempts' };
    }

    if (!await this.verifyOtpHash(inputOtp, user.otpHash)) {
      return { isValid: false, error: 'Invalid OTP' };
    }

    return { isValid: true };
  }

  canResendOtp(
    lastSentAt: Date | null,
  ): { canResend: boolean; remainingSeconds?: number } {
    if (!lastSentAt) {
      return { canResend: true };
    }

    const timeSinceLastSent = Date.now() - lastSentAt.getTime();
    const cooldownMs = this.COOLDOWN_MINUTES * 60 * 1000;

    if (timeSinceLastSent < cooldownMs) {
      const remainingSeconds = Math.ceil((cooldownMs - timeSinceLastSent) / 1000);
      return { canResend: false, remainingSeconds };
    }

    return { canResend: true };
  }

  async regenerateOtpData(
    lastSentAt: Date | null,
    purpose: OtpPurpose,
  ): Promise<{ success: true; otpData: OtpData } | { success: false; error: string; remainingSeconds?: number }> {
    const { canResend, remainingSeconds } = this.canResendOtp(lastSentAt);

    if (!canResend) {
      return {
        success: false,
        error: `Please wait ${remainingSeconds} seconds before requesting another code.`,
        remainingSeconds
      };
    }

    const otpData = await this.createOtpData(purpose);
    return { success: true, otpData };
  }
}