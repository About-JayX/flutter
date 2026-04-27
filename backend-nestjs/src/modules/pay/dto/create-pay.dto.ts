import { IsInt, IsString, IsNumber, IsEnum, IsOptional } from 'class-validator';
import { PayStatus } from '@/common/enums';

export class CreatePayDto {
  @IsInt()
  orderId: number;

  @IsNumber()
  payAmount: number;

  @IsString()
  payMethod: string;

  @IsEnum(PayStatus)
  @IsOptional()
  payStatus?: PayStatus;

  @IsString()
  @IsOptional()
  transactionId?: string;
}