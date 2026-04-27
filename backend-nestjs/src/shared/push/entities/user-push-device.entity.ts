import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  Unique,
} from 'typeorm';

export enum DeviceType {
  ANDROID = 1,
  IOS = 2,
  WECHAT_MINI = 3,
  H5 = 4,
  PAD = 5,
}

export enum PushChannel {
  JIGUANG = 1,
  GETUI = 2,
  FCM = 3,
  HUAWEI = 4,
}

@Entity({ name: 'app_user_push_device' })
@Unique(['userId', 'rid'])
@Unique(['alias']) // alias 全局唯一
export class UserPushDevice {
  @PrimaryGeneratedColumn({ type: 'bigint', comment: '主键ID', name: 'id' })
  id: string;

  @Index('idx_user_id')
  @Column({ type: 'bigint', comment: '关联用户主键ID', name: 'user_id' })
  userId: string;

  @Index('idx_rid')
  @Column({ type: 'varchar', length: 64, comment: '设备推送唯一标识rid', name: 'rid' })
  rid: string;

  @Column({ 
    type: 'varchar', 
    length: 64, 
    default: '', 
    comment: '设备推送别名（极光/个推alias）',
    name: 'alias' 
  })
  alias: string;

  @Column({
    type: 'json',
    nullable: true,
    comment: '设备级标签（JSON数组）',
    name: 'tags'
  })
  tags: string[]; // 直接映射为字符串数组，TypeORM 自动序列化/反序列化

  @Column({
    type: 'tinyint',
    comment: '设备类型',
    name: 'device_type'
  })
  deviceType: DeviceType;

  @Column({
    type: 'varchar', 
    length: 64, 
    comment: '操作系统',
    name: 'device_os',
    default: 'android',
  })
  deviceOS: string;

  @Column({
    type: 'varchar',
    length: 64,
    default: '',
    comment: '设备名称',
    name: 'device_name'
  })
  deviceName: string;

  @Column({
    type: 'varchar',
    length: 128,
    default: '',
    comment: '设备唯一标识',
    name: 'device_code'
  })
  deviceCode: string;

  @Column({
    type: 'tinyint',
    default: PushChannel.JIGUANG,
    comment: '推送渠道',
    name: 'push_channel'
  })
  pushChannel: PushChannel;

  @Index('idx_is_valid')
  @Column({
    type: 'tinyint',
    default: 1,
    comment: '设备有效性',
    name: 'is_valid'
  })
  isValid: number;

  @Column({
    type: 'datetime',
    nullable: true,
    comment: '失效时间',
    name: 'invalid_time'
  })
  invalidTime: Date | null;

  @CreateDateColumn({ type: 'datetime', comment: '创建时间', name: 'create_time' })
  createTime: Date;

  @UpdateDateColumn({ type: 'datetime', comment: '更新时间', name: 'update_time' })
  updateTime: Date;
}
