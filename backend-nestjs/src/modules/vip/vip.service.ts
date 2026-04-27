import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Inject } from '@nestjs/common';
import type { Cache } from 'cache-manager';
import { VIPSubscription } from './entities/vip-subscription.entity';
import { CallMinutes } from './entities/call-minutes.entity';
import { User } from '../users/entities/user.entity';

export interface VIPStatus {
  isVIP: boolean;
  expireDate: Date | null;
  autoRenew: boolean;
  daysLeft: number;
}

export interface VIPBenefit {
  id: string;
  name: string;
  description: string;
}

@Injectable()
export class VIPService {
  private readonly logger = new Logger(VIPService.name);

  constructor(
    @InjectRepository(VIPSubscription)
    private readonly vipSubscriptionRepository: Repository<VIPSubscription>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(CallMinutes)
    private readonly callMinutesRepository: Repository<CallMinutes>,
    @Inject(CACHE_MANAGER)
    private readonly cacheManager: Cache,
  ) {}

  async activateVIP(
    userId: string,
    vipData: { productId: string; expireDate: Date; type: string },
  ): Promise<VIPSubscription> {
    const subscription = this.vipSubscriptionRepository.create({
      userId,
      productId: vipData.productId,
      subscriptionId: `sub_${userId}_${Date.now()}`,
      type: vipData.type,
      status: 'active',
      startDate: new Date(),
      expireDate: vipData.expireDate,
      autoRenew: 1,
    });

    const savedSubscription =
      await this.vipSubscriptionRepository.save(subscription);

    await this.userRepository.update(
      { uniqid: userId },
      {
        isVIP: 1,
        vipExpireTime: vipData.expireDate,
      },
    );

    await this.grantVIPMinutes(userId);
    await this.cacheManager.del(`vip:${userId}`);

    return savedSubscription;
  }

  async renewVIP(
    userId: string,
    vipData: { productId: string; expireDate: Date },
  ): Promise<void> {
    await this.vipSubscriptionRepository.update(
      { userId, status: 'active' },
      {
        expireDate: vipData.expireDate,
        productId: vipData.productId,
      },
    );

    await this.userRepository.update(
      { uniqid: userId },
      { vipExpireTime: vipData.expireDate },
    );

    await this.grantVIPMinutes(userId);
    await this.cacheManager.del(`vip:${userId}`);
  }

  async cancelRenewal(userId: string): Promise<void> {
    await this.vipSubscriptionRepository.update(
      { userId, status: 'active' },
      { autoRenew: 0 },
    );
  }

  async deactivateVIP(userId: string): Promise<void> {
    await this.vipSubscriptionRepository.update(
      { userId, status: 'active' },
      { status: 'expired' },
    );

    await this.userRepository.update(
      { uniqid: userId },
      {
        isVIP: 0,
        vipExpireTime: undefined,
      },
    );

    await this.cacheManager.del(`vip:${userId}`);
  }

  async checkVIPStatus(userId: string): Promise<VIPStatus> {
    const cached = await this.cacheManager.get<VIPStatus>(`vip:${userId}`);
    if (cached) {
      return cached;
    }

    const user = await this.userRepository.findOne({
      where: { uniqid: userId },
      select: ['isVIP', 'vipExpireTime'],
    });

    const subscription = await this.vipSubscriptionRepository.findOne({
      where: { userId, status: 'active' },
    });

    const status: VIPStatus = {
      isVIP: user?.isVIP === 1,
      expireDate: user?.vipExpireTime || null,
      autoRenew: subscription?.autoRenew === 1,
      daysLeft: user?.vipExpireTime
        ? Math.max(
            0,
            Math.ceil(
              (new Date(user.vipExpireTime).getTime() - Date.now()) /
                (1000 * 60 * 60 * 24),
            ),
          )
        : 0,
    };

    await this.cacheManager.set(`vip:${userId}`, status, 300);

    return status;
  }

  private async grantVIPMinutes(userId: string): Promise<void> {
    const currentMonth = new Date().getMonth();
    const currentYear = new Date().getFullYear();
    const key = `vip_minutes_granted:${userId}:${currentYear}:${currentMonth}`;

    const alreadyGranted = await this.cacheManager.get(key);
    if (alreadyGranted) {
      return;
    }

    await this.callMinutesRepository.save({
      userId,
      type: 'video',
      totalMinutes: 60,
      usedMinutes: 0,
      remainingMinutes: 60,
      expireDate: new Date(currentYear, currentMonth + 1, 1),
    });

    await this.callMinutesRepository.save({
      userId,
      type: 'voice',
      totalMinutes: 120,
      usedMinutes: 0,
      remainingMinutes: 120,
      expireDate: new Date(currentYear, currentMonth + 1, 1),
    });

    await this.cacheManager.set(key, true, 2592000);
  }

  async getVIPBenefits(): Promise<VIPBenefit[]> {
    return [
      { id: 'badge', name: '专属会员徽章', description: '展示 VIP 专属标识' },
      { id: 'extra_swipes', name: '每日额外滑动次数', description: '无限滑动' },
      { id: 'rewind', name: '滑动撤回', description: '撤销上一次滑动操作' },
      { id: 'chat_lock', name: '聊天上锁', description: '为私聊设置密码保护' },
      { id: 'incognito', name: '隐身浏览', description: '匿名浏览他人主页' },
      {
        id: 'hide_online',
        name: '隐藏在线状态',
        description: '不显示在线/离线状态',
      },
      {
        id: 'full_privacy',
        name: '资料完全隐藏',
        description: '隐藏年龄、国家、性别',
      },
      {
        id: 'video_call',
        name: '解锁音视频通话',
        description: '发起语音/视频通话',
      },
      {
        id: 'free_minutes',
        name: '每月免费时长',
        description: '60分钟视频 + 120分钟语音',
      },
      { id: 'hd_video', name: '更高清画质', description: '享受高清视频通话' },
      {
        id: 'noise_reduction',
        name: '语音降噪',
        description: '清晰的语音通话体验',
      },
      { id: 'beauty', name: '美颜', description: '视频通话美颜功能' },
      {
        id: 'view_visitors',
        name: '查看谁看过你',
        description: '查看主页访客记录',
      },
      {
        id: 'custom_block_words',
        name: '自定义屏蔽骚扰词',
        description: '设置个性化屏蔽词',
      },
    ];
  }
}
