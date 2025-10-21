import { Module } from '@nestjs/common';
import { WalletsService } from './wallets.service';
import { EncryptionService } from './encryption.service';

@Module({
  providers: [WalletsService, EncryptionService],
  exports: [WalletsService]
})
export class WalletsModule {}
