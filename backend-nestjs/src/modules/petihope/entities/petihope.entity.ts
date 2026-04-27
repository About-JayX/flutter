import { 
  Entity, 
  PrimaryGeneratedColumn, 
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  BeforeInsert,
  VersionColumn,
} from 'typeorm';
import { SceneResponseStatus } from '@/common/enums/scene-status.enum';
import { CommonUtil } from '@/common/utils/common.util';
import { LocationEmbed } from '@/common/embeds/location.embed';
@Entity('app_oo')
export class Petihope {
  @PrimaryGeneratedColumn(
    'increment', {
    type: 'bigint',
    unsigned: true,
  })
  id: string;

  @Column({
    name: "oerId",
    type: 'bigint',
    unsigned: true,
  })
  oerId: string;
  // @Column({
  //   name: "oerId",
  //   type: 'int',
  // })
  // oerId: number;

  @Column({ 
    name: 'uniqid',
    type: 'char',
    length: 40
  })
  uniqid: string;

  @Column({
    name: "post",
    type: 'varchar', 
    length: 500,
    comment: '海报，格式[{"id":1,"url":""}]'
  })
  post: string;

  // @Column('json', {
  //   name: "post_array_json",
  //   transformer: {
  //     to: (value: Array<{ id: number; url: string }>) => value,
  //     from: (value: any) => value ? JSON.parse(value) : [],
  //   },
  // })
  // postArrayJson: Array<{ id: number; url: string }>;


  @Column({ 
    name: 'faith',
    type: 'varchar',
    charset: 'utf8mb4',        // 明确指定
    collation: 'utf8mb4_unicode_ci',
    length: 500,
    default: '以一种有趣的方式动起来',
    comment: '标题，解析emoji版本'
  })
  faith: string;

  @Column({
    name: "location",
    type: 'longtext',
    nullable: true,
    comment: '地址',
  })
  location: string;
  // {
  //   "longitude":"113.943165",
  //   "latitude":"22.540887",
  //   "province":"广东省",
  //   "city":"深圳市",
  //   "district":"南山区",
  //   "tail":"科兴路10号汇景豪苑群楼(深大地铁站A3口步行70米)",
  //   "locationTail":"",
  //   "name":"科技园文化广场",
  //   "locationName":"科技园文化广场"
  // }

  @Column(
  'json', 
  { 
    name: "location_map", 
    nullable: true,
    comment: ' 现场的地址地图，结构: {longitude, latitude, province, city, ...}',
    // default: () => `'{"planet":"地球","longitude":"113.943162","latitude":"22.540888"}'`
    // longtext, text, blog, json不允许默认值
  })
  locationMap: LocationEmbed | null;

  @Column({
    name: "address",
    type: 'longtext', 
    charset: 'utf8mb4',        // 明确指定
    collation: 'utf8mb4_unicode_ci',
    nullable: true,
    comment: '用户自定义详细地址精确到小区，公寓，门牌号'
  })
  address: string;

 @Column({ 
    name: 'nickname',
    type: 'varchar',
    charset: 'utf8mb4',        // 明确指定
    collation: 'utf8mb4_unicode_ci',
    length: 25,
    default: '发起人',
    comment: '发起人自定义称呼'
  })
  nickname: string;

  @Column(
  'json', 
  { 
    name: "contact", 
    nullable: true,
    comment: '发起人联系方式',
    // default: {
    //   phone:"0",
    // }
  })
  contact: {
    phone?: string;
  } | null;

  @Column({
    name: "timeline",
    type: 'longtext',
    charset: 'utf8mb4',        // 明确指定
    collation: 'utf8mb4_unicode_ci',
    comment: '时间线',
  })
  timeline: string;

  @Column({ 
    name: "starttime",
    type: 'datetime',
    precision: 0,
    nullable: true,
    comment: '请愿开始时间',
  })
  startTime: Date;

  @Column({ 
    name: "endtime",
    type: 'datetime',
    precision: 0,
    nullable: true,
    comment: '请愿结束时间',
  })
  endtime: Date;

  @Column({
    name: "people_with_me_number",
    type: 'int', 
    unsigned: true,
    default: 1,
    nullable: false,
    comment: '参与的用户数上限',
  })
  joinPeopleMax: number;

  @Column({
    name: "people_less",
    type: 'int', 
    unsigned: true,
    default: 0,
    nullable: false,
    comment: '剩余可参与的用户数',
  })
  peopleLess: number;

  @Column({
    name: "auto_response",
    type: 'tinyint',
    default: SceneResponseStatus.AUTO,
    unsigned: true,
    nullable: false,
    comment: '是否开启自动响应，0: 不开启，1: 开启'
  })
  autoResponse: SceneResponseStatus;

  @Column({
    name: "des",
    type: 'longtext',
    charset: 'utf8mb4',        // 明确指定
    collation: 'utf8mb4_unicode_ci',
    nullable: true,
    comment: '描述',
  })
  des: string;

  @Column({
    name: "publicstatus",
    type: 'int', 
    unsigned: true,
    default: 1,
    nullable: false,
    comment: '0:私密 1：表示公开'
  })
  publicstatus: number;

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

  @VersionColumn({
    name: 'version', 
  })
  version: number;

  /// --------------------------------- 待废弃区域 ---------------------------------
    @Column({
      name: "opeopleid",
      type: 'longtext', 
      nullable: true,
    })
    opeopleid: string;

