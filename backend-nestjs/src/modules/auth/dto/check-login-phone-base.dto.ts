import { IsNotEmpty, IsPhoneNumber, IsString, Length } from 'class-validator';

export class CheckLoginPhoneBaseDto {
  @IsNotEmpty({ message: '验证码不能为空' })
  // @IsString({ message: '验证码必须是字符串' })
  // @Length(4, 6, { message: '验证码长度必须在4-6位之间' })
  code: string;
}