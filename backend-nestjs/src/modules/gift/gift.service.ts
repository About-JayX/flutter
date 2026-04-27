import {
  Injectable,
  Logger,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Inject } from '@nestjs/common';
import type { Cache } from 'cache-manager';
import { Gift } from './entities/gift.entity';
import { GiftRecord } from './entities/gift-record.entity';
import { User } from '../users/entities/user.entity';
import { Friendship } from '../match/entities/friendship.entity';
import { SendGiftDto } from './dto/send-gift.dto';
import { CreateGiftDto } from './dto/create-gift.dto';

@Injectable()
export class GiftService {
  private readonly logger = new Logger(GiftService.name);

  constructor(
    @InjectRepository(Gift)
    private readonly giftRepository: Repository<Gift>,
    @InjectRepository(GiftRecord)
    private readonly giftRecordRepository: Repository<GiftRecord>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Friendship)
    private readonly friendshipRepository: Repository<Friendship>,
    @Inject(CACHE_MANAGER)
    private readonly cacheManager: Cache,
  ) {}

  async getGifts(): Promise<Gift[]> {
    const cached = await this.cacheManager.get<Gift[]>('gifts:list');
    if (cached) {
      return cached;
    }

    const gifts = await this.giftRepository.find({
      where: { status: 'active' },
      order: { price: 'ASC' },
    });

    await this.cacheManager.set('gifts:list', gifts, 3600);

    return gifts;
  }

  async sendGift(
    senderId: string,
    sendGiftDto: SendGiftDto,
  ): Promise<GiftRecord> {
    const { receiverId, giftId } = sendGiftDto;

    const gift = await this.giftRepository.findOne({
      where: { id: giftId, status: 'active' },
    });

    if (!gift) {
      throw new NotFoundException('礼物不存在');
    }

    const isFriend = await this.checkFriendship(senderId, receiverId);
    if (!isFriend) {
      throw new BadRequestException('只能给好友赠送礼物');
    }

    const sender = await this.userRepository.findOne({
      where: { uniqid: senderId },
    });

    if (!sender || (sender.diamonds || 0) < gift.price) {
      throw new BadRequestException('钻石余额不足');
    }

    await this.userRepository.decrement(
      { uniqid: senderId },
      'diamonds',
      gift.price,
    );

    const giftRecord = this.giftRecordRepository.create({
      senderId,
      receiverId,
      giftId,
      price: gift.price,
    });

    const savedRecord = await this.giftRecordRepository.save(giftRecord);

    return savedRecord;
  }

  async getGiftRecords(
    userId: string,
    type: 'sent' | 'received',
    page = 1,
    limit = 20,
  ): Promise<GiftRecord[]> {
    const where =
      type === 'sent' ? { senderId: userId } : { receiverId: userId };

    return this.giftRecordRepository.find({
      where,
      order: { createdAt: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });
  }

  async createGift(createGiftDto: CreateGiftDto): Promise<Gift> {
    const gift = this.giftRepository.create(createGiftDto);
    const savedGift = await this.giftRepository.save(gift);

    await this.cacheManager.del('gifts:list');

    return savedGift;
  }

  async updateGift(
    giftId: string,
    updateGiftDto: Partial<CreateGiftDto>,
  ): Promise<Gift> {
    const gift = await this.giftRepository.findOne({
      where: { id: giftId },
    });

    if (!gift) {
      throw new NotFoundException('礼物不存在');
    }

    Object.assign(gift, updateGiftDto);
    const updatedGift = await this.giftRepository.save(gift);

    await this.cacheManager.del('gifts:list');

    return updatedGift;
  }

  async deleteGift(giftId: string): Promise<void> {
    await this.giftRepository.update({ id: giftId }, { status: 'inactive' });

    await this.cacheManager.del('gifts:list');
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
}
