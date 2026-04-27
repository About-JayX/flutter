import { IsInt, IsString, IsNumber, IsOptional, IsObject } from 'class-validator';

export class CreateOrderProductDto {
  @IsInt()
  orderId: number;

  @IsInt()
  productId: number;

  @IsInt()
  productSkuId: number;

  @IsString()
  productName: string;

  @IsObject()
  @IsOptional()
  productAttrs?: Record<string, any>;

  @IsNumber()
  productPrice: number;

  @IsInt()
  quantity: number;

  @IsString()
  @IsOptional()
  productImage?: string;
}