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
import { CallRecord } from './entities/call-record.entity';
import { CallMinutes } from '../vip/entities/call-minutes.entity';
import { Friendship } from '../match/entities/friendship.entity';
import { UsersService } from '../users/users.service';
import { ZegoService } from '../zego/zego.service';
import { InitiateCallDto } from './dto/initiate-call.dto';
import { EndCallDto } from './dto/end-call.dto';

export interface CallInitResult {
  callId: string;
  roomId: string;
  token: string;
}

@Injectable()
export class CallService {
  private readonly logger = new Logger(CallService.name);

  constructor(
    @InjectRepository(CallRecord)
    private readonly callRecordRepository: Repository<CallRecord>,
    @InjectRepository(CallMinutes)
    private readonly callMinutesRepository: Repository<CallMinutes>,
    @InjectRepository(Friendship)
    private readonly friendshipRepository: Repository<Friendship>,
    @Inject(CACHE_MANAGER)
    private readonly cacheManager: Cache,
    private readonly zegoService: ZegoService,
    private readonly usersService: UsersService,
  ) {}

  async initiateCall(
    callerId: string,
    initiateCallDto: InitiateCallDto,
  ): Promise<CallInitResult> {
    const { calleeId, type } = initiateCallDto;

    const friendship = await this.friendshipRepository.findOne({
      where: [
        { userId: callerId, friendId: calleeId, status: 'accepted' },
        { userId: calleeId, friendId: callerId, status: 'accepted' },
      ],
    });

    if (!friendship) {
      throw new BadRequestException('只能给好友发起通话');
    }

    const caller = await this.usersService.getProfile(callerId);
    if (!caller.isVIP) {
      throw new BadRequestException(
        'Only VIP users can initiate video/voice calls',
      );
    }

    const hasEnoughMinutes = await this.checkCallMinutes(callerId, type);
    if (!hasEnoughMinutes) {
      throw new BadRequestException('Your complimentary minutes have expired');
    }

    const roomId = `call_${callerId}_${calleeId}_${Date.now()}`;
    const room = await this.zegoService.createRoom(roomId, callerId);

    const callRecord = this.callRecordRepository.create({
      callerId,
      calleeId,
      type,
      roomId,
      status: 'initiated',
    });
    await this.callRecordRepository.save(callRecord);

    await this.cacheManager.set(
      `call:${roomId}`,
      {
        callId: callRecord.id,
        callerId,
        calleeId,
        type,
        startTime: Date.now(),
      },
      3600,
    );

    return {
      callId: callRecord.id,
      roomId: room.roomId,
      token: room.token,
    };
  }

  async endCall(userId: string, endCallDto: EndCallDto): Promise<void> {
    const { callId } = endCallDto;

    const callRecord = await this.callRecordRepository.findOne({
      where: { id: callId },
    });

    if (!callRecord) {
      throw new NotFoundException('通话记录不存在');
    }

    const duration = Math.floor(
      (Date.now() - callRecord.createdAt.getTime()) / 1000,
    );
    const costMinutes = Math.ceil(duration / 60);

    callRecord.status = 'ended';
    callRecord.duration = duration;
    callRecord.costMinutes = costMinutes;
    await this.callRecordRepository.save(callRecord);

    if (costMinutes > 0) {
      await this.deductCallMinutes(
        callRecord.callerId,
        callRecord.type,
        costMinutes,
      );
    }

    await this.cacheManager.del(`call:${callRecord.roomId}`);
  }

  private async checkCallMinutes(
    userId: string,
    type: string,
  ): Promise<boolean> {
    const user = await this.usersService.getProfile(userId);
    if (
      user.isVIP &&
      user.vipExpireTime &&
      new Date(user.vipExpireTime) > new Date()
    ) {
      const monthlyMinutes = type === 'video' ? 60 : 120;
      const usedKey = `vip_minutes:${userId}:${type}:${new Date().getMonth()}`;
      const usedMinutes = (await this.cacheManager.get<number>(usedKey)) || 0;

      if (usedMinutes < monthlyMinutes) {
        return true;
      }
    }

    const callMinutes = await this.callMinutesRepository.findOne({
      where: { userId, type },
    });

    if (callMinutes && callMinutes.remainingMinutes > 0) {
      return true;
    }

    return false;
  }

  private async deductCallMinutes(
    userId: string,
    type: string,
    minutes: number,
  ): Promise<void> {
    const user = await this.usersService.getProfile(userId);
    if (
      user.isVIP &&
      user.vipExpireTime &&
      new Date(user.vipExpireTime) > new Date()
    ) {
      const monthlyMinutes = type === 'video' ? 60 : 120;
      const usedKey = `vip_minutes:${userId}:${type}:${new Date().getMonth()}`;
      const usedMinutes = (await this.cacheManager.get<number>(usedKey)) || 0;

      const remainingVipMinutes = monthlyMinutes - usedMinutes;
      if (remainingVipMinutes >= minutes) {
        await this.cacheManager.set(usedKey, usedMinutes + minutes, 2592000);
        return;
      } else {
        await this.cacheManager.set(usedKey, monthlyMinutes, 2592000);
        minutes -= remainingVipMinutes;
      }
    }

    if (minutes > 0) {
      await this.callMinutesRepository.decrement(
        { userId, type },
        'remainingMinutes',
        minutes,
      );
    }
  }

  async getCallRecords(
    userId: string,
    page = 1,
    limit = 20,
  ): Promise<CallRecord[]> {
    return this.callRecordRepository.find({
      where: [{ callerId: userId }, { calleeId: userId }],
      order: { createdAt: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });
  }
}
