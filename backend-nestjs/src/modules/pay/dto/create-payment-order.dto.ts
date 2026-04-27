import {
  IsString,
  IsNumber,
  Min,
  IsIn,
  IsOptional,
  IsUrl,
} from 'class-validator';
import { Transform, Type } from 'class-transformer';
import { PayChannel } from '@/common/enums/pay-channel.enum';

export class CreatePaymentOrderDto {
  @IsString()
  orderId: string;

  @IsString()
  channel: PayChannel;

  @IsNumber()
  @Min(0.01)
  @Type(() => Number) // ❌：前端上传的数字无法验证通过，目前是用@Type(() => Number)将传过来的数据自动转数字
  amount: number;

  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  productSkuId: number;

  @IsOptional()
  @IsString()
  subject?: string;
}
