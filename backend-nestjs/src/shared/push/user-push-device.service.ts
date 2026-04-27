import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserPushDevice, DeviceType, PushChannel } from './entities/user-push-device.entity';
import { LoginPushDto } from './dto/login.push.dto';

@Injectable()
export class UserPushDeviceService {
  constructor(
    @InjectRepository(UserPushDevice)
    private readonly pushDeviceRepo: Repository<UserPushDevice>,
  ) {}

  /**
   * 登录成功后保存/更新设备推送信息（核心方法）
   * @param userId 用户ID
   * @param pushDto 推送参数
   */
  async saveOrUpdatePushDevice(userId: string, pushDto: LoginPushDto) {
    const { rid, alias, deviceType, deviceName, deviceCode, pushChannel, tags } = pushDto;

    // 1. 查询用户是否已绑定该rid（防重）
    const existDevice = await this.pushDeviceRepo.findOne({
      where: { userId, rid },
    });

    // 2. 自动生成alias（前端未传时），保证全局唯一
    const finalAlias = alias || `user_${userId}_${deviceType}_${Date.now()}`;

    if (existDevice) {
      // 3. 已存在：更新设备信息，标记为有效
      existDevice.alias = finalAlias;
      existDevice.tags = tags || existDevice.tags; // 未传则保留原有标签
      existDevice.deviceName = deviceName || existDevice.deviceName;
      existDevice.deviceCode = deviceCode || existDevice.deviceCode;
      existDevice.pushChannel = pushChannel || existDevice.pushChannel;
      existDevice.isValid = 1; // 重置为有效
      existDevice.invalidTime = null;
      return this.pushDeviceRepo.save(existDevice);
    } else {
      // 4. 不存在：新增设备绑定
      const newDevice = this.pushDeviceRepo.create({
        userId,
        rid,
        alias: finalAlias,
        tags: tags || [DeviceType[deviceType]], // 标签兜底：设备类型名称
        deviceType,
        deviceName: deviceName || '未知设备',
        deviceCode: deviceCode || '',
        pushChannel,
        isValid: 1,
      });
      return this.pushDeviceRepo.save(newDevice);
    }
  }
}
