import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { OtpService } from './otp.service';
import { TokenService } from './token.service';
import { UsersModule } from '../users/users.module';
import { EmailModule } from 'src/email/email.module';
import { WalletsModule } from 'src/wallets/wallets.module';

@Module({
  imports: [
    UsersModule,
    EmailModule,
    WalletsModule,
    JwtModule.register({}),
  ],
  providers: [AuthService, OtpService, TokenService],
  controllers: [AuthController],
  exports: [TokenService],
})
export class AuthModule {}
