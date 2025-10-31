#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
API_DIR="$ROOT_DIR/packages/trekka-api"
MOBILE_DIR="$ROOT_DIR/packages/trekka-mobile"

API_BASE_URL_DEFAULT="http://localhost:3000"
API_BASE_URL="${API_BASE_URL:-$API_BASE_URL_DEFAULT}"
USE_MOCKS="${USE_MOCKS:-false}"

cd "$API_DIR"
if ! command -v npm >/dev/null 2>&1; then
  echo "npm is required to start the Trekka API." >&2
  exit 1
fi

echo "Starting Trekka API (npm run start:dev)..."
npm run start:dev &
API_PID=$!

cleanup() {
  echo ""
  echo "Stopping Trekka API (PID $API_PID)..."
  kill "$API_PID" 2>/dev/null || true
  wait "$API_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

cd "$MOBILE_DIR"
if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK is required to start the Trekka mobile app." >&2
  exit 1
fi

echo "Starting Trekka mobile app..."
echo "API_BASE_URL=$API_BASE_URL"
echo "USE_MOCKS=$USE_MOCKS"

flutter run \
  --dart-define=API_BASE_URL="$API_BASE_URL" \
  --dart-define=USE_MOCKS="$USE_MOCKS"
