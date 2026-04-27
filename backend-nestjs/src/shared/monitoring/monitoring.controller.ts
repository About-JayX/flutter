import { Controller, Get, Param, Post, Delete, Query, UseInterceptors, Req } from '@nestjs/common';
import { Request } from 'express'; 
import { customResponse } from '@/interceptors/response.custom.interceptor';
import { QueueMonitoringService } from './queue-monitoring.service';
import { QueueService } from '../queue/queue.service';
import { ActivitiesService } from '../activities/activities.service';
import { ApiTags, ApiOperation, ApiResponse, ApiParam, ApiQuery } from '@nestjs/swagger';
import { Public } from '@/modules/auth/decorators/public.decorator';

@ApiTags('Queue Monitoring')
@Controller('monitoring')
export class MonitoringController {
  constructor(
    private readonly monitoringService: QueueMonitoringService,
    private readonly queueService: QueueService,
    private readonly activitiesService: ActivitiesService,
  ) {}

  @Get('stats')
  @ApiOperation({ summary: '获取队列统计信息' })
  @ApiResponse({ status: 200, description: '返回队列统计信息' })
  async getQueueStats() {
    return await this.monitoringService.getQueueStats();
  }

  @Get('details')
  @ApiOperation({ summary: '获取队列详情' })
  @ApiResponse({ status: 200, description: '返回队列详情和最近任务' })
  async getQueueDetails() {
    return await this.monitoringService.getQueueDetails();
  }

  @Get('jobs')
  @ApiOperation({ summary: '获取最近的任务列表' })
  @ApiQuery({ name: 'limit', required: false, description: '返回的任务数量' })
  @ApiResponse({ status: 200, description: '返回任务列表' })
  async getRecentJobs(@Query('limit') limit: number = 50) {
    return await this.monitoringService.getRecentJobs(limit);
  }

  @Get('jobs/:jobId')
  @ApiOperation({ summary: '获取特定任务详情' })
  @ApiParam({ name: 'jobId', description: '任务ID' })
  @ApiResponse({ status: 200, description: '返回任务详情' })
  @ApiResponse({ status: 404, description: '任务不存在' })
  async getJobDetails(@Param('jobId') jobId: string) {
    const job = await this.monitoringService.getJobDetails(jobId);
    if (!job) {
      return { error: 'Job not found' };
    }
    return job;
  }

  @Public()
  @Post('jobs/:jobId/retry')
  @ApiOperation({ summary: '重试失败的任务' })
  @ApiParam({ name: 'jobId', description: '任务ID' })
  @ApiResponse({ status: 200, description: '任务重试成功' })
  @ApiResponse({ status: 404, description: '任务不存在' })
  async retryJob(@Param('jobId') jobId: string) {
    const success = await this.monitoringService.retryJob(jobId);
    return { success };
  }

  @Public()
  @Delete('jobs/:jobId')
  @ApiOperation({ summary: '删除任务' })
  @ApiParam({ name: 'jobId', description: '任务ID' })
  @ApiResponse({ status: 200, description: '任务删除成功' })
  @ApiResponse({ status: 404, description: '任务不存在' })
  async removeJob(@Param('jobId') jobId: string) {
    const success = await this.monitoringService.removeJob(jobId);
    return { success };
  }

  @Public()
  @Delete('clean')
  @ApiOperation({ summary: '清空队列中的任务' })
  @ApiQuery({ 
    name: 'type', 
    required: false, 
    enum: ['completed', 'wait', 'active', 'delayed', 'failed', 'paused'],
    description: '要清理的任务类型' 
  })
  @ApiQuery({ 
    name: 'grace', 
    required: false, 
    description: '宽限期（毫秒）' 
  })
  @ApiQuery({ 
    name: 'limit', 
    required: false, 
    description: '最大清理数量' 
  })
  @ApiResponse({ status: 200, description: '清理完成' })
  async cleanQueue(
    @Query('type') type: string = 'completed',
    @Query('grace') grace: number = 5000,
    @Query('limit') limit: number = 1000,
  ) {
    const count = await this.monitoringService.cleanQueue(grace, limit, type as any);
    return { 
      message: `Cleaned ${count} ${type} jobs`,
      count 
    };
  }

  @Get('metrics')
  @ApiOperation({ summary: '获取队列监控指标' })
  @ApiResponse({ status: 200, description: '返回队列指标' })
  async getQueueMetrics() {
    return await this.monitoringService.getQueueMetrics();
  }

