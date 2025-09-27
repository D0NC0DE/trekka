# Contributing to Trekka — Developer Guidelines

Thank you for your interest in contributing to **Trekka**, a decentralized geo‑playground app built on **Hedera Hashgraph**.  
This guide covers **workflow, setup, testing**, and **policies**.

> **Important:** Trekka is a **proprietary** project, **temporarily public for the Hedera Hackathon Judging Period (Oct 1 – Nov 2, 2025)**. After this, **access will be restricted** to authorized contributors only.  
> **Not for public use or profit.** All rights reserved © Trekka Team, 2025.

---

## 1) Getting Started

### ✅ Prerequisites
- **Flutter** 3.22+ and **Dart** 3.4+  
- **Git** (latest)  
- **IDE**: VS Code / Android Studio  
- (Optional) Access to the **staging API** (Hedera ops are backend‑only)

### 🧩 Environment
Prefer passing env at runtime via `--dart-define`:
- `API_BASE_URL` — e.g., `https://staging.api.trekka.app`
- `USE_MOCKS` — `true|false` to switch to mock data sources in repositories

### 📦 Install
```bash
git clone https://github.com/your-org/trekka.git
cd trekka
flutter pub get
```

### ▶️ Run
```bash
# with staging API
flutter run   --dart-define=API_BASE_URL=https://staging.api.trekka.app   --dart-define=USE_MOCKS=false

# with mocks (no backend required)
flutter run --dart-define=USE_MOCKS=true
```

### 🧪 Test & Lint
```bash
# Unit + widget tests
flutter test

# Integration tests
flutter test integration_test

# Lints & formatting
flutter analyze
dart format --set-exit-if-changed .
```

Optional codegen (if you adopt freezed/json_serializable later):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 2) Architecture, Structure & Import Rules

We follow a **feature‑first MVVM** with repositories and DI.

```text
lib/
├─ main.dart                 # Entry point (tiny, runs bootstrap)
│
├─ app/                      # Composition root (startup wiring + ProviderScope)
│  ├─ app.dart                # MaterialApp.router (theme + router)
│  ├─ bootstrap.dart          # WidgetsBinding.init, ProviderScope, setupDependencies()
│  ├─ router/                 # go_router routes + guards
│  ├─ di/                     # Dependency injection setup
│  └─ theme/                  # ThemeData + typography helpers
│
├─ core/                     # Shared, feature-agnostic utilities
│  ├─ design/                 # Global colors, spacing, iconography tokens
│  ├─ router/                 # Route names/paths shared by app & features
│  ├─ error/                  # Exceptions, Failures
│  ├─ extension/              # Extension methods (ContextX, StringX)
│  ├─ network/                # ApiClient, interceptors
│  ├─ services/               # Wrappers for plugins (permissions, etc.)
│  ├─ storage/                # Secure storage, prefs
│  ├─ utils/                  # Result<T>, logger, generic helpers
│  └─ widgets/                # Generic UI atoms (loading, error view)
│
└─ features/                  # Vertical slices (feature-first)
   ├─ splash/                 # Splash screen
   ├─ auth/                   # Authentication
   ├─ home/                   # 3D hub + entry points
   ├─ quests/                 # Quest flow (create, claim, verify, complete)
   └─ ... (map, marketplace, gamification, etc.)
```

```text
features/<feature>/
├─ data/
│  ├─ models/             # DTOs (API shapes)
│  ├─ datasources/        # Remote/local sources
│  └─ repositories/       # Concrete RepoImpl
├─ domain/
│  ├─ entities/           # Immutable core objects
│  ├─ repositories/       # Abstract Repo contracts
│  └─ usecases/           # Thin intent classes (optional at start)
└─ presentation/
   ├─ pages/              # Widgets (no business logic)
   ├─ widgets/            # Feature-specific UI parts
   └─ viewmodels/         # ViewModels (state + methods)
```
👉 **Skip `usecases/`** at first if the feature is small; call repos directly from ViewModels. Add them later when logic grows.

### Import Rules
```
main.dart  →  app/*
app/*      →  core/*, features/*(presentation only)
features/* →  core/*, their own layers (data/domain/presentation)
core/*     →  NO app/, NO features/
```
- `app/` composes (routing, DI), avoids business logic.  
- `core/` is generic and reusable across features.  
- Features are isolated vertical slices.

---

