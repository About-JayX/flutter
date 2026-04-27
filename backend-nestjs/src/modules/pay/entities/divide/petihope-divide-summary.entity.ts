// entities/petihope-divide-summary.entity.ts

import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, Index, Unique, BeforeInsert, } from 'typeorm';
import { v4 as uuidv4 } from 'uuid';
import { TableBusinessType } from '@/common/enums/business-type.enum';

@Entity('app_divide_summary')
@Unique(['businessType', 'businessId']) // 确保每笔业务只有一条汇总
export class PetihopeDivideSummary {
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

  // 活动发起人（分成接收人）
  @Index()
  @Column()
  userId: string;

  // 该活动产生的可分成总金额（原始支付 × 比例）
  @Column('decimal', { precision: 12, scale: 2 })
  totalSourceAmount: number;

  // 分成比例（如 0.888）
  @Column('decimal', { precision: 5, scale: 4 })
  divideRatio: number;

  // 实际分给用户的总金额（应等于所有明细之和）
  @Column('decimal', { precision: 12, scale: 2 })
  totalDivideAmount: number;

  // 平台抽成金额（可选，用于对账）
  @Column('decimal', { precision: 12, scale: 2, default: 0 })
  platformAmount: number;

  // 分成状态：pending, success, failed, reversed
  @Index()
  @Column({ default: 'success' })
  status: 'pending' | 'success' | 'failed' | 'reversed';

  // 分成时间
  @CreateDateColumn()
  divideTime: Date;

  // 更新时间
  @UpdateDateColumn()
  updateTime: Date;

  // 备注（如：手动调整、异常说明）
  @Column({ nullable: true, type: 'text' })
  remark: string;

  // 软删除标记
  @Column({ default: false })
  isDeleted: boolean;

  @BeforeInsert()
  generateUuid() {
    this.uniqueId = uuidv4();
  }

}