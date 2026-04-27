import { ValidateNested, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';
import { BaseRequestDto } from '@/dto/base.dto';
// import { CreatePaymentDto } from './create-payment.dto';
// import { PaymentsPayRequestContentDto } from './paments-pay-request-content.dto';
import { CreatePaymentOrderDto } from './create-payment-order.dto';
export class PaymentsPayRequestDto extends BaseRequestDto {
    @ValidateNested() // ✅ 确保嵌套对象被验证
    @Type(() => CreatePaymentOrderDto) // ✅ 反序列化为具体类
    declare params: CreatePaymentOrderDto;

    // // ✅ 使用 declare 表示：我是在重新声明继承来的属性的类型
    // @IsOptional()
    // @ValidateNested() // ✅ 确保嵌套对象被验证
    // @Type(() => PaymentsPayRequestContentDto) // ✅ 反序列化为具体类
    // declare params?: PaymentsPayRequestContentDto | null;


    // params?: PaymentsPayRequestContentDto = undefined;
}
