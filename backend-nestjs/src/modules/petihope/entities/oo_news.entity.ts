import { 
  Entity, 
  Column,
  PrimaryGeneratedColumn, 
  CreateDateColumn,
  UpdateDateColumn,
  BeforeInsert,
} from 'typeorm';
import { CommonUtil } from '@/common/utils/common.util';

@Entity('app_oo_news')
export class OoNews {
  @PrimaryGeneratedColumn(
    'increment', {
    type: 'bigint',
    unsigned: true,
  })
  id: string;

  @Column({ 
    name: 'oid',
    type: 'bigint', 
    unsigned: true, 
  })
  oid: string;

  @Column({ 
    name: 'con',
    type: 'longtext', 
  })
  con: string;

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

  /// ================================= 待废弃
  @Column({ 
    name: 'uniqid',
    type: 'char',
    length: 40,
    nullable: true,
  })
  uniqid: string | null;

  @Column({ 
    name: 'type',
    type: 'varchar', 
    length: 500, 
    default: 'oernews', 
  })
  type: string;

  @Column({ 
    name: 'top',
    type: 'int', 
    unsigned: true, 
    default: 0, 
  })
  top: number;

  @BeforeInsert()
  generateUuid() {
    this.uniqid = CommonUtil.generateSecureUnique40BySHA1();
  }
  /// ================================= 待废弃
}