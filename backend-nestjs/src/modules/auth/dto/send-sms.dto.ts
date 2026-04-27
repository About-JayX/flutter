import { ValidateNested, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';
import { BaseRequestDto } from '@/dto/base.dto';
import { SendSmsBaseDto } from './send-sms-base';
export class SendSmsDto extends BaseRequestDto {
    @ValidateNested()
    @Type(() => SendSmsBaseDto)
    declare params: SendSmsBaseDto;
}
