import { Controller, Get } from '@nestjs/common';
import { WalletsService } from './wallets.service';
import { GetUser } from '../users/decorator';

@Controller('wallets')
export class WalletsController {
  constructor(private readonly walletsService: WalletsService) {}

  @Get('me')
  async getWalletInfo(@GetUser('userId') userId: string) {
    return this.walletsService.getWalletInfo(userId);
  }

  @Get('me/balance')
  async getWalletBalance(@GetUser('userId') userId: string) {
    const balance = await this.walletsService.getWalletBalance(userId);
    return { balance };
  }

  @Get('me/address')
  async getWalletAddress(@GetUser('userId') userId: string) {
    const wallet = await this.walletsService.ensureWalletExists(userId);
    return { address: wallet.address };
  }
}
