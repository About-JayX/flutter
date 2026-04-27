import { 
  Entity, 
  PrimaryGeneratedColumn, 
  Column, 
  CreateDateColumn, 
  UpdateDateColumn, 
  OneToMany 
, BeforeInsert } from 'typeorm';
import { v4 as uuidv4 } from 'uuid';
import { OrderStatus, PayStatus, AfterSalesStatus } from '@/common/enums';
// import { createDecimalTransformer } from '@/common/transformers/decimal.transformer';
import { OrderProduct } from '@root/src/modules/order-product/entities/order-product.entity';
import { Pay } from '@/modules/pay/entities/pay.entity';

@Entity('app_order')
export class Order {
  @PrimaryGeneratedColumn('increment', { 
    comment: '订单ID' 
  })
  id: number;

  // 重要数据，跨数据库，唯一标志
  @Column({ 
    name: 'unique_id',
    type: 'uuid',
  })
  uniqueId: string;

  @Column({ 
    name: 'order_sn', 
    type: 'varchar', 
    length: 64, 
    unique: true, 
    comment: '订单编号' 
  })
  orderSn: string;

  @Column({ 
    name: 'bussinesstype', 
    type: 'text', 
    comment: '业务类型来源，比如petihope代表业务类型来源为：请愿' 
  })
  bussinesstype: string;

  @Column({ 
    name: 'bussinessid', 
    type: "bigint",
    comment: '业务类型来源ID' 
  })
  bussinessid: string;

  @Column({ 
    name: 'product_sku_id', 
    type: "int",
    comment: '订单的商品skuID',
    nullable: true,
  })
  productSkuId: number;

  @Column({ 
    name: 'user_id', 
    type: 'bigint', 
    comment: '用户ID' 
  })
  userId: string;
  // @Column({ 
  //   name: 'user_id', 
  //   type: 'int', 
  //   comment: '用户ID' 
  // })
  // userId: number;

  @Column({ 
    name: 'order_status', 
    type: 'tinyint', 
    default: OrderStatus.PENDING_PAYMENT,
    comment: '订单状态' 
  })
  orderStatus: OrderStatus;

  @Column({ 
    name: 'pay_status', 
    type: 'tinyint', 
    default: PayStatus.UNPAID,
    comment: '支付状态' 
  })
  payStatus: PayStatus;

  @Column({ 
    name: 'after_sales_status', 
    type: 'tinyint', 
    default: AfterSalesStatus.NONE,
    comment: '售后状态' 
  })
  afterSalesStatus: AfterSalesStatus;

  @Column({ 
    name: 'total_amount', 
    type: 'decimal', 
    precision: 10, 
    scale: 2, 
    // transformer: createDecimalTransformer(2),
    comment: '订单总金额' 
  })
  totalAmount: number;

  @Column({ 
    name: 'discount_amount', 
    type: 'decimal', 
    precision: 10, 
    scale: 2, 
    default: 0,
    comment: '优惠金额' 
  })
  discountAmount: number;

  @Column({ 
    name: 'shipping_fee', 
    type: 'decimal', 
    precision: 10, 
    scale: 2, 
    default: 0,
    comment: '运费' 
  })
  shippingFee: number;

  @Column({ 
    name: 'actual_amount', 
    type: 'decimal', 
    precision: 10, 
    scale: 2, 
    // transformer: createDecimalTransformer(2), //  数据库获取的结果是字符串，需要转换否则报错
    comment: '实付金额' 
  })
  actualAmount: number;

  @Column({ 
    name: 'currency', 
    type: 'varchar', 
    length: 10, 
    default: 'CNY',
    comment: '币种' 
  })
  currency: string;

  @Column({ 
    name: 'receiver_name', 
    type: 'varchar', 
    charset: 'utf8mb4',        // 明确指定
    collation: 'utf8mb4_unicode_ci',
    length: 50, 
    nullable: true,
    comment: '收货人姓名' 
  })
  receiverName: string;

  @Column({ 
    name: 'receiver_phone_encrypted', 
    nullable: true,
    comment: '收货人电话Encrypted' 
  })
  receiverPhoneEncrypted: string;
  @Column({ 
    name: 'receiver_phone', 
    type: 'varchar', 
    length: 20, 
    nullable: true,
    comment: '收货人电话' 
  })
  receiverPhone: string;

  // @Column({ 
  //   name: 'receiver_address', 
  //   type: 'text', 
  //   comment: '收货地址' 
  // })
  // receiverAddress: string;
  @Column({ 
    name: 'receiver_addr', 
    type: 'varchar', 
    length: 500,
    default: '地球',
    comment: '收货地址' 
  })
  receiverAddr: string;
  // ✅ 允许设置默认值：VARCHAR, CHAR, INT, DECIMAL, DATETIME 等
  // ❌ 不允许设置默认值：TEXT, BLOB, JSON, GEOMETRY 等

  @Column({ 
    name: 'user_remark', 
    type: 'text', 
    nullable: true,
    comment: '用户备注' 
  })
  userRemark: string;

  @Column({
    name: "valid_time", 
    type: 'timestamp',
    precision: 2,
    comment: '订单有效时间' 
  })
  validTime: Date;// invalidTime -> validTime

  @Column({
    name: "valid_pay_time", 
    type: 'timestamp',
    precision: 2,
    nullable: true,
    comment: '订单支付的有效时间,第三方支付订单过期时间' 
  })
  validPayTime: Date;

  @CreateDateColumn({ 
    name: 'create_time', 
    default: () => 'CURRENT_TIMESTAMP',
    precision: 0,
    comment: '创建时间' 
  })
  createTime: Date;

  @UpdateDateColumn({ 
    name: 'update_time', 
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
    precision: 0,
    comment: '更新时间' 
  })
  updateTime: Date;

  @Column({ 
    name: 'pay_time', 
    type: 'datetime', 
    nullable: true,
    comment: '支付时间' 
  })
  payTime: Date;

  @Column({ 
    name: 'cancel_time', 
    type: 'datetime', 
    nullable: true,
    comment: '取消时间' 
  })
  cancelTime: Date;

  @Column({ 
    name: 'complete_time', 
    type: 'datetime', 
    nullable: true,
    comment: '完成时间' 
  })
  completeTime: Date;

  @Column({ 
    name: 'manual_review', 
    default: false 
  })
  manualReview: boolean; // 是否进人工环节
  @Column({ 
    name: 'order_error_remark', 
    nullable: true,
  })
  orderErrorRemark: string; // 订单异常描述

  @Column({ 
    name: 'wait_check_retry_count', 
    default: 0 
  })
  waitCheckRetryCount: number; // WAIT 状态已重试次数

  @Column({ 
    name: 'last_wait_check_at', 
    nullable: true,
  })
  lastWaitCheckAt: Date; // 上次检查时间

  @Column({ 
    name: 'close_attempted', 
    default: false 
  })
  closeAttempted: boolean; // 是否已尝试关闭

  // 定义与 OrderProduct 的一对多关系
  @OneToMany(() => OrderProduct, orderProduct => orderProduct.order)
  orderProducts: OrderProduct[];

  // 定义与 Pay 的一对多关系
  @OneToMany(() => Pay, pay => pay.order)
  pays: Pay[];

  @BeforeInsert()
  generateUuid() {
    this.uniqueId = uuidv4();
  }
}