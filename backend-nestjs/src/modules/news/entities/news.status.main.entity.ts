import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';
import { TableBusinessType } from '@/common/enums/business-type.enum';
@Entity('app_news_status_main', { comment: '消息主表-存储全局唯一消息本体，所有设备/用户共享' })
export class NewsStatusMainEntity {
  /** 消息唯一主键ID */
  @PrimaryGeneratedColumn({ type: 'bigint', name: 'id', comment: '消息唯一主键ID' })
  id: string;

  /** 业务类型（chat-一对一、group-群聊、order-订单） */
  @Index('idx_biz_type')
  @Column({ type: 'varchar', length: 32, name: 'biz_type', comment: '业务类型：chat-一对一、group-群聊、order-订单' })
  bizType: TableBusinessType;

  /** 业务ID（chat-好友ID拼接、group-群聊ID、order-用户ID_订单ID） */
  @Index('idx_biz_id')
  @Column({ type: 'varchar', length: 64, name: 'biz_id', comment: '业务ID：与biz_type配合唯一标识业务实体' })
  bizId: string;

  /** 消息标题（系统/订单消息用，聊天消息可为空） */
  @Column({ type: 'varchar', length: 128, name: 'title', default: '', comment: '消息标题' })
  title: string;

  /** 消息内容 */
  @Column({ type: 'text', name: 'content', comment: '消息内容' })
  content: string;

  /** 发送方ID（platform-平台、userXXX-用户、groupXXX-群聊） */
  @Column({ type: 'varchar', length: 64, name: 'sender_id', comment: '发送方唯一标识' })
  senderId: string;

  /** 是否发布（1-已发布/可展示，0-草稿/未发布） */
  @Column({ type: 'tinyint', name: 'is_publish', default: 1, comment: '是否发布：0-未发布，1-已发布' })
  isPublish: number;

  /** 消息发送时间 */
  @Column({ type: 'datetime', name: 'send_time', default: () => 'CURRENT_TIMESTAMP', comment: '消息发送时间' })
  sendTime: Date;

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
