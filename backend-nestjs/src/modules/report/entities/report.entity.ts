import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('reports')
@Index(['reporterId', 'createdAt'])
@Index(['reportedId', 'status'])
export class Report {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 40, comment: '举报者ID' })
  reporterId: string;

  @Column({ type: 'varchar', length: 40, comment: '被举报者ID' })
  reportedId: string;

  @Column({
    type: 'varchar',
    length: 50,
    comment:
      '类型 harassment/threats/sexual_content/hate_speech/violence/spam/privacy/underage/copyright/other',
  })
  type: string;

  @Column({ type: 'text', nullable: true, comment: '描述' })
  description: string;

  @Column({ type: 'simple-json', nullable: true, comment: '截图列表' })
  screenshots: string[];

  @Column({
    type: 'varchar',
    length: 20,
    default: 'pending',
    comment: '状态 pending/processing/resolved/rejected',
  })
  status: string;

  @Column({
    type: 'varchar',
    length: 20,
    nullable: true,
    comment: '处理结果 warning/temp_ban/permanent_ban/content_removed',
  })
  result: string;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;

  @UpdateDateColumn({ comment: '更新时间' })
  updatedAt: Date;
}
