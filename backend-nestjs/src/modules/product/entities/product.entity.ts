import { 
  Entity, 
  PrimaryGeneratedColumn, 
  Column, BeforeInsert } from 'typeorm';
import { v4 as uuidv4 } from 'uuid';
import { BaseEntity } from '@/entities/shared/base.entity';
@Entity('app_product')
export class Product extends BaseEntity {
  @PrimaryGeneratedColumn('increment', { comment: '商品ID' })
  id: number;

  // 重要数据，跨数据库，唯一标志
  @Column({ 
    name: 'unique_id',
    type: 'uuid',
  })
  uniqueId: string;

  // @Column({ 
  //   name: 'product_sku', 
  //   type: 'varchar',
  //   length: 64, 
  //   unique: true,
  //   comment: '商品SKU' 
  // })
  // productSku: string;

  @Column({ 
    name: 'product_sku_id', 
    type: 'int', 
    comment: '商品SKU ID' 
  })
  productSkuId: number;

  @Column({ 
    name: 'product_type', 
    type: 'varchar', 
    length: 255, 
    default: 'all',
    comment: '商品类型,all指全品类' 
  })
  productType: string;

  @Column({ 
    name: 'product_type_name', 
    type: 'varchar', 
    length: 255, 
    default: '全品类',
    comment: '商品类型,默认全品类' 
  })
  productTypeName: string;

  @Column({ 
    name: 'product_name', 
    type: 'varchar', 
    length: 255, 
    comment: '商品名称' 
  })
  productName: string;

  @Column({ 
    name: 'product_des', 
    type: 'varchar', 
    length: 500, 
    nullable: true,
    comment: '商品描述' 
  })
  productDes: string;

  @Column({ 
    name: 'product_attrs', 
    type: 'json', 
    nullable: true,
    comment: '商品属性，默认为空' 
  })
  productAttrs: Record<string, any>;

  @Column({ 
    name: 'product_price', 
    type: 'decimal', 
    precision: 10, 
    scale: 2, 
    comment: '商品单价,保留两位数' 
  })
  productPrice: number;

  @Column({ 
    name: 'product_image', 
    type: 'varchar', 
    length: 500, 
    nullable: true,
    comment: '商品图片，可为空' 
  })
  productImage: string;

  @BeforeInsert()
  generateUuid() {
    this.uniqueId = uuidv4();
  }
}