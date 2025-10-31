import { network } from "hardhat";
import dotenv from "dotenv";
dotenv.config();

const { ethers } = await network.connect({
  network: "hedera"
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
  console.log("🚀 Deploying Trekka service contracts...");

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

  const rideHailing = await ethers.deployContract("RideHailing", [
    escrowManagerAddress,
    reputationSystemAddress,
  ]);
  await rideHailing.waitForDeployment();
  console.log("RideHailing deployed:", await rideHailing.getAddress());

  const escrowManager = await ethers.getContractAt(
    "EscrowManager",
    escrowManagerAddress,
  );

  await escrowManager.getFunction("authorizeService")(await rideHailing.getAddress());
  console.log("Authorized RideHailing on EscrowManager");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
