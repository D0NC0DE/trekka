import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { ConfigService } from '@nestjs/config';
import * as Client from '@storacha/client'
import { StoreMemory } from '@storacha/client/stores/memory'
import * as Proof from '@storacha/client/proof'
import { Signer } from '@storacha/client/principal/ed25519'

@Injectable()
export class StorageService {
    constructor(
        private prisma: PrismaService,
        private configService: ConfigService
    ) { }
    private client: any = null;

    async initializeClient() {
        if (!this.client) {
            const key = this.configService.get<string>('WEB3_STORAGE_KEY');
            const proof = this.configService.get<string>('WEB3_STORAGE_PROOF');
            
            if (!key || !proof) {
                throw new Error('Web3.Storage credentials not configured');
            }

            const principal = Signer.parse(key);
            const store = new StoreMemory();
            this.client = await Client.create({ principal, store });
            const proofParsed = await Proof.parse(proof);
            const space = await this.client.addSpace(proofParsed);
            await this.client.setCurrentSpace(space.did());
        }
        return this.client;
    }
     
}