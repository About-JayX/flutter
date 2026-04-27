import { IsOptional, IsString, IsInt, Min } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';

export class FeedQueryDto {
  @ApiPropertyOptional({ description: '交友目的筛选' })
  @IsOptional()
  @IsString()
  purpose?: string;

  @ApiPropertyOptional({ description: '页码', default: 1 })
  @IsOptional()
  @Transform(({ value }) => {
    if (value === undefined || value === null || value === '') return 1;
    const num = parseInt(value, 10);
    return isNaN(num) || num < 1 ? 1 : num;
  })
  @IsInt()
  @Min(1)
  page?: number;

  @ApiPropertyOptional({ description: '每页数量', default: 12 })
  @IsOptional()
  @Transform(({ value }) => {
    if (value === undefined || value === null || value === '') return 12;
    const num = parseInt(value, 10);
    return isNaN(num) || num < 1 ? 12 : num;
  })
  @IsInt()
  @Min(1)
  limit?: number;
}
