import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return "Welcome to Trekka! Trekka is the Gamified Playground Powering Africa’s Peer-to-Peer Economy.";
  }
}
