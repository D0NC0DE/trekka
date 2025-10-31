import { Injectable, InternalServerErrorException, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  AccountId,
  Client,
  PrivateKey,
  Status,
  TopicId,
  TopicMessageSubmitTransaction,
} from '@hashgraph/sdk';

type ConsensusMessage = string | Uint8Array | Record<string, unknown>;

interface SubmitResult {
  transactionId: string;
  status: string;
}

@Injectable()
export class HederaConsensusService implements OnModuleDestroy {
  private client: Client;
  private operatorKey: PrivateKey;

  constructor(private readonly configService: ConfigService) {
    this.initializeClient();
  }

  private initializeClient() {
    const operatorId = this.configService.get<string>('HEDERA_OPERATOR_ID');
    const operatorKey = this.configService.get<string>('HEDERA_OPERATOR_KEY');

    if (!operatorId || !operatorKey) {
      throw new Error('HEDERA_OPERATOR_ID and HEDERA_OPERATOR_KEY must be set for consensus operations');
    }

    this.operatorKey = PrivateKey.fromStringECDSA(operatorKey);

    this.client = Client.forTestnet();
    this.client.setOperator(AccountId.fromString(operatorId), this.operatorKey);
  }

  private normaliseMessage(message: ConsensusMessage): string | Uint8Array {
    if (message instanceof Uint8Array) {
      return message;
    }

    if (typeof message === 'string') {
      return message;
    }

    return JSON.stringify(message);
  }

  async submitMessage(topicId: string | TopicId, message: ConsensusMessage): Promise<SubmitResult> {
    try {
      const normalisedTopicId = typeof topicId === 'string' ? TopicId.fromString(topicId) : topicId;
      const payload = this.normaliseMessage(message);

      const transaction = new TopicMessageSubmitTransaction({
        topicId: normalisedTopicId,
        message: payload,
      });

      const frozenTx = transaction.freezeWith(this.client);
      const signedTx = await frozenTx.sign(this.operatorKey);

      const response = await signedTx.execute(this.client);
      const receipt = await response.getReceipt(this.client);

      if (receipt.status !== Status.Success) {
        throw new Error(`Consensus message failed with status ${receipt.status.toString()}`);
      }

      const result: SubmitResult = {
        status: receipt.status.toString(),
        transactionId: response.transactionId.toString(),
      };

      console.log(' Submitted Hedera message', {
        topicId: normalisedTopicId.toString(),
        ...result,
      });

      return result;
    } catch (error) {
      console.error(' Failed to submit Hedera message:', error);
      throw new InternalServerErrorException('Failed to submit Hedera message');
    }
  }

  async submitRideSummary(summary: Record<string, unknown>, topicId?: string): Promise<void> {
    const configuredTopic = topicId ?? this.configService.get<string>('HEDERA_RIDE_SUMMARY_TOPIC_ID');

    if (!configuredTopic) {
      console.warn(' HEDERA_RIDE_SUMMARY_TOPIC_ID is not configured. Skipping consensus submission.');
      return;
    }

    await this.submitMessage(configuredTopic, summary);
  }

  onModuleDestroy() {
    if (this.client) {
      this.client.close();
    }
  }
}
