import { OtpPurpose } from 'src/generated/prisma/client';

/**
 * Standard user response (safe for public exposure)
 */
export type SafeUser = {
  id: string;
  email: string;
  username: string;
  avatar: number; 
  isEmailVerified: boolean;
  lastLoginAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
};

/**
 * User with OTP fields (for internal OTP validation)
 */
export type UserWithOtp = {
  id: string;
  email: string;
  username: string;
  avatar: number; 
  isEmailVerified: boolean;
  otpHash: string | null;
  otpExpiresAt: Date | null;
  otpPurpose: OtpPurpose | null;
  otpAttemptCount: number;
  otpLastSentAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
};

/**
 * User with refresh token fields (for internal auth operations)
 */
export type UserWithRefreshToken = {
  id: string;
  email: string;
  username: string;
  refreshTokenHash: string | null;
  refreshTokenExpiresAt: Date | null;
};

/**
 * User with wallet info (for /me endpoint)
 */
export type UserWithWallet = SafeUser & {
  wallet: {
    id: string;
    address: string;
  } | null;
};

/**
 * Prisma select object for safe user data
 */
export const safeUserSelect = {
  id: true,
  email: true,
  username: true,
  avatar: true,
  isEmailVerified: true,
  lastLoginAt: true,
  createdAt: true,
  updatedAt: true,
  // Explicitly exclude sensitive fields
  otpHash: false,
  otpExpiresAt: false,
  otpPurpose: false,
  otpAttemptCount: false,
  otpLastSentAt: false,
  refreshTokenHash: false,
  refreshTokenExpiresAt: false,
} as const;

/**
 * Prisma select object for OTP operations
 */
export const userWithOtpSelect = {
  id: true,
  email: true,
  username: true,
  avatar: true,
  isEmailVerified: true,
  otpHash: true,
  otpExpiresAt: true,
  otpPurpose: true,
  otpAttemptCount: true,
  otpLastSentAt: true,
  createdAt: true,
  updatedAt: true,
} as const;

/**
 * Prisma select object for refresh token operations
 */
export const userWithRefreshTokenSelect = {
  id: true,
  email: true,
  username: true,
  refreshTokenHash: true,
  refreshTokenExpiresAt: true,
} as const;

/**
 * Prisma select object for user with wallet
 */
export const userWithWalletSelect = {
  ...safeUserSelect,
  wallet: {
    select: {
      id: true,
      address: true,
    },
  },
} as const;

