import { ValidateNested, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';
import { BaseRequestDto } from '@/dto/base.dto';
import { PetihopeMemberPostRequestCon } from './member-post-request-con.dto';
export class PetihopeMemberPostRequestDto extends BaseRequestDto {
    @ValidateNested()
    @Type(() => PetihopeMemberPostRequestCon)
    declare params: PetihopeMemberPostRequestCon;
}
