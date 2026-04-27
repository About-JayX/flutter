import { Controller, Get, Post, Body, Query, Logger } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { MatchService } from './match.service';
import { MatchFiltersDto } from './dto/match-filters.dto';
import { SwipeCardDto } from './dto/swipe-card.dto';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';

@ApiTags('匹配')
@Controller('match')
export class MatchController {
  private readonly logger = new Logger(MatchController.name);

  constructor(private readonly matchService: MatchService) {}

  @Get('cards')
  @ApiOperation({ summary: '获取匹配卡片' })
  async getMatchCards(
    @CurrentUser() user: any,
    @Query() filters: MatchFiltersDto,
  ) {
    return this.matchService.getMatchCards(user.uniqid, filters);
  }

  @Post('swipe')
  @ApiOperation({ summary: '滑动卡片' })
  async swipeCard(
    @CurrentUser() user: any,
    @Body() swipeCardDto: SwipeCardDto,
  ) {
    return this.matchService.swipeCard(
      user.uniqid,
      swipeCardDto.targetId,
      swipeCardDto.action,
    );
  }

  @Post('rewind')
  @ApiOperation({ summary: '撤回滑动' })
  async rewindSwipe(@CurrentUser() user: any) {
    await this.matchService.rewindSwipe(user.uniqid);
    return { status: '0', statusInfo: '撤回成功' };
  }
}
