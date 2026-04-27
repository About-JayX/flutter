// withdrawal.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  BeforeInsert,
} from 'typeorm';

import { IsEnum, IsNumber, IsString } from 'class-validator';

import { v4 as uuidv4 } from 'uuid';

import { WithdrawChannel } from '@/common/enums/withdraw-channel.enum';
import { WithdrawalStatus } from '@/common/enums/withdraw-status.enum';
// export enum WithdrawalStatus {
//   PENDING = 'pending',      // 待处理
//   PROCESSING = 'processing', // 处理中
//   SUCCESS = 'success',      // 成功
//   FAILED = 'failed',        // 失败
//   CANCELLED = 'cancelled',  // 已取消
// }

import { BaseEntity } from '@/entities/shared/base.entity';

@Entity('app_withdraw')
@Index(['userId', 'status'])
export class WithdrawalEntity extends BaseEntity {
  @PrimaryGeneratedColumn('increment', {
    type: 'bigint',
    unsigned: true,
  })
  id: string;

  @Column({
    name: 'unique_id',
    type: 'uuid',
  })
  uniqueId: string;

  // out_biz_no
  @Column({
    name: 'withdraw_sn',
    type: 'varchar',
    length: 64,
    unique: true,
    comment: '提现流水号/订单号',
  })
  withdrawSn: string;

  @Index()
  @Column({
    name: 'user_id',
    type: 'bigint',
    comment: '用户id',
  })
  userId: string;

  @Column({
    name: 'user_uni_id',
    type: 'varchar',
    length: 64,
    comment: '用户唯一编号',
  })
  userUniId: string;
  // @Column({ type: 'uuid' })
  // @Index()
  // userId: string;

  // 提现的金额
  @Column({
    name: 'amount',
    type: 'decimal',
    precision: 10,
    scale: 2,
  })
  amount: number;

  // 提现的实际金额（原始提现 × (1-手续费比例)）
  @Column({
    name: 'actual_amount',
    type: 'decimal',
    precision: 10,
    scale: 2,
  })
  actualAmount: number;

  // // 提现的真实到帐金额
  // @Column({
  //   name: 'real_amount',
  //   type: 'decimal',
  //   precision: 10,
  //   scale: 2,
  //   comment:'提现的真实到帐金额'
  // })
  // realAmount: number;

  // 分成比例（如 0.888）
  @Column('decimal', {
    name: 'withdraw_ratio',
    precision: 5,
    scale: 4,
    default: 0,
  })
  withdrawRatio: number;
  // @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  // fee: number; // 手续费

  @Column({
    name: 'status',
    default: WithdrawalStatus.PENDING,
    type: 'varchar',
    length: 20,
  })
  // @IsEnum(WithdrawalStatus)
  status: WithdrawalStatus;

  @Column({
    name: 'channel',
    default: WithdrawChannel.BANK,
    type: 'varchar',
    length: 20,
  })
  // @IsEnum(WithdrawChannel)
  channel: WithdrawChannel;

  @Column({
    name: 'channel_opendid',
    type: 'varchar',
    length: 64,
    nullable: true,
  })
  channelOpenid?: string;
  @Column({
    name: 'channel_openphone_encrypted',
    nullable: true,
  })
  channelOpenphoneEncrypted: string;

  //  提现第三方唯一编号
  @Column({
    name: 'transaction_id',
    type: 'varchar',
    length: 64,
    unique: true,
    nullable: true,
    comment: '第三方交易号，第三方唯一编号',
  })
  transactionId?: string;

  @Column({
    name: 'account_no_encrypted',
    type: 'varchar',
    length: 100,
    select: false,
    nullable: true,
  })
  accountNoEncrypted?: string;
  //  默认不查出
  //  对加密字段要用 select: false
  //  即使你的代码逻辑是“查完用户提现记录然后返回给前端”，只要你不显式要求查 accountNoEncrypted，它就永远不会被加载到内存中。
  // 可以防止：
  //   ❌ 意外把加密字段序列化返回给前端
  //   ❌ 日志打印出敏感字段（如 console.log(entity)）
  //   ❌ 其他服务误用

  // 使用 AES 等算法加密后的完整账号，用于调用支付接口
  @Column({
    name: 'account_no_masked',
    type: 'varchar',
    length: 100,
    nullable: true,
  })
  accountNoMasked?: string;
  // 脱敏显示用，如 "银行卡: 6222****1234"
  // @Column({ type: 'varchar', length: 100, nullable: true })
  // accountNo?: string; // 收款账号（脱敏）

  @Column({
    name: 'account_name',
    type: 'varchar',
    length: 50,
    nullable: true,
  })
  accountName?: string; // 收款人姓名

  // @Column({ type: 'jsonb', nullable: true })
  // extra: Record<string, any>; // 渠道额外信息（如支付宝账号）

  // @Column({ type: 'timestamptz', nullable: true })
  // processedAt: Date;

  @Column({
    name: 'fail_reason',
    type: 'varchar',
    length: 500,
    nullable: true,
  })
  failReason?: string;

  // @Column({ type: 'inet', nullable: true }) // 存储IP
  // clientIp: string;

  // @Column({ type: 'varchar', length: 100, nullable: true })
  // userAgent: string;

  // @CreateDateColumn({ type: 'timestamptz' })
  // createdAt: Date;

  // @UpdateDateColumn({ type: 'timestamptz' })
  // updatedAt: Date;

  // @Index(['userId', 'status'])
  // @Index('IDX_withdrawal_pending', ['status', 'createdAt']) // 用于异步任务查询

  // 插入前自动设置状态
  // @BeforeInsert()
  // setStatus() {
  //   if (!this.status) {
  //     this.status = WithdrawalStatus.PENDING;
  //   }
  // }

  @BeforeInsert()
  generateUuid() {
    this.uniqueId = uuidv4();
  }
}
