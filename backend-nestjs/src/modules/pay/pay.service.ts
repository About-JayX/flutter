import {
  Inject,
  Injectable,
  Logger,
  NotFoundException,
  UnauthorizedException,
  forwardRef,
} from '@nestjs/common';
import { createHash } from 'crypto';

import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Cache } from 'cache-manager';

import { InjectRepository } from '@nestjs/typeorm';
import {
  Repository,
  DataSource,
  EntityManager,
  Not,
  Equal,
  Between,
  In,
} from 'typeorm';
import { v4 as uuidv4 } from 'uuid';

import { ActivitiesStatus } from '@/common/enums/activities-status.enum';
import { TableBusinessType } from '@/common/enums/business-type.enum';
import {
  SceneStatus,
  SceneResponseStatus,
} from '@/common/enums/scene-status.enum';
import { PayStatus } from '@/common/enums';
import { PayChannel } from '@/common/enums/pay-channel.enum';
import { WithdrawalStatus } from '@/common/enums/withdraw-status.enum';
import { OrderStatus, AfterSalesStatus } from '@/common/enums';
import { ORDER_CONSTANTS } from '@/common/constants/order.constant';
import { PAY_CONSTANTS } from '@/common/constants/pay.constant';
import { WithdrawChannel } from '@/common/enums/withdraw-channel.enum';

import { TimeUtil } from '@root/src/common/utils/time.util';
import { PhoneUtil } from '@/common/utils/phone.util';

import { User, UserAccountType } from '@/modules/users/entities/user.entity';
import { Pay } from './entities/pay.entity';
import { Refund } from './entities/refund.entity';
import { PetihopeDivideSummary } from './entities/divide/petihope-divide-summary.entity';
import { PetihopeDivideRecord } from './entities/divide/petihope-divide-record.entity';
import { WithdrawalEntity } from './entities/withdraw.entity';
import { Activities } from '@root/src/shared/activities/entities/activities.entity';
import { Order } from '@root/src/modules/order/entities/order.entity';
import { Product } from '@root/src/modules/product/entities/product.entity';
import { OrderProduct } from '@root/src/modules/order-product/entities/order-product.entity';
import { Petihope } from '@root/src/modules/petihope/entities/petihope.entity';
import { PetihopePri } from '@root/src/modules/petihope/entities/petihope_pri.entity';

import { ArgsAuthDto } from '@/modules/auth/dto/args-auth.dto';

import { CreatePaymentOrderDto } from './dto/create-payment-order.dto';
import { CreatePaymentWithdrawDto } from './dto/create-payment-withdraw.dto';
import { CreatePayDto } from './dto/create-pay.dto';
import { UpdatePayDto } from './dto/update-pay.dto';

import { PaymentException } from './exceptions/payment.exception';

import { ActivitiesService } from '@/shared/activities/activities.service';
import { UsersService } from '@root/src/modules/users/users.service';
import { PetihopeService } from '@root/src/modules/petihope/petihope.service';
import { OrderService } from '@root/src/modules/order/order.service';
import { OrderProductService } from '@root/src/modules/order-product/order-product.service';
import { ProductService } from '@root/src/modules/product/product.service';

import { CreateActivityDto } from '@/shared/activities/dto/create-activity.dto';
import { UpdateOrderDto } from '@root/src/modules/order/dto/update-order.dto';

@Injectable()
export class PayService {
  private readonly logger = new Logger(PayService.name);

  constructor(
    @Inject(CACHE_MANAGER)
    private readonly cacheManager: Cache,

    private dataSource: DataSource,

    @InjectRepository(Pay)
    private payRepository: Repository<Pay>,

    @InjectRepository(Activities)
    private activitiesRepository: Repository<Activities>,

    @InjectRepository(WithdrawalEntity)
    private withdrawRepository: Repository<WithdrawalEntity>,

    @InjectRepository(Order)
    private orderRepository: Repository<Order>,

    @InjectRepository(OrderProduct)
    private orderProductRepository: Repository<OrderProduct>,

    private readonly usersService: UsersService,

    private readonly petihopeService: PetihopeService,

    private readonly orderService: OrderService,

    private readonly orderProductService: OrderProductService,

    @Inject(forwardRef(() => ActivitiesService))
    private readonly activitiesService: ActivitiesService,
  ) {}

  /// ===================== 公共 =====================
  /**
   * 生成生产环境安全的订单号
   */
  private generateProductionOrderId(title = 'payotuosm'): string {
    const timestamp = Date.now();
    const random = Math.random().toString(36).substring(2, 8);
    return `${title}${timestamp}${random}`.toUpperCase();
  }

