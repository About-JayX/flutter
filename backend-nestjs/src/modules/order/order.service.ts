import { Injectable, NotFoundException, BadRequestException, ConflictException, InternalServerErrorException, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThan, EntityManager } from 'typeorm';

import { OrderStatus, PayStatus, AfterSalesStatus } from '@/common/enums';
// import { ORDER_CONSTANTS } from '@/common/constants/order.constant';

import { OrderProduct } from '../order-product/entities/order-product.entity';
import { Pay } from '@/modules/pay/entities/pay.entity';

import { Order } from './entities/order.entity';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { QueryOrderDto } from './dto/query-order.dto';
import { OrderInputFactory } from '@root/src/modules/order/utils/order-input.util';
import { CreateOrderInput } from '@root/src/modules/order/types/create-order-input.type'; 
@Injectable()
export class OrderService {
  private readonly logger = new Logger(OrderService.name);

  constructor(
    // @InjectRepository(OrderProduct)
    // private orderProductRepository: Repository<OrderProduct>,
    // @InjectRepository(Pay)
    // private payRepository: Repository<Pay>,

    @InjectRepository(Order)
    private orderRepository: Repository<Order>,
    // private dataSource: DataSource,
  ) {}

  // ================== 公共 ==================
  /**
   * 生成订单编号：盐 + yyyyMMddHHmmss + 6位随机数
   * 示例：petio20250405123045123456
   */
  private generateOrderSn(): string {
    const now = new Date();
    //  ==================== 处理 ====================
    //  sail：加盐
    const sailStr = 'petio'

    //  date：yyyyMMddHHmmss
    const dateStr = now.getFullYear() +
      this.padZero(now.getMonth() + 1) +
      this.padZero(now.getDate()) +
      this.padZero(now.getHours()) +
      this.padZero(now.getMinutes()) +
      this.padZero(now.getSeconds());

    //  random：6位随机数
    const randomNum = Math.floor(Math.random() * 1000000); // 0 ~ 999999
    const randomStr = this.padZero(randomNum, 6);

    //  ==================== 处理 ====================

    //  ==================== 组织 ====================
    const result = 
      sailStr +
      dateStr + 
      randomStr
    ;

    //  ==================== 结果 ====================
    return result;
  }
  // private generateOrderSn(): string {
  //   const timestamp = Date.now().toString();
  //   const random = Math.random().toString(36).substr(2, 6).toUpperCase();
  //   return `${ORDER_CONSTANTS.ORDER_ID_PREFIX}${timestamp}${random}`;
  // }
  private padZero(num: number, length = 2): string {
    return num.toString().padStart(length, '0');
  }


