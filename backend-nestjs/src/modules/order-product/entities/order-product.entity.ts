import { 
  Entity, 
  PrimaryGeneratedColumn, 
  Column, 
  CreateDateColumn, 
  UpdateDateColumn, 
  ManyToOne, 
  JoinColumn,
  Index, BeforeInsert } from 'typeorm';
import { v4 as uuidv4 } from 'uuid';
// import { createDecimalTransformer } from '@/common/transformers/decimal.transformer';
import { Order } from '@root/src/modules/order/entities/order.entity';

@Entity('app_order_product')
@Index(['orderId', 'productId'], { unique: true }) // ⭐ 联合唯一索引
export class OrderProduct {
  @PrimaryGeneratedColumn('increment', { comment: '订单商品ID' })
  id: number;

  // 重要数据，跨数据库，唯一标志
  @Column({ 
    name: 'unique_id',
    type: 'uuid',
  })
  uniqueId: string;

  @Column({ 
    name: 'order_id', 
    type: 'int', 
    comment: '订单ID' 
  })
  orderId: number;

  @Column({ 
    name: 'product_id', 
    type: 'int', 
    comment: '商品ID' 
  })
  productId: number;

  @Column({ 
    name: 'product_sku_id', 
    type: 'int', 
    comment: '商品SKU ID' 
  })
  productSkuId: number;

  @Column({ 
    name: 'product_name', 
    type: 'varchar', 
    length: 255, 
    comment: '商品名称' 
  })
  productName: string;

  @Column({ 
    name: 'product_attrs', 
    type: 'json', 
    nullable: true,
    comment: '商品属性' 
  })
  productAttrs: Record<string, any>;

  @Column({ 
    name: 'product_price', 
    type: 'decimal', 
    precision: 10, 
    scale: 2, 
    // transformer: createDecimalTransformer(2),
    comment: '商品单价' 
  })
  productPrice: number;

  @Column({ 
    name: 'quantity', 
    type: 'int', 
    comment: '购买数量' 
  })
  quantity: number;

  @Column({ 
    name: 'total_price', 
    type: 'decimal', 
    precision: 10, 
    scale: 2, 
    comment: '商品总价' 
  })
  totalPrice: number;

  @Column({ 
    name: 'product_image', 
    type: 'varchar', 
    length: 500, 
    nullable: true,
    comment: '商品图片' 
  })
  productImage: string;

  @CreateDateColumn({ 
    name: 'create_time', 
    default: () => 'CURRENT_TIMESTAMP',
    precision: 0,
    comment: '创建时间' 
  })
  createTime: Date;

  @UpdateDateColumn({ 
    name: 'update_time', 
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
    precision: 0,
    comment: '更新时间' 
  })
  updateTime: Date;

  // 定义与 Order 的多对一关系
  @ManyToOne(() => Order, order => order.orderProducts)
  @JoinColumn({ name: 'order_id' })
  order: Order;

  @BeforeInsert()
  generateUuid() {
    this.uniqueId = uuidv4();
  }
}