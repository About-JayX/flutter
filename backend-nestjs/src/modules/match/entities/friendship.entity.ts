import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('friendships')
@Index(['userId', 'status'])
@Index(['userId', 'friendId'])
export class Friendship {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 40, comment: '用户ID' })
  userId: string;

  @Column({ type: 'varchar', length: 40, comment: '好友ID' })
  friendId: string;

  @Column({
    type: 'varchar',
    length: 20,
    default: 'pending',
    comment: '状态 pending/accepted/blocked',
  })
  status: string;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;

  @UpdateDateColumn({ comment: '更新时间' })
  updatedAt: Date;
}