  /**
   * 生成随机金额 - 预定义金额池版本（更自然）
   */
  private generateRandomAmountFromPool(): number {
    const amountPool = [0.01, 0.02, 0.05, 0.08, 0.15, 0.2, 1.0];

    const randomIndex = Math.floor(Math.random() * amountPool.length);
    return amountPool[randomIndex];
  }

  /**
   * 生成商品名
   */
  private generateSafeSubject(): string {
    const name = '请愿金';
    return name;
  }

  /**
   * 生成提现流水号
   */
  private generateWithdrawSn(): string {
    const now = new Date();
    const sailStr = 'petiwd';
    const dateStr =
      now.getFullYear() +
      this.padZero(now.getMonth() + 1) +
      this.padZero(now.getDate()) +
      this.padZero(now.getHours()) +
      this.padZero(now.getMinutes()) +
      this.padZero(now.getSeconds());
    const randomNum = Math.floor(Math.random() * 1000000);
    const randomStr = this.padZero(randomNum, 6);
    return sailStr + dateStr + randomStr;
  }

  /**
   * 生成支付流水号
   */
  private generatePaySn(): string {
    const now = new Date();
    const sailStr = 'petip';
    const dateStr =
      now.getFullYear() +
      this.padZero(now.getMonth() + 1) +
      this.padZero(now.getDate()) +
      this.padZero(now.getHours()) +
      this.padZero(now.getMinutes()) +
      this.padZero(now.getSeconds());
    const randomNum = Math.floor(Math.random() * 1000000);
    const randomStr = this.padZero(randomNum, 6);
    return sailStr + dateStr + randomStr;
  }

  /**
   * 生成退款流水号
   */
  private generateRefundSn(): string {
    const now = new Date();
    const sailStr = 'petiref';
    const dateStr =
      now.getFullYear() +
      this.padZero(now.getMonth() + 1) +
      this.padZero(now.getDate()) +
      this.padZero(now.getHours()) +
      this.padZero(now.getMinutes()) +
      this.padZero(now.getSeconds());
    const randomNum = Math.floor(Math.random() * 1000000);
    const randomStr = this.padZero(randomNum, 6);
    return sailStr + dateStr + randomStr;
  }

  private padZero(num: number, length = 2): string {
    return num.toString().padStart(length, '0');
  }

  /// ===================== 业务 =====================
  /* ------------------ 支付：支付相关 ------------------ */
  // =================== 业务 ================

