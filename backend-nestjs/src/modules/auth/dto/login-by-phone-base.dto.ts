import { IsNotEmpty, IsPhoneNumber, IsString, Length, IsOptional, ValidateNested } from 'class-validator';
import { Type as TransformType } from 'class-transformer'; // 注意：需导入class-transformer的Type（避免和class-validator冲突）
import { LoginPushDto } from '@shared/push/dto/login.push.dto'; // 导入你的推送DTO

export class LoginByPhoneBaseDto {
  @IsNotEmpty({ message: '手机号不能为空' })
  @IsPhoneNumber('CN', { message: '请输入有效的中国手机号' })
  phone: string;

  @IsNotEmpty({ message: '验证码不能为空' })
  // @IsString({ message: '验证码必须是字符串' })
  @Length(4, 6, { message: '验证码格式错误' })
  code: string;

  /**
   * 推送相关参数（可选）
   * - @IsOptional()：标记字段可选（不传不会报错）
   * - @ValidateNested()：验证嵌套的DTO结构
   * - @Type()：指定嵌套DTO的类型（class-validator需要这个才能解析嵌套对象）
   */
  @IsOptional()
  @ValidateNested()
  @TransformType(() => LoginPushDto) // 关键：指定嵌套DTO的类型
  pushInfo?: LoginPushDto; // 可选字段，加?标记
}