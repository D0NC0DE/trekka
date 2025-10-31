
import { Decimal } from '@prisma/client/runtime/library';

/**
 * Safe wallet response (safe for public exposure)
 */
export type SafeWallet = {
    id: string;
    userId: string;
    address: string;
    balance: Decimal;
    createdAt: Date;
    updatedAt: Date;
};

/**
 * Wallet with encrypted key (for internal operations)
 */
export type WalletWithKey = {
    id: string;
    userId: string;
    address: string;
    encryptedKey: string;
    balance: Decimal;
    createdAt: Date;
    updatedAt: Date;
};

/**
 * Prisma select object for safe wallet data
 */
export const safeWalletSelect = {
    id: true,
    userId: true,
    address: true,
    balance: true,
    createdAt: true,
    updatedAt: true,
    // Explicitly exclude sensitive fields
    encryptedKey: false,
} as const;

/**
 * Prisma select object for wallet with encrypted key
 */
export const walletWithKeySelect = {
    id: true,
    userId: true,
    address: true,
    encryptedKey: true,
    balance: true,
    createdAt: true,
    updatedAt: true,
} as const;
