import { Column } from 'typeorm';

export class PushEmbed {

  @Column({ 
    type: 'varchar', 
    array: true,  // 核心：开启数组类型
    nullable: true, 
    comment: 'rids列表' 
  })
  rids?: string[];  // 类型改为 string[]

  @Column({ type: 'varchar', length: 500, nullable: true, comment: 'alias别名' })
  alias?: string;
}