import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectQueue } from '@nestjs/bull';
import { Queue } from 'bullmq';
import { createBullBoard } from '@bull-board/api';
import { BullMQAdapter } from '@bull-board/api/bullMQAdapter'; // 使用 BullMQAdapter
import { ExpressAdapter } from '@bull-board/express';

@Injectable()
export class BullBoardService implements OnModuleInit {
  private serverAdapter: ExpressAdapter;
  private bullBoard: any;

  constructor(
    @InjectQueue('activity-completion') 
    private readonly activityCompletionQueue: Queue,
  ) {}

  onModuleInit() {
    this.setupBullBoard();
  }

  private setupBullBoard() {
    // 创建 Express 适配器
    this.serverAdapter = new ExpressAdapter();
    this.serverAdapter.setBasePath('/admin/queues');

    // 创建 BullBoard 实例 - 使用 BullMQAdapter
    this.bullBoard = createBullBoard({
      queues: [
        new BullMQAdapter(this.activityCompletionQueue as any), // 使用类型断言
      ],
      serverAdapter: this.serverAdapter,
    });
  }

  getRouter() {
    return this.serverAdapter.getRouter();
  }

  /**
   * 添加新队列到监控
   */
  addQueue(queue: Queue) {
    this.bullBoard.addQueue(new BullMQAdapter(queue as any));
  }

  /**
   * 移除队列监控
   */
  removeQueue(queueName: string) {
    this.bullBoard.removeQueue(queueName);
  }
}