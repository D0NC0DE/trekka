#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
API_DIR="$ROOT_DIR/packages/trekka-api"
MOBILE_DIR="$ROOT_DIR/packages/trekka-mobile"

API_PORT="${API_PORT:-${PORT:-3000}}"
PORT="$API_PORT"
export PORT

API_BASE_URL_DEFAULT="http://localhost:${API_PORT}"
API_BASE_URL="${API_BASE_URL:-$API_BASE_URL_DEFAULT}"
USE_MOCKS="${USE_MOCKS:-false}"

if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  COMPOSE_BIN=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_BIN=(docker-compose)
else
  echo "Docker Compose is required to start the Trekka API stack." >&2
  exit 1
fi

compose() {
  (cd "$API_DIR" && "${COMPOSE_BIN[@]}" "$@")
}

COMPOSE_STARTED=false

cleanup() {
  echo ""
  if [ "$COMPOSE_STARTED" = true ]; then
    echo "Stopping Trekka API Docker stack..."
    compose down
  fi
}
trap cleanup EXIT INT TERM

echo "Starting Trekka API stack with Docker Compose (PORT=$PORT)..."
compose up -d --build
COMPOSE_STARTED=true

wait_for_api() {
  if ! command -v nc >/dev/null 2>&1 && ! command -v curl >/dev/null 2>&1; then
    echo "Skipping API readiness check (requires either nc or curl)."
    return 0
  fi

  echo "Waiting for Trekka API to become reachable at ${API_BASE_URL}..."
  for attempt in $(seq 1 60); do
    if command -v nc >/dev/null 2>&1 && nc -z localhost "$API_PORT" >/dev/null 2>&1; then
      echo "Trekka API is reachable on port $API_PORT."
      return 0
    fi

    if command -v curl >/dev/null 2>&1 && curl -s "${API_BASE_URL}" >/dev/null 2>&1; then
      echo "Trekka API responded at ${API_BASE_URL}."
      return 0
    fi

    sleep 2
  done

  echo "Timed out waiting for Trekka API; continuing anyway."
  return 0
}

wait_for_api

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
