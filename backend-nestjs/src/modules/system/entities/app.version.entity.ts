// AppVersion.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Unique } from 'typeorm';
// import { BaseEntity } from '@/entities/shared/base.entity';
import { AppUpdateMode } from '@/common/enums/app-update-mode.enum';


@Entity('app_version')
@Unique(['platform', 'version'])//“不允许存在两条 platform 和 version 都相同的记录”
export class AppVersion{
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ 
    name: 'platform',
    length: 20 
  })
  platform: string; // 'ios' | 'android

  /// app更新类型
  @Column({ 
    name: 'update_mode',
    type: 'tinyint', 
    default: AppUpdateMode.NONE 
  })
  updateMode: AppUpdateMode;

  /// 是否强制更新
  // @Column({ 
  //   name: 'is_mandatory',
  //   default: false 
  // })
  // isMandatory: boolean;

  @Column({ 
    name: 'version',
    length: 50 
  })
  version: string;

  @Column({ 
    name: 'build_number',
    type: 'int', 
    nullable: true 
  })
  buildNumber?: number;

  @Column({ 
    name: 'title',
    length: 50, 
    nullable: true 
  })
  title?: string;

  @Column({ 
    name: 'message',
    type: 'text', 
    nullable: true 
  })
  message?: string;
  // @Column({ 
  //   type: 'text', 
  //   nullable: true 
  // })
  // releaseNotes?: string; // 或者用 JSON 类型

  @Column({ 
    name: 'link',
    length: 255, 
    nullable: true 
  })
  link?: string;

  ///enum('draft', 'published', 'archived')	状态（避免返回未发布版本）
  @Column({ 
    name: 'status',
    type: 'enum', 
    enum: ['draft', 'published', 'archived'], 
    default: 'published' 
  })
  status: 'draft' | 'published' | 'archived';

  @CreateDateColumn({
    name: 'create_time',
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
    comment: '创建时间',
    precision: 0, // 不保留小数秒
  })
  createTime: Date;
}