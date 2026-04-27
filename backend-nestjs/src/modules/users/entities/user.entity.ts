import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { LocationEmbed } from '@/common/embeds/location.embed';
// import { PushEmbed } from '@/common/embeds/push.embed';

export enum UserAccountType {
  MarketReview = 'market_review',
}

@Entity('app_users')
export class User {
  @PrimaryGeneratedColumn('increment', {
    type: 'bigint',
    unsigned: true,
  })
  id: string;

  @Column({
    name: 'uniqid',
    type: 'char',
    length: 40,
    unique: true,
    default: 0,
  })
  uniqid: string;

  @Column({
    name: 'account_type',
    type: 'varchar',
    length: 100,
    nullable: true,
  })
  accountType: UserAccountType;

  ///  待废弃
  @Column({
    name: 'phonenum',
    type: 'bigint',
    unsigned: true,
    unique: true,
    nullable: true,
  })
  phonenum: string;

  /// Hash比对，索引
  @Column({ name: 'phone_hash', nullable: true })
  phoneHash: string; // SHA256(8613812345678)
  //  ⚠️unique: true和非空会导致有数据的情况下迁移失败
  //  先设为空和非unique，数据清洗完成才改回来

  /// Encrypted短信登录，换号等
  @Column({
    name: 'phone_encrypted',
    nullable: true,
  })
  phoneEncrypted: string; // AES(8613812345678)
  //  ⚠️非空会导致有数据的情况下迁移失败,同上

  @Column({
    name: 'username',
    type: 'varchar',
    length: 500,
    unique: true,
    nullable: true,
  })
  userName: string;

  @Column({
    name: 'usernickname',
    type: 'varchar',
    charset: 'utf8mb4', // 明确指定
    collation: 'utf8mb4_unicode_ci',
    length: 500,
    nullable: true,
  })
  userNickName: string;

  @Column({
    name: 'herdes',
    type: 'longtext',
    charset: 'utf8mb4', // 明确指定
    collation: 'utf8mb4_unicode_ci',
    nullable: true,
  })
  herdes: string | null;

  @Column({
    name: 'avatar',
    type: 'varchar',
    length: 225,
    nullable: true,
  })
  avatar: string | null;

  @Column({
    name: 'back',
    type: 'varchar',
    length: 225,
    nullable: true,
  })
  back: string | null;

  @Column({
    name: 'location',
    type: 'longtext',
    nullable: true,
  })
  location: string | null;

  @Column('json', {
    name: 'current_location_map',
    nullable: true,
    comment: '当前定位地址',
  })
  currrentLocationMap: LocationEmbed | null;

  @Column({ name: 'mylocation', type: 'longtext', nullable: true })
  mylocation: string | null;

  @Column('json', {
    name: 'my_location_map',
    nullable: true,
    comment: '我的定位地址',
  })
  myLocationMap: LocationEmbed | null;

  @Column({
    name: 'divide_source_money',
    type: 'decimal',
    precision: 10,
    scale: 2,
    unsigned: true,
    default: 0,
    comment: '分成金额',
  })
  divideSourceMoney: number;

  @Column({
    name: 'diamonds',
    type: 'int',
    unsigned: true,
    default: 0,
    comment: '钻石余额',
  })
  diamonds: number;

  @Column({
    name: 'withdraw_source_money',
    type: 'decimal',
    precision: 10,
    scale: 2,
    unsigned: true,
    default: 0,
    comment: '提现金额',
  })
  withdrawSourceMoney: number;

  @CreateDateColumn({
    name: 'createtime',
    default: () => 'CURRENT_TIMESTAMP',
    precision: 0,
    comment: '创建时间',
  })
  createTime: Date;

  @UpdateDateColumn({
    name: 'updatetime',
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
    precision: 0,
    comment: '更新时间',
  })
  updateTime: Date;

  // @Column('json',{
  //   name: "user_push",
  //   nullable: true,
  //   comment: '推送信息',
  // })
  // userPush: PushEmbed | null;

  /**
   * 待废弃
   */
  @Column({ name: 'phonearea', type: 'varchar', length: 225, default: '0086' })
  phonearea: string;

  @Column({ name: 'mcode', type: 'bigint', nullable: true, default: 0 })
  mcode: bigint | null;

  @Column({ name: 'mcodetime', type: 'bigint', nullable: true, default: 0 })
  mcodetime: bigint | null;

  @Column({ name: 'friend', type: 'longtext', nullable: true })
  friend: string | null;

  @Column({ name: 'starfriend', type: 'longtext', nullable: true })
  starfriend: string | null;

