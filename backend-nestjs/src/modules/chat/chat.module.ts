import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ChatService } from './chat.service';
import { ChatController } from './chat.controller';
import { SystemMessageService } from './system-message.service';
import { Message } from './entities/message.entity';
import { Friendship } from '../match/entities/friendship.entity';
import { Block } from '../block/entities/block.entity';
import { UsersModule } from '../users/users.module';
import { ZegoModule } from '../zego/zego.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Message, Friendship, Block]),
    UsersModule,
    ZegoModule,
  ],
  controllers: [ChatController],
  providers: [ChatService, SystemMessageService],
  exports: [ChatService, SystemMessageService],
})
export class ChatModule {}
