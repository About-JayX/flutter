import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MatchService } from './match.service';
import { MatchController } from './match.controller';
import { User } from '../users/entities/user.entity';
import { Swipe } from './entities/swipe.entity';
import { Friendship } from './entities/friendship.entity';
import { Block } from '../block/entities/block.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, Swipe, Friendship, Block])],
  controllers: [MatchController],
  providers: [MatchService],
  exports: [MatchService],
})
export class MatchModule {}
