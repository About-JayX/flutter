import { Entity, Column, PrimaryGeneratedColumn, BeforeInsert, } from 'typeorm';
import { BaseEntity } from '@/entities/shared/base.entity';
import { v4 as uuidv4 } from 'uuid';
import { TableBusinessType } from '@/common/enums/business-type.enum';
import { ActivitiesStatus } from '@/common/enums/activities-status.enum';
//  延时任务业务类型
//  废弃
export enum ActivitiesBussiness {
  PETIHOPEENDTIME = 'petihope_end_time',     // 请愿结束时
}

// export enum ActivitiesStatus {
//   PENDING = 'pending',     // 等待开始
//   ONGOING = 'ongoing',     // 进行中
//   COMPLETED = 'completed', // 已完成
//   CANCELLED = 'cancelled', // 已取消
// }

@Entity('app_activities')
export class Activities extends BaseEntity {
  @PrimaryGeneratedColumn('increment', {
    type: 'bigint',
    unsigned: true, // 可选：无符号，使范围变为 0 到 2^64-1
  })
  id: string;

  // 重要数据，跨数据库，唯一标志
  @Column({ 
    name: 'unique_id',
    type: 'uuid',
  })
  uniqueId: string;

  @Column({
    name: "end_time",
    type: 'timestamp', 
    precision: 2,
    nullable: false,
    comment: '任务延迟的执行时间',
  })
  endTime: Date;

  @Column({ 
    name: 'bussiness_id', 
    type: "bigint",
    nullable: false,
    comment: '业务类型来源ID，名称为bussinessType指定的表对应的：id'
  })
  bussinessId: string;

  @Column({ 
    name: 'bussiness_type',
    default: TableBusinessType.Petihope,
    type: 'varchar', 
    length: '255',
    nullable: false,
    comment: '业务类型来源' 
  })
  bussinessType: string;

  @Column({
    name: 'status', 
    type: 'varchar', 
    length: '255',
    default: ActivitiesStatus.PENDING,
  })
  status: string;

  // ====== title ======
  /*
    bug:
      状态：
        已更新
        未进行
      内容：
        25字title转uri：100 -》500
  */
  @Column({ 
    name: 'title', 
    type: 'varchar', 
    length: '768',// 100
    nullable: false,
  })
  title: string;

  @Column({ 
    name: 'desc', 
    type: 'varchar', 
    length: '500',
    nullable: true,
  })
  desc: string;
  

  @BeforeInsert()
  generateUuid() {
    this.uniqueId = uuidv4();
  }
}