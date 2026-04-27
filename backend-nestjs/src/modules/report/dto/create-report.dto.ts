import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsArray,
  ArrayMinSize,
  ArrayMaxSize,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateReportDto {
  @ApiProperty({ description: '被举报者ID' })
  @IsString()
  @IsNotEmpty()
  reportedId: string;

  @ApiProperty({ description: '举报类型列表（1-3项）', type: [String] })
  @IsArray()
  @IsString({ each: true })
  @ArrayMinSize(1)
  @ArrayMaxSize(3)
  types: string[];

  @ApiPropertyOptional({ description: '描述' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({ description: '截图列表（1-6张）', type: [String] })
  @IsArray()
  @IsString({ each: true })
  @ArrayMinSize(1)
  @ArrayMaxSize(6)
  screenshots: string[];
}