  // ================== 业务 ==================
  /**
   * 创建订单
   * 1、支持事务
   */
  async createOrder(
    createOrderDto: CreateOrderDto,
    repo?: Repository<Order>
  ): Promise<Order>{//: Promise<Order> 
    const repository = repo ?? this.orderRepository;

    // const now = new Date();

    // 生成订单编号
      const orderSn = this.generateOrderSn();

    // // 计算实付金额
    //   const actualAmount = 
    //     createOrderDto.totalAmount
    //     // createOrderDto.totalAmount - createOrderDto.discountAmount + createOrderDto.shippingFee
    //   ;
    // // 订单有效时间
    //   const validTime = new Date(now.getTime() + 5 * 60 * 1000); // 5分钟后

    // 创建订单
      const order = repository.create({
        ...createOrderDto,
        orderSn:orderSn,
        // actualAmount,
        orderStatus: OrderStatus.PENDING_PAYMENT,
        payStatus: PayStatus.UNPAID,
        afterSalesStatus: AfterSalesStatus.NONE,
        // validTime: validTime
      });

    return await repository.save(order);
  }
  // ========================================
  // ✅ 供其他 Service 调用的快捷方法
  // ========================================
  async createOrderForPetihope(
    options: Parameters<typeof OrderInputFactory.forPetihope>[0]
  ): Promise<Order> {
    const input = OrderInputFactory.forPetihope(options);
    return await this.createOrderInternal(input);
  }
  // ========================================
  // ✅ 核心创建逻辑（私有）
  // ========================================
  private async createOrderInternal(input: CreateOrderInput): Promise<Order> {
    const now = new Date();

    // 生成订单编号
      const orderSn = this.generateOrderSn();
      const validTime = new Date(now.getTime() + 5 * 60 * 1000); // 5分钟后

    // 计算实付金额
    const actualAmount =
      input.totalAmount
    ;

    const order = this.orderRepository.create({
      ...input, // 自动展开所有字段
      orderSn,
      actualAmount,
      orderStatus: OrderStatus.PENDING_PAYMENT,
      payStatus: PayStatus.UNPAID,
      afterSalesStatus: AfterSalesStatus.NONE,
      validTime,
    });

  try {
    const savedOrder = await this.orderRepository.save(order);
    
    // ✅ 保存成功
    if (savedOrder && savedOrder.id) {
      return savedOrder;
    } else {
      throw new Error('订单保存成功但未生成 ID');
    }
  } catch (error) {
    // ❌ 保存失败，记录日志并抛出业务异常
    this.logger.error('创建订单失败:', error);
    
    // 可以根据错误类型做更精细处理
    if (error.code === 'ER_DUP_ENTRY') {
      throw new ConflictException(`订单编号 ${orderSn} 已存在`);
    }
    
    throw new InternalServerErrorException('创建订单失败，请稍后重试');
  }
  }
  /**
   * 统计指定活动在支付时限内的有效订单数量
   * @param hopeId 活动ID
   * @returns 有效订单数量
   */
    async countValidOrdersByPetihopeId(
      hopeId: string,
      repo?: Repository<Order> // ← 新增可选参数
    ): Promise<number> {
      const now = new Date();
      const repository = repo ?? this.orderRepository; // ← 优先使用传入的 repo
      return await repository.count({
        where: {
          bussinessid: hopeId,
          validTime: MoreThan(now),
        },
      });
    }
    // async countValidOrdersByPetihopeId(hopeId: string): Promise<number> {
    //   const now = new Date();

    //   return await this.orderRepository.count({
    //     where: {
    //       bussinessid: hopeId,
    //       validTime: MoreThan(now), // validTime > 当前时间，表示订单仍在支付有效期内
    //     },
    //   });
    // }

  /**
   * 查询订单详情
   */
  async findOne(id: number): Promise<Order> {
    const order = await this.orderRepository.findOne({
      where: { id },
      relations: ['orderProducts', 'pays'], // 现在这些关系存在了
    });

    if (!order) {
      throw new NotFoundException(`订单 #${id} 不存在`);
    }

    return order;
  }

  /**
   * 根据订单编号查询
   */
  async findOrderBySn(orderSn: string,    
    options?: {
      fields?: string[];
    }): Promise<Order> {
    const queryBuilder = this.orderRepository
      .createQueryBuilder('order')
      .where('order.orderSn = :orderSn', { orderSn });

    // 如果指定了字段，只查询这些字段
    if (options?.fields && options.fields.length > 0) {
      const selectFields = options.fields.map(field => `order.${field}`);
      queryBuilder.select(selectFields);
    }

    const order = await queryBuilder.getOne();

    if (!order) {
      throw new NotFoundException(`订单 ${orderSn} 不存在`);
    }

    return order;
  }

  async findByOrderSn(orderSn: string): Promise<Order> {
    const order = await this.orderRepository.findOne({
      where: { orderSn },
      relations: ['orderProducts', 'pays'],
    });

    if (!order) {
      throw new NotFoundException(`订单 ${orderSn} 不存在`);
    }

    return order;
  }

