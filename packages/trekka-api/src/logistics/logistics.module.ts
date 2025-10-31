import { Module } from '@nestjs/common';
import { LogisticsController } from './logistics.controller';
import { LogisticsService } from './logistics.service';
import { EventsModule } from '../events/events.module';
import { WalletsModule } from '../wallets/wallets.module';
import { ConsensusModule } from '../hedera/consensus.module';

@Module({
  imports: [EventsModule, WalletsModule, ConsensusModule],
  controllers: [LogisticsController],
  providers: [LogisticsService]
})
export class LogisticsModule {}
