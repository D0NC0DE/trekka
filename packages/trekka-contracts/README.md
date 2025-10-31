# Trekka Contracts Overview

The smart-contract layer is split into reusable core primitives and domain-specific service modules that coordinate with Trekka’s mobile and API stacks.

---

## Core Components

### EscrowManager
- Holds funds in escrow while quests and rides are in progress.
- Releases payouts based on milestones confirmed by service contracts.
- Enforces single source of truth for custody across verticals.

**Hedera Testnet (ID):** `0.0.7167779`

**Hedera Testnet (EVM):** `0x0404dF8365111b34C7Ec46C4805462b384E8B224`

### ReputationSystem
- Maintains participant reputation scores across all Trekka services.
- Exposes role-gated upsert functions for the API backend.
- Provides query helpers for clients to display trust metrics.

**Hedera Testnet (ID):** `0.0.7167780`

**Hedera Testnet (EVM):** `0x71660Df400Cb33c3032234a71625738b4A283d39`

---

## Service Modules

### RideHailing
- Extends the escrow manager with ride-specific settlement logic.
- Issues completion tokens for proof-of-ride flows.
- Writes reputation deltas back to the core system after settlement.

**Hedera Testnet (ID):** `0.0.7167785`

**Hedera Testnet (EVM):** `0x2B76D0F307EF754EF41741d2a6f3eAe4F6edc9CE`

### Marketplace

- IPFS-backed product catalog with escrow-protected orders.
- Leverages completion pins and the reputation system for dispute resolution.

**Hedera Testnet (ID):** `0.0.7173124`

**Hedera Testnet (EVM):** `0x0Aad7DCd751Bd24E2fADb4E563FAF29624076D40`

###

Upcoming services (Courier, Recycling) reuse the same core contracts and will publish their own addresses after deployment.

---

## Directory Map

```
contracts/
├─ core/            Escrow + reputation primitives
├─ services/        Vertical-specific logic (RideHailing, …)
└─ interfaces/      External-facing contract interfaces
scripts/            Hardhat deployment helpers
test/               Solidity + TypeScript specs
```

---

## Tooling Snapshot

- Solidity + Hardhat 3.x (ethers, mocha, viem)
- Typescript-based deployment scripts under `scripts/`
- Foundry-style unit tests alongside Hardhat integration tests

Local workflow:
```bash
npm install
npx hardhat compile
npx hardhat test
```

---

## Deployment Notes

- Hedera Testnet is the default environment; adjust RPC endpoints and keys in `hardhat.config.ts`.
- Core contracts deploy first; service contracts receive their addresses via constructor arguments.
- Newly deployed addresses should replace the placeholders above and be mirrored in the mobile/API `.env` files.

---

Questions, deployment logs, or planned upgrades should flow through the smart-contracts channel with network name, script path, and relevant hashes.
