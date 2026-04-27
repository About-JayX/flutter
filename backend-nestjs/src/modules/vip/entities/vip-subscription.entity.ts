import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('vip_subscriptions')
@Index(['userId', 'status'])
@Index(['subscriptionId'])
export class VIPSubscription {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 40, comment: '用户ID' })
  userId: string;

  @Column({ type: 'varchar', length: 50, comment: '产品ID' })
  productId: string;

  @Column({ type: 'varchar', length: 100, comment: '订阅ID' })
  subscriptionId: string;

  @Column({ type: 'varchar', length: 20, comment: '类型 weekly/monthly' })
  type: string;

  @Column({
    type: 'varchar',
    length: 20,
    comment: '状态 active/expired/cancelled',
  })
  status: string;

  @Column({ type: 'datetime', comment: '开始时间' })
  startDate: Date;

  @Column({ type: 'datetime', comment: '过期时间' })
  expireDate: Date;

  @Column({ type: 'tinyint', default: 1, comment: '是否自动续订 0:否 1:是' })
  autoRenew: number;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;

  @UpdateDateColumn({ comment: '更新时间' })
  updatedAt: Date;
}
