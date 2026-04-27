import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FeedService } from './feed.service';
import { FeedController } from './feed.controller';
import { ModerationService } from './services/moderation.service';
import { Post } from './entities/post.entity';
import { Comment } from './entities/comment.entity';
import { User } from '../users/entities/user.entity';
import { Swipe } from '../match/entities/swipe.entity';
import { Friendship } from '../match/entities/friendship.entity';
import { Block } from '../block/entities/block.entity';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Post, Comment, User, Swipe, Friendship, Block]),
    UsersModule,
  ],
  controllers: [FeedController],
  providers: [FeedService, ModerationService],
  exports: [FeedService, ModerationService],
})
export class FeedModule {}
