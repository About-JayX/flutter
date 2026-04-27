import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  BeforeInsert,
} from 'typeorm';
import { v4 as uuidv4 } from 'uuid';
import { Order } from '@root/src/modules/order/entities/order.entity';
import { PayStatus } from '@/common/enums';
import { PayChannel } from '@/common/enums/pay-channel.enum';
@Entity('app_pay')
export class Pay {
  @PrimaryGeneratedColumn('increment', { comment: '支付ID' })
  id: number;

  // 重要数据，跨数据库，唯一标志
  @Column({
    name: 'unique_id',
    type: 'uuid',
  })
  uniqueId: string;

  @Column({
    name: 'order_id',
    type: 'int',
    comment: '订单ID',
  })
  orderId: number;

  @Column({
    name: 'pay_sn',
    type: 'varchar',
    length: 64,
    comment: '支付流水号',
  })
  paySn: string;

  @Column({
    name: 'transaction_id',
    type: 'varchar',
    length: 64,
    unique: true,
    nullable: false,
    comment: '第三方交易号',
  })
  transactionId: string;

  @Column({
    name: 'pay_amount',
    type: 'decimal',
    precision: 10,
    scale: 2,
    comment: '支付金额',
  })
  payAmount: number;

  @Column({
    name: 'pay_method',
    type: 'varchar',
    length: 20,
    nullable: false,
    default: PayChannel.FREE,
    comment: '支付方式',
  })
  payMethod: PayChannel;

  @Column({
    name: 'pay_status',
    type: 'tinyint',
    default: PayStatus.UNPAID,
    comment: '支付状态',
  })
  payStatus: PayStatus;

  @CreateDateColumn({
    name: 'create_time',
    default: () => 'CURRENT_TIMESTAMP',
    precision: 0,
    comment: '创建时间',
  })
  createTime: Date;

  @UpdateDateColumn({
    name: 'update_time',
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
    precision: 0,
    comment: '更新时间',
  })
  updateTime: Date;

  @Column({
    name: 'pay_time',
    type: 'datetime',
    nullable: true,
    comment: '支付时间',
  })
  payTime: Date;

  @Column({
    name: 'refund_id',
    type: 'varchar',
    length: 64,
    nullable: true,
    comment: '退款交易号',
  })
  refundId: string;

  @Column({
    name: 'refund_amount',
    type: 'decimal',
    precision: 10,
    scale: 2,
    default: 0,
    comment: '退款金额',
  })
  refundAmount: number;

  @Column({
    name: 'refund_time',
    type: 'datetime',
    nullable: true,
    comment: '退款时间',
  })
  refundTime: Date;

  // 定义与 Order 的多对一关系
  @ManyToOne(() => Order, (order) => order.pays)
  @JoinColumn({ name: 'order_id' })
  order: Order;

  @BeforeInsert()
  generateUuid() {
    this.uniqueId = uuidv4();
  }
}