  // 根据订单编号查询 - manager版本
  async getOrderByOrderSn(
    orderSn: string,
    manager: EntityManager
  ): Promise<Order | null> {
    return await manager
      .getRepository(Order)
      .findOne({ where: { orderSn } });
  }

  /**
   * 更新订单
   */
  async updateOrderByOrderSn(
    orderSn: string, 
    updateOrderDto: UpdateOrderDto,
    repo?: Repository<Order>
  ): Promise<Order> {
    this.logger.log('usersservice updateOrder 进入, 参数是：', updateOrderDto);

    const repository = repo ?? this.orderRepository;  

    // 1. 通过 orderSn 查询订单
    const order = await repository.findOne({
      where: { orderSn },
    });
    if (!order) {
      throw new NotFoundException(`Order with orderSn ${orderSn} not found`);
    }
    // 2. 更新字段
    Object.assign(order, updateOrderDto);
    // 3. 保存
    return await repository.save(order);
    
    //preload只支持主键查询，会报错
    // const order = await this.orderRepository.preload({
    //   orderSn,
    //   ...updateOrderDto,
    // });

    // if (!order) {
    //   throw new NotFoundException(`orderSn ${orderSn} not found`);
    // }

    // return this.orderRepository.save(order);
  }
  // async updateOrder(id: number, updateOrderDto: UpdateOrderDto){//: Promise<Order> 
  //   // const order = await this.findOne(id);
    
  //   // const updatedOrder = this.orderRepository.merge(order, updateOrderDto);
  //   // return await this.orderRepository.save(updatedOrder);
  // }
  async updateOrderByIdManage(
    id: number,
    updates: Partial<Order>,
    manager: EntityManager
  ) {
      this.logger.log('在订单service中：updateOrderByIdManage');
      this.logger.log('在订单service中 id：',id);
      this.logger.log('在订单service中 updates',updates);
      // 更新记录
      return await manager
        .getRepository(Order)
        .update(id, updates);
  }

  // ================== 标准 ==================

  /**
   * 创建订单
   */
  async create(createOrderDto: CreateOrderDto) {//: Promise<Order>
    // const queryRunner = this.dataSource.createQueryRunner();
    // await queryRunner.connect();
    // await queryRunner.startTransaction();

    // try {
    //   // 计算实付金额
    //   const actualAmount = createOrderDto.totalAmount - createOrderDto.discountAmount + createOrderDto.shippingFee;

    //   // 创建订单
    //   const order = this.orderRepository.create({
    //     ...createOrderDto,
    //     orderSn: this.generateOrderSn(),
    //     actualAmount,
    //     orderStatus: OrderStatus.PENDING_PAYMENT,
    //     payStatus: PayStatus.UNPAID,
    //     afterSalesStatus: AfterSalesStatus.NONE,
    //   });

    //   const savedOrder = await queryRunner.manager.save(order);

    //   // 创建订单商品
    //   const orderProducts = createOrderDto.products.map(product => 
    //     this.orderProductRepository.create({
    //       orderId: savedOrder.id,
    //       ...product,
    //       totalPrice: product.price * product.quantity, // 计算商品总价
    //     })
    //   );

    //   await queryRunner.manager.save(OrderProduct, orderProducts);

    //   await queryRunner.commitTransaction();
    //   return savedOrder;
    // } catch (error) {
    //   await queryRunner.rollbackTransaction();
    //   throw new BadRequestException(`创建订单失败: ${error.message}`);
    // } finally {
    //   await queryRunner.release();
    // }
  }

  /**
   * 查询订单列表
   */
  // async findAll(queryOrderDto: QueryOrderDto) {
  //   const { 
  //     userId, 
  //     orderStatus, 
  //     payStatus, 
  //     afterSalesStatus,
  //     startDate, 
  //     endDate, 
  //     page = 1, 
  //     limit = 10 
  //   } = queryOrderDto;
    
  //   const pageNum = Math.max(1, page);
  //   const limitNum = Math.max(1, Math.min(limit, 100));
    