## 3) Git Workflow (Gitflow‑Lite)

We keep `main` stable and use `dev` as the integration branch.

```text
      main ──●────────●────────●───────────  (stable releases)
             ↑         ↑        ↑
             │         │        │
            merge     merge    merge
             │         │        │
      dev ──●───●───●──●───●────┘             (integration branch)
              \
               \
        feature/auth-login ──●───●───●        (short-lived feature branch)
               \
                └─ bugfix/quest-claim ──●     (fix branches)
```

### Branch Types
- `main` — production/stable releases  
- `dev` — ongoing integration  
- `feature/*` — new features (e.g., `feature/quests-claim-flow`)  
- `bugfix/*` — non‑critical fixes  
- `hotfix/*` — urgent fixes; merge back to both `main` and `dev`

### Flow
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

We use **Conventional Commits with emoji prefixes** to keep history clean, readable, and fun — reflecting Trekka’s gamified spirit.

### Examples
```bash
🌍 feat: add map clustering for nearby quests
🛠️ fix: resolve crash on quest verification
📖 docs: update contribution guide
🎨 style: tweak theme colors and paddings
♻️ refactor: simplify repository injection
🧪 test: add unit tests for quest ViewModel
🔒 security: sanitize API responses
⚡ perf: optimize location hash lookup
🧹 chore: upgrade dependencies
🚀 deploy: update production config
````

### Emoji Key

| Emoji | Type     | Usage                               |
| ----: | -------- | ----------------------------------- |
|    🌍 | feat     | New features (core app logic)       |
|   🛠️ | fix      | Bug fixes                           |
|    📖 | docs     | Documentation changes               |
|    🎨 | style    | UI/styling only (no logic change)   |
|    ♻️ | refactor | Code refactor (no behavior change)  |
|    🧪 | test     | Add/adjust tests                    |
|    🔒 | security | Security-related changes            |
|     ⚡ | perf     | Performance improvements            |
|    🧹 | chore    | Tooling, infra, dependency updates  |
|    🚀 | deploy   | Deployment or release configuration |


**Branch naming**
```text
feature/<scope>-<short-desc>
bugfix/<short-desc>
hotfix/<short-desc>
```
Examples: `feature/map-pins`, `bugfix/auth-token-refresh`, `hotfix/startup-crash`

---

## 5) Code Standards

- **Architecture**: Feature‑first, **MVVM**; ViewModels with **StateNotifier (Riverpod)**.  
- **Repositories**: Abstract contracts; data sources call backend; immutable entities/DTOs.  
- **DI**: Central registrations in `app/di/`; tests use provider overrides/fakes.  
- **Widgets**: “Dumb” UI (no business logic).  
- **Linting**: No warnings in CI. Use `very_good_analysis` or equivalent.  
- **Assets**: Prefer typed assets via `flutter_gen` (optional).

---

## 6) Pull Requests — Checklist

- [ ] Follows feature‑first MVVM structure  
- [ ] No business logic in `app/` or `core/`  
- [ ] Import rules respected (no cycles)  
- [ ] Unit/widget tests updated or added  
- [ ] Works with **mocks** (`USE_MOCKS=true`) for demo runs  
- [ ] No dead code / unused files  
- [ ] Clear title & description; link issues where applicable

---

## 7) Security, Licensing & Post‑Judging Access

**Proprietary — Internal/Invited Use Only.**  
All source code, designs, and IP are © Trekka Team, 2025. This project is **not open‑source** and may **not** be used, distributed, or modified for public use or profit without prior **written permission**.

> **Judging Window:** This repo is **public only** during the **Hedera Hackathon Judging Period (Oct 1 – Nov 2, 2025)** for evaluation purposes. After this, **access will be restricted** to authorized contributors only.

- Unauthorized use, replication, or commercial exploitation is **prohibited**.  
- Contributors may be required to sign an NDA and/or contributor agreement.  
- GDPR‑aligned privacy: location data is consent‑gated and hashed for proximity use cases.

Report security vulnerabilities privately: **security@trekka.app**.

---

## 8) Support & Links

- Issues: https://github.com/your-org/trekka/issues  
- Discussions: https://github.com/your-org/trekka/discussions  
- Engineering: dev@trekka.app • Security: security@trekka.app • Product: pm@trekka.app

> Keep the **README** pitch‑focused. This doc is the **source of truth** for development.
