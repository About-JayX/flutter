import {
  Injectable,
  Logger,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Inject } from '@nestjs/common';
import type { Cache } from 'cache-manager';
import { User } from '../users/entities/user.entity';
import { Swipe } from './entities/swipe.entity';
import { Friendship } from './entities/friendship.entity';
import { Block } from '../block/entities/block.entity';
import { MatchFiltersDto } from './dto/match-filters.dto';

export interface MatchCard {
  userId: string;
  nickName: string;
  avatar: string | null;
  age: number;
  gender: string;
  country: string;
  interests: string[];
  personality: string[];
  chatPurpose: string[];
  communicationStyle: string[];
  status: string;
  score: number;
}

export interface SwipeResult {
  matched: boolean;
  message: string;
}

@Injectable()
export class MatchService {
  private readonly logger = new Logger(MatchService.name);

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Swipe)
    private readonly swipeRepository: Repository<Swipe>,
    @InjectRepository(Friendship)
    private readonly friendshipRepository: Repository<Friendship>,
    @InjectRepository(Block)
    private readonly blockRepository: Repository<Block>,
    @Inject(CACHE_MANAGER)
    private readonly cacheManager: Cache,
  ) {}

  async getMatchCards(
    userId: string,
    filters: MatchFiltersDto,
  ): Promise<MatchCard[]> {
    const cacheKey = `match:${userId}:${JSON.stringify(filters)}`;

    const cached = await this.cacheManager.get<MatchCard[]>(cacheKey);
    if (cached) {
      return cached;
    }

    const currentUser = await this.userRepository.findOne({
      where: { uniqid: userId },
    });

    if (!currentUser) {
      throw new NotFoundException('用户不存在');
    }

    const swipedUsers = await this.getSwipedUsers(userId);
    const blockedUsers = await this.getBlockedUsers(userId);
    const friends = await this.getFriends(userId);

    const queryBuilder = this.userRepository
      .createQueryBuilder('user')
      .where('user.uniqid != :userId', { userId });

    const excludedUsers = [...swipedUsers, ...friends, ...blockedUsers];
    if (excludedUsers.length > 0) {
      queryBuilder.andWhere('user.uniqid NOT IN (:...excludedUsers)', {
        excludedUsers,
      });
    }

    if (filters.gender) {
      queryBuilder.andWhere('user.gender = :gender', {
        gender: filters.gender,
      });
    }

    if (filters.minAge || filters.maxAge) {
      const minDate = filters.maxAge
        ? this.calculateBirthDate(filters.maxAge)
        : null;
      const maxDate = filters.minAge
        ? this.calculateBirthDate(filters.minAge)
        : null;

      if (minDate) {
        queryBuilder.andWhere('user.birthDate <= :minDate', { minDate });
      }
      if (maxDate) {
        queryBuilder.andWhere('user.birthDate >= :maxDate', { maxDate });
      }
    }

    const candidates = await queryBuilder.take(50).getMany();

    const matchCards = candidates.map((candidate) => ({
      userId: candidate.uniqid,
      nickName: candidate.userNickName,
      avatar: candidate.avatar,
      age: this.calculateAge(candidate.birthDate),
      gender: candidate.gender,
      country: candidate.country,
      interests: candidate.interests,
      personality: candidate.personality,
      chatPurpose: candidate.chatPurpose,
      communicationStyle: candidate.communicationStyle,
      status: candidate.status,
      score: this.calculateMatchScore(currentUser, candidate),
    }));

    matchCards.sort((a, b) => b.score - a.score);

    const result = matchCards.slice(0, 20);
    await this.cacheManager.set(cacheKey, result, 300);

    return result;
  }

  async swipeCard(
    userId: string,
    targetId: string,
    action: string,
  ): Promise<SwipeResult> {
    const today = new Date().toISOString().split('T')[0];
    const swipeKey = `swipe:${userId}:${today}`;
    const swipeCount = (await this.cacheManager.get<number>(swipeKey)) || 0;

    const user = await this.userRepository.findOne({
      where: { uniqid: userId },
    });
    const maxSwipes = user?.isVIP ? 1000 : 6;

    if (swipeCount >= maxSwipes) {
      throw new BadRequestException('今日滑动次数已达上限');
    }

    const swipe = this.swipeRepository.create({
      userId,
      targetId,
      action,
    });
    await this.swipeRepository.save(swipe);

    await this.cacheManager.set(swipeKey, swipeCount + 1, 86400);

    if (action === 'like') {
      const mutualLike = await this.swipeRepository.findOne({
        where: {
          userId: targetId,
          targetId: userId,
          action: 'like',
        },
      });

      if (mutualLike) {
        const friendship1 = this.friendshipRepository.create({
          userId,
          friendId: targetId,
          status: 'accepted',
        });
        const friendship2 = this.friendshipRepository.create({
          userId: targetId,
          friendId: userId,
          status: 'accepted',
        });
        await this.friendshipRepository.save([friendship1, friendship2]);

        return {
          matched: true,
          message: '匹配成功！你们可以开始聊天了',
        };
      }
    }

    return {
      matched: false,
      message: '操作成功',
    };
  }

  async rewindSwipe(userId: string): Promise<void> {
    const today = new Date().toISOString().split('T')[0];
    const rewindKey = `rewind:${userId}:${today}`;
    const rewindCount = (await this.cacheManager.get<number>(rewindKey)) || 0;

    const user = await this.userRepository.findOne({
      where: { uniqid: userId },
    });
    const maxRewinds = user?.isVIP ? 100 : 5;

    if (rewindCount >= maxRewinds) {
      throw new BadRequestException('今日撤回次数已达上限');
    }

    const lastSwipe = await this.swipeRepository.findOne({
      where: { userId },
      order: { createdAt: 'DESC' },
    });

    if (!lastSwipe) {
      throw new BadRequestException('没有可撤回的记录');
    }

    await this.swipeRepository.remove(lastSwipe);
    await this.cacheManager.set(rewindKey, rewindCount + 1, 86400);
    await this.cacheManager.del(`match:${userId}:*`);
  }

  private calculateMatchScore(user: User, candidate: User): number {
    let score = 0;

    const topicScore = this.calculateTopicScore(
      user.interests,
      candidate.interests,
    );
    score += topicScore * 0.35;

    const purposeScore = this.calculateTopicScore(
      user.chatPurpose,
      candidate.chatPurpose,
    );
    score += purposeScore * 0.25;

    const personalityScore = this.calculatePersonalityScore(
      user.personality,
      candidate.personality,
    );
    score += personalityScore * 0.2;

    const communicationScore = this.calculateCommunicationScore(
      user.communicationStyle,
      candidate.communicationStyle,
    );
    score += communicationScore * 0.2;

    return Math.round(score);
  }

  private calculateTopicScore(
    userTopics: string[] | null,
    candidateTopics: string[] | null,
  ): number {
    if (!userTopics || !candidateTopics) return 0;

    const commonTopics = userTopics.filter((topic) =>
      candidateTopics.includes(topic),
    );

    return (
      (commonTopics.length /
        Math.max(userTopics.length, candidateTopics.length)) *
      100
    );
  }

  private calculatePersonalityScore(
    userPersonality: string[] | null,
    candidatePersonality: string[] | null,
  ): number {
    if (!userPersonality || !candidatePersonality) return 0;

    const commonTraits = userPersonality.filter((trait) =>
      candidatePersonality.includes(trait),
    );

    const baseScore =
      (commonTraits.length /
        Math.max(userPersonality.length, candidatePersonality.length)) *
      60;
    const complementScore = 40;

    return Math.min(baseScore + complementScore, 100);
  }

  private calculateCommunicationScore(
    userStyle: string[] | null,
    candidateStyle: string[] | null,
  ): number {
    if (!userStyle || !candidateStyle) return 0;

    const matchMap: Record<string, string[]> = {
      text: ['text', 'voice'],
      voice: ['voice', 'text', 'video'],
      video: ['video', 'voice'],
    };

    let totalScore = 0;
    for (const style of userStyle) {
      if (candidateStyle.includes(style)) {
        totalScore += 100;
      } else if (matchMap[style]?.some((s) => candidateStyle.includes(s))) {
        totalScore += 70;
      } else {
        totalScore += 50;
      }
    }

    return totalScore / userStyle.length;
  }

  private calculateAge(birthDate: Date | null): number {
    if (!birthDate) return 0;
    const today = new Date();
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDiff = today.getMonth() - birthDate.getMonth();
    if (
      monthDiff < 0 ||
      (monthDiff === 0 && today.getDate() < birthDate.getDate())
    ) {
      age--;
    }
    return age;
  }

  private calculateBirthDate(age: number): Date {
    const today = new Date();
    return new Date(
      today.getFullYear() - age,
      today.getMonth(),
      today.getDate(),
    );
  }

  private async getSwipedUsers(userId: string): Promise<string[]> {
    const swipes = await this.swipeRepository.find({
      where: { userId },
      select: ['targetId'],
    });
    return swipes.map((s) => s.targetId);
  }

  private async getBlockedUsers(userId: string): Promise<string[]> {
    const blocks = await this.blockRepository.find({
      where: { userId },
      select: ['blockedId'],
    });
    return blocks.map((b) => b.blockedId);
  }

  private async getFriends(userId: string): Promise<string[]> {
    const friendships = await this.friendshipRepository.find({
      where: { userId, status: 'accepted' },
      select: ['friendId'],
    });
    return friendships.map((f) => f.friendId);
  }
}
