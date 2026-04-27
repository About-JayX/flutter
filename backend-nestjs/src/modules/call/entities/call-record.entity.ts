import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('call_records')
@Index(['callerId', 'createdAt'])
@Index(['calleeId', 'createdAt'])
export class CallRecord {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 40, comment: '呼叫者ID' })
  callerId: string;

  @Column({ type: 'varchar', length: 40, comment: '被叫者ID' })
  calleeId: string;

  @Column({ type: 'varchar', length: 20, comment: '类型 voice/video' })
  type: string;

  @Column({ type: 'varchar', length: 100, comment: '房间ID' })
  roomId: string;

  @Column({
    type: 'varchar',
    length: 20,
    comment: '状态 initiated/connected/ended/missed',
  })
  status: string;

  @Column({ type: 'int', default: 0, comment: '通话时长(秒)' })
  duration: number;

  @Column({ type: 'int', default: 0, comment: '消耗时长(分钟)' })
  costMinutes: number;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;

  @UpdateDateColumn({ comment: '更新时间' })
  updatedAt: Date;
}
