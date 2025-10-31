import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as crypto from 'crypto';

@Injectable()
export class EncryptionService {
    private readonly algorithm = 'aes-256-gcm';
    private readonly ivLength = 12;
    private readonly encryptionKey: Buffer;

    constructor(private configService: ConfigService) {
        const keyString = this.configService.get<string>('ENCRYPTION_KEY');
        if (!keyString) {
            throw new Error('ENCRYPTION_KEY must be set in environment variables');
        }
        this.encryptionKey = this.parseKey(keyString);
    }

    /**
     * Parse ENCRYPTION_KEY from env in a strict, secure way.
     * Accepts base64 or hex-encoded 32-byte keys. Throws otherwise.
     */
    private parseKey(keyString: string): Buffer {
        // Try base64
        try {
            const b64 = Buffer.from(keyString, 'base64');
            if (b64.length === 32) {
                return b64;
            }
        } catch {}

        // Try hex
        try {
            const hex = Buffer.from(keyString, 'hex');
            if (hex.length === 32) {
                return hex;
            }
        } catch {}

        throw new Error('ENCRYPTION_KEY must be a 32-byte key encoded in base64 or hex');
    }

    /**
     * Encrypt plaintext using AES-256-GCM.
     * Format (versioned): v1:<iv_b64>:<tag_b64>:<cipher_b64>
     * - IV: 12 bytes, base64
     * - TAG: 16 bytes, base64
     * - CIPHER: base64
     * Optional AAD may be provided; the same AAD must be supplied to decrypt.
     */
    encrypt(plaintext: string, aad?: string): string {
        const iv = crypto.randomBytes(this.ivLength);
        const cipher = crypto.createCipheriv(this.algorithm, this.encryptionKey, iv);

        if (aad) {
            cipher.setAAD(Buffer.from(aad, 'utf8'));
        }

        const ciphertext = Buffer.concat([
            cipher.update(plaintext, 'utf8'),
            cipher.final(),
        ]);
        const tag = cipher.getAuthTag();

        return `v1:${iv.toString('base64')}:${tag.toString('base64')}:${ciphertext.toString('base64')}`;
    }

    /**
     * Decrypt ciphertext produced by encrypt().
     * Supports legacy format (iv:tag:cipher as hex) for backward compatibility.
     */
    decrypt(payload: string, aad?: string): string {
        // New format: v1:<iv_b64>:<tag_b64>:<cipher_b64>
        if (payload.startsWith('v1:')) {
            const parts = payload.split(':');
            if (parts.length !== 4) {
                throw new Error('Invalid v1 encrypted data format');
            }
            const iv = Buffer.from(parts[1], 'base64');
            const tag = Buffer.from(parts[2], 'base64');
            const cipherB64 = parts[3];

            const decipher = crypto.createDecipheriv(this.algorithm, this.encryptionKey, iv);
            if (aad) {
                decipher.setAAD(Buffer.from(aad, 'utf8'));
            }
            decipher.setAuthTag(tag);

            const plaintext = Buffer.concat([
                decipher.update(cipherB64, 'base64'),
                decipher.final(),
            ]);
            return plaintext.toString('utf8');
        }

        // Legacy format: iv:authTag:cipher (all hex, with 16-byte IV)
        const legacyParts = payload.split(':');
        if (legacyParts.length !== 3) {
            throw new Error('Invalid encrypted data format');
        }

        const ivLegacy = Buffer.from(legacyParts[0], 'hex');
        const tagLegacy = Buffer.from(legacyParts[1], 'hex');
        const cipherHex = legacyParts[2];

        const decipherLegacy = crypto.createDecipheriv(this.algorithm, this.encryptionKey, ivLegacy);
        // AAD was not supported in legacy format
        decipherLegacy.setAuthTag(tagLegacy);

        let decrypted = decipherLegacy.update(cipherHex, 'hex', 'utf8');
        decrypted += decipherLegacy.final('utf8');
        return decrypted;
    }
}

