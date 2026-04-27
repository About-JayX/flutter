import { Controller, Get, Post, Body, Query, Logger } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { BlockService } from './block.service';
import { BlockUserDto } from './dto/block-user.dto';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';

@ApiTags('拉黑')
@Controller('block')
export class BlockController {
  private readonly logger = new Logger(BlockController.name);

  constructor(private readonly blockService: BlockService) {}

  @Post('block')
  @ApiOperation({ summary: '拉黑用户' })
  async blockUser(
    @CurrentUser() user: any,
    @Body() blockUserDto: BlockUserDto,
  ) {
    await this.blockService.blockUser(user.uniqid, blockUserDto.blockedId);
    return { status: '0', statusInfo: '已拉黑该用户' };
  }

  @Post('unblock')
  @ApiOperation({ summary: '取消拉黑' })
  async unblockUser(
    @CurrentUser() user: any,
    @Body() blockUserDto: BlockUserDto,
  ) {
    await this.blockService.unblockUser(user.uniqid, blockUserDto.blockedId);
    return { status: '0', statusInfo: '已取消拉黑' };
  }

  @Get('list')
  @ApiOperation({ summary: '获取拉黑列表' })
  async getBlockedUsers(@CurrentUser() user: any) {
    return this.blockService.getBlockedUsers(user.uniqid);
  }

  @Get('check')
  @ApiOperation({ summary: '检查是否被拉黑' })
  async isBlocked(
    @CurrentUser() user: any,
    @Query('targetId') targetId: string,
  ) {
    const isBlocked = await this.blockService.isBlocked(user.uniqid, targetId);
    return { status: '0', data: { isBlocked } };
  }
}
