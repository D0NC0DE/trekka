import { OtpPurpose } from 'src/generated/prisma/client';

export type EmailTemplate = {
  subject: string;
  htmlBody: string;
  textBody: string;
};

export type OtpEmailData = {
  username: string;
  otp: string;
  expiresInMinutes: number;
  purpose: OtpPurpose;
};

