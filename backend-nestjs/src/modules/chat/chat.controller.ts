import { Controller, Get, Post, Body, Query, Logger } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ChatService } from './chat.service';
import { SystemMessageService } from './system-message.service';
import { SendMessageDto } from './dto/send-message.dto';
import { GetMessagesDto } from './dto/get-messages.dto';
import { ChatLockDto } from './dto/chat-lock.dto';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';

@ApiTags('聊天')
@Controller('chat')
export class ChatController {
  private readonly logger = new Logger(ChatController.name);

  constructor(
    private readonly chatService: ChatService,
    private readonly systemMessageService: SystemMessageService,
  ) {}

  @Post('send')
  @ApiOperation({ summary: '发送消息' })
  async sendMessage(
    @CurrentUser() user: any,
    @Body() sendMessageDto: SendMessageDto,
  ) {
    return this.chatService.sendMessage(user.uniqid, sendMessageDto);
  }

  @Get('messages')
  @ApiOperation({ summary: '获取消息列表' })
  async getMessages(
    @CurrentUser() user: any,
    @Query('targetId') targetId: string,
    @Query() getMessagesDto: GetMessagesDto,
  ) {
    return this.chatService.getMessages(user.uniqid, targetId, getMessagesDto);
  }

  @Post('read')
  @ApiOperation({ summary: '标记消息为已读' })
  async markAsRead(
    @CurrentUser() user: any,
    @Body('senderId') senderId: string,
  ) {
    await this.chatService.markAsRead(user.uniqid, senderId);
    return { status: '0', statusInfo: '已标记为已读' };
  }

  @Post('lock')
  @ApiOperation({ summary: '设置/移除聊天上锁' })
  async setChatLock(
    @CurrentUser() user: any,
    @Body('targetId') targetId: string,
    @Body() chatLockDto: ChatLockDto,
  ) {
    await this.chatService.setChatLock(user.uniqid, targetId, chatLockDto);
    return { status: '0', statusInfo: '操作成功' };
  }

  @Post('verify-lock')
  @ApiOperation({ summary: '验证聊天上锁密码' })
  async verifyChatLock(
    @CurrentUser() user: any,
    @Body('targetId') targetId: string,
    @Body('password') password: string,
  ) {
    const isValid = await this.chatService.verifyChatLock(
      user.uniqid,
      targetId,
      password,
    );
    return { status: '0', data: { isValid } };
  }

  @Get('system-messages')
  @ApiOperation({ summary: '获取系统消息' })
  async getSystemMessages(@CurrentUser() user: any) {
    return this.systemMessageService.getSystemMessages(user.uniqid);
  }
}
