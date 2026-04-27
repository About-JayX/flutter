import { Injectable, Logger, NotFoundException, BadRequestException, Inject, forwardRef} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { TimeUtil } from '@root/src/common/utils/time.util';

import { TableBusinessType } from '@/common/enums/business-type.enum';
import { ActivitiesStatus } from '@/common/enums/activities-status.enum';

import { CreateActivityDto } from './dto/create-activity.dto';

import { Activities } from './entities/activities.entity';
// import { Activity, ActivityStatus } from './entities/activity.entity';

import { QueueService } from '../queue/queue.service';
import { PayService } from '@/modules/pay/pay.service';
// import { PetihopeService } from '@/modules/petihope/petihope.service';

@Injectable()
export class ActivitiesService {
  private readonly logger = new Logger(ActivitiesService.name);

  constructor(
    @InjectRepository(Activities)
    private readonly activityRepository: Repository<Activities>,

    private readonly queueService: QueueService,
    private readonly payService: PayService,
    // @Inject(forwardRef(() => PetihopeService))/// PetihopeService 和activity循环依赖
    // private readonly petihopeService: PetihopeService,
  ) {}

  // ===================== 公共方法 ====================
  /**
   * 解析日期字符串或对象
   */
  // private parseDate(dateInput: string | Date, fieldName: string): Date {
  //   if (dateInput instanceof Date) {
  //     return dateInput;
  //   }

  //   if (typeof dateInput === 'string') {
  //     // 尝试多种日期格式
  //     let date: Date;
      
  //     // 尝试 ISO 格式
  //     date = new Date(dateInput);
  //     if (!isNaN(date.getTime())) {
  //       return date;
  //     }

  //     // 尝试替换空格为 T 的格式
  //     const isoFormat = dateInput.replace(' ', 'T');
  //     date = new Date(isoFormat);
  //     if (!isNaN(date.getTime())) {
  //       return date;
  //     }

  //     // 尝试添加时区信息
  //     const withTimezone = dateInput + 'Z';
  //     date = new Date(withTimezone);
  //     if (!isNaN(date.getTime())) {
  //       return date;
  //     }

  //     throw new BadRequestException(`无效的${fieldName}格式: ${dateInput}`);
  //   }

  //   throw new BadRequestException(`${fieldName}必须是字符串或Date对象`);
  // }

  // ===================== 业务逻辑 ====================
  /**
   * 创建新活动
   */
  async createActivity(
    createActivityDto: CreateActivityDto,
    repo?: Repository<Activities> // ← 新增可选参数
  ){
    // 数据
      //  Repository     
        const repository = repo ?? this.activityRepository; // 优先使用传入的 repo

      //  createActivityDto
      // 数据组织
        // endtime
          // 处理时间格式
          // const startTime = this.parseDate(createActivityDto.startTime, 'startTime');
          const endTime = 
            TimeUtil.parseTime(createActivityDto.endTime);
            // this.parseDate(createActivityDto.endTime, 'endTime')
          ;

          // 验证时间逻辑
          // if (startTime >= endTime) {
          //   throw new BadRequestException('开始时间必须早于结束时间');
          // }

          if (endTime <= new Date()) {
            throw new BadRequestException('结束时间必须大于当前时间，结束时间必须是将来的时间');
          }
        // status
          //设置任务状态：进行中
          const status = ActivitiesStatus.PENDING;

      // 数据保存    
        // 数据库记录
        const activity = repository.create({
          ...createActivityDto,
          endTime,
          status: status,
        });
        const savedActivity = await repository.save(activity);

    // 任务
      // 数据
        // 解析
          const businessTitle = decodeURIComponent(savedActivity.title);
      // 执行  
        // 创建延时任务
        await this.queueService.addActivityCompletionJob(
          savedActivity.uniqueId,
          savedActivity.endTime,
          savedActivity.bussinessType,
          businessTitle,
        );
        this.logger.log(`Activities created: ${savedActivity.uniqueId}`);

    // 响应
      return savedActivity;
  }

