import { Controller, Get, Post, Body, Logger } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { VIPService } from './vip.service';
import { SubscribeVipDto } from './dto/subscribe-vip.dto';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';

@ApiTags('VIP')
@Controller('vip')
export class VIPController {
  private readonly logger = new Logger(VIPController.name);

  constructor(private readonly vipService: VIPService) {}

  @Get('status')
  @ApiOperation({ summary: '获取VIP状态' })
  async getVIPStatus(@CurrentUser() user: any) {
    return this.vipService.checkVIPStatus(user.uniqid);
  }

  @Get('benefits')
  @ApiOperation({ summary: '获取VIP特权列表' })
  async getVIPBenefits() {
    return this.vipService.getVIPBenefits();
  }

  @Post('subscribe')
  @ApiOperation({ summary: '订阅VIP' })
  async subscribeVIP(
    @CurrentUser() user: any,
    @Body() subscribeVipDto: SubscribeVipDto,
  ) {
    void subscribeVipDto;
    return { status: '0', statusInfo: '请使用RevenueCat进行内购' };
  }
}
