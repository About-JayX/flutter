import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('messages')
@Index(['senderId', 'receiverId', 'createdAt'])
@Index(['receiverId', 'status', 'createdAt'])
export class Message {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 40, comment: '发送者ID' })
  senderId: string;

  @Column({ type: 'varchar', length: 40, comment: '接收者ID' })
  receiverId: string;

  @Column({
    type: 'varchar',
    length: 20,
    comment: '类型 text/image/audio/video/gift',
  })
  type: string;

  @Column({ type: 'text', comment: '内容' })
  content: string;

  @Column({
    type: 'varchar',
    length: 20,
    default: 'sent',
    comment: '状态 sent/delivered/read',
  })
  status: string;

  @Column({ type: 'tinyint', default: 0, comment: '是否被拦截 0:否 1:是' })
  isBlocked: number;

  @CreateDateColumn({ comment: '创建时间' })
  createdAt: Date;
}
