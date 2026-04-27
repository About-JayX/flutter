import { Injectable, NotFoundException, UnauthorizedException, Logger, Inject, forwardRef } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource, EntityManager, Not, Equal } from 'typeorm';

import { ORDER_CONSTANTS } from '@/common/constants/order.constant';
import { TableBusinessType } from '@/common/enums/business-type.enum';
import { PayStatus } from '@/common/enums/pay-status.enum';
// import { OrderStatus } from '@root/src/common/enums';
// import { PayChannel } from '@/common/enums/pay-channel.enum';

import { TimeUtil } from '@root/src/common/utils/time.util';

import { Order } from '@root/src/modules/order/entities/order.entity';
// import { Pay } from '@root/src/modules/pay/entities/pay.entity';
import { User } from '@/modules/users/entities/user.entity';
import { Activities } from '@root/src/shared/activities/entities/activities.entity';

import { CreateActivityDto } from '@/shared/activities/dto/create-activity.dto';
import { ArgsAuthDto } from '@/modules/auth/dto/args-auth.dto';
// import { PaymentException } from '@/modules/pay/exceptions/payment.exception';

// import { PaymentStrategy } from '@/modules/pay/strategies/payment.strategy.interface';
// import { AlipayStrategy } from '@/modules/pay/strategies/alipay.strategy_alipay_sdk';

import { UsersService } from '@root/src/modules/users/users.service';
import { OrderService } from '@root/src/modules/order/order.service';
import { ActivitiesService } from '@/shared/activities/activities.service';
// import { ProductService } from '@root/src/modules/product/product.service';
// import { OrderProductService } from '@root/src/modules/order-product/order-product.service';

import { Petihope } from './entities/petihope.entity';
import { PetihopePri } from './entities/petihope_pri.entity';
import { CreatePetihopeDto } from './dto/create-petihope.dto';
import { UpdatePetihopeDto } from './dto/update-petihope.dto';
import { PetihopeMemberPostRequestCon } from './dto/member-post-request-con.dto';
// import { CreateOrderDto } from '@/order/dto/create-order.dto';
import { OrderInputFactory } from '@root/src/modules/order/utils/order-input.util';


@Injectable()
export class PetihopeService {
  private readonly logger = new Logger(PetihopeService.name);
  // private strategies: Map<string, PaymentStrategy> = new Map();

  constructor(
    private dataSource: DataSource,

    // @InjectRepository(Pay)
    // private payRepository: Repository<Pay>,
    // @InjectRepository(User)
    // private userRepository: Repository<User>,

    @InjectRepository(Order)
    private orderRepository: Repository<Order>,

    // @InjectRepository(PetihopePri)
    // private petihopePriRepository: Repository<PetihopePri>, 
    // @InjectRepository(Petihope)
    // private petihopeRepository: Repository<Petihope>,

    // private readonly orderProductService: OrderProductService,
    // private readonly productService: ProductService,
    private readonly usersService: UsersService,
    private readonly orderService: OrderService,

    @Inject(forwardRef(() => ActivitiesService))/// ActivitiesService 和Petihope循环依赖
    private readonly activitiesService: ActivitiesService,
  ) {
    // this.strategies.set('alipay', alipayStrategy);
  }


  // ================== 业务 ==================
  //  申请
  async memberAddPost(
    user: ArgsAuthDto,
    con: PetihopeMemberPostRequestCon
  ) {
      /// 事务状态更新
      const result = await this.dataSource.transaction(async (manager) => {
        // 所有操作用 manager
          return await this.memberAddPostProcess( manager, user, con );
        // 如果抛异常 → 自动 rollback
        // 如果正常结束 → 自动 commit
        // 连接自动 release

      });
      /// 延迟任务设置
      if(result && 
        result.status =='0' &&
        result.data && result.data.orderId
      ){
        await this.startOrderDelayTask(result.data.orderId);
      }
      return result;
  } 

