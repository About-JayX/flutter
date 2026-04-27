import { IsString, IsOptional, IsArray, IsEnum } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreatePostDto {
  @ApiProperty({ description: '内容' })
  @IsString()
  content: string;

  @ApiPropertyOptional({ description: '话题标签', example: '[{"emoji":"🥾","text":"Need to get outside"}]' })
  @IsOptional()
  tags?: any[];

  @ApiProperty({ description: '交友目的' })
  @IsString()
  purpose: string;

  @ApiPropertyOptional({
    description: '可见范围',
    enum: ['public', 'friends', 'only_me'],
  })
  @IsOptional()
  @IsEnum(['public', 'friends', 'only_me'])
  visibility?: string;

  @ApiPropertyOptional({ description: '图片列表' })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  images?: string[];

  @ApiPropertyOptional({ description: '是否匿名发布', default: false })
  @IsOptional()
  isAnonymous?: boolean;
}
