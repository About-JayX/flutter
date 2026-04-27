import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { NewsStatusLevelType } from '@/common/enums/news-status-level-type.enum';

@Entity('app_news_status_level', { comment: '消息层级映射表-用户消息数量层级映射依据' })
export class NewsStatusLevelEntity {
  /** 映射记录唯一主键ID */
  @PrimaryGeneratedColumn({ type: 'bigint', name: 'id', comment: '映射记录唯一主键ID' })
  id: string;

  /** 层级类型 */
  @Column({ type: 'varchar', length: 32, name: 'level_type', comment: '层级类型（chat/group/order）' })
  levelType: NewsStatusLevelType;

  /** 父层级ID：顶级层级为NULL，子层级指向同一用户下的父层级ID */
  @Column({ type: 'bigint', name: 'parent_id', nullable: true, comment: '父层级ID：顶级为NULL' })
  parentId: string | null;

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

}
