import { Controller, Post, Body, Logger } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Public } from '@/modules/auth/decorators/public.decorator';
import {
  RevenueCatService,
  RevenueCatWebhookPayload,
} from './revenuecat.service';

@ApiTags('RevenueCat')
@Controller('webhooks/revenuecat')
export class RevenueCatController {
  private readonly logger = new Logger(RevenueCatController.name);

  constructor(private readonly revenueCatService: RevenueCatService) {}

  @Public()
  @Post()
  async handleWebhook(
    @Body() payload: RevenueCatWebhookPayload,
  ): Promise<{ received: boolean }> {
    try {
      await this.revenueCatService.handleWebhook(payload);
      return { received: true };
    } catch (error) {
      this.logger.error('RevenueCat webhook handling failed', error);
      return { received: true };
    }
  }
}
