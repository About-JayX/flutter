import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Message } from './entities/message.entity';

export enum SystemMessageType {
  VIOLATION_WARNING = 'violation_warning',
  VIP_EXPIRE_REMINDER = 'vip_expire_reminder',
  FRIEND_REQUEST = 'friend_request',
  CALL_MISSED = 'call_missed',
  GIFT_RECEIVED = 'gift_received',
}

@Injectable()
export class SystemMessageService {
  private readonly logger = new Logger(SystemMessageService.name);

  constructor(
    @InjectRepository(Message)
    private readonly messageRepository: Repository<Message>,
  ) {}

  async sendSystemMessage(
    userId: string,
    type: SystemMessageType,
    content: string,
  ): Promise<Message> {
    const message = this.messageRepository.create({
      senderId: 'system',
      receiverId: userId,
      type: 'text',
      content: JSON.stringify({
        type,
        content,
        timestamp: new Date().toISOString(),
      }),
      status: 'delivered',
    });

    return this.messageRepository.save(message);
  }

  async sendViolationWarning(userId: string, reason: string): Promise<void> {
    await this.sendSystemMessage(
      userId,
      SystemMessageType.VIOLATION_WARNING,
      `Your behavior violates our dating & community rules. Please communicate in a polite and respectful manner. Reason: ${reason}`,
    );
  }

  async sendVIPExpireReminder(userId: string, daysLeft: number): Promise<void> {
    await this.sendSystemMessage(
      userId,
      SystemMessageType.VIP_EXPIRE_REMINDER,
      `Your VIP membership will expire in ${daysLeft} days. Renew now to keep enjoying all VIP privileges!`,
    );
  }

  async sendFriendRequestNotification(
    userId: string,
    senderId: string,
    senderName: string,
  ): Promise<void> {
    await this.sendSystemMessage(
      userId,
      SystemMessageType.FRIEND_REQUEST,
      `${senderName} sent you a friend request`,
    );
  }

  async getSystemMessages(userId: string): Promise<Message[]> {
    return this.messageRepository.find({
      where: {
        senderId: 'system',
        receiverId: userId,
      },
      order: { createdAt: 'DESC' },
      take: 50,
    });
  }
}
