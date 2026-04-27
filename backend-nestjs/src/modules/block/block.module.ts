import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BlockService } from './block.service';
import { BlockController } from './block.controller';
import { Block } from './entities/block.entity';
import { Friendship } from '../match/entities/friendship.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Block, Friendship])],
  controllers: [BlockController],
  providers: [BlockService],
  exports: [BlockService],
})
export class BlockModule {}
