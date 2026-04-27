import { ValidateNested, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';
import { BaseRequestDto } from '@/dto/base.dto';
import { CreatePaymentWithdrawDto } from './create-payment-withdraw.dto';
export class PaymentsWithdrawRequestDto extends BaseRequestDto {
    @ValidateNested() // ✅ 确保嵌套对象被验证
    @Type(() => CreatePaymentWithdrawDto) // ✅ 反序列化为具体类
    declare params: CreatePaymentWithdrawDto;
}
