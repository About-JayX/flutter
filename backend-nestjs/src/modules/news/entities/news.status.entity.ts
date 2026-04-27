
import { 
    Entity,
    Column, 
    PrimaryGeneratedColumn, 
    CreateDateColumn,
    UpdateDateColumn,
} from 'typeorm';

@Entity('app_news_status')
export class NewsStatus {
    @PrimaryGeneratedColumn(
        'increment', {
        type: 'bigint',
        unsigned: true,
    })
    id: string;
    //   @PrimaryGeneratedColumn({ 
    //     type: 'int', 
    //     name: 'id' 
    //   })
    //   id: number;

    @Column({ 
        name: 'uniqid',
        type: 'char', 
        length: 40, 
        nullable: true, 
    })
    uniqid: string | null;

    /// ⚠️type，typesource：业务类型；后期改为businessType，和common/enum中的businessType保持一致
    @Column({ 
        name: 'type',
        type: 'varchar', 
        length: 5000,  
    })
    type: string;
    @Column({ 
        name: 'typesource', 
        type: 'varchar', 
        length: 225, 
    })
    typesource: string;

    @Column({ 
        name: 'userid',  
        type: 'bigint', 
        unsigned: true, 
    })
    userid: string;

    /// ⚠️objid：发送消息的数据表数据表ID或unique；后期改为businessId，和common/enum中的businessType保持一致
    @Column({ 
        name: 'objid',
        type: 'bigint', 
        nullable: true, 
     })
    objid: string | null;

    /// ⚠️目前将部分业务的已读状态以ID的形式管理在数组中
    /// 只适合小量，后期要改进方案：businessType[和数据表一一对应, businessId【数据表ID或unique，每一条消息都写一条数据
    @Column({ 
        name: 'readsourceidlist',
        type: 'longtext', 
        nullable: true, 
    })
    readsourceidlist: string | null;

    @Column({ 
        name: 'isread',
        type: 'int', 
        unsigned: true, 
        default: 0, 
     })
    isread: number;

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

    /**
     * 待废弃
     */
        @Column({
            name: 'readtime',
            type: 'datetime',
            default: () => 'CURRENT_TIMESTAMP',
        })
        readtime: Date;

        @Column({ 
            name: 'readid', 
            type: 'bigint', 
            unsigned: true, 
            nullable: true
        })
        readid: string | null;

        @Column({ 
            name: 'status', 
            type: 'int', 
            default: 1, 
        })
        status: number;
}