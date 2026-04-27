import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  // ManyToOne,
  // JoinColumn,
} from 'typeorm';
// import { NewsStatusMainEntity } from './news.status.main.entity';

@Entity('app_news_status_user', { comment: '消息-用户触达记录表-记录消息对用户的触达状态（未读/已读）' })
// 核心唯一索引：保证单用户对单消息的触达记录唯一
@Index('idx_msg_user', ['messageId', 'userId'], { unique: true })
// 核心联合索引：加速按用户+状态过滤查询
@Index('idx_user_read_status', ['userId', 'readStatus'])
export class NewsStatusUserEntity {
  /** 触达记录唯一主键ID */
  @PrimaryGeneratedColumn({ type: 'bigint', name: 'id', comment: '触达记录唯一主键ID' })
  id: string;

  /** 关联消息主表ID */
  @Column({ type: 'bigint', name: 'message_id', comment: '关联message_core的主键ID' })
  messageId: string;

  /** 用户唯一标识 */
  @Column({ type: 'varchar', length: 64, name: 'user_id', comment: '用户唯一标识ID' })
  userId: string;

  /** 触达状态：0-未读，1-已读 */
  @Column({ type: 'tinyint', name: 'read_status', default: 0, comment: '触达状态：0-未读，1-已读' })
  readStatus: number;

  /** 消息标记已读时间（未读则为NULL） */
  @Column({ type: 'datetime', name: 'read_time', nullable: true, comment: '消息标记已读时间（NULL表示未读）' })
  readTime: Date | null;

  /** 消息触达用户时间 */
  @Column({
    type: 'datetime',
    name: 'reach_time',
    default: () => 'CURRENT_TIMESTAMP',
    comment: '消息触达用户时间',
  })
  reachTime: Date;

  /** 记录创建时间 */
  @CreateDateColumn({ type: 'datetime', name: 'create_time', comment: '记录创建时间' })
  createTime: Date;

  /** 记录更新时间 */
  @UpdateDateColumn({
    type: 'datetime',
    name: 'update_time',
    comment: '记录更新时间',
  })
  updateTime: Date;

  // // 外键关联：消息主表，消息删除时同步删除触达记录
  // @ManyToOne(() => NewsStatusMainEntity, (core) => core.id, { onDelete: 'CASCADE' })
  // @JoinColumn({ name: 'message_id', referencedColumnName: 'id' })
  // messageCore: NewsStatusMainEntity;
}
