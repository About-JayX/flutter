import { Injectable, Logger } from '@nestjs/common';
import { InjectQueue } from '@nestjs/bull';
import { Queue, Job } from 'bullmq';

export interface QueueStats {
  waiting: number;
  active: number;
  completed: number;
  failed: number;
  delayed: number;
  paused: boolean;
}

export interface JobDetails {
  id: string;
  name: string;
  data: any;
  state: string;
  progress: number;
  timestamp: number;
  failedReason?: string;
  returnvalue?: any;
  attemptsMade?: number;
}

@Injectable()
export class QueueMonitoringService {
  private readonly logger = new Logger(QueueMonitoringService.name);

  constructor(
    @InjectQueue('activity-completion') 
    private readonly activityCompletionQueue: Queue,
  ) {}

  /**
   * 获取活动执行日志
   */
  async getActivityExecutionLogs(limit: number = 20): Promise<any[]> {
    try {
      // 这里需要注入 ActivityCompletionProcessor
      // 暂时返回空数组，实际使用时需要正确注入
      return [];
    } catch (error) {
      this.logger.error('获取执行日志失败:', error);
      return [];
    }
  }

  /**
   * 检查 Redis 连接状态
   */
  async checkRedisConnection(): Promise<{ status: string; message: string }> {
    try {
      // 这里需要访问 Redis 客户端进行 ping 测试
      // 暂时返回模拟数据
      return {
        status: 'connected',
        message: 'Redis 连接正常'
      };
    } catch (error) {
      return {
        status: 'disconnected',
        message: `Redis 连接失败: ${error.message}`
      };
    }
  }

  /**
   * 检查处理器状态
   */
  async checkProcessorStatus(): Promise<{ status: string; workers: number }> {
    try {
      // 这里可以检查处理器的工作状态
      return {
        status: 'running',
        workers: 1
      };
    } catch (error) {
      return {
        status: 'error',
        workers: 0
      };
    }
  }

  /**
   * 获取队列统计信息
   */
  async getQueueStats(): Promise<QueueStats> {
    try {
      // 使用新的 API 获取队列状态
      const [waiting, active, completed, failed, delayed] = await Promise.all([
        this.activityCompletionQueue.getWaiting(),
        this.activityCompletionQueue.getActive(),
        this.activityCompletionQueue.getCompleted(),
        this.activityCompletionQueue.getFailed(),
        this.activityCompletionQueue.getDelayed(),
      ]);

      // 检查队列是否暂停
      const isPaused = await this.activityCompletionQueue.isPaused();

      return {
        waiting: waiting.length,
        active: active.length,
        completed: completed.length,
        failed: failed.length,
        delayed: delayed.length,
        paused: isPaused,
      };
    } catch (error) {
      this.logger.error('Failed to get queue stats:', error);
      throw error;
    }
  }

  /**
   * 获取队列详情
   */
  async getQueueDetails(): Promise<any> {
    const stats = await this.getQueueStats();
    const jobs = await this.getRecentJobs(50);

    return {
      name: 'activity-completion',
      stats,
      jobs,
      timestamp: new Date().toISOString(),
    };
  }

  /**
   * 获取最近的任务
   */
  async getRecentJobs(count: number = 50): Promise<JobDetails[]> {
    try {
      // 获取各种状态的任务
      const [completedJobs, failedJobs, waitingJobs, activeJobs, delayedJobs] = await Promise.all([
        this.activityCompletionQueue.getJobs(['completed'], 0, count - 1),
        this.activityCompletionQueue.getJobs(['failed'], 0, count - 1),
        this.activityCompletionQueue.getJobs(['waiting'], 0, count - 1),
        this.activityCompletionQueue.getJobs(['active'], 0, count - 1),
        this.activityCompletionQueue.getJobs(['delayed'], 0, count - 1),
      ]);

      const allJobs = [
        ...completedJobs.map(job => this.formatJobDetails(job, 'completed')),
        ...failedJobs.map(job => this.formatJobDetails(job, 'failed')),
        ...waitingJobs.map(job => this.formatJobDetails(job, 'waiting')),
        ...activeJobs.map(job => this.formatJobDetails(job, 'active')),
        ...delayedJobs.map(job => this.formatJobDetails(job, 'delayed')),
      ];

      // 按时间戳排序，最新的在前
      return allJobs
        .sort((a, b) => b.timestamp - a.timestamp)
        .slice(0, count);
    } catch (error) {
      this.logger.error('Failed to get recent jobs:', error);
      throw error;
    }
  }

  /**
   * 格式化任务详情
   */
  private formatJobDetails(job: Job, state: string): JobDetails {
    // 安全处理 progress 字段
    let progressValue = 0;
    
    if (typeof job.progress === 'number') {
      progressValue = job.progress;
    } else if (typeof job.progress === 'string') {
      // 尝试将字符串转换为数字
      const parsed = parseFloat(job.progress);
      progressValue = isNaN(parsed) ? 0 : parsed;
    } else if (typeof job.progress === 'object' && job.progress !== null) {
      // 如果 progress 是对象，可以记录日志或使用默认值
      this.logger.debug(`Job ${job.id} has object progress:`, job.progress);
      progressValue = 0;
    } else if (job.progress === true) {
      // 如果 progress 是 true，表示 100%
      progressValue = 100;
    } else if (job.progress === false) {
      // 如果 progress 是 false，表示 0%
      progressValue = 0;
    }

    // 确保 progress 在 0-100 范围内
    progressValue = Math.max(0, Math.min(100, progressValue));

    return {
      id: job.id!,
      name: job.name,
      data: job.data,
      state,
      progress: progressValue,
      timestamp: job.timestamp || Date.now(),
      failedReason: job.failedReason,
      returnvalue: job.returnvalue,
      attemptsMade: job.attemptsMade,
    };
  }
    //   private formatJobDetails(job: Job, state: string): JobDetails {
    //     return {
    //       id: job.id!,
    //       name: job.name,
    //       data: job.data,
    //       state,
    //       progress: job.progress || 0,
    //       timestamp: job.timestamp || Date.now(),
    //       failedReason: job.failedReason,
    //       returnvalue: job.returnvalue,
    //       attemptsMade: job.attemptsMade,
    //     };
    //   }

