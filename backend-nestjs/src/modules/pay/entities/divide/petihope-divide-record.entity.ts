// entities/petihope-divide-record.entity.ts

import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index, BeforeInsert } from 'typeorm';
import { v4 as uuidv4 } from 'uuid';
import { TableBusinessType } from '@/common/enums/business-type.enum';

@Entity('app_divide_record')
export class PetihopeDivideRecord {
  @PrimaryGeneratedColumn('increment', {
    type: 'bigint',
    unsigned: true, // 可选：无符号，使范围变为 0 到 2^64-1
  })
  id: string;

  // 重要数据，跨数据库，唯一标志
  @Column({ 
    name: 'unique_id',
    type: 'uuid',
  })
  uniqueId: string;

//   @PrimaryGeneratedColumn('uuid')
//   id: string;

  @Index()
  @Column({ 
    name: 'business_id', 
    type: "bigint",
    nullable: false,
    comment: '业务类型来源ID，名称为businessType指定的表对应的：id'
  })
  businessId: string;

  @Index()
  @Column({ 
    name: 'business_type',
    default: TableBusinessType.Petihope,
    type: 'varchar', 
    length: '255',
    nullable: false,
    comment: '业务类型来源' 
  })
  businessType: string;

  // 获得分成的用户 ID（通常是活动发起人）
  @Index()
  @Column()
  userId: string;

  // 关联的订单 ID（可选）
  @Index()
  @Column({ nullable: true })
  orderId: string;

  // 关联的支付记录 ID（关键，用于追溯）
  @Index()
  @Column({ nullable: true })
  payId: string;

  // 原始支付金额
  @Column('decimal', { precision: 10, scale: 2 })
  originAmount: number;

  // 分成比例
  @Column('decimal', { precision: 5, scale: 4 })
  divideRatio: number;

  // 分成金额（originAmount × divideRatio）
  @Column('decimal', { precision: 10, scale: 2 })
  divideAmount: number;

  // 平台抽成金额（originAmount × (1 - divideRatio)）
  @Column('decimal', { precision: 10, scale: 2 })
  platformAmount: number;

  // 分成状态
  @Index()
  @Column({ default: 'success' })
  status: 'success' | 'failed' | 'reversed' | 'pending';

  // 分成时间
  @CreateDateColumn()
  divideTime: Date;

  // 备注
  @Column({ nullable: true, type: 'text' })
  remark: string;

  // 软删除标记
  @Column({ default: false })
  isDeleted: boolean;


  @BeforeInsert()
  generateUuid() {
    this.uniqueId = uuidv4();
  }

  // 自动计算平台金额（插入前）
  @BeforeInsert()
  calculatePlatformAmount() {
    this.platformAmount = this.originAmount - this.divideAmount;
  }
}