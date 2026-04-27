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
import { TableBusinessType } from '@/common/enums/business-type.enum';
// import { NewsStatusUserUnreadEntity } from './news.status.user.unread.entity';

@Entity('app_news_status_user_unread_level', { comment: '用户-业务层级映射表-建立业务与用户叶子层级的唯一映射' })
// 核心唯一索引：保证单用户的单业务实体唯一映射一个叶子层级
// @Index('idx_user_biz_level', ['userId', 'levelId'], { unique: true })
@Index('idx_user_biz_level', ['userId', 'bizType', 'bizId'], { unique: true })
/// 「user_id + biz_type + biz_id」是「用户 - 业务 - 层级」的完整映射，能精准定位「某类业务的消息该归属到用户的哪个层级下统计」
export class NewsStatusUserUnreadLevelEntity {
  /** 映射记录唯一主键ID */
  @PrimaryGeneratedColumn({ type: 'bigint', name: 'id', comment: '映射记录唯一主键ID' })
  id: string;

  /** 用户唯一标识 */
  @Column({ type: 'varchar', length: 64, name: 'user_id', comment: '用户唯一标识ID' })
  userId: string;

  /** 业务类型（与message_core的biz_type一致：chat/group/order） */
  @Column({ type: 'varchar', length: 32, name: 'biz_type', comment: '业务类型（chat/group/order）' })
  bizType: TableBusinessType;

  /** 业务ID（与message_core的biz_id一致） */
  @Column({ type: 'varchar', length: 64, name: 'biz_id', comment: '业务ID（与message_core.biz_id一致）' })
  bizId: string;

  /** 关联消息层级表的主键ID */
  @Column({ type: 'bigint', name: 'level_id', comment: '关联消息层级表的主键ID' })
  levelId: string;

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

  // // 外键关联：用户层级表，层级删除时同步删除映射记录
  // @ManyToOne(() => NewsStatusUserUnreadEntity, (level) => level.id, { onDelete: 'CASCADE' })
  // @JoinColumn({ name: 'level_id', referencedColumnName: 'id' })
  // messageUnreadLevel: NewsStatusUserUnreadEntity;
}