  async memberAddPostProcess(
    manager: EntityManager, 
    user: ArgsAuthDto,
    con: PetihopeMemberPostRequestCon
  ) {
    // this.logger.log("user信息", user);
    // this.logger.log("user信息uniqid: ", user.uniqid);
    // return{ 
    //   status: '1'
    // };  

    //  事务Rep
      //  Petihope
      const petihopeRepo = manager.getRepository<Petihope>(Petihope);
      // 1. 获取事务内的 UserRepository
      const userRepo = manager.getRepository<User>(User);
      // 1. 获取事务中的 PetihopePri Repository
      const petihopePriRep = manager.getRepository<PetihopePri>(PetihopePri);
      // 获取事务内的 Order Repository
      const orderRepo = manager.getRepository<Order>(Order);
      // // 获取事务内的 activities Repository
      // const activitiesRepo = manager.getRepository<Activities>(Activities);

    // ==================== 订单创建：入口 ｜ 请求 ====================
      this.logger.log("✅进入memberAddPost Service服务");

    // ==================== 订单创建：信息 ====================  
    //  信息获取
      //  传入信息
          this.logger.log("=====================================传入的信息");
          this.logger.log("user信息", user);
          this.logger.log("user信息uniqid: ", user.uniqid);
          this.logger.log("user自定义信息", con);
          this.logger.log("user信息hopeId: ", con.hopeId);

          const uniqid = user.uniqid;
          const { hopeId } = con;
      //  数据库信息
          this.logger.log("=====================================数据库的信息");
        // 1. 获取用户信息
          const userInfo = await this.usersService.findOneByUnique(uniqid, userRepo);
          this.logger.log("🤔userInfo: ", userInfo);
          if (!userInfo) {
            /// 1、用户通过 Auth 但 DB 中不存在	抛出 UnauthorizedException（401）
            throw new UnauthorizedException({statusCode: 401, message: 'Authentication failed', error: 'Unauthorized'});
            // throw new NotFoundException(`用户 ${uniqid} 不存在`);
          }

        // 2. 获取请愿信息
          const petihope = await petihopeRepo.findOne({
            where: { id: hopeId },
          });
          // const petihope = await this.petihopeRepository.findOne({
          //   where: { id: hopeId },
          // });
          this.logger.log("🆚petihope: ", petihope);
          if (!petihope) {
            /// 资源不存在：404
            throw new NotFoundException('请愿不存在或已经删除');//请愿 ${hopeId} 不存在
          }
          this.logger.log("🆚petihope.endtime: ", petihope.endtime);
          this.logger.log("🆚petihope.joinPeopleMax: ", petihope.joinPeopleMax);
          const now = new Date();
          // const oneHourFromNow = new Date(now.getTime() + 60 * 60 * 1000); // 当前时间 + 1小时
          // const endTime = TimeUtil.parseTime(petihope.endtime);
          const startTime = TimeUtil.parseTime(petihope.startTime);

    // ==================== 订单创建：验证 ====================
    this.logger.log("🌺订单创建：验证 - 开始");
    //  合法检查
     //  请愿合法检查
      /// 1、请愿合法检查 -请愿检查
        //  1、✅请愿检查 - 请愿时间
          //  请愿已开始，无法加入【1、检查请愿是否已结束或离结束不到一小时
            if (startTime <= now) {
              this.logger.log("startTime <= now: 该请愿已开始，无法加入");
              return { status: '1', statusInfo: '该请愿已开始，无法加入' };
              // throw new BadRequestException('该请愿已结束，无法创建订单');
            }
          //  请愿是否已结束或离结束不到一小时
            // if (endTime <= now) {
            //   this.logger.log("endTime <= now: 该请愿已结束，无法加入");
            //   return { status: '1', statusInfo: '该请愿已结束，无法加入' }; 
            //   // throw new BadRequestException('该请愿已结束，无法创建订单');
            // }
            // if (endTime <= oneHourFromNow) {
            //   return { status: '1', statusInfo: '该请愿即将在一小时内结束，无法加入', data:{tobe:''}};
            //   // throw new BadRequestException('该请愿即将在一小时内结束，无法创建订单');
            // }

          // 2、✅请愿合法检查 - 剩余人数检查【检查是否超过活动允许的最大人数
            //  1、目前使用乐观锁减人数
            //  2、有效订单过期释放数量：使用延迟任务
              if (petihope.peopleLess <= 0) {
                return { status: '1', statusInfo: '请愿名额已满，暂时无法加入' };
              }
            /// 二次检查【订单数+加入数量联合检查
              // // 1. 获取已加入活动的人数
              // const joinedCount = await petihopePriRep.count({
              //   where: { 
              //     oid: hopeId,
              //     joinuserid: Not(Equal(petihope.oerId)),
              //   },
              // });
              // this.logger.log("9️⃣joinedCount: ", joinedCount);

              // // 2. 获取该活动在支付时限内的有效订单数量（通过 OrderService）
              // const validOrderCount = await this.orderService.countValidOrdersByPetihopeId(hopeId, orderRepo);
              // this.logger.log("🉑validOrderCount: ", validOrderCount);

              // // 3. 计算总占用人数
              // const totalOccupied = joinedCount + validOrderCount;

              // // 4. 检查是否超过活动允许的最大人数
              // if (totalOccupied >= petihope.joinPeopleMax) {
              //   return { status: '1', statusInfo: '请愿名额已满，暂时无法加入' };
              //   // throw new BadRequestException('该活动名额已满，无法创建订单');
              // }

      /// 2、请愿合法检查 - 用户检查
        // 1. ✅请愿合法检查 - 用户检查 - 检查用户是否已加入该活动
          const existingJoin = await petihopePriRep.findOne({
            where: { oid: hopeId, joinuserid: userInfo.id },
          });
          this.logger.log("😋existingJoin: ", existingJoin);
          if (existingJoin) {
            return { status: '1', statusInfo: '您已加入该请愿，请退出后进洞' };
            // throw new BadRequestException('您已加入该活动，无法重复加入');
          }

      /// 3、请愿合法检查 - 订单检查  
        // 2. 检查用户是否有生效中的订单（当前时间未超过订单的 valid_time）
        // 2.1.前往支付或返回【有生效的订单：
        // 2.1.1. 0、订单存在，且1、在有效时间内，且2、未支付 或 支付中；前往支付
        // 2.1.2. 0、订单存在，且1、已支付；返回
          const activeOrders = await orderRepo.findOne({
            where: {
              userId: userInfo.id,
              bussinessid: hopeId,
            },
            order: {
              createTime: 'DESC', // 按 createTime 降序，最新的在前
            },
          });
          // const activeOrders = await this.orderRepository.findOne({
          //   where: {
          //     userId: userInfo.id,
          //     bussinessid: hopeId,
          //     // validTime: MoreThan(now), // 假设 validTime 是订单有效的截止时间（即创建时间 + 5分钟）
          //   },
          // });
          this.logger.log("🍚activeOrders: ", activeOrders);
          /// ⚠️前端，后端，数据库的时间时区处理的方案
          /// =============================== 现象
          /// 数据库：validTime: 本地时间，
          /// 日志打印：activeOrders：validTime相比数据库减了八个小时是utc时间，
          /// 日志打印：activeOrders.validTime: 打印的时候又重新加回来了八个小时
          /// 发送到前端: 又变成减了八个小时到utc时间
          /// =============================== 方案
          // 层级	时间格式	时区	说明
          // 前端（客户端）	ISO 8601 字符串 或 时间戳	用户本地时区	显示用本地时间；提交时转为 UTC
          // 后端（NestJS）	Date 对象（内部 UTC 毫秒）	逻辑上视为 UTC	所有业务逻辑、比较、存储均基于 UTC
          // 数据库	TIMESTAMP（带时区）或 DATETIME（但存 UTC）	UTC	绝对不要存“本地时间”
          if (activeOrders) {
            const validTimeGet = activeOrders.validPayTime || activeOrders.validTime;// activeOrders.validPayTime || 
            const payStatusGet = activeOrders.payStatus;
            this.logger.log(`🍚validTime: ${validTimeGet}, now: ${now}`);
            this.logger.log("🍚validTime) > now: ", validTimeGet > now);
            // 2.1.2. 0、订单存在，且1、已支付；返回【return
              if(payStatusGet == PayStatus.PAID){
                this.logger.log("🍚❌已有支付成功的请愿订单");
                return { 
                  status: '1', 
                  statusInfo: '已有支付成功的请愿订单，无需重复申请',
                };
              }
              // 2.1.2. 0、订单存在，且1、支付中；返回 ｜ 进入支付【return
              else if(payStatusGet == PayStatus.PAYING){
                /// 超时支付中的订单
                if(validTimeGet <= now){
                  this.logger.log("🍚❌payStatusGet == PayStatus.PAYING：超时支付中的订单，却有支付中的请愿订单");
                  return { 
                    status: '1', 
                    statusInfo: '已有支付中的请愿订单在处理中，去请愿列表查看',
                  };
                }
                /// 未超时支付中的订单
                else{
                  this.logger.log("🍚✅payStatusGet == PayStatus.PAYING: 未超时支付中的订单：已有生效中的请愿订单");
                  return { 
                    status: '0', 
                    statusInfo: '已有生效中的请愿订单，去处理',
                    data: {
                      hopeId: activeOrders.bussinessid,
                      orderId: activeOrders.orderSn, 
                      validTime: activeOrders.validPayTime || activeOrders.validTime,
                    }
                  };
                }
              }
              // 2.1.2. 0、订单存在，且1、未支付；返回 ｜ 进入支付【return
              else if(payStatusGet == PayStatus.UNPAID){
                /// 超时未支付的订单
                if(validTimeGet <= now){
                  /// 去创建订单
                    // 不允许，有订单的情况，不能为未支付，已支付或支付中
                  /// 不允许创建订单：和paying一致，如果订单不改为失败就不能创建新的订单,延时任务执行失败或容错延迟
                    this.logger.log("🍚❌payStatusGet == PayStatus.UNPAID：超时未支付的订单，超时却有未支付的请愿订单");
                    return { 
                      status: '1', 
                      statusInfo: '超时未支付的请愿申请处理中，请稍后重试申请',
                    };
                }
                /// 未超时未支付的订单
                else{
                  this.logger.log("🍚✅payStatusGet == PayStatus.UNPAID: 未超时未支付的订单：已有生效中的请愿订单");
                  return { 
                    status: '0', 
                    statusInfo: '已有生效中的请愿订单，去处理',
                    data: {
                      hopeId: activeOrders.bussinessid,
                      orderId: activeOrders.orderSn, 
                      validTime: activeOrders.validPayTime || activeOrders.validTime,
                    }
                  };
                }
                
              }
            // /// 2、返回
            // // 2.1.1. 0、订单存在，且1、不在有效时间内，且2、支付中；返回
            //   else if((validTimeGet <= now) &&
            //     payStatusGet == PayStatus.PAYING){
            //     this.logger.log("🍚❌超时，却有支付中的请愿订单");
            //     return { 
            //       status: '1', 
            //       statusInfo: '已有支付中的请愿订单在处理中，去请愿列表查看',
            //     };
            //   }
            // /// 1、前往支付
            //   // 2.1.1. 0、订单存在，且1、在有效时间内，且2、未支付 或 支付中；前往支付
            //   else if((validTimeGet > now) &&
            //     (payStatusGet == PayStatus.UNPAID || payStatusGet == PayStatus.PAYING)
            //     ){
            //       this.logger.log("🍚✅已有生效中的请愿订单");
            //       return { 
            //         status: '0', 
            //         statusInfo: '已有生效中的请愿订单，去处理',
            //         data: {
            //           hopeId: activeOrders.bussinessid,
            //           orderId: activeOrders.orderSn, 
            //           validTime: activeOrders.validPayTime || activeOrders.validTime,
            //         }
            //       };
            //     }

            /// 3、去创建订单
            /// 其他情况
            /// 1、没有订单
            /// 2、有最新订单，订单支付状态不为未支付，已支付，也不能为支付中【为失败，已退款
          }

    // ==================== 订单创建：减人操作 ====================
      // 先锁定资源，再固化状态
      // 库存是共享资源，必须最先处理，防止超卖；
      // 一旦库存成功扣减，就代表“资源已预留”，后续步骤失败可回滚，但不会导致超卖

      /// 2、当单商品的并发请求 ≥ 100 QPS，或库存 ≤ 100 件时，就应考虑引入 Redis + Lua 原子扣减，而不是依赖数据库乐观锁。
        // 场景	是否适合乐观锁	建议方案
        // 普通商品下单（库存 > 1000，QPS < 50）	✅ 适合	数据库乐观锁 or 悲观锁均可
        // 热销商品（库存 100~1000，QPS 50~200）	⚠️ 边缘	乐观锁 + 重试可能扛住，但体验差
        // 秒杀/限量商品（库存 ≤ 100，QPS ≥ 100）	❌ 不适合	必须上 Redis + Lua

        // 压测建议：用数据说话
        // 你可以用 JMeter / k6 / wrk 模拟以下场景：
        // # 模拟 500 并发抢 10 件商品
        // wrk -t50 -c500 -d30s http://your-api/order
        // 观察：
        //     成功率（应接近 库存/请求总数）；
        //     错误率（乐观锁冲突是否主导）；
        //     DB 负载。
        // 如果：
        //     成功率远低于理论值（如 10/500 = 2%，但实际只有 0.5%）；
        //     DB 出现大量慢查询；
        // 👉 立即切换到 Redis 方案

      /// 1、乐观锁减员
        /// 1、version + 重试
        /// 乐观锁+事务意思是两人下单都成功了，但在版本更新中有一个失败了触发事务回滚
        const decreasePeopleResult = await this.decreasePeopleLessWithOptimisticLock(
          manager,
          hopeId
        )
        if(!decreasePeopleResult.success){
          return { 
            status: '1', 
            statusInfo: '请愿申请失败，稍后重试',
          }
        }

    // ==================== 订单创建：执行 ====================
      // 依赖关系顺序
      // OrderProduct 依赖 Order.id（外键）；
      // 所以必须 先保存 Order，再保存 OrderProduct

      this.logger.log("✅✅订单创建：执行");
      /// 数据处理
        /// 计算金额
          /// 计算总金额
          const totalAmount = 0;
          /// 计算实付金额
          const actualAmount = totalAmount;
        // 订单有效时间
          const validTime = new Date(now.getTime() + ORDER_CONSTANTS.AUTO_CANCEL_SECONDS * 1000);

      //  数据组织
        const orderInput = OrderInputFactory.forPetihope({
          bussinesstype: TableBusinessType.Petihope,
          bussinessid: hopeId,
          userId: userInfo.id,
          validTime: validTime,
          totalAmount: totalAmount,
          actualAmount: actualAmount,
          // receiverName: receiverName,//暂设置为none
          // receiverPhoneEncrypted: receiverPhoneEncrypted,//暂设置为none
          // receiverPhone: userInfo.phonenum,//待废弃
        });
      this.logger.log("✅✅订单创建orderInput：", orderInput);
      
      //  服务执行
        const orderCreateRes = 
          await this.orderService.createOrder(
            orderInput, 
            orderRepo
          )
        ;
        this.logger.log("✅✅订单创建orderCreateRes：", orderCreateRes);
        this.logger.log("✅✅订单创建orderCreateRes.bussinessid：", orderCreateRes.bussinessid);
        this.logger.log("✅✅订单创建orderCreateRes.orderSn：", orderCreateRes.orderSn);

    // ==================== 订单创建：订单商品快照 ====================
      // 商品是动态的，在支付的时候才出现  
      // // 3. 生成订单商品记录
      //   // 3.1 获取商品信息
      //     const product = await this.productService.getProductBySkuId(
      //       orderCreateRes.productSkuId, 
      //       manager
      //     );
      //     this.logger.log(`商品数据: ${product}`);
      //     if (!product) {
      //       this.logger.warn(`商品未找到，SKU ID: ${orderCreateRes.productSkuId}`);
      //       // throw new Error(`Product not found for SKU: ${productSkuId}`);
      //     }else{
      //       const { id: productId, productName, productPrice,productSkuId } = product;
      //       this.logger.log(`商品数据productId: ${productId}`);

      //       const quantity = 1;
      //       const totalPrice = productPrice * quantity;
      //     // 4.2 创建订单商品记录
      //       await this.orderProductService.createProductOrderManager(
      //         orderCreateRes.id,
      //         productId,
      //         productSkuId,
      //         productName,
      //         productPrice,
      //         quantity,
      //         totalPrice,
      //         manager,
      //       );
      //       this.logger.log(`3、订单商品记录创建成功: 订单ID ${orderCreateRes.id}, 商品 ${productName}`);
      //     }

    // // ==================== 订单创建：延迟任务 ====================
    //   /// 延迟任务
    //     /// 订单有效延迟任务
    //     const activities:CreateActivityDto = {
    //       endTime: TimeUtil.addTimeDate(
    //         orderCreateRes.validTime, 
    //         ORDER_CONSTANTS.AUTO_CANCEL_FIX_SECONDS * 1000
    //       ),
    //       bussinessId: orderCreateRes.id.toString(),
    //       bussinessType: TableBusinessType.OrderCancel,
    //       title: '请愿订单取消或完成监听'
    //     };
 
    //     const activitiesServiceResult = await this.activitiesService.createActivity(
    //       activities,
    //       activitiesRepo
    //     )

    // ==================== 订单创建：响应 ====================
    this.logger.log("✅✅✅完成memberAddPost Service服务");
    //   回调数据
    const customRes =  { 
      status: '0', 
      statusInfo: '请愿申请成功，去支付',
      data: {
        hopeId: orderCreateRes.bussinessid,
        orderId: orderCreateRes.orderSn, 
        validTime: orderCreateRes.validPayTime || orderCreateRes.validTime,
      }
    };  
    this.logger.log("✅✅✅customRes：", customRes);
    return customRes;
  } 

