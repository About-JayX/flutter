import { Column } from 'typeorm';

export enum Planet {
  EARTH = 'Earth',
  MOON  = 'Moon',
  MARS  = 'Mars',
}

/**
 * 进入场景位置（通用嵌套结构）
 * 可被任何实体 embed
 */
export class LocationEmbed {
  @Column({ type: 'varchar', length: 64, nullable: true, comment: '源' })
  origin?: string;

  @Column({ type: 'enum', enum: Planet, nullable: true, comment: '星球' })
  planet?: Planet;

  @Column({ type: 'varchar', length: 20, nullable: true, comment: '经度' })
  longitude?: string;

  @Column({ type: 'varchar', length: 20, nullable: true, comment: '纬度' })
  latitude?: string;

  @Column({ type: 'varchar', length: 64, nullable: true })
  continent?: string;

  @Column({ type: 'varchar', length: 64, nullable: true })
  country?: string;

  @Column({ type: 'varchar', length: 64, nullable: true })
  province?: string;

  @Column({ type: 'varchar', length: 64, nullable: true })
  city?: string;

  @Column({ type: 'varchar', length: 64, nullable: true })
  district?: string;

  @Column({ type: 'varchar', length: 64, nullable: true })
  village?: string;

  @Column({ type: 'varchar', length: 128, nullable: true })
  street?: string;

  @Column({ type: 'varchar', length: 128, nullable: true, comment: '位置名称' })
  name?: string;

  @Column({ type: 'varchar', length: 255, nullable: true, comment: '详细位置描述' })
  tail?: string;

  @Column({ type: 'varchar', length: 255, nullable: true, comment: '详细位置精确到小区，公寓，门牌号' })
  address?: string;
}