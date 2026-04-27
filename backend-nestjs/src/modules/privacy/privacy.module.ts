import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PrivacyService } from './privacy.service';
import { PrivacyController } from './privacy.controller';
import { User } from '../users/entities/user.entity';
import { ViewRecord } from './entities/view-record.entity';
import { Friendship } from '../match/entities/friendship.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, ViewRecord, Friendship])],
  controllers: [PrivacyController],
  providers: [PrivacyService],
  exports: [PrivacyService],
})
export class PrivacyModule {}
