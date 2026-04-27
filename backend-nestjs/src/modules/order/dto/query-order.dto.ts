import { ValidateNested, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';
import { BaseRequestDto } from '@/dto/base.dto';
import { QueryOrderConDto } from './query-order-dto/query-order-con.dto';
export class QueryOrderDto extends BaseRequestDto {
    @ValidateNested()
    @Type(() => QueryOrderConDto)
    declare params: QueryOrderConDto;
}
