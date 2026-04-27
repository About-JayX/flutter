import { Module, forwardRef } from '@nestjs/common';
import { BullBoardController } from './bull-board.controller';
import { BullBoardService } from './bull-board.service';
import { QueueModule } from '@root/src/shared/queue/queue.module';
@Module({
  imports: [
    forwardRef(() => QueueModule), // 导入 QueueModule
  ],
  controllers: [BullBoardController],
  providers: [BullBoardService],
  exports: [BullBoardService],
})
export class BullBoardModule {}