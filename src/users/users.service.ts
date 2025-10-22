import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { User, OtpPurpose } from 'src/generated/prisma/client';
import { 
    safeUserSelect, 
    userWithOtpSelect, 
    userWithRefreshTokenSelect,
    userWithWalletSelect,
    SafeUser, 
    UserWithOtp,
    UserWithRefreshToken,
    UserWithWallet
} from './types';
import { UpdateUserDto } from './dto';

@Injectable()
export class UsersService {
    constructor(private prisma: PrismaService) { }

    private async generateUniqueUsername(email: string): Promise<string> {
        const [rawLocalPart = ''] = email.split('@');
        const sanitizedBase = rawLocalPart
            .toLowerCase()
            .replace(/[^a-z0-9._-]/g, '')
            .slice(0, 30);

        const baseUsername = sanitizedBase || 'user';

        let attempt = 0;
        let candidate = baseUsername;

        while (await this.findByUsername(candidate)) {
            attempt += 1;
            candidate = `${baseUsername}${attempt}`;
        }

        return candidate;
    }

    private async reactivateAccount(
        userId: string,
        data: {
            isEmailVerified?: boolean;
            otpHash?: string;
            otpExpiresAt?: Date;
            otpPurpose?: OtpPurpose;
        }
    ): Promise<SafeUser> {
        const reactivatedUser = await this.prisma.user.update({
            where: { id: userId },
            data: {
                deletedAt: null,
                isEmailVerified: data.isEmailVerified ?? false,
                ...(data.otpHash && {
                    otpHash: data.otpHash,
                    otpExpiresAt: data.otpExpiresAt,
                    otpPurpose: data.otpPurpose,
                    otpAttemptCount: 0,
                    otpLastSentAt: new Date(),
                }),
            },
            select: safeUserSelect,
        });

        return reactivatedUser;
    }

    private async create(data: {
        email: string;
        isEmailVerified?: boolean;
        otpHash?: string;
        otpExpiresAt?: Date;
        otpPurpose?: OtpPurpose;
    }): Promise<SafeUser> {
        const existingUser = await this.prisma.user.findUnique({
            where: { email: data.email },
            select: { id: true, deletedAt: true },
        });

        if (existingUser) {
            if (existingUser.deletedAt) {
                return this.reactivateAccount(existingUser.id, data);
            }

            throw new ConflictException('Email already exists');
        }

        const username = await this.generateUniqueUsername(data.email);

        const user = await this.prisma.user.create({
            data: {
                email: data.email,
                username,
                isEmailVerified: data.isEmailVerified ?? false,
                ...(data.otpHash && {
                    otpHash: data.otpHash,
                    otpExpiresAt: data.otpExpiresAt,
                    otpPurpose: data.otpPurpose,
                    otpAttemptCount: 0,
                    otpLastSentAt: new Date(),
                }),
            },
            select: safeUserSelect,
        });

        return user;
    }

    async findByEmail(email: string): Promise<SafeUser | null> {
        const user = await this.prisma.user.findUnique({
            where: { email, deletedAt: null },
            select: safeUserSelect,
        });

        return user;
    }

    async findByUsername(username: string): Promise<SafeUser | null> {
        const user = await this.prisma.user.findUnique({
            where: { username },
            select: safeUserSelect,
        });

        return user;
    }

    async findById(id: string): Promise<SafeUser | null> {
        const user = await this.prisma.user.findUnique({
            where: { id, deletedAt: null },
            select: safeUserSelect,
        });

        return user;
    }

    async findByIdWithWallet(id: string): Promise<UserWithWallet | null> {
        const user = await this.prisma.user.findUnique({
            where: { id, deletedAt: null },
            select: userWithWalletSelect,
        });

        return user;
    }

    async createWithOtp(
        email: string,
        otpHash: string,
        expiresAt: Date,
        purpose: OtpPurpose,
    ): Promise<SafeUser> {
        return this.create({
            email,
            otpHash,
            otpExpiresAt: expiresAt,
            otpPurpose: purpose,
        });
    }

