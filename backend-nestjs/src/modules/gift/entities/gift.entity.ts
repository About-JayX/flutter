import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
} from 'typeorm';

@Entity('gifts')
export class Gift {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 100, comment: '名称' })
  name: string;

  @Column({ type: 'varchar', length: 225, comment: '图标' })
  icon: string;

  @Column({ type: 'varchar', length: 225, nullable: true, comment: '动画' })
  animation: string;

  @Column({ type: 'int', comment: '价格(钻石)' })
  price: number;

  @Column({
    type: 'varchar',
    length: 20,
    default: 'active',
    comment: '状态 active/inactive',
  })
  status: string;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;
}