  @Column({
    name: 'avatarabsolute',
    type: 'varchar',
    length: 500,
    nullable: true,
  })
  avatarabsolute: string | null;

  @Column({
    name: 'backabsolute',
    type: 'varchar',
    length: 500,
    nullable: true,
  })
  backabsolute: string | null;

  @Column({
    name: 'fire',
    type: 'varchar',
    length: 225,
    default: 'fire-wood',
    comment: '火种',
  })
  fire: string;

  @Column({ name: 'fireid', type: 'int', unsigned: true, default: 1 })
  fireid: number;

  @Column({
    name: 'mystate',
    type: 'varchar',
    length: 225,
    nullable: true,
    default: '想动',
  })
  mystate: string | null;

  @Column({
    name: 'mystatetime',
    type: 'varchar',
    length: 225,
    nullable: true,
    comment: '状态保持时间包括起始于持续时间',
  })
  mystatetime: string | null;

  @Column({ name: 'push', type: 'longtext', nullable: true })
  push: string | null;

  @Column({ name: 'pushnum', type: 'longtext', nullable: true })
  pushnum: string | null;

  @Column({ name: 'friendnum', type: 'int', default: 0 })
  friendnum: number;

  @Column({ name: 'starfriendnum', type: 'int', default: 0 })
  starfriendnum: number;

  @Column({ name: 'pushlast', type: 'longtext', nullable: true })
  pushlast: string | null;

  @Column({ name: 'friendverifynum', type: 'int', default: 0 })
  friendverifynum: number;

  @Column({ name: 'ootop', type: 'bigint', nullable: true, default: 0 })
  ootop: bigint | null;

  @Column({ name: 'backhead', type: 'longtext', nullable: true })
  backhead: string | null;

  @Column({ name: 'email', type: 'varchar', length: 225, nullable: true })
  email: string | null;

  @Column({ name: 'passw', type: 'varchar', length: 225, nullable: true })
  passw: string | null;

  @Column({ name: 'userinvite', type: 'longtext', nullable: true })
  userinvite: string | null;

  @Column({ name: 'oo', type: 'int', unsigned: true, default: 0 })
  oo: number;

  @Column({ name: 'onewest', type: 'bigint', unsigned: true, nullable: true })
  onewest: bigint | null;

  @Column({ name: 'opublicstatus', type: 'varchar', length: 225, default: '1' })
  opublicstatus: string;

  @Column({ name: 'searchhistory', type: 'longtext', nullable: true })
  searchhistory: string | null;

  @Column({ name: 'quserid', type: 'varchar', length: 500, nullable: true })
  quserid: string | null;

  @Column({ name: 'quserinfo', type: 'varchar', length: 500, nullable: true })
  quserinfo: string | null;

  @Column({
    name: 'appleuserinfo',
    type: 'varchar',
    length: 500,
    nullable: true,
  })
  appleuserinfo: string | null;

  @Column({ name: 'appleuserid', type: 'varchar', length: 500, nullable: true })
  appleuserid: string | null;

  @Column({ name: 'updateapp', type: 'int', default: 1 })
  updateapp: number;

  @Column({ name: 'updateserver', type: 'int', default: 1 })
  updateserver: number;

  @Column({
    name: 'serverversion',
    type: 'varchar',
    length: 225,
    default: '1.5.7',
  })
  serverversion: string;

  @Column({
    name: 'style',
    type: 'varchar',
    length: 225,
    nullable: true,
    default: 'orange',
  })
  style: string | null;

  @Column({
    name: 'darkmode',
    type: 'varchar',
    length: 255,
    nullable: true,
    default: 'light',
  })
  darkmode: string | null;

  @Column({ name: 'usernew', type: 'varchar', length: 225, nullable: true })
  usernew: string | null;

  @Column({ name: 'funnew', type: 'varchar', length: 255, nullable: true })
  funnew: string | null;

  @Column({ name: 'useraction', type: 'longtext', nullable: true })
  useraction: string | null;

  @Column({
    name: 'searchremcommend',
    type: 'varchar',
    length: 225,
    nullable: true,
  })
  searchremcommend: string | null;

  @Column({ name: 'hertag', type: 'varchar', length: 5000, nullable: true })
  hertag: string | null;

  @Column({ name: 'others', type: 'varchar', length: 225, nullable: true })
  others: string | null;

  @Column({ name: 'avatar1', type: 'longtext', nullable: true })
  avatar1: string | null;

  @Column({
    name: 'authenticationstatus',
    type: 'int',
    unsigned: true,
    default: 0,
    comment: '0：未验证 2：验证中 1：验证成功 3：验证失败',
  })
  authenticationstatus: number;

