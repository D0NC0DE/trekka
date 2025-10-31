import { OtpPurpose } from 'src/generated/prisma/client';

/**
 * OTP data returned when creating a new OTP
 */
export type OtpData = {
  code: string;
  hash: string;
  expiresAt: Date;
  purpose: OtpPurpose;
};

/**
 * JWT token payload
 */
export type TokenPayload = {
  userId: string;
  email: string;
  username: string;
};

/**
 * Access and refresh tokens pair
 */
export type Tokens = {
  accessToken: string;
  refreshToken: string;
};

