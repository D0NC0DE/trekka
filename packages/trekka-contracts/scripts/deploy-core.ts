import { network } from "hardhat";

const { ethers } = await network.connect({
  network: "hedera"
});

async function main() {
  console.log("🚀 Deploying Trekka core contracts...");

  const escrowManager = await ethers.deployContract("EscrowManager");
  await escrowManager.waitForDeployment();
  console.log("EscrowManager deployed:", await escrowManager.getAddress());

  const reputationSystem = await ethers.deployContract("ReputationSystem");
  await reputationSystem.waitForDeployment();
  console.log("ReputationSystem deployed:", await reputationSystem.getAddress());

  console.log("\nCore deployment complete. Record the addresses and pass them to service deployment scripts.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
