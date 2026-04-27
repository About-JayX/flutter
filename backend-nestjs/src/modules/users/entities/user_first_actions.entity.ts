import { 
  Entity, 
  Column,
  PrimaryGeneratedColumn, 
  PrimaryColumn,
  CreateDateColumn,} from 'typeorm';
import { UserActionType } from '@/common/enums/user-action-type.enum';

@Entity('app_user_first_action')
export class UserFirstAction {
  @PrimaryGeneratedColumn('increment', {
    type: 'bigint',
    unsigned: true,
  })
  id: string;

  @Column({
    name: "user_id",
    type: 'bigint',
    unsigned: true,
  })
  userId: string;

  @PrimaryColumn({ 
    name: 'action_type', 
    type: 'varchar', 
    length: 64,
    comment: '第一次的各种类型，字母小写' 
  })
  actionType: UserActionType;

  @CreateDateColumn({ 
      name: 'createtime', 
      default: () => 'CURRENT_TIMESTAMP',
      precision: 0,
      comment: '创建时间' 
  })
  createTime: Date;
  
}