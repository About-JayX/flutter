// follows.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('app_follows')
export class Follows {
  @PrimaryGeneratedColumn({ type: 'bigint', unsigned: true, name: 'id' })
  id: number;

  @Column({ type: 'char', length: 40, nullable: true, name: 'uniqid' })
  uniqid: string | null;

  @Column({ type: 'bigint', unsigned: true, name: 'followid' })
  followid: number;

  @Column({ type: 'bigint', unsigned: true, name: 'followerid' })
  followerid: number;

  @CreateDateColumn({ type: 'datetime', name: 'createtime' })
  createtime: Date;

  @UpdateDateColumn({ type: 'datetime', name: 'updatetime' })
  updatetime: Date;
}