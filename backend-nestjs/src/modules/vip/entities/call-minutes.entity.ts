import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('call_minutes')
@Index(['userId', 'type'])
export class CallMinutes {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 40, comment: '用户ID' })
  userId: string;

  @Column({ type: 'varchar', length: 20, comment: '类型 voice/video' })
  type: string;

  @Column({ type: 'int', default: 0, comment: '总时长(分钟)' })
  totalMinutes: number;

  @Column({ type: 'int', default: 0, comment: '已使用时长(分钟)' })
  usedMinutes: number;

  @Column({ type: 'int', default: 0, comment: '剩余时长(分钟)' })
  remainingMinutes: number;

  @Column({ type: 'datetime', nullable: true, comment: '过期时间' })
  expireDate: Date;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;

  @UpdateDateColumn({ comment: '更新时间' })
  updatedAt: Date;
}
