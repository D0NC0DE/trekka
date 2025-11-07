#!/bin/sh

set -e

cd /app

if [ ! -d "node_modules" ] || [ -z "$(ls -A node_modules 2>/dev/null)" ]; then
  echo "Installing npm dependencies..."
  npm install
fi

echo "Generating Prisma client..."
npm run prisma:generate

echo "Applying database migrations..."
npx prisma migrate deploy

if [ "${SKIP_DB_SEED:-false}" = "true" ]; then
  echo "Skipping database seed because SKIP_DB_SEED=true"
else
  echo "Seeding database..."
  npm run prisma:seed
fi

echo "Starting Trekka API..."
exec npm run start:dev
