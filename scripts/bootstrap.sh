#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
API_DIR="$ROOT_DIR/packages/trekka-api"
MOBILE_DIR="$ROOT_DIR/packages/trekka-mobile"

echo "📦 Installing Trekka API dependencies (npm install)..."
if ! command -v npm >/dev/null 2>&1; then
  echo "npm is required to install Trekka API dependencies." >&2
  exit 1
fi
(cd "$API_DIR" && npm install)

echo "📦 Installing Trekka mobile dependencies (flutter pub get)..."
if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK is required to install Trekka mobile dependencies." >&2
  exit 1
fi
(cd "$MOBILE_DIR" && flutter pub get)

echo "✅ Dependency bootstrap complete."
