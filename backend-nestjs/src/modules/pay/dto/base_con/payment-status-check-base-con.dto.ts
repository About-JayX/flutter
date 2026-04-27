import { IsNumber, Min, IsEnum } from 'class-validator';
import { Type } from 'class-transformer';
import { PayChannel } from '@/common/enums/pay-channel.enum';
export class PaymentStatusCheckBaseConDto {

  @IsEnum(PayChannel)
  channel: PayChannel;

}