  /**
   * 获取特定任务详情
   */
  async getJobDetails(jobId: string): Promise<JobDetails | null> {
    try {
      const job = await this.activityCompletionQueue.getJob(jobId);
      if (!job) {
        return null;
      }

      const state = await job.getState();
      return this.formatJobDetails(job, state);
    } catch (error) {
      this.logger.error(`Failed to get job details for ${jobId}:`, error);
      throw error;
    }
  }

  /**
   * 重试失败的任务
   */
  async retryJob(jobId: string): Promise<boolean> {
    try {
      const job = await this.activityCompletionQueue.getJob(jobId);
      if (!job) {
        return false;
      }

      // 检查任务状态
      const state = await job.getState();
      if (state !== 'failed') {
        this.logger.warn(`Job ${jobId} is not failed, current state: ${state}`);
        return false;
      }

      await job.retry();
      this.logger.log(`Job ${jobId} retried successfully`);
      return true;
    } catch (error) {
      this.logger.error(`Failed to retry job ${jobId}:`, error);
      throw error;
    }
  }

  /**
   * 删除任务
   */
  async removeJob(jobId: string): Promise<boolean> {
    try {
      const job = await this.activityCompletionQueue.getJob(jobId);
      if (!job) {
        return false;
      }

      await job.remove();
      this.logger.log(`Job ${jobId} removed successfully`);
      return true;
    } catch (error) {
      this.logger.error(`Failed to remove job ${jobId}:`, error);
      throw error;
    }
  }

  /**
   * 清空队列
   */
  async cleanQueue(
    grace: number = 5000, 
    limit: number = 1000, 
    type: 'completed' | 'wait' | 'active' | 'delayed' | 'failed' | 'paused' = 'completed'
  ): Promise<number> {
    try {
      const cleanedJobs = await this.activityCompletionQueue.clean(grace, limit, type);
      this.logger.log(`Cleaned ${cleanedJobs.length} ${type} jobs from queue`);
      return cleanedJobs.length;
    } catch (error) {
      this.logger.error(`Failed to clean ${type} jobs:`, error);
      throw error;
    }
  }

  /**
   * 暂停/恢复队列
   */
  async pauseQueue(pause: boolean): Promise<void> {
    try {
      if (pause) {
        await this.activityCompletionQueue.pause();
        this.logger.log('Queue paused');
      } else {
        await this.activityCompletionQueue.resume();
        this.logger.log('Queue resumed');
      }
    } catch (error) {
      this.logger.error(`Failed to ${pause ? 'pause' : 'resume'} queue:`, error);
      throw error;
    }
  }

  /**
   * 获取队列是否暂停
   */
  async isQueuePaused(): Promise<boolean> {
    return this.activityCompletionQueue.isPaused();
  }

  /**
   * 获取队列中的任务数量
   */
  async getJobCounts(): Promise<any> {
    try {
      const counts = await this.activityCompletionQueue.getJobCounts(
        'waiting', 'active', 'completed', 'failed', 'delayed'
      );
      return counts;
    } catch (error) {
      this.logger.error('Failed to get job counts:', error);
      throw error;
    }
  }

  /**
   * 获取队列指标（用于监控仪表板）
   */
  async getQueueMetrics(): Promise<any> {
    try {
      const [stats, jobCounts, isPaused] = await Promise.all([
        this.getQueueStats(),
        this.getJobCounts(),
        this.isQueuePaused(),
      ]);

      return {
        queueName: 'activity-completion',
        timestamp: new Date().toISOString(),
        isPaused,
        jobCounts,
        stats,
        memoryUsage: process.memoryUsage(),
        uptime: process.uptime(),
      };
    } catch (error) {
      this.logger.error('Failed to get queue metrics:', error);
      throw error;
    }
  }

  /**
   * 获取失败任务的详细信息
   */
  async getFailedJobs(limit: number = 50): Promise<JobDetails[]> {
    try {
      const failedJobs = await this.activityCompletionQueue.getJobs(['failed'], 0, limit - 1);
      return failedJobs.map(job => this.formatJobDetails(job, 'failed'));
    } catch (error) {
      this.logger.error('Failed to get failed jobs:', error);
      throw error;
    }
  }

  /**
   * 重试所有失败的任务
   */
  async retryAllFailedJobs(): Promise<{ success: number; failed: number }> {
    try {
      const failedJobs = await this.activityCompletionQueue.getJobs(['failed'], 0, 1000);
      let successCount = 0;
      let failedCount = 0;

      for (const job of failedJobs) {
        try {
          await job.retry();
          successCount++;
        } catch (error) {
          this.logger.error(`Failed to retry job ${job.id}:`, error);
          failedCount++;
        }
      }

      this.logger.log(`Retried ${successCount} failed jobs, ${failedCount} failed to retry`);
      return { success: successCount, failed: failedCount };
    } catch (error) {
      this.logger.error('Failed to retry all failed jobs:', error);
      throw error;
    }
  }
}