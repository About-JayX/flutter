import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { VIPService } from './vip.service';
import { VIPController } from './vip.controller';
import { VIPSubscription } from './entities/vip-subscription.entity';
import { CallMinutes } from './entities/call-minutes.entity';
import { User } from '../users/entities/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([VIPSubscription, CallMinutes, User])],
  controllers: [VIPController],
  providers: [VIPService],
  exports: [VIPService],
})
export class VIPModule {}