  private async startOrderDelayTask(orderNo: string) {
    /// 延迟任务【如果不存在则构建或只在第一次构建
      const order = await this.orderRepository.findOne({
        where: { 
          orderSn: orderNo,
        },
      });
      if(!order){
        this.logger.log("order: 订单不存在异常，无法创订单建延迟任务");
        throw new NotFoundException('订单不存在，无法创建订单延迟任务');
      }
      /// 允许延迟任务事务失败，使用支付回调和轮询保证数据一致性 
      try{
        const activities:CreateActivityDto = {
          endTime: TimeUtil.addTimeDate(
            order.validTime, 
            ORDER_CONSTANTS.AUTO_CANCEL_FIX_SECONDS * 1000
          ),
          bussinessId: order.id.toString(),
          bussinessType: TableBusinessType.OrderCancel,
          title: '订单超时监听'
        };
        const activitiesServiceResult = await this.activitiesService.createActivity(
          activities
        )
      } catch (error) {
        // 📌 关键：记录日志，但不抛出异常！
        this.logger.warn("⚠️创建订单有效延迟任务异常");
        this.logger.warn(`Failed to delayed task for order ${orderNo}`, error);
        // 继续正常返回 success
      } 
  }

  async decreasePeopleLessWithOptimisticLock(
    manager: EntityManager,
    id: string
  ): Promise<{ 
    success: boolean; 
    message?: string; 
    currentValue?: number }> {
    this.logger.log("开始减员操作：decreasePeopleLessWithOptimisticLock：");

    const maxRetries = 3; // 最大重试次数
    //  事务Rep
      //  Petihope
      const petihopeRep = manager.getRepository<Petihope>(Petihope);

    for (let attempt = 0; attempt < maxRetries; attempt++) {
      // 1. 读取当前数据
      const record = await petihopeRep.findOne({ 
        where: { id } 
      });
      this.logger.log("decrea****sticLock---数据record：",record);
      if (!record) {
        this.logger.log("decrea****sticLock：请愿不存在");
        return { success: false, message: '记录不存在' };
      }
      
      if (record.peopleLess <= 0) {
        this.logger.log("decrea****sticLock：人员数量已为0，不可再减");
        return { success: false, message: '人员数量已为0，不可再减' };
      }
      
      const result = await petihopeRep
        .createQueryBuilder()
        .update(Petihope)
        .set({ 
          peopleLess: record.peopleLess - 1 
        })
        .where('id = :id AND version = :version AND people_less > 0', { 
          id, 
          version: record.version 
        })
        .execute();
      
      // 修复：检查 affected 是否为 undefined 或 null
      const affected = result.affected ?? 0;
      
      if (affected > 0) {
        // 更新成功
          const updatedRecord = await petihopeRep.findOne({ 
            where: { id } 
          });
        
        // 修复：检查 updatedRecord 是否存在
        if (!updatedRecord) {
          this.logger.log("decrea****sticLock：更新后记录不存在");
          return { success: false, message: '更新后记录不存在' };
        }
        
        return { 
          success: true, 
          currentValue: updatedRecord.peopleLess 
        };
      }
      
      // 更新失败，版本冲突，等待后重试
      if (attempt < maxRetries - 1) {
        await this.delay(50 * (attempt + 1)); // 指数退避
      }
    }
    
    this.logger.log("decrea****sticLock：操作冲突，请重试");
    return { success: false, message: '操作冲突，请重试' };
  }
  
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
  /// 订单取消加员
  // async handlePetihopeOrderCancel(
  //   businessType: string,
  //   businessId: string
  // ) {
  //     this.logger.log(`延迟任务进入业务逻辑函数中====handlePetihopeOrderCancel：取消订单加员 ===`);
  //     /// ================================ 取消订单加员操作合法性检查
  //       /// 订单合法性检查
  //         this.logger.log(`========= 订单合法性检查：start ========= `);
  //         /// 自身
  //           /// 订单不存在 或 支付状态
  //             const order = await this.orderRepository.findOne({
  //               where: { id: Number(businessId) },
  //             });
  //             /// 订单不存在:return 或者
  //             /// 订单存在但没有被处理过:return
  //               /// PAI：未支付，用户下单默认状态：能确定用户没有支付过
  //               /// PAYING：：不能确定用户究竟有没有支付,确定的是用户用户吊起第三方支付成功创建了第三方支付订单
  //               /// 其他状态说明订单已经被处理了，属于终态
  //             if (!order || (order.payStatus!= PayStatus.PAID && order.payStatus!= PayStatus.PAYING)) {
  //               /// 正常流程，非系统错误
  //               return;
  //               /// 系统错误
  //               // this.logger.log(`========= 订单数据：${order} `);
  //               // this.logger.log(`========= 订单合法性检查：❌不合法，订单不存在 ========= `);
  //               // this.logger.log(`========= 订单合法性检查：end ========= `);
  //               // throw new NotFoundException('订单不存在');
  //             };
  //           ///支付记录【多渠道
  //             /// 渠道
  //               /// 支付宝
  //                 const payChannel = PayChannel.ALIPAY;
  //                 const strategy = this.strategies.get(payChannel);
  //                 if (!strategy) {
  //                   this.logger.log("❌不支持的支付方式：", PayChannel.ALIPAY);
  //                   throw new PaymentException(`不支持的支付方式: ${PayChannel.ALIPAY}`);
  //                 }

