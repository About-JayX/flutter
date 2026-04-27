import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as jwt from 'jsonwebtoken';

export interface ZegoRoom {
  roomId: string;
  token: string;
}

export interface ZegoMessage {
  type: number;
  content: string;
}

@Injectable()
export class ZegoService {
  private readonly logger = new Logger(ZegoService.name);
  private readonly zegoAppId: number;
  private readonly zegoServerSecret: string;

  constructor(private readonly configService: ConfigService) {
    this.zegoAppId = parseInt(this.configService.get('ZEGO_APP_ID') || '0', 10);
    this.zegoServerSecret = this.configService.get('ZEGO_SERVER_SECRET') || '';
  }

  generateToken(userId: string, roomId?: string): string {
    const timestamp = Math.floor(Date.now() / 1000);
    const nonce = Math.floor(Math.random() * 2147483647);

    const payload: Record<string, any> = {
      app_id: this.zegoAppId,
      user_id: userId,
      nonce,
      ctime: timestamp,
      expire: timestamp + 3600,
    };

    if (roomId) {
      payload['room_id'] = roomId;
    }

    return jwt.sign(payload, this.zegoServerSecret, {
      algorithm: 'HS256',
    });
  }

  async createRoom(roomId: string, userId: string): Promise<ZegoRoom> {
    try {
      const response = await fetch('https://rtc-api.zego.im/v1/rooms', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.generateToken(userId)}`,
        },
        body: JSON.stringify({
          room_id: roomId,
          user_id: userId,
        }),
      });

      const data = await response.json();
      return {
        roomId: data.room_id || roomId,
        token: this.generateToken(userId, roomId),
      };
    } catch (error) {
      this.logger.error('Failed to create ZEGO room', error);
      throw new BadRequestException('创建通话房间失败');
    }
  }

  async sendMessage(
    senderId: string,
    receiverId: string,
    message: ZegoMessage,
  ): Promise<void> {
    try {
      await fetch('https://zim-api.zego.im/v2/peers/message', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.generateToken(senderId)}`,
        },
        body: JSON.stringify({
          from_user_id: senderId,
          to_user_id: receiverId,
          message_type: message.type,
          message_body: message.content,
        }),
      });
    } catch (error) {
      this.logger.error('Failed to send ZEGO message', error);
      throw new BadRequestException('发送消息失败');
    }
  }
}
