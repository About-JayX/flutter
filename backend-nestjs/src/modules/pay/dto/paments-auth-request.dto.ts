import { ValidateNested, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';
import { BaseRequestDto } from '@/dto/base.dto';
import { CreatePaymentAuthDto } from './create-payment-auth.dto';
export class PaymentsAuthRequestDto extends BaseRequestDto {
    @ValidateNested() // ✅ 确保嵌套对象被验证
    @Type(() => CreatePaymentAuthDto) // ✅ 反序列化为具体类
    declare params: CreatePaymentAuthDto;
}
