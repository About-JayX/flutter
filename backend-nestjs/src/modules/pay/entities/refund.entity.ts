// refund.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, Index } from 'typeorm';
import { RefundStatus,RefundType,RefundMethod } from '@/common/enums/refund-status.enum';
import { BaseEntity } from '@/entities/shared/base.entity';

// 可选：定义枚举
// export enum RefundStatus {
//   PENDING = 0,      // 待处理
//   APPROVED = 1,     // 已同意
//   REJECTED = 2,     // 已拒绝
//   REFUNDED = 3,     // 已退款（第三方成功）
//   FAILED = 4,       // 退款失败
//   CANCELLED = 5,    // 用户取消
// }

// export enum RefundType {
//   FULL = 0,         // 全额退款
//   PARTIAL = 1,      // 部分退款
// }

// export enum RefundMethod {
//   ORIGINAL = 0,     // 原路退回
//   WALLET = 1,       // 退回至用户钱包
//   BANK_TRANSFER = 2,// 银行转账
// }
@Index(['orderSn'], { unique: true }) // 唯一索引
@Entity('app_refund')
export class Refund extends BaseEntity{
  @PrimaryGeneratedColumn('increment',{
    type: 'bigint', // 明确指定数据库类型为 BIGINT
    unsigned: true, // 可选：无符号，使范围变为 0 到 2^64-1
  })
  id: string;

  @Column({ 
    name: 'refund_no', 
    type: 'varchar', 
    length: 64, 
    unique: true, 
    comment: '退款单号，系统生成，唯一标识' 
  })
  refundNo: string;

  @Column({ 
    name: 'order_sn', 
    type: 'varchar', 
    length: 64, 
    comment: '关联的订单编号' 
  })
  orderSn: string;

  @Column({ 
    name: 'user_id', 
    type: 'bigint', 
    comment: '退款用户ID' 
  })
  userId: string;

  // 金额相关
  @Column({ 
    name: 'refund_amount', 
    type: 'decimal', 
    precision: 10, 
    scale: 2, 
    comment: '总退款金额（单位：元），精确到分' 
  })
  refundAmount: number;

  @Column({ 
    name: 'product_amount', 
    type: 'decimal', 
    precision: 10, 
    scale: 2, 
    nullable: true,
    comment: '商品退款金额' 
  })
  productAmount: number | null;

  @Column({ 
    name: 'shipping_amount', 
    type: 'decimal', 
    precision: 10, 
    scale: 2, 
    nullable: true,
    comment: '运费退款金额' 
  })
  shippingAmount: number | null;

  @Column({ 
    name: 'discount_refunded', 
    type: 'decimal', 
    precision: 10, 
    scale: 2, 
    default: 0,
    comment: '退还的优惠金额（如优惠券、积分等）' 
  })
  discountRefunded: number;

  // 退款类型与状态
  @Column({ 
    name: 'refund_type', 
    type: 'tinyint', 
    unsigned: true, 
    default: RefundType.FULL,
    comment: '退款类型: 0=全额, 1=部分' 
  })
  refundType: RefundType;

  @Column({ 
    name: 'status', 
    type: 'tinyint', 
    unsigned: true, 
    default: RefundStatus.PENDING,
    comment: '退款状态: 0=待处理, 1=已同意, 2=已拒绝, 3=已退款, 4=失败, 5=已取消' 
  })
  status: RefundStatus;

  // 原因与描述
  @Column({ 
    name: 'reason', 
    type: 'varchar', 
    length: 100, 
    comment: '退款原因（如：商品损坏、不想要了等）' 
  })
  reason: string;

  @Column({ 
    name: 'description', 
    type: 'text', 
    nullable: true,
    comment: '用户提交的退款说明或描述' 
  })
  description: string | null;

  @Column({ 
    name: 'admin_remark', 
    type: 'text', 
    nullable: true,
    comment: '管理员/客服备注' 
  })
  adminRemark: string | null;

  // 凭证图片
  @Column({ 
    name: 'evidence_images', 
    type: 'json', 
    nullable: true,
    comment: '退款凭证图片链接数组，如 ["https://...", "..."]' 
  })
  evidenceImages: string[] | null;

  // 退款方式
  @Column({ 
    name: 'refund_method', 
    type: 'tinyint', 
    unsigned: true, 
    default: RefundMethod.ORIGINAL,
    comment: '退款方式: 0=原路退回, 1=退回钱包, 2=银行转账' 
  })
  refundMethod: RefundMethod;

  // 第三方支付信息
  @Column({ 
    name: 'channel_refund_no', 
    type: 'varchar', 
    length: 128, 
    nullable: true,
    comment: '第三方渠道退款单号（如微信 refund_id）' 
  })
  channelRefundNo: string | null;

  @Column({ 
    name: 'channel_response', 
    type: 'text', 
    nullable: true,
    comment: '第三方退款接口原始响应（用于排查问题）' 
  })
  channelResponse: string | null;

  // 时间字段
  @Column({ 
    name: 'applied_time', 
    type: 'timestamp', 
    precision: 3, 
    nullable: true,
    comment: '用户申请退款时间' 
  })
  appliedTime: Date | null;

  @Column({ 
    name: 'approved_time', 
    type: 'timestamp', 
    precision: 3, 
    nullable: true,
    comment: '审核通过时间' 
  })
  approvedTime: Date | null;

  @Column({ 
    name: 'refunded_time', 
    type: 'timestamp', 
    precision: 3, 
    nullable: true,
    comment: '实际退款成功时间（第三方回调）' 
  })
  refundedTime: Date | null;
}