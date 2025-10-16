# Contributing to Trekka API — Backend Guidelines

Thank you for your interest in contributing to the Trekka API, a NestJS backend powering Trekka — a decentralized geo‑playground on Hedera Hashgraph.

> Important: Trekka is a proprietary project, temporarily public for the Hedera Hackathon Judging Period (Oct 1 – Nov 2, 2025). After this, access will be restricted to authorized contributors only. Not for public use or profit. All rights reserved © Trekka Team, 2025.

---

## 1) Getting Started

### ✅ Prerequisites
- Node.js 20+, npm (or pnpm/yarn)
- Git (latest)
- IDE: VS Code / JetBrains
- (Optional) Access to staging Hedera credentials and DB

### 🧩 Environment
Prefer real env vars (12‑factor) or a local `.env` that is not committed:
- `PORT` — default 3000
- `NODE_ENV` — `development|staging|production`
- `API_BASE_URL` — used for Swagger docs URL
- `HEDERA_NETWORK` — e.g., `testnet`
- `HEDERA_OPERATOR_ID` — account ID
- `HEDERA_OPERATOR_KEY` — private key (use secrets manager in real deployments)
- `DB_URL` — database connection string

### 📦 Install
```bash
npm install
```

### ▶️ Run
```bash
# Dev (watch)
npm run start:dev

# Prod
npm run build && npm run start:prod
```

### 🧪 Test & Lint
```bash
# Unit tests
npm run test

# E2E tests
npm run test:e2e

# Coverage
npm run test:cov

# Lints & formatting
npm run lint
npm run format
```

---

## 2) Architecture, Structure & Import Rules

We follow modular NestJS with layered boundaries.

```
src/
├─ main.ts                 # Bootstrap (validation, Swagger non-prod)
├─ app.module.ts           # Root composition
├─ common/                 # Filters, guards, interceptors, pipes, DTOs
├─ modules/                # Feature slices
│  ├─ quests/
│  ├─ users/
│  ├─ verification/
│  └─ payouts/
└─ infra/                  # Repositories, external clients (db, cache, hedera)
```

Import rules:
```
controllers → services → repositories → external clients
common/*    → used anywhere (no circular deps)
infra/*     → no importing from modules/* (only referenced by services)
```

Guidelines:
- Controllers stay thin; no business logic.
- Services coordinate workflows, validations beyond DTOs.
- Repositories abstract data access.
- Configuration and secrets via env only.

---

## 3) Git Workflow (Gitflow‑Lite)

We mirror the mobile repo’s workflow.

Branches:
- `main` — production/stable releases
- `dev` — integration
- `feature/*` — new features (e.g., `feature/verification-gps-qr`)
- `bugfix/*` — fixes
- `hotfix/*` — urgent fixes; merge back to both `main` and `dev`

Flow:
```bash
git checkout dev
git pull origin dev
git checkout -b feature/<name>
# commit work
git push origin feature/<name>
# open PR into dev
```

---

## 4) Commit Style & Branch Naming (Trekka Standard)

We use Conventional Commits with emoji prefixes.

Examples:
```bash
🌍 feat: add payouts endpoint (hedera transfer)
🛠️ fix: handle invalid GPS proof error case
📖 docs: document /quests API
🎨 style: consistent DTO property ordering
♻️ refactor: split verification service
🧪 test: add e2e tests for /auth/login
🔒 security: rotate operator key usage path
⚡ perf: cache quest listings for 60s
🧹 chore: bump NestJS to 9.x
```

Branch naming:
```
feature/<scope>-<short-desc>
bugfix/<short-desc>
hotfix/<short-desc>
```

---

## 5) Code Standards

- Validation via `class-validator` DTOs; global validation pipe.
- Use guards/interceptors for auth, rate limiting, and logging.
- No business logic in controllers; avoid deep service coupling.
- Prefer dependency inversion for external clients (Hedera, DB).
- Keep modules cohesive; avoid cross‑module imports unless via explicit interfaces.
- Zero lint warnings in CI.

---

## 6) Pull Requests — Checklist

- [ ] Follows modular NestJS layout and import rules
- [ ] Controllers thin; services/repositories hold logic
- [ ] DTOs validated; pipes/guards applied where needed
- [ ] Unit/E2E tests updated or added
- [ ] Works in dev with local env; Swagger available in non‑prod
- [ ] No dead code / unused files
- [ ] Clear title & description; link issues

---

## 7) Security, Licensing & Post‑Judging Access

Proprietary — Internal/Invited Use Only. All source code, designs, and IP are © Trekka Team, 2025. This project is not open‑source and may not be used, distributed, or modified for public use or profit without prior written permission.

Judging Window: This repo is public only during the Hedera Hackathon Judging Period (Oct 1 – Nov 2, 2025) for evaluation purposes. After this, access will be restricted to authorized contributors only.

- Unauthorized use, replication, or commercial exploitation is prohibited.
- Contributors may be required to sign an NDA and/or contributor agreement.
- Report security vulnerabilities privately: security@trekka.app.

---

## 8) Support & Links

- Issues: https://github.com/trekka-hq/trekka/issues
- Discussions: https://github.com/trekka-hq/trekka/discussions
- Engineering: dev@trekka.app • Security: security@trekka.app • Product: pm@trekka.app

See README for pitch‑level overview; this document is the source of truth for backend development.


