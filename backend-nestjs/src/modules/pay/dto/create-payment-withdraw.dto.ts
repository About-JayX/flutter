import { IsNumber, Min, IsEnum } from 'class-validator';
import { Type } from 'class-transformer';
import { WithdrawChannel } from '@/common/enums/withdraw-channel.enum';
export class CreatePaymentWithdrawDto {
  @IsEnum(WithdrawChannel)
  channel: WithdrawChannel;

  @IsNumber()
  @Min(0.1)
  @Type(() => Number) // ❌：前端上传的数字无法验证通过，目前是用@Type(() => Number)将传过来的数据自动转数字
  amount: number;
}
