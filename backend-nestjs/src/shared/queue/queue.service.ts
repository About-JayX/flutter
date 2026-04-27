import { Injectable, Logger } from '@nestjs/common';
import { InjectQueue } from '@nestjs/bull';
import { Queue, Job } from 'bullmq';
import { QUEUE_JOB_NAMES } from '@root/src/shared/queue/constants/index.constants';

@Injectable()
export class QueueService {
  private readonly logger = new Logger(QueueService.name);

  constructor(
    @InjectQueue('activity-completion') 
    private readonly activityCompletionQueue: Queue,
  ) {}

  /**
   * 格式化剩余时间
   */
  private formatTimeLeft(milliseconds: number): string {
    if (milliseconds <= 0) return '已到期';
    
    const seconds = Math.floor(milliseconds / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    const days = Math.floor(hours / 24);

    if (days > 0) {
      return `${days}天 ${hours % 24}小时 ${minutes % 60}分钟`;
    } else if (hours > 0) {
      return `${hours}小时 ${minutes % 60}分钟 ${seconds % 60}秒`;
    } else if (minutes > 0) {
      return `${minutes}分钟 ${seconds % 60}秒`;
    } else {
      return `${seconds}秒`;
    }
  }
 /**
   * 格式化本地时间（不使用时区转换）
   */
  private formatLocalTime(date: Date): string {
    // 直接使用日期对象的方法，不进行时区转换
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    
    return `${year}/${month}/${day} ${hours}:${minutes}:${seconds}`;
  }

  /**
   * 验证时间计算是否正确
   */
  private validateTimeCalculation(now: Date, endTime: Date, delay: number): void {
    const expectedEnd = new Date(now.getTime() + delay);
    
    this.logger.log('=== 时间计算验证 ===');
    this.logger.log(`现在时间: ${this.formatLocalTime(now)}`);
    this.logger.log(`结束时间: ${this.formatLocalTime(endTime)}`);
    this.logger.log(`计算延迟: ${delay}ms`);
    this.logger.log(`预计执行: ${this.formatLocalTime(expectedEnd)}`);
    
    const timeDiff = Math.abs(expectedEnd.getTime() - endTime.getTime());
    if (timeDiff > 1000) { // 允许1秒误差
      this.logger.warn(`⚠️ 时间计算可能有误，差异: ${timeDiff}ms`);
    } else {
      this.logger.log('✅ 时间计算正确');
    }
  }

  // /**
  //  * 计算从现在到任务结束的延迟时间
  //  */
  private calculateDelay(endTime: Date): number {
    const now = new Date();
    const delay = endTime.getTime() - now.getTime();

    this.logger.log(`⏱️ 延迟计算:`);
    this.logger.log(`   - 现在: ${this.formatLocalTime(now)} (${now.getTime()})`);
    this.logger.log(`   - 结束: ${this.formatLocalTime(endTime)} (${endTime.getTime()})`);
    this.logger.log(`   - 延迟: ${delay}ms`);

    // 如果任务已经结束，立即执行
    return Math.max(0, delay);
  }

  /**
   * 添加任务结束延时任务 - 修复时间显示
   */
  async addActivityCompletionJob( 
    activityId: string,  
    endTime: Date, 
    bussinessType: string,   
    title: string,  
  ): Promise<{ 
    activityId: string; 
  }> {
    const now = new Date();
    const jobDelay = this.calculateDelay(endTime);
    const systemCalculateEndTime = new Date(now.getTime() + jobDelay);
    
    this.logger.log('🎯 === 创建延时任务 ===');
    this.logger.log(`🆔 任务ID: ${activityId}`);
    this.logger.log(`🆔 业务类别: ${bussinessType}`);
    this.logger.log(`🆔 业务名称: ${title}`);
    this.logger.log(`📍 延时任务开始的时间【当前服务器时间: ${this.formatLocalTime(now)}`);
    this.logger.log(`📍 业务开始执行的时间【任务结束时间-业务设置: ${this.formatLocalTime(endTime)}`);
    this.logger.log(`📍 业务的执行时间【任务结束时间-程序计算【: ${this.formatLocalTime(systemCalculateEndTime)}`);
    // this.logger.log(`⏱️ 延时设置: ${jobDelay}ms (${Math.round(jobDelay/1000)}秒)`);
    this.logger.log(`⏳ 业务执行剩余时间【任务结束剩余时间: ${this.formatTimeLeft(jobDelay)}`);

    // 验证时间计算
    // this.validateTimeCalculation(now, endTime, jobDelay);

    // ============ 执行队列任务 =============================
    // 参数
      // add(
      //     name: string,                          // 任务名称
      //     data: any,                             // 任务数据
      //     opts?: JobOptions                      // 任务选项
      // ): Promise<Job>;
      // interface JobOptions {
      //     jobId?: string;                         // 自定义任务ID
      //     delay?: number;                         // 延迟时间（毫秒）
      //     attempts?: number;                      // 重试次数
      //     backoff?: BackoffOptions;               // 重试策略
      //     lifo?: boolean;                         // LIFO 模式
      //     timeout?: number;                       // 超时时间
      //     removeOnComplete?: boolean | number;    // 完成后删除
      //     removeOnFail?: boolean | number;        // 失败后删除
      //     // ... 其他选项
      // }
    // 逻辑
      //  activities/processors/activity-completion.processor.ts
      //    handleActivityCompletion
    // 业务
      //  activities/activities.service.ts
      //    handleActivityCompletion
    const job = await this.activityCompletionQueue.add(
      QUEUE_JOB_NAMES.MISSION_COMPLETE,
      { 
        activityId, 
        endTime: this.formatLocalTime(endTime),// 任务结束时间【业务执行时间
        bussinessType: bussinessType,// 业务类别名称,标题 Mission Complete
        title: title,// 业务类别名称,标题 Mission Complete
        createdAt: this.formatLocalTime(now),// 任务创建时间
        // --------------------------------
        // expectedExecution: systemCalculateEndTime.toISOString(),// 任务计算出来的结束时间
      },
      { 
        jobId: `${QUEUE_JOB_NAMES.MISSION_COMPLETE}-${activityId}`,
        delay: jobDelay,
        attempts: 2,
        removeOnFail: { age: 24*3600, count: 1000 },
        removeOnComplete: true,
      }
    );
    this.logger.log('✅ 延时任务创建成功');
    this.logger.log(`📍 任务将在 ${this.formatLocalTime(systemCalculateEndTime)} 自动结束`);
    
    return {
      activityId
    };
  }
  
  /**
   * 检查特定任务的任务状态
   */
  async checkActivityJobStatus(activityId: string): Promise<any> {
    const jobId = `${QUEUE_JOB_NAMES.MISSION_COMPLETE}-${activityId}`;
    const job = await this.activityCompletionQueue.getJob(jobId);
    
    if (!job) {
      return {
        exists: false,
        status: 'not_found',
        message: '任务不存在，可能已执行完成或被删除'
      };
    }

    const state = await job.getState();
    const now = new Date();
    const createdTime = new Date(job.timestamp);
    const delayTime = job.delay || 0;
    const expectedExecutionTime = new Date(createdTime.getTime() + delayTime);
    const timeUntilExecution = Math.max(0, expectedExecutionTime.getTime() - now.getTime());
    const isOverdue = now > expectedExecutionTime;
    
    return {
      exists: true,
      jobId: job.id,
      state: state,
      activityId: job.data.activityId,
      createdAt: createdTime.toISOString(),
      expectedExecutionTime: expectedExecutionTime.toISOString(),
      currentTime: now.toISOString(),
      timeUntilExecution,
      timeUntilExecutionFormatted: this.formatTimeLeft(timeUntilExecution),
      isOverdue,
      overdueBy: isOverdue ? Math.max(0, now.getTime() - expectedExecutionTime.getTime()) : 0,
      progress: job.progress,
      attemptsMade: job.attemptsMade,
      failedReason: job.failedReason,
      data: job.data
    };
  }

  /**
   * 获取所有任务任务的倒计时信息
   */
  async getAllActivityCountdowns(): Promise<any[]> {
    const [delayedJobs, waitingJobs] = await Promise.all([
      this.activityCompletionQueue.getJobs(['delayed']),
      this.activityCompletionQueue.getJobs(['waiting'])
    ]);
    
    const allJobs = [...delayedJobs, ...waitingJobs];
    const now = new Date();
    
    return allJobs.map(job => {
      const createdTime = new Date(job.timestamp);
      const delayTime = job.delay || 0;
      const expectedExecutionTime = new Date(createdTime.getTime() + delayTime);
      const timeLeft = Math.max(0, expectedExecutionTime.getTime() - now.getTime());
      const isOverdue = now > expectedExecutionTime;
      
      return {
        jobId: job.id,
        activityId: job.data.activityId,
        state: isOverdue ? 'overdue' : 'scheduled',
        createdAt: createdTime.toISOString(),
        expectedExecutionTime: expectedExecutionTime.toISOString(),
        timeLeft,
        timeLeftFormatted: this.formatTimeLeft(timeLeft),
        isOverdue,
        overdueBy: isOverdue ? Math.max(0, now.getTime() - expectedExecutionTime.getTime()) : 0,
        data: job.data
      };
    });
  }

  /**
   * 手动触发任务结束任务
   */
  async triggerActivityCompletion(activityId: string): Promise<boolean> {
    try {
      const jobId = `${QUEUE_JOB_NAMES.MISSION_COMPLETE}-${activityId}`;
      const job = await this.activityCompletionQueue.getJob(jobId);
      
      if (!job) {
        this.logger.warn(`任务不存在: ${activityId}`);
        return false;
      }

      const state = await job.getState();
      if (state !== 'delayed' && state !== 'waiting') {
        this.logger.warn(`任务状态不是可触发状态: ${state}`);
        return false;
      }

      // 将任务移动到任务队列立即执行
      await job.promote();
      this.logger.log(`✅ 手动触发任务结束任务: ${activityId}`);
      return true;
    } catch (error) {
      this.logger.error(`手动触发任务失败:`, error);
      return false;
    }
  }

  /**
   * 移除任务结束任务
   */
  async removeActivityCompletionJob(activityId: string): Promise<void> {
    const job = await this.activityCompletionQueue.getJob(`${QUEUE_JOB_NAMES.MISSION_COMPLETE}-${activityId}`);
    if (job) {
      await job.remove();
      this.logger.log(`🗑️ 移除任务结束任务: ${activityId}`);
    }
  }

  /**
   * 获取队列状态
   */
  async getQueueStatus() {
    const [waiting, active, completed, failed, delayed] = await Promise.all([
      this.activityCompletionQueue.getWaiting(),
      this.activityCompletionQueue.getActive(),
      this.activityCompletionQueue.getCompleted(),
      this.activityCompletionQueue.getFailed(),
      this.activityCompletionQueue.getDelayed(),
    ]);

    return {
      waiting: waiting.length,
      active: active.length,
      completed: completed.length,
      failed: failed.length,
      delayed: delayed.length,
    };
  }
}