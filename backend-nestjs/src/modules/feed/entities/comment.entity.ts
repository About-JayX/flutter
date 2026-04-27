import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('comments')
@Index(['postId', 'createdAt'])
@Index(['userId', 'createdAt'])
export class Comment {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 36, comment: '帖子ID' })
  postId: string;

  @Column({ type: 'varchar', length: 40, comment: '用户ID' })
  userId: string;

  @Column({ type: 'text', comment: '内容' })
  content: string;

  @Column({ type: 'varchar', length: 36, nullable: true, comment: '父评论ID' })
  parentId: string;

  @Column({
    type: 'varchar',
    length: 20,
    default: 'approved',
    comment: '状态 approved/rejected',
  })
  status: string;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;

  @UpdateDateColumn({ comment: '更新时间' })
  updatedAt: Date;
}
