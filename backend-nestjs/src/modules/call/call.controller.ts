import { Controller, Get, Post, Body, Query, Logger } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { CallService } from './call.service';
import { InitiateCallDto } from './dto/initiate-call.dto';
import { EndCallDto } from './dto/end-call.dto';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';

@ApiTags('通话')
@Controller('call')
export class CallController {
  private readonly logger = new Logger(CallController.name);

  constructor(private readonly callService: CallService) {}

  @Post('initiate')
  @ApiOperation({ summary: '发起通话' })
  async initiateCall(
    @CurrentUser() user: any,
    @Body() initiateCallDto: InitiateCallDto,
  ) {
    return this.callService.initiateCall(user.uniqid, initiateCallDto);
  }

  @Post('end')
  @ApiOperation({ summary: '结束通话' })
  async endCall(@CurrentUser() user: any, @Body() endCallDto: EndCallDto) {
    await this.callService.endCall(user.uniqid, endCallDto);
    return { status: '0', statusInfo: '通话已结束' };
  }

  @Get('records')
  @ApiOperation({ summary: '获取通话记录' })
  async getCallRecords(
    @CurrentUser() user: any,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.callService.getCallRecords(user.uniqid, page || 1, limit || 20);
  }
}
