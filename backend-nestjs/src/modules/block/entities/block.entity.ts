import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('blocks')
@Index(['userId', 'blockedId'])
@Index(['userId', 'createdAt'])
export class Block {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 40, comment: '用户ID' })
  userId: string;

  @Column({ type: 'varchar', length: 40, comment: '被拉黑用户ID' })
  blockedId: string;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;
}
