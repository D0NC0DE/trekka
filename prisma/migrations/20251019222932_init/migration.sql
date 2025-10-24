/*
  Warnings:

  - The values [SIGNUP,LOGIN] on the enum `OtpPurpose` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "OtpPurpose_new" AS ENUM ('AUTH', 'WITHDRAW', 'EXPORT_KEY');
ALTER TABLE "users" ALTER COLUMN "otpPurpose" TYPE "OtpPurpose_new" USING ("otpPurpose"::text::"OtpPurpose_new");
ALTER TYPE "OtpPurpose" RENAME TO "OtpPurpose_old";
ALTER TYPE "OtpPurpose_new" RENAME TO "OtpPurpose";
DROP TYPE "public"."OtpPurpose_old";
COMMIT;
