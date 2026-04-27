import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('view_records')
@Index(['viewedId', 'createdAt'])
@Index(['viewerId', 'viewedId'])
export class ViewRecord {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 40, comment: '浏览者ID' })
  viewerId: string;

  @Column({ type: 'varchar', length: 40, comment: '被浏览者ID' })
  viewedId: string;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;
}
