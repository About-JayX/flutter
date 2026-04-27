//  用户昵称库
import { 
    Entity, 
    Column, 
    PrimaryGeneratedColumn, 
    CreateDateColumn,
    UpdateDateColumn } from 'typeorm';

@Entity('app_usernames_db')
export class UserNamesDB {

@PrimaryGeneratedColumn(
    'increment', 
    {
        type: 'bigint',
        unsigned: true,
    }
)
id: string;

@Column({ 
    name: 'uniqid',
    type: 'char', 
    length: 40, 
    nullable: false, 
})
unique: string;

@Column({ 
    name: 'username',
    type: 'varchar', 
    length: 500, 
})
userName: string;

@Column({ 
    name: 'usernickname',
    type: 'varchar', 
    length: 5000, 
})
userNickName: string;

@Column({ 
    name: 'cat',
    type: 'varchar', 
    length: 50, 
    nullable: true, 
})
cat: string;

@Column({ 
    name: 'importid',
    type: 'varchar', 
    length: 5000, 
    nullable: true, 
})
importId: string;

@CreateDateColumn({ 
    name: 'createtime', 
    default: () => 'CURRENT_TIMESTAMP',
    precision: 0,
    comment: '创建时间' 
})
createTime: Date;

@UpdateDateColumn({ 
    name: 'updatetime', 
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
    precision: 0,
    comment: '更新时间' 
})
updateTime: Date;

}