  @Get('failed-jobs')
  @ApiOperation({ summary: '获取失败任务列表' })
  @ApiQuery({ name: 'limit', required: false, description: '返回的任务数量' })
  @ApiResponse({ status: 200, description: '返回失败任务列表' })
  async getFailedJobs(@Query('limit') limit: number = 50) {
    return await this.monitoringService.getFailedJobs(limit);
  }

  @Public()
  @Post('retry-all-failed')
  // @ApiOperation({ summary: '重试所有失败的任务' })
  // 自定义拦截器
  // @UseInterceptors(
  //   customResponse(
  //     { version: '2.1.0' }, // 自定义版本
  //     { statusInfo: 'Payment service success' }, // 自定义提示
  //   ),
  // )
  // @ApiResponse({ status: 200, description: '重试操作完成' })
  async retryAllFailedJobs(@Req() req: Request) {
    // 1. 跳过包装
    req.skipGlobalWrap = true;
    // console.log('🔥 赋值后 req.skipGlobalWrap:', req.skipGlobalWrap);
    // req.customBody = { status: '1', statusInfo: '导出失败！' };
    const result = await this.monitoringService.retryAllFailedJobs();
    return {
      message: `Retried ${result.success} jobs, ${result.failed} failed`,
      ...result
    };
  }

  @Get('job-counts')
  @ApiOperation({ summary: '获取各种状态的任务数量' })
  @ApiResponse({ status: 200, description: '返回任务数量统计' })
  async getJobCounts() {
    return await this.monitoringService.getJobCounts();
  }

  // ========== 新增的活动任务监控端点 ==========

  @Get('activity/:activityId/job-status')
  @ApiOperation({ summary: '检查特定活动的任务状态' })
  @ApiParam({ name: 'activityId', description: '活动ID' })
  @ApiResponse({ status: 200, description: '返回任务状态信息' })
  async getActivityJobStatus(@Param('activityId') activityId: string) {
    const jobStatus = await this.queueService.checkActivityJobStatus(activityId);
    const activity = await this.activitiesService.getActivity(activityId).catch(() => null);
    
    return {
      activityId,
      activityExists: !!activity,
      activityStatus: activity?.status,
      ...jobStatus,
      timestamp: new Date().toISOString()
    };
  }

  @Get('activity-countdowns')
  @ApiOperation({ summary: '获取所有活动任务的倒计时信息' })
  @ApiResponse({ status: 200, description: '返回倒计时列表' })
  async getActivityCountdowns() {
    const countdowns = await this.queueService.getAllActivityCountdowns();
    return {
      total: countdowns.length,
      countdowns,
      timestamp: new Date().toISOString()
    };
  }

  @Post('activity/:activityId/trigger')
  @ApiOperation({ summary: '手动触发活动结束任务' })
  @ApiParam({ name: 'activityId', description: '活动ID' })
  @ApiResponse({ status: 200, description: '任务触发结果' })
  async triggerActivityCompletion(@Param('activityId') activityId: string) {
    const success = await this.queueService.triggerActivityCompletion(activityId);
    return {
      activityId,
      success,
      message: success ? '任务触发成功，将立即执行' : '任务触发失败，可能任务不存在或状态不正确',
      timestamp: new Date().toISOString()
    };
  }

  @Get('activity-execution-logs')
  @ApiOperation({ summary: '获取活动执行日志' })
  @ApiQuery({ name: 'limit', required: false, description: '返回的日志数量' })
  @ApiResponse({ status: 200, description: '返回执行日志' })
  async getActivityExecutionLogs(@Query('limit') limit: number = 20) {
    const logs = await this.monitoringService.getActivityExecutionLogs(limit);
    return {
      logs,
      total: logs.length,
      timestamp: new Date().toISOString()
    };
  }

  @Get('system-status')
  @ApiOperation({ summary: '获取系统状态检查' })
  @ApiResponse({ status: 200, description: '返回系统状态' })
  async getSystemStatus() {
    const [queueStats, redisStatus, processorStatus, recentActivities] = await Promise.all([
      this.monitoringService.getQueueStats(),
      this.monitoringService.checkRedisConnection(),
      this.monitoringService.checkProcessorStatus(),
      this.activitiesService.getRecentActivities(5)
    ]);

    return {
      timestamp: new Date().toISOString(),
      queue: queueStats,
      redis: redisStatus,
      processor: processorStatus,
      recentActivities,
      system: {
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        nodeVersion: process.version
      }
    };
  }
}