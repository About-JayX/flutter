import { 
  Entity, 
  PrimaryGeneratedColumn, 
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  BeforeInsert,
  // VersionColumn,
} from 'typeorm';
import { CommonUtil } from '@/common/utils/common.util';
import { LocationEmbed } from '@/common/embeds/location.embed';
@Entity('app_o_response_chats')
export class OResponseChats {
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
    name: "send_user_id",
    type: 'bigint',
    unsigned: true,
  })
  sendUserId: string;

  @Column({
    name: "accept_user_id",
    type: 'bigint',
    unsigned: true,
  })
  acceptUserId: string;

  @Column({
    name: "match_code",
    type: 'char',
    length: 40,
    comment: '等于发送方的ID'
  })
  matchCode: string;

  @Column({ 
    name: 'chat',
    type: 'longtext',
    charset: 'utf8mb4',        // 明确指定
    collation: 'utf8mb4_unicode_ci',
    comment: '标题，解析emoji版本'
  })
  chat: string;
  
  @Column(
  'json', 
  { 
    name: "location", 
    nullable: true,
    comment: ' 现场的地址地图，结构: {longitude, latitude, province, city, ...}',
    // default: () => `'{"planet":"地球","longitude":"113.943162","latitude":"22.540888"}'`
    // longtext, text, blog, json不允许默认值
  })
  location: LocationEmbed | null;

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

  // @VersionColumn({
  //   name: 'version', 
  // })
  // version: number;

  @BeforeInsert()
  generateUuid() {
    this.matchCode = CommonUtil.generateSecureUnique40BySHA1();
  }
}