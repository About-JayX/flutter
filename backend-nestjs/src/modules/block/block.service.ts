import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Inject } from '@nestjs/common';
import type { Cache } from 'cache-manager';
import { Block } from './entities/block.entity';
import { Friendship } from '../match/entities/friendship.entity';

@Injectable()
export class BlockService {
  private readonly logger = new Logger(BlockService.name);

  constructor(
    @InjectRepository(Block)
    private readonly blockRepository: Repository<Block>,
    @InjectRepository(Friendship)
    private readonly friendshipRepository: Repository<Friendship>,
    @Inject(CACHE_MANAGER)
    private readonly cacheManager: Cache,
  ) {}

  async blockUser(userId: string, blockedId: string): Promise<void> {
    const existing = await this.blockRepository.findOne({
      where: { userId, blockedId },
    });

    if (existing) {
      throw new BadRequestException('已拉黑该用户');
    }

    const block = this.blockRepository.create({
      userId,
      blockedId,
    });
    await this.blockRepository.save(block);

    await this.friendshipRepository.delete({
      userId,
      friendId: blockedId,
    });
    await this.friendshipRepository.delete({
      userId: blockedId,
      friendId: userId,
    });

    await this.updateBlockCache(userId);
    await this.updateBlockCache(blockedId);
  }

  async unblockUser(userId: string, blockedId: string): Promise<void> {
    await this.blockRepository.delete({
      userId,
      blockedId,
    });

    await this.updateBlockCache(userId);
  }

  async getBlockedUsers(userId: string): Promise<Block[]> {
    return this.blockRepository.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }

  async isBlocked(userId: string, targetId: string): Promise<boolean> {
    const block = await this.blockRepository.findOne({
      where: [
        { userId, blockedId: targetId },
        { userId: targetId, blockedId: userId },
      ],
    });

    return !!block;
  }

  private async updateBlockCache(userId: string): Promise<void> {
    const blocks = await this.blockRepository.find({
      where: { userId },
      select: ['blockedId'],
    });

    const blockedIds = blocks.map((b) => b.blockedId);
    await this.cacheManager.set(`blocks:${userId}`, blockedIds, 3600);
  }
}
