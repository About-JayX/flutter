import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('swipes')
@Index(['userId', 'createdAt'])
@Index(['userId', 'targetId'])
export class Swipe {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 40, comment: '用户ID' })
  userId: string;

  @Column({ type: 'varchar', length: 40, comment: '目标用户ID' })
  targetId: string;

  @Column({ type: 'varchar', length: 20, comment: '操作 like/dislike/rewind' })
  action: string;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;
}
