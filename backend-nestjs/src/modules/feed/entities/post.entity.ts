import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('posts')
@Index(['userId', 'createdAt'])
@Index(['purpose', 'status', 'createdAt'])
@Index(['visibility', 'status', 'createdAt'])
export class Post {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 40, comment: '用户ID' })
  userId: string;

  @Column({ type: 'text', comment: '内容' })
  content: string;

  @Column({ type: 'simple-json', nullable: true, comment: '话题标签' })
  tags: any[];

  @Column({ type: 'varchar', length: 50, comment: '交友目的' })
  purpose: string;

  @Column({
    type: 'varchar',
    length: 50,
    default: 'public',
    comment: '可见范围 public/friends/only_me',
  })
  visibility: string;

  @Column({ type: 'simple-json', nullable: true, comment: '图片列表' })
  images: string[];

  @Column({ type: 'int', default: 0, comment: '点赞数' })
  likeCount: number;

  @Column({ type: 'int', default: 0, comment: '评论数' })
  commentCount: number;

  @Column({
    type: 'varchar',
    length: 20,
    default: 'pending',
    comment: '状态 pending/approved/rejected',
  })
  status: string;

  @Column({
    type: 'tinyint',
    default: 0,
    comment: '是否匿名 0:否 1:是',
  })
  isAnonymous: number;

  @Column({
    type: 'varchar',
    length: 225,
    nullable: true,
    comment: '审核原因',
  })
  moderationReason: string;

  @Column({
    type: 'datetime',
    nullable: true,
    comment: '审核时间',
  })
  moderatedAt: Date;

  @Column({
    type: 'varchar',
    length: 40,
    nullable: true,
    comment: '审核人ID',
  })
  moderatedBy: string;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;

  @UpdateDateColumn({ comment: '更新时间' })
  updatedAt: Date;
}