    async updateOtpParams(
        userId: string, 
        otpHash: string,
        expiresAt: Date,
        purpose: OtpPurpose
    ): Promise<SafeUser> {
        const user = await this.prisma.user.update({
            where: { id: userId },
            data: {
                otpHash,
                otpExpiresAt: expiresAt,
                otpPurpose: purpose,
                otpAttemptCount: 0,
                otpLastSentAt: new Date(),

                refreshTokenHash: null,
                refreshTokenExpiresAt: null,
                lastLoginAt: new Date(),
            },
            select: safeUserSelect,
        });

        return user;
    }

    async createWithVerifiedEmail(email: string): Promise<SafeUser> {
        return this.create({
            email,
            isEmailVerified: true,
        });
    }

    async findByEmailWithOtp(email: string): Promise<UserWithOtp | null> {
        return await this.prisma.user.findUnique({
            where: { email },
            select: userWithOtpSelect,
        });
    }

    async incrementOtpAttempt(userId: string): Promise<void> {
        await this.prisma.user.update({
            where: { id: userId },
            data: {
                otpAttemptCount: {
                    increment: 1,
                },
            },
        });
    }

    async completeAuth(
        userId: string,
        refreshTokenHash: string,
        refreshTokenExpiresAt: Date
    ): Promise<SafeUser> {
        const user = await this.prisma.user.update({
            where: { id: userId },
            data: {
                isEmailVerified: true,
                otpHash: null,
                otpExpiresAt: null,
                otpPurpose: null,
                otpAttemptCount: 0,
                otpLastSentAt: null,
                refreshTokenHash,
                refreshTokenExpiresAt,
                lastLoginAt: new Date(),
            },
            select: safeUserSelect,
        });

        return user;
    }

    async clearRefreshToken(userId: string): Promise<void> {
        await this.prisma.user.update({
            where: { id: userId },
            data: {
                refreshTokenHash: null,
                refreshTokenExpiresAt: null,
            },
        });
    }

    async updateRefreshToken(
        userId: string,
        refreshTokenHash: string,
        refreshTokenExpiresAt: Date
    ): Promise<void> {
        await this.prisma.user.update({
            where: { id: userId },
            data: {
                refreshTokenHash,
                refreshTokenExpiresAt,
                lastLoginAt: new Date(),
            },
        });
    }

    async findByIdWithRefreshToken(userId: string): Promise<UserWithRefreshToken | null> {
        return this.prisma.user.findUnique({
            where: { id: userId, deletedAt: null },
            select: userWithRefreshTokenSelect,
        });
    }

    async updateLastLogin(userId: string): Promise<void> {
        await this.prisma.user.update({
            where: { id: userId },
            data: {
                lastLoginAt: new Date(),
            },
        });
    }

    async updateUser(userId: string, data: UpdateUserDto): Promise<SafeUser> {
        const user = await this.findById(userId);

        if (!user) {
            throw new NotFoundException('User not found');
        }

        if (data.username && data.username !== user.username) {
            const existingUser = await this.findByUsername(data.username);
            if (existingUser) {
                throw new ConflictException('Username already taken');
            }
        }

        const updatedUser = await this.prisma.user.update({
            where: { id: userId },
            data: {
                ...(data.username && { username: data.username }),
                ...(data.avatar !== undefined && { avatar: data.avatar }),
            },
            select: safeUserSelect,
        });

        return updatedUser;
    }

    async softDelete(userId: string): Promise<{ message: string }> {
        const user = await this.findById(userId);

        if (!user) {
            throw new NotFoundException('User not found');
        }

        await this.prisma.user.update({
            where: { id: userId },
            data: {
                deletedAt: new Date(),
                refreshTokenHash: null,
                refreshTokenExpiresAt: null,
            },
        });

        return {
            message: 'Account deleted successfully. You can restore it within 30 days by contacting support.',
        };
    }
}
