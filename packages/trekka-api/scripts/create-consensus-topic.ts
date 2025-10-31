#!/usr/bin/env tsx

import 'dotenv/config';
import {
  AccountId,
  Client,
  PrivateKey,
  TopicCreateTransaction,
} from '@hashgraph/sdk';

function normalizePrivateKey(rawKey: string): string {
  return rawKey.startsWith('0x') ? rawKey.slice(2) : rawKey;
}

function getClient(network: string): Client {
  const lower = network.toLowerCase();

  switch (lower) {
    case 'mainnet':
      return Client.forMainnet();
    case 'previewnet':
      return Client.forPreviewnet();
    case 'testnet':
    default:
      return Client.forTestnet();
  }
}

async function main() {
  const operatorId = process.env.HEDERA_OPERATOR_ID;
  const operatorKey = process.env.HEDERA_OPERATOR_KEY;
  const network = process.env.HEDERA_NETWORK ?? 'testnet';
  const memo = process.argv.slice(2).join(' ') || undefined;

  if (!operatorId || !operatorKey) {
    console.error('HEDERA_OPERATOR_ID and HEDERA_OPERATOR_KEY must be set in the environment');
    process.exit(1);
  }

  const normalizedKey = normalizePrivateKey(operatorKey);
  const privateKey = PrivateKey.fromStringECDSA(normalizedKey);
  const client = getClient(network);

  client.setOperator(AccountId.fromString(operatorId), privateKey);

  try {
    let tx = new TopicCreateTransaction()
      .setAdminKey(privateKey.publicKey)
      .setSubmitKey(privateKey.publicKey);

    if (memo) {
      tx = tx.setTopicMemo(memo);
    }

    const frozenTx = await tx.freezeWith(client);
    const signedTx = await frozenTx.sign(privateKey);
    const response = await signedTx.execute(client);
    const receipt = await response.getReceipt(client);

    if (!receipt.topicId) {
      throw new Error('Topic creation did not return a topic ID');
    }

    const topicId = receipt.topicId.toString();

    console.log('\n✅ Hedera topic created successfully');
    console.log('Transaction ID:', response.transactionId.toString());
    console.log('Topic ID:', topicId);
    if (memo) {
      console.log('Memo:', memo);
    }

    console.log('\n⏳ Waiting 5s for propagation...');
    await new Promise((resolve) => setTimeout(resolve, 5000));
    console.log('✨ Topic ready for submissions.');
  } catch (error) {
    console.error('❌ Failed to create Hedera topic:', error);
    process.exitCode = 1;
  } finally {
    client.close();
  }
}

main();