  // ====================================================== 分成或退款逻辑 start
  async handlePetihopeEndtime(businessType: string, hopeId: string) {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.startTransaction();

    try {
      const manager = queryRunner.manager;
      await this.handlePetihopeEndtimeLogic(manager, businessType, hopeId);
      await queryRunner.commitTransaction();
      this.logger.log(`活动 ${hopeId} 的分成/退款处理成功`);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `活动 ${hopeId} 的分成/退款处理失败: ${error.message}`,
        error.stack,
      );
      throw error;
    } finally {
      await queryRunner.release();
    }
  }

  async handlePetihopeEndtimeLogic(
    manager: EntityManager,
    businessType: string,
    hopeId: string,
  ) {
    this.logger.log('开始执行handlePetihopeEndtimeLogic，hopeId：', hopeId);
    const petihope = await manager.findOne(Petihope, { where: { id: hopeId } });
    if (!petihope) {
      throw new Error(`活动 ${hopeId} 不存在`);
    }
    const joinRecords = await manager.findOne(PetihopePri, {
      where: { oid: petihope.id, joinuserid: petihope.oerId },
    });
    if (!joinRecords) {
      throw new Error(`发起人 活动 ${hopeId} 的PetihopePri记录不存在`);
    }

    if (joinRecords.enterSceneStatus === SceneStatus.PENDING_SCENE) {
      await this.processRefund(
        manager,
        businessType,
        hopeId,
        '发起人未进入现场全额退款',
      );
      return;
    }

    if (petihope.autoResponse === SceneResponseStatus.MANUEL) {
      await this.processRefundForLateParticipants(
        manager,
        businessType,
        hopeId,
      );
    }

    await this.processDivideInto(manager, businessType, hopeId);
  }

  async petihopeSourcPay(createPayDto: CreatePayDto) {
    const timestamp = Date.now().toString();
    const random = Math.random().toString(36).substr(2, 6).toUpperCase();
    return `${ORDER_CONSTANTS.PAY_ID_PREFIX}${timestamp}${random}`;
  }

  async processRefund(
    manager: EntityManager,
    businessType: string,
    hopeId: string,
    reason: string,
  ) {
    const petihope = await manager.findOne(Petihope, { where: { id: hopeId } });
    if (!petihope) return;

    const joinRecords = await manager.find(PetihopePri, {
      where: {
        oid: petihope.id,
        joinuserid: Not(Equal(petihope.oerId)),
      },
    });

    for (const record of joinRecords) {
      const orders = await manager.find(Order, {
        where: {
          bussinesstype: businessType,
          bussinessid: hopeId,
          payStatus: 2,
        },
      });

      for (const order of orders) {
        const pays = await manager.find(Pay, {
          where: { orderId: order.id, payStatus: 2 },
        });

        for (const pay of pays) {
          const existingRefund = await manager.findOne(Refund, {
            where: { orderSn: order.orderSn },
          });

          if (existingRefund) {
            continue;
          }

          const rNo = this.generateRefundSn();
          const refund = manager.create(Refund, {
            refundNo: rNo,
            orderSn: order.orderSn,
            userId: record.joinuserid,
            refundAmount: pay.payAmount,
            reason,
          });
          await manager.save(Refund, refund);

          await manager.update(
            Order,
            { id: order.id },
            {
              orderStatus: OrderStatus.REFUNDING,
            },
          );
        }
      }
    }
  }

  async processRefundForLateParticipants(
    manager: EntityManager,
    businessType: string,
    hopeId: string,
  ) {
    const petihope = await manager.findOne(Petihope, { where: { id: hopeId } });
    if (!petihope) return;

    const joinRecords = await manager.find(PetihopePri, {
      where: {
        oid: hopeId,
        joinuserid: Not(Equal(petihope.oerId)),
      },
    });

    for (const record of joinRecords) {
      const postSceneTime = record.postSceneTime
        ? TimeUtil.parseTime(record.postSceneTime)
        : null;
      const postSceneResValidTime = record.postSceneResValidTime
        ? TimeUtil.parseTime(record.postSceneResValidTime)
        : null;
      const postSceneResTime = record.postSceneResTime
        ? TimeUtil.parseTime(record.postSceneResTime)
        : null;

      if (!postSceneTime) continue;

      let refundReason = '';

      if (!postSceneResTime) {
        refundReason = '发起人未响应申请人进入现场';
      }

      if (
        postSceneResTime &&
        postSceneResValidTime &&
        postSceneResTime.getTime() > postSceneResValidTime.getTime()
      ) {
        refundReason = '发起人响应超时';
      }

      if (refundReason) {
        await this.createRefundForUser(
          manager,
          businessType,
          hopeId,
          record.joinuserid,
          refundReason,
        );
      }
    }
  }

  async createRefundForUser(
    manager: EntityManager,
    businessType: string,
    hopeId: string,
    userId: string,
    reason: string,
  ) {
    const orders = await manager.find(Order, {
      where: {
        bussinesstype: businessType,
        bussinessid: hopeId,
        payStatus: 2,
      },
    });

    for (const order of orders) {
      const pays = await manager.find(Pay, {
        where: { orderId: order.id, payStatus: 2 },
      });

      for (const pay of pays) {
        const existingRefund = await manager.findOne(Refund, {
          where: { orderSn: order.orderSn },
        });

        if (existingRefund) {
          continue;
        }

        const rNo = this.generateRefundSn();
        const refund = manager.create(Refund, {
          refundNo: rNo,
          orderSn: order.orderSn,
          userId,
          refundAmount: pay.payAmount,
          reason,
        });
        await manager.save(Refund, refund);

        await manager.update(
          Order,
          { id: order.id },
          {
            orderStatus: OrderStatus.REFUNDING,
          },
        );
      }
    }
  }

  async processDivideInto(
    manager: EntityManager,
    businessType: string,
    hopeId: string,
  ) {
    const petihope = await manager.findOne(Petihope, { where: { id: hopeId } });
    if (!petihope) return;

    const orders = await manager.find(Order, {
      where: {
        bussinesstype: businessType,
        bussinessid: hopeId,
        payStatus: 2,
      },
    });

    if (orders.length === 0) return;

    const divideRatio =
      petihope.autoResponse === SceneResponseStatus.MANUEL ? 0.888 : 0.808;

    const divideRecords: PetihopeDivideRecord[] = [];
    let totalDivideAmount = 0;
    let totalSourceAmount = 0;
    let platformAmount = 0;

    for (const order of orders) {
      const pays = await manager.find(Pay, {
        where: { orderId: order.id, payStatus: 2 },
      });

      for (const pay of pays) {
        const divideAmount = parseFloat(
          (pay.payAmount * divideRatio).toFixed(2),
        );
        const currentPlatformAmount = pay.payAmount - divideAmount;
        const record = manager.create(PetihopeDivideRecord);

        record.businessId = petihope.id;
        record.businessType = businessType;
        record.userId = petihope.oerId;
        record.orderId = order.id.toString();
        record.payId = pay.id.toString();
        record.originAmount = pay.payAmount;
        record.divideRatio = divideRatio;
        record.divideAmount = divideAmount;
        record.platformAmount = currentPlatformAmount;
        record.status = 'success';
        record.remark = `活动分成: ${petihope.id}`;

        divideRecords.push(record);
        totalDivideAmount += divideAmount;
        totalSourceAmount += pay.payAmount;
        platformAmount += currentPlatformAmount;
      }
    }

    if (divideRecords.length > 0) {
      await manager.save(PetihopeDivideRecord, divideRecords);
    }

    let summary = await manager.findOne(PetihopeDivideSummary, {
      where: { businessId: petihope.id },
    });

    if (summary) {
      summary.totalSourceAmount += totalSourceAmount;
      summary.totalDivideAmount += totalDivideAmount;
      summary.platformAmount += platformAmount;
      summary.updateTime = new Date();
    } else {
      summary = manager.create(PetihopeDivideSummary, {
        businessId: petihope.id,
        businessType: businessType,
        userId: petihope.oerId,
        totalSourceAmount,
        divideRatio,
        totalDivideAmount,
        platformAmount,
        status: 'success',
        remark: `活动 ${petihope.id} 分成`,
      });
    }
    await manager.save(PetihopeDivideSummary, summary);

    if (totalDivideAmount > 0) {
      await this.usersService.incrementDivideSourceMoney(
        petihope.oerId,
        totalDivideAmount,
        manager,
      );
      this.logger.log(
        `为用户 ${petihope.oerId} 增加可提现余额: ${totalDivideAmount}`,
      );
    }
  }
  // ====================================================== 分成或退款逻辑 end

  // ====================================================== 订单相关：start
  async handleOrderCancel(businessType: string, businessId: string) {
    this.logger.log(
      `延迟任务进入业务逻辑函数中====handleOrderCancel：取消订单加员 ===`,
    );
    const handleOrderCancelDataSourceResult = await this.dataSource.transaction(
      async (manager: EntityManager) => {
        const orderRepo = manager.getRepository<Order>(Order);
        const order = await orderRepo.findOne({
          where: { id: Number(businessId) },
        });
        if (!order) {
          return;
        }
        if (order.payStatus == PayStatus.UNPAID) {
          this.logger.log('order.payStatus == PayStatus.UNPAID：进入减员操作');
          const unPaidHandleOrderChancelAddBack =
            await this.handleOrderChancelAddBack(
              manager,
              order.id,
              OrderStatus.CLOSED,
              PayStatus.PAY_FAILED,
            );
          return unPaidHandleOrderChancelAddBack;
        } else if (order.payStatus == PayStatus.PAYING) {
          this.logger.log(
            'order.payStatus == PayStatus.PAYING：订单处于支付中状态，标记为人工审核',
          );
          await this.markAsManualReview(
            manager,
            order.id,
            '订单处于PAYING状态，支付宝已移除，需人工处理',
          );
          return { success: true, message: '订单标记为人工审核' };
        } else {
          return;
        }
      },
    );
    return handleOrderCancelDataSourceResult;
  }

  async processWaitPaymentOrder(manager: EntityManager, orderId: number) {
    const MAX_RETRY = 5;

    const orderRepo = manager.getRepository<Order>(Order);
    const order = await orderRepo.findOne({ where: { id: orderId } });
    if (!order) {
      return;
    }

    if (
      [PayStatus.PAID, PayStatus.PAY_FAILED].includes(order.payStatus) ||
      order.manualReview == true
    ) {
      return;
    }

    try {
      const currentRetry = order.waitCheckRetryCount || 0;
      if (currentRetry < MAX_RETRY) {
        await orderRepo.update(orderId, {
          waitCheckRetryCount: currentRetry + 1,
          lastWaitCheckAt: new Date(),
        });
        this.logger.log(
          `订单 ${orderId} 第 ${currentRetry + 1} 次 WAIT 检查，等待下次任务`,
        );
        return;
      }

      if (!order.closeAttempted) {
        await orderRepo.update(orderId, { closeAttempted: true });
        this.logger.log(
          'PayStatus.PAYING，支付宝已移除，无法关闭第三方订单，标记为人工审核：',
        );
        await this.markAsManualReview(
          manager,
          orderId,
          '支付宝已移除，无法自动关闭第三方订单',
        );
      }
    } catch (error) {
      this.logger.error(
        `处理 WAIT 订单 ${orderId} 异常: ${error.message}`,
        error.stack,
      );
    }
  }

  private async markAsManualReview(
    manager: EntityManager,
    orderId: number,
    reason: string,
  ): Promise<void> {
    const orderRepo = manager.getRepository<Order>(Order);
    await orderRepo.update(orderId, {
      manualReview: true,
      orderErrorRemark: `[自动异常] ${reason}`,
    });
    this.logger.error(`订单 ${orderId} 已转人工: ${reason}`);
  }

  async handleOrderChancelAddBack(
    manager: EntityManager,
    orderId: number,
    orderStatus?: OrderStatus,
    payStatus?: PayStatus,
  ) {
    const petihopeRepo = manager.getRepository<Petihope>(Petihope);

    const order = await manager.findOne(Order, {
      where: { id: orderId },
      lock: { mode: 'pessimistic_write' },
    });
    if (!order || order.orderStatus === OrderStatus.CLOSED) {
      return;
    } else {
      let orderData = {
        payTime: new Date(),
        ...(orderStatus ? { orderStatus } : {}),
        ...(payStatus ? { payStatus } : {}),
      };
      const updateOrderResult = await this.orderService.updateOrderByIdManage(
        order.id,
        orderData,
        manager,
      );
    }

    const petihope = await petihopeRepo.findOne({
      where: { id: order.bussinessid },
    });
    if (!petihope) {
      this.logger.warn(`请愿合法性检查：请愿不存在，id:${order.bussinessid}`);
    } else {
      const petihopeId = petihope.id;
      await petihopeRepo
        .createQueryBuilder()
        .update(Petihope)
        .set({
          peopleLess: () => 'people_less + 1',
        })
        .where('id = :petihopeId', { petihopeId })
        .andWhere('people_less < people_with_me_number')
        .execute();
    }

    return {
      success: true,
      message: '订单取消成功',
    };
  }

  // ====================================================== 订单相关：end

  // ====================================================== 延迟任务相关：start
  private async closeOrderDelayTask(orderNo: string) {
    try {
      const activityOrder = await this.activitiesRepository.findOne({
        where: {
          bussinessId: orderNo,
          bussinessType: TableBusinessType.OrderCancel,
          status: ActivitiesStatus.PENDING,
        },
      });
      if (activityOrder) {
        await this.activitiesService.cancelActivity(activityOrder.uniqueId);
      }
    } catch (error) {
      this.logger.warn('关闭延迟任务异常');
      this.logger.warn(
        `Failed to remove Order delayed task for order ${orderNo}`,
        error,
      );
    }
    try {
      const activityPay = await this.activitiesRepository.findOne({
        where: {
          bussinessId: orderNo,
          bussinessType: TableBusinessType.PayCancel,
          status: ActivitiesStatus.PENDING,
        },
      });
      if (activityPay) {
        await this.activitiesService.cancelActivity(activityPay.uniqueId);
      }
    } catch (error) {
      this.logger.warn('关闭延迟任务异常');
      this.logger.warn(
        `Failed to remove Pay delayed task for order ${orderNo}`,
        error,
      );
    }
  }

  private async startPayDelayTask(orderNo: string) {
    const updateOrderPayment = await this.orderRepository.findOne({
      where: {
        orderSn: orderNo,
      },
    });
    if (!updateOrderPayment) {
      this.logger.log('updateOrderPayment: 订单不存在异常，无法创建延迟任务');
      throw new NotFoundException('订单不存在，无法创建延迟任务');
    }
    try {
      const activities: CreateActivityDto = {
        endTime: updateOrderPayment.validPayTime,
        bussinessId: updateOrderPayment.id.toString(),
        bussinessType: TableBusinessType.PayCancel,
        title: '订单支付超时监听',
      };
      await this.activitiesService.createActivity(activities);
    } catch (error) {
      this.logger.warn('创建支付有效延迟任务异常');
      this.logger.warn(`Failed to delayed task for order ${orderNo}`, error);
    }
    try {
      const activityOrder = await this.activitiesRepository.findOne({
        where: {
          bussinessId: updateOrderPayment.id.toString(),
          bussinessType: TableBusinessType.OrderCancel,
          status: ActivitiesStatus.PENDING,
        },
      });
      if (activityOrder) {
        await this.activitiesService.cancelActivity(activityOrder.uniqueId);
      }
    } catch (error) {
      this.logger.warn('关闭存在的订单有效延迟任务异常');
      this.logger.warn(`Failed to delayed task for order ${orderNo}`, error);
    }
  }

  // ====================================================== 延迟任务相关：end

  // =================== 标准 ================
  /**
   * 创建支付记录
   */
  async createPayRecord(
    orderId: number,
    paySn: string,
    transactionId: string,
    payAmount: number,
    payMethod: PayChannel,
    payStatus: number,
    manager: EntityManager,
  ) {
    const existing = await manager
      .createQueryBuilder(Pay, 'pay')
      .where('pay.transactionId = :transactionId', { transactionId })
      .getOne();

    if (existing) {
      this.logger.log(`transactionId already exist: ${transactionId}`);
      return { generatedMaps: [], raw: [], identifiers: [] };
    }

    const uniqueId = uuidv4();
    return await manager
      .createQueryBuilder()
      .insert()
      .into(Pay)
      .values({
        uniqueId,
        orderId,
        paySn,
        transactionId,
        payAmount,
        payMethod,
        payStatus,
      })
      .execute();
  }

  async create(createPayDto: CreatePayDto) {
    return;
  }

  /**
   *  支付状态查询
   */
  async orderPayStatusCheckBySn(orderSn: string, channel: string) {
    this.logger.log('开始进入订单支付状态检测：orderPayStatusCheckBySn');
    this.logger.log('orderSn: ', orderSn);
    this.logger.log('channel: ', channel);

    const processPaymentCloseDataSourceResult =
      await this.dataSource.transaction(async (manager: EntityManager) => {
        const orderRepo = manager.getRepository<Order>(Order);
        const activeOrder = await orderRepo.findOne({
          where: {
            orderSn: orderSn,
          },
        });
        this.logger.log('订单信息： ', activeOrder);
        if (!activeOrder) {
          return {
            status: 'failed',
          };
        }

        if (activeOrder.payStatus == PayStatus.PAID) {
          return { status: 'success' };
        }

        if (
          activeOrder.payStatus == PayStatus.PAY_FAILED ||
          activeOrder.payStatus == PayStatus.UNPAID
        ) {
          return { status: 'failed' };
        }

        return { status: 'paying' };
      });
    return processPaymentCloseDataSourceResult;
  }

  /**
   * 根据订单ID查询支付记录
   */
  async findByOrderId(orderId: number): Promise<Pay[]> {
    return await this.payRepository.find({
      where: { orderId },
      relations: ['order'],
    });
  }

  /**
   * 查询所有支付记录
   */
  async findAll(): Promise<Pay[]> {
    return await this.payRepository.find({
      relations: ['order'],
    });
  }

  /**
   * 查询支付记录详情
   */
  async findOne(id: number): Promise<Pay> {
    const pay = await this.payRepository.findOne({
      where: { id },
      relations: ['order'],
    });

    if (!pay) {
      throw new NotFoundException(`支付记录 #${id} 不存在`);
    }

    return pay;
  }

  /**
   * 更新支付记录
   */
  async update(id: number, updatePayDto: UpdatePayDto) {
    return;
  }

  /**
   * 删除支付记录
   */
  async remove(id: number): Promise<void> {
    const pay = await this.findOne(id);
    await this.payRepository.remove(pay);
  }

  /* ------------------ 支付：工具相关 ------------------ */
  /* ------ 提现相关 ------ */
  /**
   * 用户提现 - 入口
   */
  async createWithdraw(
    user: any,
    channel: WithdrawChannel,
    amount: number,
    body: CreatePaymentWithdrawDto,
  ) {
    this.logger.log('开始进入提现：pay.service.ts：createWithdraw');
    return {
      status: '1',
      statusInfo: '提现功能已关闭，请使用其他方式',
    };
  }

  /* ------ 退款相关 ------ */
  async refund(channel: string, orderId: string, amount: number) {
    throw new PaymentException('退款功能暂不可用');
  }
}
