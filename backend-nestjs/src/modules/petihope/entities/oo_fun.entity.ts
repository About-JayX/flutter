import { 
  Entity, 
  PrimaryGeneratedColumn, 
  Column, BeforeInsert } from 'typeorm';
import { v4 as uuidv4 } from 'uuid';
import { BaseEntity } from '@/entities/shared/base.entity';
@Entity('app_oo_fun')
export class OoFun extends BaseEntity {
  @PrimaryGeneratedColumn(
    'increment', { 
      comment: '功能ID' 
  })
  id: number;

  // 重要数据，跨数据库，唯一标志
  @Column({ 
    name: 'unique_id',
    type: 'uuid',
  })
  uniqueId: string;

  @Column({ 
    name: 'show', 
    type: 'tinyint', 
    default: 1,
    comment: '是否显示或运用，1：是，0:隐藏'
  })
  show: Number;

  @Column({ 
    name: 'type', 
    type: 'varchar', 
    length: 255, 
    default: 'all',
    comment: '功能类型'
  })
  type: string;

  @Column({ 
    name: 'name', 
    type: 'varchar', 
    length: 255, 
    comment: '功能名称,字母小写' 
  })
  name: string;

  @Column({ 
    name: 'title', 
    type: 'varchar', 
    length: 255, 
    comment: '功能标题, 本地化名称' 
  })
  title: string;

  @Column({ 
    name: 'route', 
    type: 'varchar', 
    length: 255, 
    nullable: true,
    comment: '路由信息'
  })
  route: string;

  @Column({ 
    name: 'des', 
    type: 'varchar', 
    length: 500, 
    nullable: true,
    comment: '功能描述' 
  })
  des: string;

  @Column({ 
    name: 'image', 
    type: 'varchar', 
    length: 500, 
    nullable: true,
    comment: '功能图片，可为空' 
  })
  image: string;

  @BeforeInsert()
  generateUuid() {
    this.uniqueId = uuidv4();
  }
}