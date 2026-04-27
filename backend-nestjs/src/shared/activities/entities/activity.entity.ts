import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';

export enum ActivityStatus {
  PENDING = 'pending',     // 等待开始
  ONGOING = 'ongoing',     // 进行中
  COMPLETED = 'completed', // 已完成
  CANCELLED = 'cancelled', // 已取消
}

//  进入废弃倒计时
@Entity('app_activity')
export class Activity {
  @PrimaryGeneratedColumn('increment', {
    type: 'bigint', // 明确指定数据库类型为 BIGINT
    unsigned: true, // 可选：无符号，使范围变为 0 到 2^64-1
  })
  identity: string;

  @Column('uuid')
  id: string;

  @Column()
  title: string;

  @Column('text')
  description: string;

  // 被bussinesstype取代
  @Column('text')
  bussinestype: string;

  // 被bussinessid取代
  @Column({ type: "bigint" })
  bussinesid: number;

  @Column({ 
    name: 'bussinesstype', 
    type: 'text', 
    comment: '业务类型来源，比如petihope代表业务类型来源为：请愿' 
  })
  bussinesstype: string;

  @Column({ 
    name: 'bussinessid', 
    type: "bigint",
    comment: '业务类型来源ID' 
  })
  bussinessid: string;

  // @Column()
  // creatorId: string;

  // @Column({ type: 'timestamp' })
  // startTime: Date;

  @Column({ type: 'timestamp', name: "endTime" })
  endTime: Date;

  @Column({
    type: 'enum',
    enum: ActivityStatus,
    default: ActivityStatus.PENDING,
  })
  status: ActivityStatus;

  @Column({
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
    precision: 0,
    name: "createdAt"
  })
  createdAt: Date;

  @Column({
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
    precision: 0,
    name: "updatedAt"
  })
  updatedAt: Date;

  // /**
  //  * 检查活动是否已结束
  //  */
  // isEnded(): boolean {
  //   return new Date() > this.endTime;
  // }

  // /**
  //  * 检查活动是否正在进行
  //  */
  // isOngoing(): boolean {
  //   const now = new Date();
  //   return now >= this.startTime && now <= this.endTime;
  // }
}