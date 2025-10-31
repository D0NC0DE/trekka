# Contributing to Trekka

Thanks for helping build Trekka — a decentralized geo playground powered by Hedera Hashgraph. This document covers workflow, tooling, coding standards, and security policies for the monorepo.

> **Important**  
> Trekka is proprietary. The codebase is temporarily public only for the **Hedera Hackathon Judging Period (Oct 1 – Nov 2, 2025)**. After judging, access returns to the internal team. Unauthorized redistribution or commercial use is prohibited. All rights reserved © Trekka Team, 2025.

---

## 1. Monorepo Overview

- `packages/trekka-mobile` — Flutter app (consumer/provider experiences)
- `packages/trekka-api` — NestJS backend (quests, payouts, verification)
- Legacy `android/` and `ios/` shells are kept for reference; new work happens inside the package directories.

Each package owns its own dependencies and tests. Shared workflows, policies, and repo-level scripts live at the root.

---

## 2. Getting Started

```bash
git clone https://github.com/trekka-hq/trekka.git
cd trekka
```

### Mobile (Flutter)
```bash
cd packages/trekka-mobile
flutter pub get
```

Run options:
```bash
# Staging backend
flutter run \
  --dart-define=API_BASE_URL=https://staging.api.trekka.app \
  --dart-define=USE_MOCKS=false

# Demo mode (no backend)
flutter run --dart-define=USE_MOCKS=true
```

Testing and quality:
```bash
flutter test
flutter test integration_test
flutter analyze
dart format --set-exit-if-changed .
# Optional codegen
flutter pub run build_runner build --delete-conflicting-outputs
```

### API (NestJS)
```bash
cd packages/trekka-api
npm install
```

Run options:
```bash
npm run start:dev
npm run build && npm run start:prod
```

Environment variables:
- `PORT`, `NODE_ENV`, `API_BASE_URL`
- `HEDERA_NETWORK`, `HEDERA_OPERATOR_ID`, `HEDERA_OPERATOR_KEY`
- `DB_URL` (or providers via Prisma)

Testing and quality:
```bash
npm run lint
npm run format
npm run test
npm run test:e2e
npm run test:cov
```

Swagger UI is available at `http://localhost:3000/docs` in non-production environments.

---

## 3. Architecture & Code Standards

### Flutter Guidelines
- **Pattern**: Feature-first MVVM with Riverpod `StateNotifier` view models.
- **Layers**: Presentation (widgets, view models) → Domain (optional use cases, entities) → Data (repositories, data sources).
- **Imports**: 
  - `app/` composes the app (routing, DI) and depends on `core/` and feature presentation.
  - `core/` is feature-agnostic utilities/components; no imports from `features/`.
  - Features may depend on `core/` and their own layers, but not on other features directly.
- Widgets remain “dumb”; business logic lives in view models and repositories.
- Prefer immutable models (`freezed` or `equatable`) when domain stabilizes.

### API Guidelines
- **Pattern**: Modular NestJS with controllers → services → repositories → external clients.
- **Structure**: `common/` for shared pipes/guards/interceptors; `modules/` for feature slices; `infra/` for DB/Hedera adapters.
- Controllers stay thin; services coordinate workflows and validation beyond DTOs.
- No cross-module imports without explicit contracts; prefer dependency inversion for external clients.
- Runtime config via environment variables only.

### Shared Expectations
- Zero lint warnings in CI.
- Tests accompany behavior changes; keep demo (`USE_MOCKS=true`) mode working.
- Document non-obvious decisions inline with brief comments when necessary.

---

## 4. Git Workflow

- `main` — stable releases
- `dev` — integration branch
- `feature/<scope>-<slug>` — new work
- `bugfix/<slug>` — non-critical fixes
- `hotfix/<slug>` — urgent fixes merged into both `main` and `dev`

Typical flow:
```bash
git checkout dev
git pull origin dev
git checkout -b feature/<scope>-<slug>
# work, commit, push
git push origin feature/<scope>-<slug>
# open PR into dev
```

Rebase before merge when possible; resolve conflicts locally.

---

## 5. Commit Style

Use Conventional Commits with emoji prefixes:

| Emoji | Type | Example |
| ----- | ---- | ------- |
| 🌍 | feat | `🌍 feat: add clustered quest map` |
| 🛠️ | fix | `🛠️ fix: handle invalid GPS proof` |
| 📖 | docs | `📖 docs: update onboarding steps` |
| 🎨 | style | `🎨 style: adjust token spacing` |
| ♻️ | refactor | `♻️ refactor: split payout repository` |
| 🧪 | test | `🧪 test: add quest view model specs` |
| 🔒 | security | `🔒 security: rotate operator key usage` |
| ⚡ | perf | `⚡ perf: cache quest list response` |
| 🧹 | chore | `🧹 chore: bump Flutter SDK constraint` |
| 🚀 | deploy | `🚀 deploy: update production config` |
| 🚢 | ship | `🚢 ship: launch quest marketplace` |

---

## 6. Pull Request Checklist

- [ ] Branch is up to date with `dev`
- [ ] Tests and linters pass (`flutter test`, `flutter analyze`, `npm run test`, `npm run lint`, etc.)
- [ ] Architecture rules respected (no cross-feature leaks, controllers stay thin, etc.)
- [ ] Demo mode works (`USE_MOCKS=true`) when relevant
- [ ] New environment variables or scripts are documented
- [ ] No dead code or unused assets
- [ ] PR title and description are clear; link issues/hackathon tasks

---

## 7. Security & Licensing

- Proprietary code — do not redistribute, fork, commercialize, or present Trekka as your own product without written approval.
- Sensitive credentials (Hedera keys, DB URLs) are never committed. Use secrets managers or local `.env` files excluded by `.gitignore`.
- Report security issues privately: `security@trekka.app`.
- Contributors may be required to sign NDAs or contributor agreements.

---

## 8. Support

- Issues: <https://github.com/trekka-hq/trekka/issues>
- Discussions: <https://github.com/trekka-hq/trekka/discussions>
- Engineering: `dev@trekka.app`
- Security: `security@trekka.app`
- Product: `pm@trekka.app`

Thanks for building Trekka with us — let’s make quests rewarding, transparent, and fun.
