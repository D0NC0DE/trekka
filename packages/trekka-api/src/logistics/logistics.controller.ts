import { Body, Controller, Get, Param, Patch, Post } from '@nestjs/common';
import { CreateHailingQuoteDto, CreateHailingRequestDto, UpdateHailingRequestDto } from './dto';
import { LogisticsService } from './logistics.service';
import { GetUser } from '../users/decorator';

@Controller('logistics/hailing')
export class LogisticsController {
  constructor(private readonly logisticsService: LogisticsService) { }

  @Post('quotes')
  createLogisticsHailingQuote(@Body() body: CreateHailingQuoteDto) {
    return this.logisticsService.calculateHailingQuote(body);
  }

  @Post('requests')
  createLogisticsHailingRequest(
    @GetUser('userId') userId: string,
    @Body() body: CreateHailingRequestDto,
  ) {
    return this.logisticsService.createHailingRequest(userId, body);
  }

  @Get('requests/:id')
  async getHailingRequest(@Param('id') id: string) {
    return this.logisticsService.getRide(id);
  }

  @Patch('requests/:id')
  updateLogisticsHailingRequest(
    @Param('id') id: string,
    @Body() body: UpdateHailingRequestDto,
  ) {
    return this.logisticsService.updateHailingRequest(id, body);
  }
}
