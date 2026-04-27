// report_user.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('app_report_user')
export class ReportUser {
  @PrimaryGeneratedColumn({ type: 'bigint', unsigned: true, name: 'id' })
  id: number;

  @Column({ type: 'bigint', unsigned: true, nullable: true, name: 'userid' })
  userid: number | null;

  @Column({ type: 'bigint', unsigned: true, nullable: true, name: 'beuserid' })
  beuserid: number | null;

  @Column({ type: 'int', unsigned: true, name: 'reporttypeid' })
  reporttypeid: number;

  @Column({ type: 'varchar', length: 225, name: 'reporttypedetail' })
  reporttypedetail: string;

  @Column({ type: 'bigint', unsigned: true, name: 'reportsourceid' })
  reportsourceid: number;

  @Column({ type: 'varchar', length: 225, nullable: true, name: 'des' })
  des: string | null;

  @Column({ type: 'int', unsigned: true, default: 0, name: 'status' })
  status: number;

  @Column({ type: 'varchar', length: 5000, name: 'dealresultdes' })
  dealresultdes: string;

  @Column({ type: 'varchar', length: 225, default: '举报结果反馈', name: 'dealresulttitle' })
  dealresulttitle: string;

  @CreateDateColumn({ type: 'datetime', name: 'createtime' })
  createtime: Date;

  @UpdateDateColumn({ type: 'datetime', name: 'updatetime' })
  updatetime: Date;
}