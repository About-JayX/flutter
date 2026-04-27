import { IsString, IsOptional, IsInt, Min, Max } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class MatchFiltersDto {
  @ApiPropertyOptional({ description: '性别筛选' })
  @IsOptional()
  @IsString()
  gender?: string;

  @ApiPropertyOptional({ description: '最小年龄' })
  @IsOptional()
  @IsInt()
  @Min(18)
  minAge?: number;

  @ApiPropertyOptional({ description: '最大年龄' })
  @IsOptional()
  @IsInt()
  @Max(100)
  maxAge?: number;
}
