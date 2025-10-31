# Trekka Monorepo

Trekka is a **decentralized geo playground** built on **Hedera Hashgraph**. This repository hosts both the Flutter mobile client and the NestJS API that powers quests, verification, payouts, and the gamified ecosystem.

It’s a gamified peer-to-peer playground where Africans — and eventually the world — can exchange value directly without middlemen, but with trust, fun, and fairness.

---

## Hedera Integration

### Hedera Consensus Service (HCS)
We stream immutable ride life-cycle summaries (and the upcoming marketplace sales receipts) to Hedera Consensus Service topics so regulators, riders, and partners can audit Trekka without touching our primary database. `LogisticsService` pushes a structured completion payload for every ride that settles on-chain through the shared `HederaConsensusService`, which signs and submits `TopicMessageSubmitTransaction` calls against the configured topic (`HEDERA_RIDE_SUMMARY_TOPIC_ID`). The same helper backs the sales stream once the marketplace API exposes settlements, meaning both mobility and commerce events land on a tamper-evident ledger with ~5 second finality.
- **Transaction Types:** `TopicMessageSubmitTransaction` for runtime logging, with `TopicCreateTransaction` handled by `packages/trekka-api/scripts/create-consensus-topic.ts` when provisioning new topics.
- **Economic Justification:** HCS’ predictable ~$0.0001 per message lets us notarize hundreds of micro-events daily without inflating delivery fees, while ABFT consensus gives partners deterministic finality that satisfies compliance teams in lower-margin African markets.

### Hedera Smart Contract Service (EVM)
Ride escrow, marketplace orders, and cross-vertical reputation all settle on Hedera’s EVM layer. The backend `WalletsService` keeps user wallets synced and executes `ContractExecuteTransaction` calls into the deployed contracts — RideHailing for trip state, EscrowManager for custody, and Marketplace for IPFS-backed orders — using IDs configured in environment variables (see `packages/trekka-contracts/contracts/**`). This gives the mobile app instant proof that funds are locked, released, or refunded based on the contract events, and lets us reuse the same primitives for future courier/recycling verticals.
- **Transaction Types:** `ContractExecuteTransaction` (ride request, accept, cancel, complete), plus the deployment scripts that drive `ethers.deployContract` workflows and authorize services against EscrowManager/ReputationSystem.
- **Economic Justification:** Hedera’s fixed gas schedule keeps escrow updates far below $0.01 even during congestion, so we can clear payments in real time without charging surge-like network fees; native finality prevents double-spend disputes that would otherwise erode trust in cash-light regions.

### Hedera Account Service (Crypto)
Every Trekka participant receives an on-ledger wallet that the API seeds and manages. We call `AccountCreateTransaction` while encrypting the private key with per-user AAD, cache balances through `AccountBalanceQuery`, and reuse those keys to sign smart-contract calls on behalf of riders or drivers. Seed scripts pre-provision demo drivers so the mobile MVP can showcase the full Hedera flow without manual setup.
- **Transaction Types:** `AccountCreateTransaction` for wallet provisioning, `AccountBalanceQuery` for live HBAR telemetry, and HBAR transfers embedded in contract executions.
- **Economic Justification:** Creating and topping up accounts costs pennies, making it viable to onboard drivers who may hold only a few dollars’ worth of float while still guaranteeing custody and compliance through ledger-backed operations.

### Decentralized Storage (IPFS + Storacha)
Product metadata and proof artifacts are stored off-chain using IPFS CIDs referenced directly in the Marketplace contract. The API’s `StorageService` is wired to pin new assets through Storacha/Web3.Storage once credentials are present, so marketplace listings, delivery proofs, and compliance documents stay content-addressable, redundant, and verifiable by any stakeholder.
- **Operational Benefit:** Off-chain binaries stay lightweight while the on-chain footprint remains minimal, but the CID linkage still guarantees integrity for dispute resolution.

### Hedera Deployment IDs (Testnet)
Keep these in sync with environment variables such as `HEDERA_RIDE_HAILING_CONTRACT_ID` and `HEDERA_RIDE_SUMMARY_TOPIC_ID`.

| Component        | Hedera ID      | Hedera EVM Address                       |
|-----------------|----------------|------------------------------------------|
| EscrowManager   | `0.0.7167779`  | `0x0404dF8365111b34C7Ec46C4805462b384E8B224` |
| ReputationSystem| `0.0.7167780`  | `0x71660Df400Cb33c3032234a71625738b4A283d39` |
| RideHailing     | `0.0.7167785`  | `0x2B76D0F307EF754EF41741d2a6f3eAe4F6edc9CE` |
| Marketplace     | `0.0.7173124`  | `0x0Aad7DCd751Bd24E2fADb4E563FAF29624076D40` |

Additional Hedera resources:
- Ride summary topic (`HEDERA_RIDE_SUMMARY_TOPIC_ID`): `0.0.7171590`
- Any new marketplace or sales topics should follow the same naming convention when provisioned.

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
