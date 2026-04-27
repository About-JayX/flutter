import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Post } from '../entities/post.entity';
import { User } from '../../users/entities/user.entity';

@Injectable()
export class ModerationService {
  private readonly logger = new Logger(ModerationService.name);

  private readonly sensitiveWords = [
    '赌博', '色情', '暴力', '毒品', '诈骗',
    'gambling', 'porn', 'violence', 'drugs', 'fraud',
  ];

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async moderateContent(content: string, userId: string): Promise<{
    status: string;
    reason?: string;
  }> {
    const hasSensitiveWords = this.checkSensitiveWords(content);
    if (hasSensitiveWords) {
      return {
        status: 'rejected',
        reason: '内容包含敏感词',
      };
    }

    const isSpam = await this.checkSpam(content, userId);
    if (isSpam) {
      return {
        status: 'rejected',
        reason: '疑似垃圾信息',
      };
    }

    return { status: 'approved' };
  }

  private checkSensitiveWords(content: string): boolean {
    const lowerContent = content.toLowerCase();
    return this.sensitiveWords.some((word) => lowerContent.includes(word.toLowerCase()));
  }

  private async checkSpam(content: string, userId: string): Promise<boolean> {
    const recentPosts = await this.userRepository.query(
      `SELECT COUNT(*) as count FROM posts 
       WHERE userId = ? AND createdAt > DATE_SUB(NOW(), INTERVAL 1 MINUTE)`,
      [userId],
    );

    if (recentPosts[0].count >= 5) {
      return true;
    }

    const repeatedChars = /(.){10,}/.test(content);
    if (repeatedChars) {
      return true;
    }

    return false;
  }

  async checkBlockedWords(content: string, receiverId: string): Promise<boolean> {
    const receiver = await this.userRepository.findOne({
      where: { uniqid: receiverId },
      select: ['blockedWords'],
    });

    if (!receiver || !receiver.blockedWords || receiver.blockedWords.length === 0) {
      return false;
    }

    const lowerContent = content.toLowerCase();
    return receiver.blockedWords.some((word) =>
      lowerContent.includes(word.toLowerCase()),
    );
  }
}
