/*
  Warnings:

  - You are about to drop the column `publicKey` on the `wallets` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[username]` on the table `users` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `username` to the `users` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "OtpPurpose" AS ENUM ('SIGNUP', 'LOGIN', 'WITHDRAW', 'EXPORT_KEY');

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "isEmailVerified" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "otpAttemptCount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "otpExpiresAt" TIMESTAMP(3),
ADD COLUMN     "otpHash" TEXT,
ADD COLUMN     "otpLastSentAt" TIMESTAMP(3),
ADD COLUMN     "otpPurpose" "OtpPurpose",
ADD COLUMN     "username" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "wallets" DROP COLUMN "publicKey";

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");
