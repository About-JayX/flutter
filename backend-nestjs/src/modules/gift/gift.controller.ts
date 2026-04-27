import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  Param,
  Patch,
  Delete,
  Logger,
} from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { GiftService } from './gift.service';
import { SendGiftDto } from './dto/send-gift.dto';
import { CreateGiftDto } from './dto/create-gift.dto';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';

@ApiTags('礼物')
@Controller('gifts')
export class GiftController {
  private readonly logger = new Logger(GiftController.name);

  constructor(private readonly giftService: GiftService) {}

  @Get()
  @ApiOperation({ summary: '获取礼物列表' })
  async getGifts() {
    return this.giftService.getGifts();
  }

  @Post('send')
  @ApiOperation({ summary: '赠送礼物' })
  async sendGift(@CurrentUser() user: any, @Body() sendGiftDto: SendGiftDto) {
    return this.giftService.sendGift(user.uniqid, sendGiftDto);
  }

  @Get('records')
  @ApiOperation({ summary: '获取赠送记录' })
  async getGiftRecords(
    @CurrentUser() user: any,
    @Query('type') type: 'sent' | 'received',
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.giftService.getGiftRecords(
      user.uniqid,
      type,
      page || 1,
      limit || 20,
    );
  }

  @Post('admin')
  @ApiOperation({ summary: '创建礼物（后台）' })
  async createGift(@Body() createGiftDto: CreateGiftDto) {
    return this.giftService.createGift(createGiftDto);
  }

  @Patch('admin/:id')
  @ApiOperation({ summary: '更新礼物（后台）' })
  async updateGift(
    @Param('id') giftId: string,
    @Body() updateGiftDto: Partial<CreateGiftDto>,
  ) {
    return this.giftService.updateGift(giftId, updateGiftDto);
  }

  @Delete('admin/:id')
  @ApiOperation({ summary: '删除礼物（后台）' })
  async deleteGift(@Param('id') giftId: string) {
    await this.giftService.deleteGift(giftId);
    return { status: '0', statusInfo: '礼物已删除' };
  }
}
