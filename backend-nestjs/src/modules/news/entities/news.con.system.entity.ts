import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

/**
 * 系统消息表 Entity
 * 存储全局系统消息本体（如系统公告、版本更新、全局通知等）
 * 不关联用户触达状态，触达状态可关联之前的 message_user_reach 表
 */
@Entity('app_news_con_system', { comment: '系统消息主表-存储全局系统消息本体' })
// 核心索引：按发送时间倒序查询（常用场景：最新系统消息优先展示）
// ✅ TypeORM 0.3.28 完全合法：函数式排序 + 移除 comment 配置
@Index('idx_send_time', (_sm: NewsConSystem) => ({ sendTime: -1 }))
// @Index('idx_send_time', ['sendTime'], { order: { sendTime: 'DESC' } })

// 联合索引：按消息类型+启用状态查询（常用场景：查询可用的公告类消息）
@Index('idx_type_status', ['msgType', 'isEnable'])
export class NewsConSystem {
  /** 系统消息唯一主键ID */
  @PrimaryGeneratedColumn({ type: 'bigint', name: 'id', comment: '系统消息唯一主键ID' })
  id: string;

  /** 消息标题（必填，如「V2.0版本更新公告」） */
  @Column({ type: 'varchar', length: 128, name: 'title', comment: '系统消息标题' })
  title: string;

  /** 消息描述/内容（必填，支持长文本，如更新内容、公告详情） */
  @Column({ type: 'text', name: 'des', comment: '系统消息描述/详细内容' })
  des: string;

  /** 消息类型（用于分类，如announcement-系统公告、update-版本更新、notice-全局通知） */
  @Column({
    type: 'varchar',
    length: 32,
    name: 'msg_type',
    default: 'announcement',
    comment: '消息类型：announcement-系统公告、update-版本更新、notice-全局通知',
  })
  msgType: string;

  /** 消息发送时间（前端展示的发布时间，可提前设置定时推送） */
  @Column({
    type: 'datetime',
    name: 'send_time',
    default: () => 'CURRENT_TIMESTAMP',
    comment: '消息发送/发布时间（支持定时推送）',
  })
  sendTime: Date;

  /** 是否启用（0-禁用/不展示，1-启用/展示，用于下架无效消息） */
  @Column({
    type: 'tinyint',
    name: 'is_enable',
    default: 1,
    comment: '是否启用：0-禁用（不展示），1-启用（展示）',
  })
  isEnable: number;

  /** 推送范围（all-全用户，partial-定向用户，用于区分推送对象） */
  @Column({
    type: 'varchar',
    length: 16,
    name: 'push_scope',
    default: 'all',
    comment: '推送范围：all-全用户，partial-定向用户',
  })
  pushScope: string;

  /** 消息跳转链接（可选，如公告详情页、下载链接） */
  @Column({
    type: 'varchar',
    length: 255,
    name: 'jump_url',
    default: '',
    comment: '消息跳转链接（可选）',
  })
  jumpUrl: string;

  /** 记录创建时间（数据库自动维护，无需手动赋值） */
  @CreateDateColumn({ type: 'datetime', name: 'create_time', comment: '记录创建时间' })
  createTime: Date;

  /** 记录更新时间（数据库自动维护，更新时刷新） */
  @UpdateDateColumn({ type: 'datetime', name: 'update_time', comment: '记录更新时间' })
  updateTime: Date;
}
