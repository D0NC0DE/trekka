# Trekka Flutter App

Trekka is a **decentralized geo‑playground app** built on **Hedera Hashgraph**.  
We turn real‑world gigs into quests with **instant on‑chain payouts**, **privacy‑safe geo**, and **no middleman’s 20–30% cut**.

<p align="left">
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/license-Proprietary-red.svg"></a>
  <a href="https://flutter.dev"><img alt="Flutter" src="https://img.shields.io/badge/flutter-%E2%89%A53.22-blue.svg"></a>
  <a href="CONTRIBUTING.md"><img alt="PRs" src="https://img.shields.io/badge/PRs-internal%20team%20only-orange.svg"></a>
  <a href="#"><img alt="Hackathon Status" src="https://img.shields.io/badge/Hedera%20Hackathon-Public%20Oct%201%20–%20Nov%202%2C%202025-purple.svg"></a>
  <!-- CI badges (enable after setting up GitHub Actions)
  <a href="#"><img alt="Tests" src="https://github.com/your-org/trekka/actions/workflows/ci.yml/badge.svg"></a>
  <a href="#"><img alt="Lint" src="https://github.com/your-org/trekka/actions/workflows/lint.yml/badge.svg"></a>
  -->
</p>

> **Vision (Pitch):**  
> 
> Trekka is a **decentralized gamified geo-playground** built on **Hedera Hashgraph**, transforming everyday tasks—such as sales promos, lead generation, merchant onboarding, ride hailing, courier services, recycling bounties, and P2P marketplace trades—into engaging quests with **instant payouts, real-time tracking, XP rewards, and fair earnings**.  
>
> By enabling organizations and individuals to hire a dynamic network of providers and pay **only for performance**, Trekka reduces inefficiencies, eliminates middleman fees, and fosters a transparent, fun, and sustainable gig economy.

---

## 🌟 Highlights

- **3D Homepage Hub** — Quests(Online & Physical), Hailing, Courier, Recycling, Marketplace, and **+Plus** custom quests.  
- **Dual Modes** — **Consumer** (broadcast needs) and **Provider** (opt‑in to earn).  
- **Core Flow** — Input/broadcast → geo‑hashed map pins → claim/bid → verify (**GPS/QR/photo**) → payout + XP.  
- **Gamification** — XP/levels, badges, leaderboards; sustainability via **carbon NFTs**.  
- **Privacy & Anti‑Sybil** — Hashed IDs/DID off‑chain, zk‑proofs, GDPR consent for geo.  
- **Image Verification** — CLIP‑assisted checks via backend.  
- **Revenue** — 1–2% protocol fees, subscriptions, token utilities.

---

## 🏗 Architecture (at a glance)

- **Feature‑first, MVVM** — Widgets stay dumb; **StateNotifier (Riverpod)** ViewModels handle logic.  
- **Repository pattern** — Abstract data access; Hedera ops handled **server‑side**.  
- **Dependency Injection** — Centralized bindings (e.g., `app/di/`), test‑friendly with overrides/fakes.  
- **Unidirectional flow** — UI → VM → Repo → DataSource → back to UI.  
- **Immutability** — Entities/models are immutable (e.g., with `freezed`).

```text
lib/
├─ main.dart                 # Entry point (tiny, runs bootstrap)
├─ app/                      # Composition root (startup wiring)
├─ core/                     # Shared, feature-agnostic utilities
└─ features/                  # Vertical slices (feature-first)
   └─ ... (map, marketplace, gamification, etc.)
```

---

## ⚙️ Quick Start

### Prerequisites
- **Flutter** ≥ 3.22, **Dart** ≥ 3.4  
- **Git** (latest) and an IDE (VS Code / Android Studio)  
- (Optional) Access to staging API (Hedera interactions are backend‑only)

### Install & Run
```bash
# 1) Clone
git clone https://github.com/trekka-hq/trekka.git
cd trekka

# 2) Install deps
flutter pub get

# 3) (Optional) Start with staging API
flutter run   --dart-define=API_BASE_URL=https://staging.api.trekka.app   --dart-define=USE_MOCKS=false
```

**Mock mode (for demos / investors):**
```bash
# Start with local mocks enabled (no backend required)
flutter run --dart-define=USE_MOCKS=true
```
> When `USE_MOCKS=true`, repositories should switch to in‑memory or stub data sources.

### Test & Lint
```bash
# Unit & widget tests
flutter test

# Integration tests (requires an emulator/device)
flutter test integration_test

# Static analysis & formatting
flutter analyze
dart format --set-exit-if-changed .
```

---

## 🗺️ Roadmap

- [x] Phase 1 — Auth, splash, 3D hub, basic quests
- [ ] Phase 2 — Map pins, claims/bids, GPS/QR/photo verification
- [ ] Phase 3 — Gamification (XP/badges/leaderboards), carbon NFTs
- [ ] Phase 4 — Hailing, courier, recycling, marketplace verticals
- [ ] Phase 5 — Subscriptions, protocol fees, token utilities

---

## 🧑‍🤝‍🧑 Community & Contributing

- Issues: **https://github.com/trekka-hq/trekka/issues**  
- Discussions: **https://github.com/trekka-hq/trekka/discussions**  
- Developer workflow, commit style (✨ 🐞 📝 ♻️ …), and PR checklist: **[CONTRIBUTING.md](./CONTRIBUTING.md)**

> **Status:** Trekka is a **proprietary** project, **temporarily public for the Hedera Hackathon Judging Period (Oct 1 – Nov 2, 2025)**. See **CONTRIBUTING.md** for usage policy, licensing details, and **post‑judging restrictions**.

---

## 🔐 Security & Privacy

- **Server‑side** Hedera interactions; client is non‑custodial.  
- **Privacy‑preserving** geo (hashing + consent).  
- Report security issues privately: **security@trekka.app**.

---

## ⚖️ License & Usage

**Proprietary — Internal/Invited Use Only.**  
All source code, designs, and IP are © Trekka Team, 2025. This project is **not open‑source** and may **not** be used, distributed, or modified for public use or profit without prior **written permission**.

See **[CONTRIBUTING.md](./CONTRIBUTING.md)** for details.
