import { Injectable, InternalServerErrorException, OnModuleDestroy } from '@nestjs/common';
import { Wallet } from 'src/generated/prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
import { ConfigService } from '@nestjs/config';
import {
    AccountId,
    PrivateKey,
    Client,
    AccountCreateTransaction,
    Hbar,
    Status,
    AccountBalanceQuery
} from "@hashgraph/sdk";
import { EncryptionService } from './encryption.service';
import { SafeWallet, safeWalletSelect } from './types/wallet.types';

@Injectable()
export class WalletsService implements OnModuleDestroy {
    private client: Client;
    private readonly INITIAL_BALANCE = 10;
    constructor(
        private prisma: PrismaService,
        private configService: ConfigService,
        private encryptionService: EncryptionService
    ) {
        this.initializeHederaClient();
    }

    private initializeHederaClient() {
        try {
            // Get operator credentials from environment
            const operatorId = this.configService.get<string>('HEDERA_OPERATOR_ID');
            const operatorKey = this.configService.get<string>('HEDERA_OPERATOR_KEY');

            if (!operatorId || !operatorKey) {
                throw new Error('HEDERA_OPERATOR_ID and HEDERA_OPERATOR_KEY must be set');
            }

            // Initialize client for testnet
            this.client = Client.forTestnet();

            // Set operator
            this.client.setOperator(
                AccountId.fromString(operatorId),
                PrivateKey.fromStringECDSA(operatorKey)
            );

            console.log('✅ Hedera client initialized successfully');
        } catch (error) {
            console.error('❌ Failed to initialize Hedera client:', error);
            throw error;
        }
    }

    private buildWalletAad(accountId: string, userId: string): string {
        const env = this.configService.get<string>('NODE_ENV') || 'development';
        return `v1|env:${env}|wallet:${accountId}|user:${userId}`;
    }

    async createWallet(userId: string): Promise<Wallet> {
        try {
            // Check if user already has a wallet
            const existingWallet = await this.prisma.extendedPrismaClient().wallet.findUnique({
                where: { userId }
            });

            if (existingWallet) {
                throw new Error('User already has a wallet');
            }

            const accountPrivateKey = PrivateKey.generateECDSA();
            const accountPublicKey = accountPrivateKey.publicKey;

            const txCreateAccount = new AccountCreateTransaction()
                .setKeyWithoutAlias(accountPublicKey)
                .setInitialBalance(new Hbar(this.INITIAL_BALANCE));

            const txCreateAccountResponse = await txCreateAccount.execute(this.client);
            const receiptCreateAccountTx = await txCreateAccountResponse.getReceipt(this.client);
            const accountId = receiptCreateAccountTx.accountId;
            const statusCreateAccountTx = receiptCreateAccountTx.status;

            if (!accountId || statusCreateAccountTx !== Status.Success) {
                throw new Error('Failed to create Hedera account');
            }

            // Build AAD to bind the ciphertext to environment + wallet + user context
            const aad = this.buildWalletAad(accountId.toString(), userId);

            const encryptedKey = this.encryptionService.encrypt(
                accountPrivateKey.toStringRaw(),
                aad,
            );

            const wallet = await this.prisma.extendedPrismaClient().wallet.create({
                data: {
                    userId,
                    address: accountId.toString(),
                    encryptedKey,
                    balance: this.INITIAL_BALANCE,
                },
            });

            // Log success
            console.log('✅ Wallet created successfully:');
            console.log('Account ID:', accountId.toString());
            console.log('Transaction ID:', txCreateAccountResponse.transactionId.toString());

            return wallet;
        } catch (error) {
            console.error('❌ Failed to create wallet:', error);
            throw new InternalServerErrorException('Failed to create wallet');
        }
    }

    async getWalletByUserId(userId: string): Promise<Wallet | null> {
        return this.prisma.extendedPrismaClient().wallet.findUnique({
            where: { userId }
        });
    }

    async ensureWalletExists(userId: string): Promise<Wallet> {
        let wallet = await this.getWalletByUserId(userId);

        if (wallet) {
            return wallet;
        }

        console.log(`⚠️  Wallet not found for user ${userId}, creating now...`);
        wallet = await this.createWallet(userId);

        return wallet;
    }

    /**
     * Decrypts the private key for signing transactions
     * IMPORTANT: Use this only when needed, never expose decrypted key to client!
     */
    getDecryptedPrivateKey(wallet: Wallet): PrivateKey {
        const aad = this.buildWalletAad(wallet.address, wallet.userId);

        const decryptedKey = this.encryptionService.decrypt(wallet.encryptedKey, aad);
        return PrivateKey.fromStringECDSA(decryptedKey);
    }

    async getAccountBalance(accountId: string): Promise<number> {
        try {
            const query = new AccountBalanceQuery()
                .setAccountId(AccountId.fromString(accountId));

            const balance = await query.execute(this.client);
            return balance.hbars.toBigNumber().toNumber();
        } catch (error) {
            console.error('❌ Failed to get account balance:', error);
            throw new InternalServerErrorException('Failed to get account balance');
        }
    }

    async getWalletBalance(userId: string): Promise<number> {
        try {
            const wallet = await this.ensureWalletExists(userId);
            return await this.getAccountBalance(wallet.address);
        } catch (error) {
            console.error('❌ Failed to get wallet balance:', error);
            throw new InternalServerErrorException('Failed to get wallet balance');
        }
    }

    async getWalletInfo(userId: string): Promise<SafeWallet> {
        try {
            const wallet = await this.ensureWalletExists(userId);
            
            const realTimeBalance = await this.getAccountBalance(wallet.address);
            
            const updatedWallet = await this.prisma.extendedPrismaClient().wallet.update({
                where: { id: wallet.id },
                data: { balance: realTimeBalance },
                select: safeWalletSelect
            });
            
            return updatedWallet;
        } catch (error) {
            console.error('❌ Failed to get wallet info with updated balance:', error);
            throw new InternalServerErrorException('Failed to get wallet info');
        }
    }

    onModuleDestroy() {
        if (this.client) {
            this.client.close();
        }
    }
}
