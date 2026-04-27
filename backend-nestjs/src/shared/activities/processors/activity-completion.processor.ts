import { Processor, Process, OnQueueEvent } from '@nestjs/bull';
import { Job } from 'bullmq';
import { Injectable, Logger } from '@nestjs/common';
import { ActivitiesService } from '../activities.service';
import { QUEUE_JOB_NAMES } from '@root/src/shared/queue/constants/index.constants';
import { TimeUtil } from '@root/src/common/utils/time.util';

@Injectable()
@Processor('activity-completion')
export class ActivityCompletionProcessor {
  private readonly logger = new Logger(ActivityCompletionProcessor.name);
  private readonly executionLogs: any[] = [];

  constructor(private readonly activitiesService: ActivitiesService) {}

  /**
   * 处理任务结束任务 - 增强版本
   */
  @Process(QUEUE_JOB_NAMES.MISSION_COMPLETE)
  async handleActivityCompletion(
    job: Job<{ 
      activityId: string; 
      endTime: string; 
      bussinessType: string; 
      title: string; 
      createdAt?: string 
  }>): Promise<void> {
    //  数据
      //  传惨数据
      const { 
        activityId, 
        endTime, 
        bussinessType,
        title,
        createdAt, 
      } = job.data;

      // 自定义数据
      const executionStart = new Date();

    //  日志
      const logEntry = {
        jobId: job.id,// 延时任务jobId
        activityId,// 延时任务唯一标志
        bussinessType: bussinessType,// 业务类别
        title: title,// 业务标题
        jobCreatedAt: createdAt, // 任务创建的时间
        taskStartSysTime: TimeUtil.formatTime(executionStart),// 业务执行【任务结束记录的系统时间
        plannedEndTime: endTime,// 业务执行【任务结束计划时间
        delay: executionStart.getTime() - new Date(endTime).getTime(),// 业务执行【任务结束延迟时间
        action: 'start',
        // -------------------------------------------
        bussinesstitle: title,
        timestamp: executionStart.toISOString(),
      };
      this.executionLogs.unshift(logEntry);
      this.executionLogs.splice(100); // 保持最近100条日志
    
    this.logger.log('🎯 ================ 开始处理任务结束任务 ================');
    this.logger.log(`📋 jobId: ${job.id}`);
    this.logger.log(`🆔 延迟任务唯一标志: ${activityId}`);
    this.logger.log(`🆔 业务标题: ${title}`);
    this.logger.log(`🆔 业务类型: ${bussinessType}`);
    this.logger.log(`⏰ 计划结束时间: ${endTime}`);
    this.logger.log(`🚀 实际[结束｜执行]时间: ${executionStart.toISOString()}`);
    this.logger.log(`⏱️ 执行延迟: ${logEntry.delay}ms`);

    try {
      // 检查任务是否存在
      const activity = await this.activitiesService.getActivity(activityId);
      if (!activity) {
        throw new Error(`任务 ${activityId} 不存在`);
      }

      // 执行任务结束逻辑
        this.logger.log(`🏷️ ================ 开始执行业务逻辑！ ================`);
        this.logger.log(`📝 任务状态: ${activity.status}`);
        this.logger.log(`🏷️ 业务标题 - 传参: ${title}`);
        this.logger.log(`🏷️ 业务标题 - 数据库: ${activity.title}`);
        this.logger.log(`🆔 业务类型: ${bussinessType}`);
        await this.activitiesService.handleActivityCompletion(activityId);
    
      // 日志
        const executionEnd = new Date();
        const duration = executionEnd.getTime() - executionStart.getTime();
        const successLog = {
          jobId: job.id,
          activityId,
          bussinessType: bussinessType,
          title: title,
          bussinessEndSysTime: TimeUtil.formatTime(executionEnd),
          bussinessDuration: duration,
          action: 'success',
          // ------------------------------
          activityStatus: 'completed',
          timestamp: executionEnd.toISOString(),
          duration,
          bussinesstitle: title,
        };
        this.executionLogs.unshift(successLog);

      // 调试
        this.logger.log('✅ ================ 完成执行业务逻辑 ================');
        this.logger.log(`🆔 延迟任务唯一标志ID: ${activityId}`);
        this.logger.log(`🏷️ 业务标题 - 传参: ${title}`);
        this.logger.log(`🏷️ 业务标题 - 数据库: ${activity.title}`);
        this.logger.log(`🆔 业务类型: ${bussinessType}`);
        this.logger.log(`⏱️ 业务处理耗时: ${duration / 1000}s`);
        this.logger.log(`🏁 业务完成时间: ${TimeUtil.formatTime(executionEnd)}`);
        this.logger.log(`📊 最终状态: 已完成`);
      
    } catch (error) {
      const executionEnd = new Date();
      const duration = executionEnd.getTime() - executionStart.getTime();
      
      // 日志
      const errorLog = {
        jobId: job.id,
        activityId,
        bussinessType: bussinessType,
        title: title,
        bussinessEndSysTime: TimeUtil.formatTime(executionEnd),
        bussinessDuration: duration,
        action: 'error',
        error: error.message,
        stack: error.stack,
        // ------------------------------------
        bussinesstitle: title,
        timestamp: executionEnd.toISOString(),
        duration,
      };
      this.executionLogs.unshift(errorLog);
      
      this.logger.error('❌ === 任务处理失败 ===');
      this.logger.error(`🆔 任务ID: ${activityId}`);
      this.logger.log(`🏷️ 业务标题: ${title}`);
      this.logger.log(`🆔 业务类型: ${bussinessType}`);
      this.logger.error(`💥 错误信息: ${error.message}`);
      this.logger.error(`🔧 错误堆栈: ${error.stack}`);
      this.logger.error(`⏱️ 失败耗时: ${duration}ms`);
      
      throw error; // 让 BullMQ 进行重试
    }
  }

  /**
   * 任务完成事件
   */
  @OnQueueEvent('completed')
  onCompleted(job: Job) {
    this.logger.log(`✅ 任务完成: ${job.id} [${job.name}]`);
    this.logger.log(`📊 任务数据:`, job.data);
  }

  /**
   * 任务失败事件
   */
  @OnQueueEvent('failed')
  onFailed(job: Job, error: Error) {
    this.logger.error(`❌ 任务失败: ${job.id} [${job.name}]`);
    this.logger.error(`💥 失败原因: ${error.message}`);
    this.logger.error(`🆔 任务ID: ${job.data?.activityId}`);
  }

  /**
   * 任务开始事件
   */
  @OnQueueEvent('active')
  onActive(job: Job) {
    this.logger.log(`🚀 任务开始执行: ${job.id} [${job.name}]`);
    this.logger.log(`🆔 任务ID: ${job.data?.activityId}`);
  }

  /**
   * 获取执行日志
   */
  getExecutionLogs(limit: number = 20): any[] {
    return this.executionLogs.slice(0, limit);
  }

  /**
   * 任务等待事件
   */
  @OnQueueEvent('waiting')
  onWaiting(jobId: string) {
    this.logger.log(`⏳ 任务进入等待: ${jobId}`);
  }

  /**
   * 任务进度事件
   */
  @OnQueueEvent('progress')
  onProgress(job: Job, progress: number) {
    this.logger.log(`📈 任务进度更新: ${job.id} - ${progress}%`);
  }
}