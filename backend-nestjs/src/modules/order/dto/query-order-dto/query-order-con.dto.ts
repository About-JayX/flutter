import { IsOptional, IsInt, IsEnum, IsDateString, IsString, Min, Max } from 'class-validator';
import { OrderStatus, PayStatus, AfterSalesStatus } from '@/common/enums';
import { Type } from 'class-transformer';

export class QueryOrderConDto {
  @IsOptional()
  @IsString()
  fields?: string;  // 前端传: "orderTime,paymentAmount,status"

  // @IsOptional()
  // @IsInt()
  // @Type(() => Number)
  // userId?: number;

  // @IsOptional()
  // @IsEnum(OrderStatus)
  // @Type(() => Number)
  // orderStatus?: OrderStatus;

  // @IsOptional()
  // @IsEnum(PayStatus)
  // @Type(() => Number)
  // payStatus?: PayStatus;

  // @IsOptional()
  // @IsEnum(AfterSalesStatus)
  // @Type(() => Number)
  // afterSalesStatus?: AfterSalesStatus;

  // @IsOptional()
  // @IsDateString()
  // startDate?: string;

  // @IsOptional()
  // @IsDateString()
  // endDate?: string;

  // @IsOptional()
  // @IsInt()
  // @Min(1)
  // @Type(() => Number)
  // page: number = 1;  // 移除可选标识，设置默认值

  // @IsOptional()
  // @IsInt()
  // @Min(1)
  // @Max(100)
  // @Type(() => Number)
  // limit: number = 10; // 移除可选标识，设置默认值
}