  //   const queryBuilder = this.orderRepository.createQueryBuilder('order')
  //     .leftJoinAndSelect('order.orderProducts', 'orderProducts') // 现在这个关系存在了
  //     .leftJoinAndSelect('order.pays', 'pays'); // 现在这个关系也存在了

  //   // ... 查询条件构建保持不变

  //   const [data, total] = await queryBuilder
  //     .orderBy('order.create_time', 'DESC')
  //     .skip((pageNum - 1) * limitNum)
  //     .take(limitNum)
  //     .getManyAndCount();

  //   return {
  //     data,
  //     total,
  //     page: pageNum,
  //     limit: limitNum,
  //     totalPages: Math.ceil(total / limitNum),
  //   };
  // }

  // /**
  //  * 查询订单详情
  //  */
  // async findOne(id: number): Promise<Order> {
  //   const order = await this.orderRepository.findOne({
  //     where: { id },
  //     relations: ['orderProducts', 'pays'], // 现在这些关系存在了
  //   });

  //   if (!order) {
  //     throw new NotFoundException(`订单 #${id} 不存在`);
  //   }

  //   return order;
  // }

  /**
   * 更新订单
   */

  async update(id: number, updateOrderDto: UpdateOrderDto){//: Promise<Order> 
    // const order = await this.findOne(id);
    
    // const updatedOrder = this.orderRepository.merge(order, updateOrderDto);
    // return await this.orderRepository.save(updatedOrder);
  }

  /**
   * 取消订单
   */
  async cancel(id: number): Promise<Order> {
    const order = await this.findOne(id);

    if (order.orderStatus !== OrderStatus.PENDING_PAYMENT) {
      throw new BadRequestException('只有待付款订单可以取消');
    }

    order.orderStatus = OrderStatus.CANCELLED;
    order.cancelTime = new Date();

    return await this.orderRepository.save(order);
  }

  /**
   * 删除订单
   */
  async remove(id: number): Promise<void> {
    const order = await this.findOne(id);
    await this.orderRepository.remove(order);
  }

  /**
   * 申请退款
   */
  async applyRefund(id: number, reason: string): Promise<Order> {
    const order = await this.findOne(id);

    if (order.payStatus !== PayStatus.PAID) {
      throw new BadRequestException('只有已支付订单可以申请退款');
    }

    if (order.afterSalesStatus !== AfterSalesStatus.NONE) {
      throw new BadRequestException('订单已有售后申请');
    }

    order.afterSalesStatus = AfterSalesStatus.APPLYING;
    return await this.orderRepository.save(order);
  }

  /**
   * 处理发货
   */
  async shipOrder(id: number, shippingInfo: { 
    shippingName: string; 
    shippingCode: string; 
    trackingNumber: string; 
  }): Promise<Order> {
    const order = await this.findOne(id);

    if (order.orderStatus !== OrderStatus.PENDING_SHIPMENT) {
      throw new BadRequestException('只有待发货订单可以发货');
    }

    order.orderStatus = OrderStatus.SHIPPED;
    // 这里可以添加物流信息到订单中
    // 例如：order.shippingName = shippingInfo.shippingName;

    return await this.orderRepository.save(order);
  }

  /**
   * 确认收货
   */
  async confirmReceipt(id: number): Promise<Order> {
    const order = await this.findOne(id);

    if (order.orderStatus !== OrderStatus.SHIPPED) {
      throw new BadRequestException('只有已发货订单可以确认收货');
    }

    order.orderStatus = OrderStatus.COMPLETED;
    order.completeTime = new Date();

    return await this.orderRepository.save(order);
  }

  /**
   * 获取用户订单列表
   */
  // async findByUserId(userId: number, queryOrderDto: QueryOrderDto) {
  //   return this.findAll({
  //     ...queryOrderDto,
  //     userId,
  //   });
  // }
}