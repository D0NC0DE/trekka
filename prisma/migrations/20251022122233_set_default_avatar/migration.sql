/*
  Warnings:

  - Made the column `avatar` on table `users` required. This step will fail if there are existing NULL values in that column.

*/
-- First, set existing NULL values to 1
UPDATE "users" SET "avatar" = 1 WHERE "avatar" IS NULL;

-- Then make the column required with default
ALTER TABLE "users" ALTER COLUMN "avatar" SET NOT NULL,
ALTER COLUMN "avatar" SET DEFAULT 1;
