import { ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { BaseRequestDto } from '@/dto/base.dto';
import { PaymentStatusCheckBaseConDto } from './base_con/payment-status-check-base-con.dto';
export class PaymentStatusCheckDto extends BaseRequestDto {
    @ValidateNested() // ✅ 确保嵌套对象被验证
    @Type(() => PaymentStatusCheckBaseConDto) // ✅ 反序列化为具体类
    declare params: PaymentStatusCheckBaseConDto;
}
