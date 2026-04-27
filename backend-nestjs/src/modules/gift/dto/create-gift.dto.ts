import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsInt,
  Min,
  MaxLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateGiftDto {
  @ApiProperty({ description: '名称' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  name: string;

  @ApiProperty({ description: '图标' })
  @IsString()
  @IsNotEmpty()
  icon: string;

  @ApiPropertyOptional({ description: '动画' })
  @IsString()
  @IsOptional()
  animation?: string;

  @ApiProperty({ description: '价格(钻石)' })
  @IsInt()
  @Min(1)
  price: number;

  @ApiPropertyOptional({ description: '状态' })
  @IsString()
  @IsOptional()
  status?: string;
}