  @Column({
    name: 'authenticationtype',
    type: 'varchar',
    length: 225,
    nullable: true,
    comment:
      'personauthe:个人实名 professionalsauthe：专业人士 companyauthe：公司',
  })
  authenticationtype: string | null;

  @Column({ name: 'mytags', type: 'varchar', length: 500, nullable: true })
  mytags: string | null;

  @Column({ name: 'importid', type: 'varchar', length: 5000, default: 'no' })
  importid: string;

  @Column({
    name: 'publicstatus',
    type: 'int',
    unsigned: true,
    default: 0,
    comment: '0:私密 1：公开',
  })
  publicstatus: number;

  @Column({ name: 'guide', type: 'longtext', nullable: true })
  guide: string | null;

  @Column({ name: 'usertype', type: 'varchar', length: 225, default: 'real' })
  usertype: string;

  @Column({
    type: 'enum',
    enum: ['male', 'female', 'non_binary', 'prefer_not_say'],
    nullable: true,
    comment: '性别',
  })
  gender: string;

  @Column({ type: 'date', nullable: true, comment: '出生日期' })
  birthDate: Date;

  @Column({ type: 'varchar', length: 100, nullable: true, comment: '国家' })
  country: string;

  @Column({ type: 'varchar', length: 100, nullable: true, comment: '语言' })
  language: string;

  @Column({ type: 'varchar', length: 100, nullable: true, comment: '职业' })
  occupation: string;

  @Column({ type: 'simple-json', nullable: true, comment: '兴趣爱好' })
  interests: string[];

  @Column({ type: 'simple-json', nullable: true, comment: '性格标签' })
  personality: string[];

  @Column({ type: 'simple-json', nullable: true, comment: '聊天目的' })
  chatPurpose: string[];

  @Column({ type: 'simple-json', nullable: true, comment: '沟通风格' })
  communicationStyle: string[];

  @Column({
    type: 'varchar',
    length: 500,
    nullable: true,
    comment: '一句话状态',
  })
  status: string;

  @Column({ type: 'tinyint', default: 1, comment: '状态是否公开 0:否 1:是' })
  isStatusPublic: number;

  @Column({ type: 'tinyint', default: 0, comment: '是否模糊资料卡 0:否 1:是' })
  blurProfileCard: number;

  @Column({ type: 'tinyint', default: 0, comment: '是否VIP 0:否 1:是' })
  isVIP: number;

  @Column({ type: 'datetime', nullable: true, comment: 'VIP过期时间' })
  vipExpireTime: Date;

  @Column({ type: 'simple-json', nullable: true, comment: '隐私设置' })
  privacySettings: PrivacySettings;

  @Column({
    type: 'varchar',
    length: 225,
    nullable: true,
    comment: 'Google用户ID',
  })
  googleId: string;

  @Column({
    type: 'varchar',
    length: 225,
    nullable: true,
    comment: 'Apple用户ID',
  })
  appleId: string;

  @Column({
    type: 'varchar',
    length: 225,
    nullable: true,
    comment: 'Firebase用户ID',
  })
  firebaseUid: string;

  @Column({ type: 'varchar', length: 225, nullable: true, comment: '设备ID' })
  deviceId: string;

  @Column({ type: 'int', default: 0, comment: '今日滑动次数' })
  dailySwipeCount: number;

  @Column({ type: 'int', default: 0, comment: '今日消息次数' })
  dailyMessageCount: number;

  @Column({ type: 'int', default: 0, comment: '今日申请次数' })
  dailyApplyCount: number;

  @Column({ type: 'datetime', nullable: true, comment: '上次滑动重置时间' })
  lastSwipeResetTime: Date;

  @Column({ type: 'datetime', nullable: true, comment: '上次消息重置时间' })
  lastMessageResetTime: Date;

  @Column({ type: 'datetime', nullable: true, comment: '上次申请重置时间' })
  lastApplyResetTime: Date;

  @Column({ type: 'simple-json', nullable: true, comment: '自定义屏蔽词' })
  blockedWords: string[];

  @Column({
    name: 'personalize_edit',
    type: 'int',
    unsigned: true,
    default: 0,
    comment: '个性化编辑状态：0=未完成，1=已完成',
  })
  personalizeEdit: number;
}

export interface PrivacySettings {
  hideAge: boolean;
  hideCountry: boolean;
  hideOnlineStatus: boolean;
  profileVisibility: 'everyone' | 'friends' | 'only_me';
  allowStrangerMessage: boolean;
}
