import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Inject } from '@nestjs/common';
import type { Cache } from 'cache-manager';
import * as bcrypt from 'bcrypt';
import { Message } from './entities/message.entity';
import { Friendship } from '../match/entities/friendship.entity';
import { Block } from '../block/entities/block.entity';
import { UsersService } from '../users/users.service';
import { SendMessageDto } from './dto/send-message.dto';
import { GetMessagesDto } from './dto/get-messages.dto';
import { ChatLockDto } from './dto/chat-lock.dto';
import { ZegoService } from '../zego/zego.service';

@Injectable()
export class ChatService {
  private readonly logger = new Logger(ChatService.name);

  constructor(
    @InjectRepository(Message)
    private readonly messageRepository: Repository<Message>,
    @InjectRepository(Friendship)
    private readonly friendshipRepository: Repository<Friendship>,
    @InjectRepository(Block)
    private readonly blockRepository: Repository<Block>,
    @Inject(CACHE_MANAGER)
    private readonly cacheManager: Cache,
    private readonly zegoService: ZegoService,
    private readonly usersService: UsersService,
  ) {}

  async sendMessage(
    senderId: string,
    sendMessageDto: SendMessageDto,
  ): Promise<Message> {
    const { receiverId, type, content } = sendMessageDto;

    const friendship = await this.friendshipRepository.findOne({
      where: [
        { userId: senderId, friendId: receiverId, status: 'accepted' },
        { userId: receiverId, friendId: senderId, status: 'accepted' },
      ],
    });

    if (!friendship) {
      throw new BadRequestException('只能给好友发送消息');
    }

    const isBlocked = await this.blockRepository.findOne({
      where: [
        { userId: senderId, blockedId: receiverId },
        { userId: receiverId, blockedId: senderId },
      ],
    });

    if (isBlocked) {
      throw new BadRequestException('无法发送消息');
    }

    await this.checkMessageLimit(senderId, receiverId);

    const isBlockedWord = await this.checkBlockedWords(receiverId, content);

    const message = this.messageRepository.create({
      senderId,
      receiverId,
      type,
      content,
      isBlocked: isBlockedWord ? 1 : 0,
      status: 'sent',
    });

    const savedMessage = await this.messageRepository.save(message);

    if (!isBlockedWord) {
      await this.zegoService.sendMessage(senderId, receiverId, {
        type: this.getZegoMessageType(type),
        content: JSON.stringify({
          messageId: savedMessage.id,
          content,
          timestamp: savedMessage.createdAt,
        }),
      });
    }

    return savedMessage;
  }

  async getMessages(
    userId: string,
    targetId: string,
    getMessagesDto: GetMessagesDto,
  ): Promise<Message[]> {
    const { page = 1, limit = 50, beforeId } = getMessagesDto;

    const queryBuilder = this.messageRepository
      .createQueryBuilder('message')
      .where(
        '(message.senderId = :userId AND message.receiverId = :targetId) OR (message.senderId = :targetId AND message.receiverId = :userId)',
        { userId, targetId },
      );

    if (beforeId) {
      const beforeMessage = await this.messageRepository.findOne({
        where: { id: beforeId },
      });
      if (beforeMessage) {
        queryBuilder.andWhere('message.createdAt < :beforeTime', {
          beforeTime: beforeMessage.createdAt,
        });
      }
    } else {
      const threeDaysAgo = new Date();
      threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);
      queryBuilder.andWhere('message.createdAt >= :threeDaysAgo', {
        threeDaysAgo,
      });
    }

    queryBuilder
      .orderBy('message.createdAt', 'DESC')
      .skip((page - 1) * limit)
      .take(limit);

    const messages = await queryBuilder.getMany();

    await this.markAsRead(userId, targetId);

    return messages.reverse();
  }

  async markAsRead(userId: string, senderId: string): Promise<void> {
    await this.messageRepository.update(
      {
        senderId,
        receiverId: userId,
        status: 'delivered',
      },
      { status: 'read' },
    );
  }

  private async checkMessageLimit(
    senderId: string,
    receiverId: string,
  ): Promise<void> {
    const recentMessages = await this.messageRepository.find({
      where: [
        { senderId, receiverId },
        { senderId: receiverId, receiverId: senderId },
      ],
      order: { createdAt: 'DESC' },
      take: 3,
    });

    if (recentMessages.length >= 2) {
      const senderMessages = recentMessages.filter(
        (m) => m.senderId === senderId,
      );
      const receiverMessages = recentMessages.filter(
        (m) => m.senderId === receiverId,
      );

      if (senderMessages.length >= 2 && receiverMessages.length === 0) {
        throw new BadRequestException(
          "You can't send a new message until the other person replies",
        );
      }
    }
  }

  private async checkBlockedWords(
    receiverId: string,
    content: string,
  ): Promise<boolean> {
    const receiver = await this.usersService.getProfile(receiverId);
    if (!receiver.blockedWords || receiver.blockedWords.length === 0) {
      return false;
    }

    return receiver.blockedWords.some((word: string) =>
      content.toLowerCase().includes(word.toLowerCase()),
    );
  }

  async setChatLock(
    userId: string,
    targetId: string,
    chatLockDto: ChatLockDto,
  ): Promise<void> {
    const { password, action } = chatLockDto;

    if (action === 'set') {
      const hashedPassword = await bcrypt.hash(password, 10);
      await this.cacheManager.set(
        `chat_lock:${userId}:${targetId}`,
        hashedPassword,
        0,
      );
    } else if (action === 'remove') {
      await this.cacheManager.del(`chat_lock:${userId}:${targetId}`);
    }
  }

  async verifyChatLock(
    userId: string,
    targetId: string,
    password: string,
  ): Promise<boolean> {
    const hashedPassword = await this.cacheManager.get<string>(
      `chat_lock:${userId}:${targetId}`,
    );

    if (!hashedPassword) {
      return true;
    }

    return bcrypt.compare(password, hashedPassword);
  }

  private getZegoMessageType(type: string): number {
    const typeMap: Record<string, number> = {
      text: 1,
      image: 2,
      audio: 3,
      video: 4,
      gift: 5,
    };
    return typeMap[type] || 1;
  }
}
