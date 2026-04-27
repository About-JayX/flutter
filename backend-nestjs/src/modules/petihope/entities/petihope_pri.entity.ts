import { 
  Entity, 
  PrimaryGeneratedColumn, 
  Column, 
  Index,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { SceneStatus } from '@/common/enums/scene-status.enum';
import { LocationEmbed } from '@/common/embeds/location.embed';
@Entity('app_oo_pri')
@Index(['joinuserid', 'oid'], { unique: true }) // ⭐ 联合唯一索引
export class PetihopePri {
  @PrimaryGeneratedColumn(
    'increment', {
    type: 'bigint',
    unsigned: true,
  })
  id: string;

  @Column({
    name: "oid",
    type: 'bigint',
    unsigned: true,
  })
  oid: string;

  @Column({
    name: "joinuserid",
    type: 'bigint',
    unsigned: true,
  })
  joinuserid: string;

  @Column({
    name: "is_open_res_location",
    type: 'tinyint',
    default: 1,
    unsigned: true,
    nullable: false,
    comment: '是否响应时添加当前位置: 1=是, 0=否'
  })
  isOpenResLocation: number;

  @Column({
    name: "enter_scene_status",
    type: 'tinyint',
    default: SceneStatus.PENDING_SCENE,
    unsigned: true,// 0 - 255
    nullable: false,
    comment: '进入现场状态: 0=未进入, 1=已进入'
  })
  enterSceneStatus: SceneStatus;

  @Column('decimal', { 
    name: "enter_scene_distance",
    precision: 10, 
    scale: 2,
    nullable: true,
    comment: '进入现场时的距离（单位：米），null 表示未记录'
  })
  enterSceneDistance: number;

  @Column('json', 
  { 
    name: "enter_scene_location", 
    nullable: true,
    // default: {
    //   planet:"地球",
    //   longitude:"113.943162",
    //   latitude:"22.540888",
    // },
    comment: '进入现场的详细地址，结构: {province, city, district, detail, postalCode}'
  })
  enterSceneLocation: LocationEmbed | null;
  // enterSceneLocation: {
  //   origin?: string;//  源
  //   planet?: string;
  //   longitude?: string;
  //   latitude?: string;
  //   continent?: string;
  //   country?: string;
  //   province?: string;
  //   city?: string;
  //   district?: string;
  //   village?: string;
  //   street?: string;
  //   name?: string;//  位置名称: 建筑，地名等
  //   tail?: string;//  详细位置描述
  //   address?: string;//  详细位置精确到小区，公寓，门牌号
  // } | null;

  @Column({
    name: "enter_scene_time", 
    type: 'timestamp',
    precision: 3,// 毫秒级精度
    nullable: true,
    comment: '进入现场的时间（精确到毫秒），null 表示尚未进入' 
  })
  enterSceneTime: Date;

  @Column('json', 
  { 
    name: "post_scene_location", 
    nullable: true,

    comment: '申请进入现场的详细地址'
  })
  postSceneLocation: LocationEmbed | null;

 @Column('decimal', { 
    name: "post_scene_distance",
    precision: 10, 
    scale: 2,
    nullable: true,
    comment: '申请进入现场时的距离（单位：米），null 表示未记录'
  })
  postSceneDistance: number;

  @Column({
    name: "post_scene_time", 
    type: 'timestamp',
    precision: 3,// 毫秒级精度
    nullable: true,
    comment: '申请进入现场的时间（精确到毫秒）' 
  })
  postSceneTime: Date;

 @Column({ 
    name: 'post_scene_nick_name',
    type: 'varchar',
    length: 25,
    nullable: true,
    comment: '成员进入现场自定义称呼',
  })
  postSceneNickName: string;

 @Column({ 
    name: 'post_scene_phone',
    type: 'bigint',
    unsigned: true,
    nullable: true,
    comment: '成员进入现场联系方式',
  })
  postScenePhone: string;

 @Column({ 
    name: 'post_scene_des',
    type: 'longtext',
    nullable: true,
    charset: 'utf8mb4',        // 明确指定
    collation: 'utf8mb4_unicode_ci',
    comment: '成员进入现场描述',
  })
  postSceneDes: string | null;

 @Column({ 
    name: 'post_scene_res_time',
    type: 'timestamp',
    precision: 3,// 毫秒级精度
    nullable: true,
    comment: '成员申请进入现场发起人回应时间',
  })
  postSceneResTime: Date;

 @Column({ 
    name: 'post_scene_res_des',
    type: 'longtext',
    nullable: true,
    charset: 'utf8mb4',        // 明确指定
    collation: 'utf8mb4_unicode_ci',
    comment: '成员申请进入现场发起人回应内容',
  })
  postSceneResDes: string;

 @Column({ 
    name: 'post_scene_res_valid_time',
    type: 'timestamp',
    precision: 3,// 毫秒级精度
    nullable: true,
    comment: '发起人回应有效时间',
  })
  postSceneResValidTime: Date;

  @CreateDateColumn({ 
    name: 'createtime', 
    default: () => 'CURRENT_TIMESTAMP',
    precision: 0,
    comment: '创建时间' 
  })
  createTime: Date;

  @UpdateDateColumn({ 
    name: 'updatetime', 
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
    precision: 0,
    comment: '更新时间' 
  })
  updateTime: Date;

  /// --------------------------------- 待废弃区域 ---------------------------------
  @Column({
    name: "oerid",
    type: 'bigint',
    unsigned: true,
    nullable: true,
  })
  oerid: string;

  @Column({
    name: "usertype",
    type: 'varchar',
    length: 100,
    nullable: true,
  })
  usertype: string;

  @Column({
    name: "status",
    type: 'int',
    unsigned: true,
    default: 0,
  })
  status: number;

  @Column({
    name: "wand",
    type: 'int',
    unsigned: true,
    default: 0,
  })
  wand: number;

  @Column({
    name: "joinin",
    type: 'int',
    unsigned: true,
    default: 0,
  })
  joinin: number;

  @Column({
    name: "updatecon",
    type: 'varchar',
    length: 500,
    nullable: true,
  })
  updatecon: string;

  @Column({
    name: "activitymodule",
    type: 'varchar',
    length: 225,
    nullable: true,
  })
  activitymodule: string;

  @Column({
    name: "firenum",
    type: 'int',
    unsigned: true,
    default: 1,
  })
  firenum: number;

  @Column({
    name: "isdoor",
    type: 'int',
    unsigned: true,
    default: 0,
  })
  isdoor: number;

  @Column({
    name: "compassreadidlist",
    type: 'longtext',
    nullable: true,
  })
  compassreadidlist: string; 

  @Column({
    name: "collapsecompass",
    type: 'int',
    unsigned: true,
    default: 0,
  })
  collapsecompass: number;

  @Column({
    name: "collapsecompassid",
    type: 'bigint',
    unsigned: true,
    nullable: true,
  })
  collapsecompassid: string;

  @Column({
    name: "oqrcode",
    type: 'longtext',
    nullable: true,
  })
  oqrcode: string; 

  @Column({
    name: "sence",
    type: 'int',
    unsigned: true,
    default: 0,
  })
  sence: number;

  @Column({ 
    name: 'morelife', 
    type: 'int', 
    unsigned: true, 
    default: 0 
  })
  morelife: number;

  @Column({ 
    name: 'cardback', 
    type: 'varchar', 
    length: 500, 
    nullable: true 
  })
  cardback: string | null;

  @Column({ 
    name: 'cardavatar', 
    type: 'varchar', 
    length: 500, 
    nullable: true 
  })
  cardavatar: string | null;

  @Column({ 
    name: 'cardname', 
    type: 'varchar', 
    length: 5000, 
    nullable: true 
  })
  cardname: string | null;

  @Column({ 
    name: 'cardphone', 
    type: 'bigint', 
    nullable: true 
  })
  cardphone: string;

  @Column({ 
    name: 'carddes', 
    type: 'longtext', 
    nullable: true 
  })
  carddes: string | null;

  @Column({ 
    name: 'cardupdatetime', 
    type: 'int', 
    default: 1 
  })
  cardupdatetime: number;

  @Column({ 
    name: 'res', 
    type: 'int', 
    default: 1 
  })
  res: number;

  @Column({ 
    name: 'xiangyinstatus', 
    type: 'int', 
    unsigned: true, 
    default: 3,
    comment: 'x1:响应2:拒绝响应 3：失去响应【创建时间大于现在5min 默认'
  })
  xiangyinstatus: number;

  @Column({ 
    name: 'refusexiangyinanimaid', 
    type: 'int', 
    unsigned: true, 
    default: 1, 
    nullable: true 
  })
  refusexiangyinanimaid: number | null;

  @Column({ 
    name: 'refusexiangyindes', 
    type: 'text', 
    nullable: true 
  })
  refusexiangyindes: string | null;

  @Column({ 
    name: 'xiangyindes', 
    type: 'text', 
    nullable: true 
  })
  xiangyindes: string | null;
  /// --------------------------------- 待废弃区域 ---------------------------------

// @Column({
//     name: "be_post_scene_time", 
//     type: 'timestamp',
//     precision: 3,// 毫秒级精度
//     nullable: true,
//     comment: '申请进入现场，被响应的时间（精确到毫秒）' 
//   })
//   BePostSceneTime: Date;
}