    @Column({
      name: "oback",
      type: 'varchar', 
      length: 500,
      nullable: true,
    })
    oback: string;

    @Column({
      name: "obackid",
      type: 'int',
      nullable: false,
      default: 17,
    })
    obackid: number;

    @Column({
      name: "obacktype",
      type: 'int',
      unsigned: true,
      nullable: false,
      default: 0,
      comment: '0:代表系统壁纸 1：代表上传壁纸',
    })
    obacktype: number;

    @Column({
      name: "cover",
      type: 'varchar', 
      length: 5000,
      nullable: true,
    })
    cover: string;

    @Column({
      name: "push",
      type: 'int',
      nullable: true,
    })
    push: number;

    @Column({
      name: "fire",
      type: 'varchar', 
      length: 225,
      default: '00001'
    })
    fire: string;  

    @Column({
      name: "activityorder",
      type: 'varchar', 
      length: 225,
      nullable: true,
    })
    activityorder: string;

    @Column({
      name: "country",
      type: 'varchar', 
      length: 225,
      nullable: true,
    })
    country: string;

    @Column({
      name: "province",
      type: 'varchar', 
      length: 225,
      nullable: true,
    })
    province: string;

    @Column({
      name: "city",
      type: 'varchar', 
      length: 225,
      nullable: true,
    })
    city: string;

    @Column({
      name: "district",
      type: 'varchar', 
      length: 225,
      nullable: true,
    })
    district: string;

    @Column({
      name: "cats",
      type: 'varchar', 
      length: 500,
      nullable: true,
      comment: '活动分类',
    })
    cats: string;

    @Column({
      name: "tags",
      type: 'varchar', 
      length: 225,
      nullable: true,
    })
    tags: string;

    @Column({
      name: "tools",
      type: 'varchar', 
      length: 5000,
      nullable: true,
    })
    tools: string;

    @Column({
      name: "tagssys",
      type: 'longtext', 
      nullable: true,
    })
    tagssys: string;

     @Column({
      name: "theme",
      type: 'varchar', 
      length: 5000,
      nullable: true,
    })
    theme: string;

    @Column({
      name: "enablepicwalls",
      type: 'int', 
      unsigned: true,
      default: 1,
      nullable: true,
      comment: '0:私密 1：表示公开',
    })
    enablepicwalls: number;

    @Column({
      name: "newstop",
      type: 'bigint', 
      unsigned: true,
      nullable: true,
      comment: '置顶消息id',
    })
    newstop: string;

    @Column({
      name: "newsnum",
      type: 'int', 
      unsigned: true,
      default: 0,
    })
    newsnum: number; 
           
    @CreateDateColumn({ 
      name: 'time', 
      default: () => 'CURRENT_TIMESTAMP',
      precision: 0,
      comment: '关键时间点' 
    })
    time: Date;

    @Column({
      name: "endtimemorecount",
      type: 'int', 
      default: 5,
    })
    endtimemorecount: number;

    @Column({
      name: "endtimestatus",
      type: 'int', 
      default: 0,
    })
    endtimestatus: number;

   @Column({
      name: "end",
      type: 'int', 
      unsigned: true,
      default: 0,
      comment: '1：行动被删除了0：未被删除',
    })
    end: number;

    @Column({
      name: "close",
      type: 'int', 
      default: 0,
    })
    close: number;

    @Column({
      name: "deletedestroy",
      type: 'int', 
      unsigned: true,
      default: 0,
    })
    deletedestroy: number;

    @Column({
      name: "commentrate",
      type: 'varchar', 
      length: 25,
      default: '5.0',
    })
    commentrate: string;

   @Column({
      name: "hot",
      type: 'int', 
      unsigned: true,
      nullable: true,
      default: 0,
    })
    hot: number;

    @Column({
      name: "friends",
      type: 'varchar', 
      length: 225,
      nullable: true,
    })
    friends: string;

   @Column({
      name: "xiangyinstatus",
      type: 'int', 
      default: 3,
    })
    xiangyinstatus: number;

   @Column({
      name: "refusexiangyinanimaid",
      type: 'int', 
      unsigned: true,
      nullable: true,
    })
    refusexiangyinanimaid: number;

    @Column({
      name: "refusexiangyindes",
      type: 'text', 
      nullable: true,
    })
    refusexiangyindes: string;

    @Column({
      name: "xiangyindes",
      type: 'text', 
      nullable: true,
    })
    xiangyindes: string;

   @Column({
      name: "sceneusernums",
      type: 'int', 
      default: 0,
    })
    sceneusernums: number;

    @Column({
      name: "service",
      type: 'longtext', 
      nullable: true,
      // default: '{"startTime":"2088-08-08 00:00:01","endTime":"2888-08-08 00:00:01","code":"88+"}',
      comment: '服务'
    })
    service: string;

    @Column({
      name: "oerinfos",
      type: 'longtext', 
      nullable: true,
      // default: '{"userid":"16105","nickname":"亮叶雪山报春"}',
      comment: '发起者们'
    })
    oerinfos: string;
  /// --------------------------------- 待废弃区域 ---------------------------------
  
  @BeforeInsert()
  generateUuid() {
    this.uniqid = CommonUtil.generateSecureUnique40BySHA1();
  }
}