  //         /// 第三方支付
  //           /// 支付宝
  //           const orderThirdPaymentResult = await strategy.queryOrder(order.orderSn);
  //           this.logger.log("🈯️获取第三方支付信息：");
  //           this.logger.log(orderThirdPaymentResult);
  //           /// 订单已支付成功[TRADE_SUCCESS ｜｜ finish之类
  //           if(orderThirdPaymentResult.trade_status == 'TRADE_SUCCESS'){
  //             this.logger.log(`⚠️订单已支付成功：orderThirdPaymentResult.trade_status：${orderThirdPaymentResult.trade_status}`);
              
  //           }
  //           /// 订单wait
  //           if(orderThirdPaymentResult){
  //             ///  关闭第三方订单
              
  //           }
  //           /// 订单支付失败【订单为终态
  //           if(orderThirdPaymentResult.trade_status == 'TRADE_CLOSED'){
  //             this.logger.log(`⚠️订单关闭：orderThirdPaymentResult.trade_status：${orderThirdPaymentResult.trade_status}`);
  //             // return;
  //           }

  //       /// 请愿合法性检查
  //         this.logger.log(`========= 请愿合法性检查：start ========= `);
  //         const petihope = await this.petihopeRepository.findOne({
  //           where: { id: order.bussinessid },
  //         });
  //         /// 请愿不存在或请愿存在但剩余人数等于限制人数
  //         if (!petihope ||
  //           ( petihope && petihope.peopleLess >= petihope.joinPeopleMax )
  //         ) {
  //           this.logger.log(`========= 请愿数据：${petihope} `);
  //           this.logger.log(`========= 请愿合法性检查：❌请愿不存在或请愿存在但剩余人数等于限制人数 ========= `);
  //           this.logger.log(`========= 请愿合法性检查：end ========= `);
  //           return
  //         };
  //         this.logger.log(`========= 请愿合法性检查：✅合法 ========= `);
  //         this.logger.log(`========= 请愿合法性检查：end ========= `);


