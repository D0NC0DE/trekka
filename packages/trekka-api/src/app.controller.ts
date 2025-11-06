import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { VERSION_NEUTRAL } from '@nestjs/common';
import { SkipAuth } from './auth/decorator';

@Controller({version: VERSION_NEUTRAL})
export class AppController {
  constructor(private readonly appService: AppService) {}

  @SkipAuth()
  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
}
