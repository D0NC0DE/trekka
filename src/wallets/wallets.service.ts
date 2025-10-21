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
    Status
} from "@hashgraph/sdk";
import { EncryptionService } from './encryption.service';

@Injectable()
export class WalletsService implements OnModuleDestroy {
    private client: Client;

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
            const existingWallet = await this.prisma.wallet.findUnique({
                where: { userId }
            });

            if (existingWallet) {
                throw new Error('User already has a wallet');
            }

            const accountPrivateKey = PrivateKey.generateECDSA();
            const accountPublicKey = accountPrivateKey.publicKey;

            const txCreateAccount = new AccountCreateTransaction()
                .setKeyWithoutAlias(accountPublicKey)
                .setInitialBalance(new Hbar(10));

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

            const wallet = await this.prisma.wallet.create({
                data: {
                    userId,
                    address: accountId.toString(),
                    encryptedKey,
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
        return this.prisma.wallet.findUnique({
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

    onModuleDestroy() {
        if (this.client) {
            this.client.close();
        }
    }
}
