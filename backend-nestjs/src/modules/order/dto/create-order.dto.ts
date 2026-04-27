import { IsInt, IsNumber, IsString, IsOptional, IsArray, ValidateNested, Min, IsDate } from 'class-validator';
import { Type } from 'class-transformer';

class OrderProductItemDto {
  @IsInt()
  productId: number;

  @IsInt()
  skuId: number;

  @IsInt()
  @Min(1)
  quantity: number;

  @IsNumber()
  @Min(0)
  price: number;
}

export class CreateOrderDto {
  /// 必选
  @IsString()
  bussinesstype: string;

  @IsString()
  bussinessid: string;

  @IsString()
  userId: string;

  @Type(() => Number)
  @IsNumber()
  @Min(0)
  totalAmount: number;

  @IsString()
  receiverName: string;

  @IsString()
  receiverPhoneEncrypted: string;

  // @IsString()
  // receiverPhone: string;

  /// 可选
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  actualAmount?: number;

  @IsOptional()
  @IsDate()
  validPayTime?: Date;

  @IsOptional()// 否则会和input冲突
  @IsNumber()
  productSkuId?: number;
  // @IsArray()
  // @ValidateNested({ each: true })
  // @Type(() => OrderProductItemDto)
  // products: OrderProductItemDto[];

  @IsOptional()// 否则会和input冲突
  @IsNumber()
  payStatus?: number;

  @IsOptional() 
  @IsString()
  userRemark?: string;
}