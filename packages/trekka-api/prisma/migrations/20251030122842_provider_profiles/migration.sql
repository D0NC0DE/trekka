-- CreateEnum
CREATE TYPE "ProviderType" AS ENUM ('RIDE_HAILING');

-- CreateEnum
CREATE TYPE "FuelType" AS ENUM ('ELECTRIC', 'GAS', 'DIESEL', 'PETROL');

-- CreateTable
CREATE TABLE "providers" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" "ProviderType" NOT NULL,
    "displayName" TEXT NOT NULL,
    "rating" DECIMAL(3,2) NOT NULL DEFAULT 0,
    "reviewCount" INTEGER NOT NULL DEFAULT 0,
    "completedOrders" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "providers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ride_hailing_providers" (
    "id" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "vehiclePlate" TEXT NOT NULL,
    "vehicleModel" TEXT NOT NULL,
    "vehicleFuelType" "FuelType",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ride_hailing_providers_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "providers_userId_type_key" ON "providers"("userId", "type");

-- CreateIndex
CREATE UNIQUE INDEX "ride_hailing_providers_providerId_key" ON "ride_hailing_providers"("providerId");

-- AddForeignKey
ALTER TABLE "providers" ADD CONSTRAINT "providers_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ride_hailing_providers" ADD CONSTRAINT "ride_hailing_providers_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "providers"("id") ON DELETE CASCADE ON UPDATE CASCADE;
