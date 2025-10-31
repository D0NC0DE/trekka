/*
  Warnings:

  - You are about to drop the column `providerId` on the `ride_hailing_providers` table. All the data in the column will be lost.
  - You are about to drop the `providers` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[userId]` on the table `ride_hailing_providers` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `displayName` to the `ride_hailing_providers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userId` to the `ride_hailing_providers` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "ServiceType" AS ENUM ('RIDE_HAILING', 'RECYCLING');

-- CreateEnum
CREATE TYPE "RecyclingMaterial" AS ENUM ('PLASTIC', 'METAL', 'GLASS', 'PAPER', 'ELECTRONICS', 'ORGANIC', 'OTHER');

-- DropForeignKey
ALTER TABLE "public"."providers" DROP CONSTRAINT "providers_userId_fkey";

-- DropForeignKey
ALTER TABLE "public"."ride_hailing_providers" DROP CONSTRAINT "ride_hailing_providers_providerId_fkey";

-- DropIndex
DROP INDEX "public"."ride_hailing_providers_providerId_key";

-- AlterTable
ALTER TABLE "ride_hailing_providers" DROP COLUMN "providerId",
ADD COLUMN     "completedOrders" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "displayName" TEXT NOT NULL,
ADD COLUMN     "rating" DECIMAL(3,2) NOT NULL DEFAULT 0,
ADD COLUMN     "reviewCount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "userId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "servicesOffered" "ServiceType"[] DEFAULT ARRAY[]::"ServiceType"[];

-- DropTable
DROP TABLE "public"."providers";

-- DropEnum
DROP TYPE "public"."ProviderType";

-- CreateIndex
CREATE UNIQUE INDEX "ride_hailing_providers_userId_key" ON "ride_hailing_providers"("userId");

-- AddForeignKey
ALTER TABLE "ride_hailing_providers" ADD CONSTRAINT "ride_hailing_providers_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
