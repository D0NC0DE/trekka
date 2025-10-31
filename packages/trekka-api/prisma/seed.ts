import {
  FuelType,
  PrismaClient,
  ServiceType,
  Wallet,
} from '../src/generated/prisma/client';
import dotenv from 'dotenv';
import path from 'path';
import {
  AccountCreateTransaction,
  AccountId,
  Client,
  Hbar,
  PrivateKey,
  Status,
} from '@hashgraph/sdk';
import { ConfigService } from '@nestjs/config';
import { EncryptionService } from '../src/wallets/encryption.service';

const prisma = new PrismaClient();
dotenv.config({
  path: path.resolve(__dirname, '../.env'),
});
dotenv.config();

const configService = new ConfigService();
const encryptionService = new EncryptionService(configService);
const INITIAL_BALANCE_HBAR = 100;

function requireEnv(value: string | undefined, label: string) {
  if (!value) {
    throw new Error(`${label} must be set to seed Hedera wallets.`);
  }
  return value;
}

function buildWalletAad(accountId: string, userId: string) {
  const env = configService.get<string>('NODE_ENV') || 'development';
  return `v1|env:${env}|wallet:${accountId}|user:${userId}`;
}

function isPlaceholderWallet(wallet: Wallet | null) {
  if (!wallet) return true;
  return (
    wallet.address === '0.0.5001' ||
    wallet.encryptedKey === 'encrypted-key-placeholder'
  );
}

async function createHederaWallet(userId: string) {
  const operatorId = requireEnv(
    configService.get<string>('HEDERA_OPERATOR_ID'),
    'HEDERA_OPERATOR_ID',
  );
  const operatorKey = requireEnv(
    configService.get<string>('HEDERA_OPERATOR_KEY'),
    'HEDERA_OPERATOR_KEY',
  );

  const client = Client.forTestnet();
  client.setOperator(
    AccountId.fromString(operatorId),
    PrivateKey.fromStringECDSA(operatorKey),
  );

  try {
    const accountPrivateKey = PrivateKey.generateECDSA();
    const accountPublicKey = accountPrivateKey.publicKey;

    const createTx = new AccountCreateTransaction()
      .setKeyWithoutAlias(accountPublicKey)
      .setInitialBalance(new Hbar(INITIAL_BALANCE_HBAR));

    const txResponse = await createTx.execute(client);
    const receipt = await txResponse.getReceipt(client);

    if (!receipt.accountId || receipt.status !== Status.Success) {
      throw new Error(
        `Failed to create Hedera wallet. Status: ${receipt.status.toString()}`,
      );
    }

    const accountId = receipt.accountId.toString();
    const aad = buildWalletAad(accountId, userId);
    const encryptedKey = encryptionService.encrypt(
      accountPrivateKey.toStringRaw(),
      aad,
    );

    const wallet = await prisma.wallet.upsert({
      where: { userId },
      update: {
        address: accountId,
        encryptedKey,
        balance: INITIAL_BALANCE_HBAR,
      },
      create: {
        userId,
        address: accountId,
        encryptedKey,
        balance: INITIAL_BALANCE_HBAR,
      },
    });

    console.log(`✅ Seed wallet created for user ${userId}: ${accountId}`);
    return wallet;
  } finally {
    client.close();
  }
}

async function ensureDriverWallet(userId: string) {
  const existingWallet = await prisma.wallet.findUnique({
    where: { userId },
  });

  if (!isPlaceholderWallet(existingWallet)) {
    return existingWallet;
  }

  return createHederaWallet(userId);
}

async function main() {
  const driverEmail = 'driver@trekkaweb.com';
  const username = 'trekka-driver';

  const user = await prisma.user.upsert({
    where: { email: driverEmail },
    update: {
      username,
      avatar: 1,
      isEmailVerified: true,
      servicesOffered: {
        set: [ServiceType.RIDE_HAILING],
      },
    },
    create: {
      email: driverEmail,
      username,
      avatar: 1,
      isEmailVerified: true,
      servicesOffered: [ServiceType.RIDE_HAILING],
    },
  });

  await ensureDriverWallet(user.id);

  await prisma.rideHailingProvider.upsert({
    where: { userId: user.id },
    update: {
      displayName: 'Trekka Pioneer Driver',
      vehiclePlate: 'TREK-001',
      vehicleModel: 'Toyota Corolla',
      vehicleFuelType: FuelType.PETROL,
    },
    create: {
      userId: user.id,
      displayName: 'Trekka Pioneer Driver',
      vehiclePlate: 'TREK-001',
      vehicleModel: 'Toyota Corolla',
      vehicleFuelType: FuelType.PETROL,
    },
  });
}

main()
  .catch((error) => {
    console.error('Seed failed', error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
