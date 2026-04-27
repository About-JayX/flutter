import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('gift_records')
@Index(['senderId', 'createdAt'])
@Index(['receiverId', 'createdAt'])
export class GiftRecord {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 40, comment: '赠送者ID' })
  senderId: string;

  @Column({ type: 'varchar', length: 40, comment: '接收者ID' })
  receiverId: string;

  @Column({ type: 'varchar', length: 40, comment: '礼物ID' })
  giftId: string;

  @Column({ type: 'int', comment: '价格(钻石)' })
  price: number;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;
}
