import { network } from "hardhat";
import dotenv from "dotenv";

dotenv.config();

const { ethers } = await network.connect({
  network: "hedera",
});

const CORE_ADDRESSES = {
  escrowManager: process.env.CORE_ESCROW_MANAGER_ADDRESS,
  reputationSystem: process.env.CORE_REPUTATION_SYSTEM_ADDRESS,
};

function requireAddress(value: string | undefined, label: string): string {
  if (!value) {
    throw new Error(`Missing ${label} in environment configuration.`);
  }
  return value;
}

async function main() {
  console.log("🚀 Deploying Trekka Marketplace contract...");

  const escrowManagerAddress = requireAddress(
    CORE_ADDRESSES.escrowManager,
    "CORE_ESCROW_MANAGER_ADDRESS",
  );
  const reputationSystemAddress = requireAddress(
    CORE_ADDRESSES.reputationSystem,
    "CORE_REPUTATION_SYSTEM_ADDRESS",
  );

  console.log("Using EscrowManager:", escrowManagerAddress);
  console.log("Using ReputationSystem:", reputationSystemAddress);

  const marketplace = await ethers.deployContract("Marketplace", [
    escrowManagerAddress,
    reputationSystemAddress,
  ]);

  await marketplace.waitForDeployment();

  const marketplaceAddress = await marketplace.getAddress();
  console.log("Marketplace deployed:", marketplaceAddress);

  const escrowManager = await ethers.getContractAt(
    "EscrowManager",
    escrowManagerAddress,
  );

  await escrowManager.getFunction("authorizeService")(marketplaceAddress);
  console.log("Authorized Marketplace on EscrowManager");

  const reputationSystem = await ethers.getContractAt(
    "ReputationSystem",
    reputationSystemAddress,
  );

  await reputationSystem.getFunction("authorizeService")(marketplaceAddress);
  console.log("Authorized Marketplace on ReputationSystem");

  console.log("✅ Marketplace deployment complete");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
