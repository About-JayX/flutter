import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserPushConfig } from './entities/user-push-config.entity';
import { LoginPushDto } from './dto/login.push.dto';

@Injectable()
export class UserPushConfigService {
  constructor(
    @InjectRepository(UserPushConfig)
    private readonly pushConfigRepo: Repository<UserPushConfig>,
  ) {}

  /**
   * 初始化/更新用户推送配置（首次登录创建，非首次不覆盖）
   * @param userId 用户ID
   * @param pushDto 推送参数
   */
  async initUserPushConfig(userId: string, pushDto: LoginPushDto) {
    // 1. 查询用户是否已有配置
    const existConfig = await this.pushConfigRepo.findOne({
      where: { userId },
    });

    if (!existConfig) {
      // 2. 首次登录：创建默认配置
      const newConfig = this.pushConfigRepo.create({
        userId,
        userTags: pushDto.userTags || ['普通用户'], // 用户标签兜底
        pushSwitch: 1, // 默认开启全局推送
        disturbStart: '23:00',
        disturbEnd: '07:00',
        msgPush: 1,
        noticePush: 1,
        activityPush: 1,
      });
      return this.pushConfigRepo.save(newConfig);
    }

    // 非首次登录：仅更新用户标签（可选，根据业务需求调整）
    if (pushDto.userTags && pushDto.userTags.length > 0) {
      existConfig.userTags = pushDto.userTags;
      return this.pushConfigRepo.save(existConfig);
    }

    return existConfig;
  }
}
