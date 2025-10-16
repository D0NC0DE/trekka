<p align="left">
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/license-Proprietary-red.svg"></a>
  <a href="https://nestjs.com"><img alt="NestJS" src="https://img.shields.io/badge/nestjs-%E2%89%A59.x-E0234E.svg"></a>
  <a href="#"><img alt="Hackathon Status" src="https://img.shields.io/badge/Hedera%20Hackathon-Public%20Oct%201%20–%20Nov%202%2C%202025-purple.svg"></a>
  <!-- CI badges (enable after setting up)
  <a href="#"><img alt="Tests" src="https://github.com/trekka-hq/trekka-api/actions/workflows/ci.yml/badge.svg"></a>
  <a href="#"><img alt="Lint" src="https://github.com/trekka-hq/trekka-api/actions/workflows/lint.yml/badge.svg"></a>
  -->
</p>

# Trekka API (NestJS)

> Backend for Trekka — a decentralized geo‑playground built on Hedera Hashgraph. Provides secure APIs for quests, claims/bids, verification (GPS/QR/photo), payouts, and gamification.

---

## 🟣 Core Vision

"Bringing true peer‑to‑peer back to African life — powered by blockchain, guided by simplicity, driven by community."

Trekka is inspired by Africa’s natural P2P culture — from trade‑by‑barter to buying directly from open‑market merchants. We’re rebuilding that direct exchange with modern trustless rails, without middlemen taking the value.

---

## 🧩 Ecosystem Pillars

We’re starting with three real‑world value pillars:

1. 🚗 Ride Hailing — Drivers keep more; no 20–25% platform cut. Transparent, fair pricing.
2. ♻️ Recycling — Sell recyclables directly to verified buyers/companies; no underpayment.
3. 🛍 Marketplace — P2P goods/services, immutable on‑chain receipts, transparent exchange.

Future expansions:
- 🎯 Quests (physical/online) with instant, verified payouts
- 🚚 Logistics & Courier with escrow‑backed trust
- 🌍 Cross‑border payments & token integration
- 🔐 Zero‑knowledge KYC; full non‑custodial control
- 🤖 AI navigation, recommendations, dispute resolution

---

## 🌟 Highlights

- **Hedera‑backed ops** — Server‑side interactions; client remains non‑custodial.
- **Quest Engine** — Create/broadcast gigs; claim/bid; verify via GPS/QR/photo; settle payouts.
- **Privacy & Anti‑Sybil** — Hashed IDs/DID off‑chain, zk‑friendly patterns, consent‑gated geo.
- **Observability** — Structured logging, health checks, readiness probes.
- **Docs** — OpenAPI/Swagger at `/docs` in non‑prod.
- **P2P Verticals** — Ride Hailing, Recycling, and Marketplace endpoints as first‑class modules.

---

## 🏗 Architecture (at a glance)

- **NestJS 9+**, TypeScript, modular feature slices.
- **Hex/Layered** mindset — Controllers → Services → Repos → External (Hedera, DB, storage).
- **Configuration** via environment variables (12‑factor).

```
src/
├─ app.module.ts           # Root module wiring
├─ main.ts                 # Bootstrap (validation, Swagger in non-prod)
├─ common/                 # Filters, guards, interceptors, pipes, DTOs
├─ modules/
│  ├─ quests/
│  ├─ users/
│  ├─ verification/        # GPS/QR/photo flows
│  └─ payouts/             # Hedera interactions via backend
└─ infra/                  # Repositories, external clients (db, cache, hedera)
```

---

## ⚙️ Quick Start

### Prerequisites
- Node.js 20+
- npm (or pnpm/yarn)
- (Optional) Access to staging Hedera credentials and DB

### Install & Run
```bash
# 1) Install deps
npm install

# 2) Dev (watch)
npm run start:dev

# 3) Prod build + run
npm run build && npm run start:prod
```

### Environment
Pass env via process env or a local `.env` (not committed):

- `PORT` — default 3000
- `NODE_ENV` — `development|staging|production`
- `API_BASE_URL` — external URL used for Swagger docs
- `HEDERA_NETWORK` — e.g., `testnet`
- `HEDERA_OPERATOR_ID` — account ID
- `HEDERA_OPERATOR_KEY` — private key (use secrets manager in real deployments)
- `DB_URL` — database connection string

---

## 📜 API Docs

- Swagger UI at `http://localhost:3000/docs` (non‑prod only). See `src/main.ts` for setup.
- Example requests: see `requests.http` in the repo.

---

## 🧪 Test & Lint

```bash
# Unit tests
npm run test

# E2E tests
npm run test:e2e

# Coverage
npm run test:cov

# Lint & format
npm run lint
npm run format
```

---

## 🚀 Deployment

- Provide required env vars via your platform (Docker, Kubernetes, Render, Fly.io, etc.).
- Disable Swagger in production (default behavior).
- Expose `/health` and `/ready` if using probes.

---

## 🗺️ Roadmap (Backend)

- [x] Scaffold NestJS app, health, Swagger
- [ ] Ride Hailing module (driver/rider matching, pricing, settlement)
- [ ] Recycling module (listings, bids, verified buyers)
- [ ] Marketplace module (list/sell, on‑chain receipts)
- [ ] Verification (GPS/QR/photo) pipelines
- [ ] Hedera payouts integration (escrow/settlement)
- [ ] Quests module (physical/online micro‑tasks)
- [ ] Gamification endpoints (XP/badges/leaderboards)

---

## 🔐 Security & Privacy

- Hedera interactions are strictly server‑side; never expose private keys to clients.
- Location data is consent‑gated and hashed for proximity use cases.
- Report security issues privately: `security@trekka.app`.

---

## ⚖️ License & Usage

**Proprietary — Internal/Invited Use Only.**
All source code, designs, and IP are © Trekka Team, 2025. This project is not open‑source and may not be used, distributed, or modified for public use or profit without prior written permission.

See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for contribution policy and the temporary public access window during the Hedera Hackathon (Oct 1 – Nov 2, 2025).
