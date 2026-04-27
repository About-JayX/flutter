import { CreateDateColumn, UpdateDateColumn, DeleteDateColumn } from 'typeorm';

export abstract class BaseEntity {
  @CreateDateColumn({
    name: 'create_time',
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
    comment: '创建时间',
    precision: 0, // 不保留小数秒
  })
  createTime: Date;

  @UpdateDateColumn({
    name: 'update_time', 
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
    comment: '更新时间',
    precision: 0,
  })
  updateTime: Date;

  // 可选：软删除字段
  @DeleteDateColumn({
    name: 'delete_time',
    type: 'timestamp',
    nullable: true,
    comment: '删除时间',
    precision: 0,
  })
  deleteTime: Date;
}