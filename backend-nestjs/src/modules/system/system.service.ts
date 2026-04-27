import { Injectable, Logger, } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository} from 'typeorm';
import * as semver from 'semver';
import { CreateSystemDto } from './dto/create-system.dto';
import { UpdateSystemDto } from './dto/update-system.dto';
import { AppVersion } from '@/modules/system/entities/app.version.entity';

@Injectable()
export class SystemService {
  private readonly logger = new Logger(SystemService.name);

  constructor(
    @InjectRepository(AppVersion)
    private appVersionRepository: Repository<AppVersion>,
  ) {}


  create(createSystemDto: CreateSystemDto) {
    return 'This action adds a new system';
  }

  findAll() {
    return `This action returns all system`;
  }

  /// 拿到最新一条APP更新记录
  async findAppUpdateVersionInfo(
    version: string, 
    os: string, 
  ) {
    // 1. 校验输入
      if (!version || !os) {
        throw new Error('Version and OS are required');
      }

    // 2. 查询该平台所有已发布的版本，按创建时间倒序（或按版本号排序）
      const publishedVersions = await this.appVersionRepository.find({
        where: {
          platform: os,
          status: 'published',
        },
        order: { createTime: 'DESC' }, // 或者按 buildNumber / version 排序
      });

    // 3. 找出比当前 version 更新的版本（使用 semver 比较）
      const newerVersions = publishedVersions.filter(v =>
        semver.valid(v.version) && semver.gt(v.version, version),
      );

    // 4. 如果没有更新，返回 null 或特定结构
      if (newerVersions.length === 0) {
        return null;
      }

    // 5. 返回最新的那个（因为按时间倒序，第一个就是最新发布的）
    // 但为了更严谨，可以按版本号排序取最大
      const latestNewVersion = newerVersions.reduce((prev, current) =>
        semver.gt(current.version, prev.version) ? current : prev,
      );
      return latestNewVersion;
  }

  findOne(id: number) {
    return `This action returns a #${id} system`;
  }

  update(id: number, updateSystemDto: UpdateSystemDto) {
    return `This action updates a #${id} system`;
  }

  remove(id: number) {
    return `This action removes a #${id} system`;
  }
}
