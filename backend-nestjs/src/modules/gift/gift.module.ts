import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { GiftService } from './gift.service';
import { GiftController } from './gift.controller';
import { Gift } from './entities/gift.entity';
import { GiftRecord } from './entities/gift-record.entity';
import { User } from '../users/entities/user.entity';
import { Friendship } from '../match/entities/friendship.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Gift, GiftRecord, User, Friendship])],
  controllers: [GiftController],
  providers: [GiftService],
  exports: [GiftService],
})
export class GiftModule {}
