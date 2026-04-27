import { IsNotEmpty, IsPhoneNumber,IsOptional, IsInt, IsString, } from 'class-validator';

export class SendSmsBaseDto {
  @IsNotEmpty({ message: '手机号不能为空' })
  @IsPhoneNumber('CN', { message: '请输入有效的中国手机号' })
  phone: string;

  // @IsNotEmpty({ message: '手机号不能为空' })
  // @IsString({ message: '请输入有效的中国手机号' })
  // phone: string;

  // @IsOptional()
  // @IsInt()
  // businessType?: number;  // 1: 已登录获取验证码，0或不存[在如果手机号码正确]: 手机号码获取验证码
}