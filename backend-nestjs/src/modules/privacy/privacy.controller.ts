import { Controller, Get, Post, Body, Query, Logger } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { PrivacyService } from './privacy.service';
import { PrivacySettingsDto } from './dto/privacy-settings.dto';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';

@ApiTags('隐私')
@Controller('privacy')
export class PrivacyController {
  private readonly logger = new Logger(PrivacyController.name);

  constructor(private readonly privacyService: PrivacyService) {}

  @Post('settings')
  @ApiOperation({ summary: '更新隐私设置' })
  async updatePrivacySettings(
    @CurrentUser() user: any,
    @Body() settings: PrivacySettingsDto,
  ) {
    await this.privacyService.updatePrivacySettings(user.uniqid, settings);
    return { status: '0', statusInfo: '隐私设置已更新' };
  }

  @Get('settings')
  @ApiOperation({ summary: '获取隐私设置' })
  async getPrivacySettings(@CurrentUser() user: any) {
    return this.privacyService.getPrivacySettings(user.uniqid);
  }

  @Get('view-history')
  @ApiOperation({ summary: '获取浏览历史' })
  async getViewHistory(
    @CurrentUser() user: any,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.privacyService.getViewHistory(
      user.uniqid,
      page || 1,
      limit || 20,
    );
  }
}
