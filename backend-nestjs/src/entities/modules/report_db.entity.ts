// report_db.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('app_report_db')
export class ReportDb {
  @PrimaryGeneratedColumn({ type: 'int', unsigned: true, name: 'id' })
  id: number;

  @Column({ type: 'int', unsigned: true, default: 0, name: 'type' })
  type: number;

  @Column({ type: 'varchar', length: 225, name: 'con' })
  con: string;

  @Column({ type: 'int', unsigned: true, default: 1, name: 'level' })
  level: number;

  @CreateDateColumn({ type: 'datetime', name: 'createtime' })
  createtime: Date;

  @UpdateDateColumn({ type: 'datetime', name: 'updatetime' })
  updatetime: Date;
}