# Trekka Monorepo

Trekka is a **decentralized geo playground** built on **Hedera Hashgraph**. This repository hosts both the Flutter mobile client and the NestJS API that powers quests, verification, payouts, and the gamified ecosystem.

It’s a gamified peer-to-peer playground where Africans — and eventually the world — can exchange value directly without middlemen, but with trust, fun, and fairness.

---

## Repo Layout

```
.
├─ packages/
│  ├─ trekka-mobile/   # Flutter app (consumer + provider experiences)
│  └─ trekka-api/      # NestJS backend (quests, payouts, verification)
```

Each package keeps its own source, tooling, and tests. Shared policies and workflows live at the repo root.

---

## Prerequisites

- **Flutter** 3.22+ and **Dart** 3.4+ (for `trekka-mobile`)
- **Node.js** 20+ and npm (or pnpm/yarn) for `trekka-api`
- Git, an IDE (VS Code / Android Studio / JetBrains), and a configured device or emulator
- Optional: Access to staging Hedera credentials and database for end-to-end flows

---

## Quick Start

```bash
git clone https://github.com/trekka-hq/trekka.git
cd trekka
```

### Install Dependencies for All Packages

```bash
./scripts/bootstrap.sh
```

The script runs `npm install` for `packages/trekka-api` and `flutter pub get` for `packages/trekka-mobile`.

### Bootstrap the Flutter App
```bash
cd packages/trekka-mobile
flutter pub get
```

### Bootstrap the API
```bash
cd packages/trekka-api
npm install
```

---

## Running the Projects

### Mobile (`packages/trekka-mobile`)

```bash
# With staging API
flutter run \
  --dart-define=API_BASE_URL=https://staging.api.trekka.app \
  --dart-define=USE_MOCKS=false

# Demo / investor mode (no backend)
flutter run --dart-define=USE_MOCKS=true
```

Key runtime flags:
- `API_BASE_URL` – backend endpoint (omit to use defaults or mocks)
- `USE_MOCKS=true|false` – switch repositories to in-memory data sources for demos

### API (`packages/trekka-api`)

```bash
# Development (watch mode)
npm run start:dev

# Production build and run
npm run build && npm run start:prod
```

Required environment variables (set via shell or a local `.env` that is not committed):
- `PORT` – default `3000`
- `NODE_ENV` – `development|staging|production`
- `API_BASE_URL` – used for Swagger docs metadata
- `HEDERA_NETWORK` – e.g., `testnet`
- `HEDERA_OPERATOR_ID` / `HEDERA_OPERATOR_KEY`
- `DB_URL` – database connection string

Swagger UI is available at `http://localhost:3000/docs` in non-production environments.

---

### Combined Dev Runner

A helper script is available to launch the API and mobile app together:

```bash
# From repo root
./scripts/dev.sh
```

The script will:

- start the API in watch mode (`npm run start:dev`)
- launch the Flutter app pointing at `http://localhost:3000` by default
- shut the API down when you exit the Flutter process

Override defaults by exporting environment variables before running:

```bash
API_BASE_URL=https://staging.api.trekka.app USE_MOCKS=false ./scripts/dev.sh
```

---

## Testing & Quality

### Flutter
```bash
flutter test                     # Unit + widget tests
flutter test integration_test    # Integration tests (device/emulator required)
flutter analyze                  # Static analysis
dart format --set-exit-if-changed .
```

Optional code generation (if `freezed`/`json_serializable` are introduced later):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### API
```bash
npm run lint
npm run format
npm run test         # Unit tests
npm run test:e2e     # E2E tests
npm run test:cov     # Coverage report
```

---

## Contributing

- We follow a lightweight **Gitflow**: `main` (stable) ← `dev` (integration) ← feature branches (`feature/*`, `bugfix/*`, `hotfix/*`).
- Commits use **Conventional Commits** with **emoji prefixes** (e.g., `🌍 feat: add quest feed`, `🛠️ fix: resolve map crash`).
- See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for architecture rules, PR checklists, and security policy spanning both mobile and API codebases.

---

## Support & Links

- Issues: <https://github.com/trekka-hq/trekka/issues>  
- Discussions: <https://github.com/trekka-hq/trekka/discussions>  
- Engineering: `dev@trekka.app` • Security: `security@trekka.app` • Product: `pm@trekka.app`

---

## License

Proprietary — Internal/Invited Use Only. You may not fork, resell, package, or otherwise profit from this codebase, nor present it as your own work, without prior written permission. Refer to [`CONTRIBUTING.md`](./CONTRIBUTING.md) for the hackathon access window and contributor obligations.
