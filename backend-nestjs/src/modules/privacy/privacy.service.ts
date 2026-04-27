import {
  Injectable,
  Logger,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Inject } from '@nestjs/common';
import type { Cache } from 'cache-manager';
import { User } from '../users/entities/user.entity';
import { ViewRecord } from './entities/view-record.entity';
import { Friendship } from '../match/entities/friendship.entity';
import { PrivacySettingsDto } from './dto/privacy-settings.dto';

export interface PrivacySettings {
  hideAge: boolean;
  hideCountry: boolean;
  hideOnlineStatus: boolean;
  profileVisibility: 'everyone' | 'friends' | 'only_me';
  allowStrangerMessage: boolean;
  incognito: boolean;
  allowViewHistory: boolean;
  showReadReceipt: boolean;
}

export interface FilteredProfile {
  id: string;
  nickName: string;
  avatar: string | null;
  age?: number;
  gender?: string;
  country?: string;
  status?: string;
  interests?: string[];
  personality?: string[];
  chatPurpose?: string[];
  communicationStyle?: string[];
}

@Injectable()
export class PrivacyService {
  private readonly logger = new Logger(PrivacyService.name);

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(ViewRecord)
    private readonly viewRecordRepository: Repository<ViewRecord>,
    @InjectRepository(Friendship)
    private readonly friendshipRepository: Repository<Friendship>,
    @Inject(CACHE_MANAGER)
    private readonly cacheManager: Cache,
  ) {}

  async updatePrivacySettings(
    userId: string,
    settings: PrivacySettingsDto,
  ): Promise<void> {
    const user = await this.userRepository.findOne({
      where: { uniqid: userId },
    });

    if (!user) {
      throw new NotFoundException('用户不存在');
    }

    user.privacySettings = {
      ...user.privacySettings,
      ...settings,
    } as any;

    await this.userRepository.save(user);
    await this.cacheManager.del(`privacy:${userId}`);
  }

  async getPrivacySettings(userId: string): Promise<PrivacySettings> {
    const cached = await this.cacheManager.get<PrivacySettings>(
      `privacy:${userId}`,
    );
    if (cached) {
      return cached;
    }

    const user = await this.userRepository.findOne({
      where: { uniqid: userId },
      select: ['privacySettings'],
    });

    const settings =
      (user?.privacySettings as PrivacySettings) ||
      this.getDefaultPrivacySettings();

    await this.cacheManager.set(`privacy:${userId}`, settings, 3600);

    return settings;
  }

  async filterUserProfile(
    viewerId: string,
    targetId: string,
    profile: any,
  ): Promise<FilteredProfile> {
    const privacySettings = await this.getPrivacySettings(targetId);

    const isFriend = await this.checkFriendship(viewerId, targetId);

    const canView = this.canViewProfile(privacySettings, viewerId, isFriend);
    if (!canView) {
      throw new ForbiddenException('无法查看该用户资料');
    }

    const filtered: FilteredProfile = {
      id: profile.uniqid || profile.id,
      nickName: profile.userNickName || profile.nickName,
      avatar: profile.avatar,
      status: profile.status,
    };

    if (!privacySettings.hideAge || isFriend) {
      filtered.age = profile.age;
    }

    if (!privacySettings.hideCountry || isFriend) {
      filtered.country = profile.country;
    }

    if (privacySettings.profileVisibility !== 'only_me' || isFriend) {
      filtered.gender = profile.gender;
    }

    if (privacySettings.profileVisibility === 'everyone' || isFriend) {
      filtered.interests = profile.interests;
      filtered.personality = profile.personality;
      filtered.chatPurpose = profile.chatPurpose;
      filtered.communicationStyle = profile.communicationStyle;
    }

    if (viewerId !== targetId) {
      await this.recordView(viewerId, targetId);
    }

    return filtered;
  }

  private canViewProfile(
    settings: PrivacySettings,
    viewerId: string,
    isFriend: boolean,
  ): boolean {
    if (viewerId === (settings as any).userId) {
      return true;
    }

    switch (settings.profileVisibility) {
      case 'everyone':
        return true;
      case 'friends':
        return isFriend;
      case 'only_me':
        return false;
      default:
        return true;
    }
  }

  private async recordView(viewerId: string, viewedId: string): Promise<void> {
    const viewerPrivacy = await this.getPrivacySettings(viewerId);
    if (viewerPrivacy.incognito) {
      return;
    }

    const viewedPrivacy = await this.getPrivacySettings(viewedId);
    if (!viewedPrivacy.allowViewHistory) {
      return;
    }

    const viewRecord = this.viewRecordRepository.create({
      viewerId,
      viewedId,
    });
    await this.viewRecordRepository.save(viewRecord);
  }

  async getViewHistory(
    userId: string,
    page = 1,
    limit = 20,
  ): Promise<ViewRecord[]> {
    return this.viewRecordRepository.find({
      where: { viewedId: userId },
      order: { createdAt: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });
  }

  private async checkFriendship(
    userId: string,
    targetId: string,
  ): Promise<boolean> {
    const friendship = await this.friendshipRepository.findOne({
      where: [
        { userId, friendId: targetId, status: 'accepted' },
        { userId: targetId, friendId: userId, status: 'accepted' },
      ],
    });
    return !!friendship;
  }

  private getDefaultPrivacySettings(): PrivacySettings {
    return {
      hideAge: false,
      hideCountry: false,
      hideOnlineStatus: false,
      profileVisibility: 'everyone',
      allowStrangerMessage: true,
      incognito: false,
      allowViewHistory: true,
      showReadReceipt: true,
    };
  }
}
