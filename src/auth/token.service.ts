import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { TokenPayload, Tokens } from './types';
import * as argon2 from 'argon2';

@Injectable()
export class TokenService {
    constructor(
        private jwtService: JwtService,
        private configService: ConfigService
    ) { }

    private async generateAccessToken(payload: TokenPayload): Promise<string> {
        return this.jwtService.signAsync(payload, {
            secret: this.configService.get<string>('JWT_ACCESS_SECRET'),
            expiresIn: '15m', // 15 minutes
        });
    }

    private async generateRefreshToken(payload: TokenPayload): Promise<string> {
        return this.jwtService.signAsync(payload, {
            secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
            expiresIn: '7d', // 7 days
        });
    }

    async generateTokens(payload: TokenPayload): Promise<Tokens> {
        const [accessToken, refreshToken] = await Promise.all([
            this.generateAccessToken(payload),
            this.generateRefreshToken(payload),
        ]);

        return { accessToken, refreshToken };
    }

    async hashRefreshToken(token: string): Promise<string> {
        return argon2.hash(token);
    }

    getRefreshTokenExpiry(): Date {
        return new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // 7 days
    }

    async generateAuthTokens(payload: TokenPayload): Promise<{
        tokens: Tokens;
        refreshTokenHash: string;
        refreshTokenExpiresAt: Date;
    }> {
        const tokens = await this.generateTokens(payload);
        const refreshTokenHash = await this.hashRefreshToken(tokens.refreshToken);
        const refreshTokenExpiresAt = this.getRefreshTokenExpiry();

        return {
            tokens,
            refreshTokenHash,
            refreshTokenExpiresAt,
        };
    }

    async verifyAccessToken(token: string): Promise<TokenPayload> {
        const payload = await this.jwtService.verifyAsync(token, {
            secret: this.configService.get<string>('JWT_ACCESS_SECRET'),
        });
        return payload;
    }

    async verifyRefreshToken(token: string): Promise<TokenPayload> {
        try {
            const payload = await this.jwtService.verifyAsync(token, {
                secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
            });
            return payload;
        } catch (error) {
            throw new Error('Invalid or expired refresh token');
        }
    }

    async verifyRefreshTokenHash(token: string, hash: string): Promise<boolean> {
        try {
            return await argon2.verify(hash, token);
        } catch {
            return false;
        }
    }

    isRefreshTokenExpired(expiresAt: Date): boolean {
        return new Date() > expiresAt;
    }
}

