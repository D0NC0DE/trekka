# Trekka Contracts Overview

The smart-contract layer is split into reusable core primitives and domain-specific service modules that coordinate with Trekka’s mobile and API stacks.

---

## Core Components

### EscrowManager
- Holds funds in escrow while quests and rides are in progress.
- Releases payouts based on milestones confirmed by service contracts.
- Enforces single source of truth for custody across verticals.

**Hedera Testnet (placeholder):** `0x8f5a8d9b1e4c3f2a7b6c5d4e3f1a2b3c4d5e6f7a`

### ReputationSystem
- Maintains participant reputation scores across all Trekka services.
- Exposes role-gated upsert functions for the API backend.
- Provides query helpers for clients to display trust metrics.

**Hedera Testnet (placeholder):** `0x2c4d6e8f1a3b5c7d9e0f1a2b3c4d5e6f7a8b9c0d`

---

## Service Modules

### RideHailing
- Extends the escrow manager with ride-specific settlement logic.
- Issues completion tokens for proof-of-ride flows.
- Writes reputation deltas back to the core system after settlement.

**Hedera Testnet (placeholder):** `0x7e6d5c4b3a291817262524232221201f1e1d1c1b`

Upcoming services (Courier, Recycling, Marketplace) reuse the same core contracts and will publish their own addresses after deployment.

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