  //     /// ================================ 执行取消订单加员操作
  //       this.logger.log(`========= 执行取消订单加员操作：start ========= `);
  //       const petihopeId = petihope.id;
  //       const petihopeResult = await this.petihopeRepository
  //         .createQueryBuilder()
  //         .update(Petihope)
  //         .set({ 
  //           peopleLess: () => 'people_less + 1' 
  //         })
  //         .where('id = :petihopeId', { petihopeId })
  //         .andWhere('people_less < people_with_me_number')
  //         .execute()
  //       ;
  //     this.logger.log(`========= 执行取消订单加员操作数据：${petihopeResult} `);
  //     this.logger.log(`========= 执行取消订单加员操作：end ========= `);
  // }

  //  加入
  async memberAddSave(
    joinuserid: string, 
    oid: string, 
    manager: EntityManager
  ) {
    // 1. 先检查是否已存在（使用同一个 manager）
    const existing = await manager
      .createQueryBuilder(PetihopePri, 'petihopepri')
      .where('petihopepri.joinuserid = :joinuserid', { joinuserid })
      .andWhere('petihopepri.oid = :oid', { oid })
      .getOne();

    if (existing) {
      this.logger.log(`User already joined: joinuserid[${joinuserid}] - oid[${oid}]`);
      return { generatedMaps: [], raw: [], identifiers: [] };
    }

    // 2. 插入新记录（同样使用 execManager）
    return await manager
      .createQueryBuilder()
      .insert()
      .into(PetihopePri)
      .values({ joinuserid, oid })
      .execute()//  失败抛出异常 使用manager整个事务回滚
  }

  // ================== 标准 ==================
  create(createPetihopeDto: CreatePetihopeDto) {
    return 'This action adds a new petihope';
  }

  findAll() {
    return `This action returns all petihope`;
  }

  findOne(id: number) {
    return `This action returns a #${id} petihope`;
  }

  update(id: number, updatePetihopeDto: UpdatePetihopeDto) {
    return `This action updates a #${id} petihope`;
  }

  remove(id: number) {
    return `This action removes a #${id} petihope`;
  }
}
