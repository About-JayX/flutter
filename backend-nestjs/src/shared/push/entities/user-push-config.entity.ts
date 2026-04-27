import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Unique,
  Index,
} from 'typeorm';

@Entity({ name: 'app_user_push_config' }) // 显式指定数据库表名
@Unique(['userId']) // 一个用户对应一条配置（唯一索引）
export class UserPushConfig {
  /** 主键ID */
  @PrimaryGeneratedColumn({
    type: 'bigint',
    comment: '主键ID',
    name: 'id' // 数据库字段名
  })
  id: string;

  /** 关联用户主键ID（外键） */
  @Column({
    type: 'bigint',
    comment: '关联用户主键ID',
    name: 'user_id' // 数据库字段名
  })
  userId: string;

   /** 移除 @Index 装饰器，避免TypeORM自动创建无效索引 */
  @Column({
    type: 'json',
    nullable: true,
    comment: '用户级标签（JSON数组，如["VIP","北京","90后"]）',
    name: 'user_tags'
  })
  userTags: string[];
  // /** 用户级标签（全局标签，所有设备共享） */
  // @Index('idx_user_tags') // 标签查询索引（MySQL 8.0+ 支持JSON索引）
  // @Column({
  //   type: 'json',
  //   nullable: true,
  //   comment: '用户级标签（JSON数组，如["VIP","北京","90后"]）',
  //   name: 'user_tags' // 数据库字段名
  // })
  // userTags: string[];

  /** 全局推送开关：1-开启，0-关闭（优先级最高） */
  @Column({
    type: 'tinyint',
    default: 1,
    comment: '全局推送开关：1-开启，0-关闭',
    name: 'push_switch' // 数据库字段名
  })
  pushSwitch: number;

  /** 免打扰开始时间（如23:00） */
  @Column({
    type: 'varchar',
    length: 8,
    default: '23:00',
    comment: '免打扰开始时间',
    name: 'disturb_start' // 数据库字段名
  })
  disturbStart: string;

  /** 免打扰结束时间（如07:00） */
  @Column({
    type: 'varchar',
    length: 8,
    default: '07:00',
    comment: '免打扰结束时间',
    name: 'disturb_end' // 数据库字段名
  })
  disturbEnd: string;

  /** 消息推送开关：1-开启，0-关闭 */
  @Column({
    type: 'tinyint',
    default: 1,
    comment: '消息推送开关',
    name: 'msg_push' // 数据库字段名
  })
  msgPush: number;

  /** 通知推送开关：1-开启，0-关闭 */
  @Column({
    type: 'tinyint',
    default: 1,
    comment: '通知推送开关',
    name: 'notice_push' // 数据库字段名
  })
  noticePush: number;

  /** 活动推送开关：1-开启，0-关闭 */
  @Column({
    type: 'tinyint',
    default: 1,
    comment: '活动推送开关',
    name: 'activity_push' // 数据库字段名
  })
  activityPush: number;

  /** 创建时间（自动生成，无需手动赋值） */
  @CreateDateColumn({
    type: 'datetime',
    comment: '创建时间',
    name: 'create_time' // 数据库字段名
  })
  createTime: Date;

  /** 更新时间（自动更新，无需手动赋值） */
  @UpdateDateColumn({
    type: 'datetime',
    comment: '更新时间',
    name: 'update_time' // 数据库字段名
  })
  updateTime: Date;
}
