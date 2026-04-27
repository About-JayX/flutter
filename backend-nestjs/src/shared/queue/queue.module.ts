import { Module } from '@nestjs/common';
import { BullModule } from '@nestjs/bull';
import { QueueService } from './queue.service';
import { QUEUE_JOB_NAMES } from '@root/src/shared/queue/constants/index.constants';
@Module({
  imports: [
    BullModule.forRoot({
      // 使用 'redis' 而不是 'connection'
      redis: {
        host: process.env.REDIS_HOST || 'localhost',
        port: parseInt(process.env.REDIS_PORT || '6379', 10),
        password: process.env.REDIS_PASSWORD,
        db: parseInt(process.env.REDIS_DB || '0', 10),
      },
      defaultJobOptions: {
        removeOnComplete: 100,
        removeOnFail: 100,
        attempts: 3,
        backoff: {
          type: 'exponential',
          delay: 1000,
        },
      },
    }),
    BullModule.registerQueue({
      name: 'activity-completion',
    }),
  ],
  providers: [QueueService],
  exports: [QueueService, BullModule],
})
export class QueueModule {}