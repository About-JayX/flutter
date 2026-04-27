import { IsString, IsNotEmpty, IsNumber, IsOptional, IsArray } from 'class-validator';
import { DeviceType, PushChannel } from '../entities/user-push-device.entity';

/** 登录时推送参数 DTO */
export class LoginPushDto {
  /** 设备推送rid（必传） */
  @IsString()
  @IsNotEmpty({ message: '设备rid不能为空' })
  rid: string;

  /** 设备别名（可选，为空则自动生成） */
  @IsString()
  @IsOptional()
  alias?: string;

  /** 设备类型（必传：1-安卓，2-IOS，3-小程序） */
  @IsNumber()
  @IsNotEmpty({ message: '设备类型不能为空' })
  deviceType: DeviceType;

  /** 设备名称（可选） */
  @IsString()
  @IsOptional()
  deviceName?: string;

  /** 设备唯一标识（如IMEI/小程序openid，可选） */
  @IsString()
  @IsOptional()
  deviceCode?: string;

  /** 推送渠道（可选，默认极光） */
  @IsNumber()
  @IsOptional()
  pushChannel?: PushChannel = PushChannel.JIGUANG;

  /** 设备级标签（可选） */
  @IsArray()
  @IsOptional()
  tags?: string[];

  /** 用户级标签（可选） */
  @IsArray()
  @IsOptional()
  userTags?: string[];
}
