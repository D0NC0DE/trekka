import { Module } from '@nestjs/common';
import { HederaConsensusService } from './consensus.service';

@Module({
  providers: [HederaConsensusService],
  exports: [HederaConsensusService],
})
export class ConsensusModule {}
