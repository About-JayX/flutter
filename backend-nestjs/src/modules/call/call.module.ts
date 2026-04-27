import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CallService } from './call.service';
import { CallController } from './call.controller';
import { CallRecord } from './entities/call-record.entity';
import { CallMinutes } from '../vip/entities/call-minutes.entity';
import { Friendship } from '../match/entities/friendship.entity';
import { UsersModule } from '../users/users.module';
import { ZegoModule } from '../zego/zego.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([CallRecord, CallMinutes, Friendship]),
    UsersModule,
    ZegoModule,
  ],
  controllers: [CallController],
  providers: [CallService],
  exports: [CallService],
})
export class CallModule {}
