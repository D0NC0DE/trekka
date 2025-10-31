import { Module } from '@nestjs/common';
import { WalletsService } from './wallets.service';
import { EncryptionService } from './encryption.service';
import { WalletsController } from './wallets.controller';

@Module({
  providers: [WalletsService, EncryptionService],
  exports: [WalletsService],
  controllers: [WalletsController]
})
export class WalletsModule {}
