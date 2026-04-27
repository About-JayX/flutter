import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('app_news_status_user_unread', { comment: '用户层级式未读数量表-按用户管理层级关系+未读总数' })
// 核心索引：按用户+父层级查询子层级，聚合未读数
@Index('idx_user_parent', ['userId', 'parentLevelId'])
// // 核心索引：按用户+层级编码快速查询
// @Index('idx_user_code', ['userId', 'levelCode'])
export class NewsStatusUserUnreadEntity {
  /** 主键ID */
  @PrimaryGeneratedColumn({ type: 'bigint', name: 'id', comment: '层级唯一主键ID' })
  id: string;

  /** 用户唯一标识 */
  @Column({ type: 'varchar', length: 64, name: 'user_id', comment: '用户唯一标识ID' })
  userId: string;

  /** 关联消息层级表的主键ID */
  @Column({ type: 'bigint', name: 'level_id', comment: '关联消息层级表的主键ID' })
  levelId: string;

  // /** 层级名称（如消息Tab、系统公告、订单提醒） */
  // @Column({ type: 'varchar', length: 64, name: 'level_name', comment: '层级名称' })
  // levelName: string;

  // /** 层级唯一编码（如tab_msg、sub_order、sub_group） */
  // @Column({ type: 'varchar', length: 64, name: 'level_code', default: '', comment: '层级唯一编码' })
  // levelCode: string;

  /** 父层级ID：顶级层级为NULL，子层级指向同一用户下的父层级ID */
  @Column({ type: 'bigint', name: 'parent_level_id', nullable: true, comment: '父层级ID：顶级为NULL' })
  parentLevelId: string | null;

  /** 该层级当前未读消息总数（0则隐藏红标） */
  @Column({ type: 'int', name: 'unread_count', default: 0, comment: '层级未读消息总数' })
  unreadCount: number;

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

  // ========== 核心新增：软删除字段 ==========
  @Column({ 
    name: 'is_deleted', // 数据库字段名
    type: 'tinyint',    // 用tinyint节省空间（1=未删，0=已删）
    default: 1,         // 默认未删除
    comment: '软删除标记：1=有效（未删），0=失效（已删）'
  })
  isDeleted: number;

  // 可选：新增删除时间字段（便于追溯）
  @Column({ 
    name: 'delete_time',
    type: 'datetime',
    nullable: true,     // 未删除时为NULL
    comment: '软删除时间'
  })
  deleteTime: Date;
}