  /**
   * 获取最近的活动
   */
  async getRecentActivities(limit: number = 5){
    return this.activityRepository.find({
      order: { createTime: 'DESC' },
      take: limit,
    });
  }
  /**
   * 获取活动详情
   */
  async getActivity(activityId: string){
    const activity = await this.activityRepository.findOne({
      where: { uniqueId: activityId },
    });

    if (!activity) {
      throw new NotFoundException(`Activities ${activityId} not found`);
    }

    return activity;
  }

  // /**
  //  * 获取用户创建的活动列表
  //  */
  // async getUserActivities(userId: string): Promise<Activities[]> {
  //   return this.activityRepository.find({
  //     where: { creatorId: userId },
  //     order: { createdAt: 'DESC' },
  //   });
  // }

  /**
   * 处理活动结束逻辑
   * 对应activity-completion.processor.ts中的handleActivityCompletion，如果延迟任务失败，手动调用这里
   */
  async handleActivityCompletion(activityId: string): Promise<void> {
    /*
    *=============== 任务 ===============
    */ 
    // 判断任务是否存在
      const activity = await this.activityRepository.findOne({
        where: { uniqueId: activityId },
      });
      if (!activity) {
        throw new NotFoundException(`Activities ${activityId} not found`);
      } 
    // 更新任务状态为已完成
      activity.status = ActivitiesStatus.COMPLETED;
      await this.activityRepository.save(activity);
      this.logger.log(`任务存在，marked as complete`);

    /*
    *=============== 业务 ｜逻辑 ===============
    */ 
    this.logger.log(`========== 💰任务存在，开始执行业务逻辑 ========== `);
    //  =============== 执行业务逻辑 ===============
    this.logger.log(`业务类型是：activity.bussinessType: ${activity.bussinessType}`);
    // this.logger.log(`TableBusinessType.Petihope: ${TableBusinessType.Petihope}`);
    // this.logger.log(`activity.bussinessType == TableBusinessType.Petihope: ${activity.bussinessType == TableBusinessType.Petihope}`);
    /// 请愿活动结束
    if(activity.bussinessType == TableBusinessType.Petihope){
      this.logger.log(`业务类型是（${TableBusinessType.Petihope}）：请愿 - 活动结束`);
      await this.payService.handlePetihopeEndtime(
        activity.bussinessType,
        activity.bussinessId
      );
    }
    /// 订单取消
    if(activity.bussinessType == TableBusinessType.OrderCancel ||
      activity.bussinessType == TableBusinessType.PayCancel
    ){
      this.logger.log(`业务类型是（${activity.bussinessType}）：请愿 - 订单取消`);
      await this.payService.handleOrderCancel(
        activity.bussinessType,
        activity.bussinessId
      );
    }
    // if(activity.bussinessType == TableBusinessType.OrderCancel){
    //   this.logger.log(`业务类型是（${TableBusinessType.OrderCancel}）：请愿 - 订单取消`);
    //   await this.petihopeService.handlePetihopeOrderCancel(
    //     activity.bussinessType,
    //     activity.bussinessId
    //   );
    // }
    //  =============== 执行业务逻辑 ===============
    this.logger.log(`========== 🌴任务存在，结束执行业务逻辑 ========== `);
    
    // // 示例：发送通知
    // await this.sendCompletionNotification(activity);
  }

  /**
   * 发送活动完成通知
   */
  private async sendCompletionNotification(activity: Activities): Promise<void> {
    // 实现通知逻辑，比如发送邮件、推送通知等
    this.logger.log(`Sending completion notification for activity: ${activity.title}`);
    
    // 模拟异步操作
    await new Promise(resolve => setTimeout(resolve, 1000));
  }

  /**
   * 取消活动
   */
  async cancelActivity(activityId: string){
    const activity = await this.activityRepository.findOne({
      where: { uniqueId: activityId },
    });

    if (!activity) {
      throw new NotFoundException(`Activities ${activityId} not found`);
    }

    // 移除对应的延时任务
    await this.queueService.removeActivityCompletionJob(activityId);

    // 更新活动状态
    activity.status = ActivitiesStatus.CANCELLED;
    const updatedActivity = await this.activityRepository.save(activity);

    this.logger.log(`Activities ${activityId} cancelled`);

    return updatedActivity;
  }
}