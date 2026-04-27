import { IsString, IsNumber, Min, IsIn, IsOptional, IsUrl } from 'class-validator';
import { Transform, Type } from 'class-transformer';

export class CreatePaymentAuthDto {
  @IsString()
  auth_code: string;
}