import { ValidateNested, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';
import { BaseRequestDto } from '@/dto/base.dto';
import { CheckLoginPhoneBaseDto } from './check-login-phone-base.dto';
export class CheckLoginPhoneDto extends BaseRequestDto {
    @ValidateNested()
    @Type(() => CheckLoginPhoneBaseDto)
    declare params: CheckLoginPhoneBaseDto;
}
