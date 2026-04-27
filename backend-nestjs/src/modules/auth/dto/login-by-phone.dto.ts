import { ValidateNested, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';
import { BaseRequestDto } from '@/dto/base.dto';
import { LoginByPhoneBaseDto } from './login-by-phone-base.dto';
export class LoginByPhoneDto extends BaseRequestDto {
    @ValidateNested()
    @Type(() => LoginByPhoneBaseDto)
    declare params: LoginByPhoneBaseDto;
}
