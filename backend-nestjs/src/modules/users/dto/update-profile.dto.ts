import {
  IsOptional,
  IsEnum,
  IsDateString,
  IsString,
  MaxLength,
  IsArray,
  IsBoolean,
} from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateProfileDto {
  @ApiPropertyOptional({ description: '性别' })
  @IsOptional()
  @IsEnum(['male', 'female', 'non_binary', 'prefer_not_say'])
  gender?: string;

  @ApiPropertyOptional({ description: '出生日期' })
  @IsOptional()
  @IsDateString()
  birthDate?: string;

  @ApiPropertyOptional({ description: '昵称' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  userNickName?: string;

  @ApiPropertyOptional({ description: '头像URL' })
  @IsOptional()
  @IsString()
  avatar?: string;

  @ApiPropertyOptional({ description: '国家' })
  @IsOptional()
  @IsString()
  country?: string;

  @ApiPropertyOptional({ description: '语言' })
  @IsOptional()
  @IsString()
  language?: string;

  @ApiPropertyOptional({ description: '职业' })
  @IsOptional()
  @IsString()
  occupation?: string;

  @ApiPropertyOptional({ description: '兴趣爱好' })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  interests?: string[];

  @ApiPropertyOptional({ description: '性格标签' })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  personality?: string[];

  @ApiPropertyOptional({ description: '聊天目的' })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  chatPurpose?: string[];

  @ApiPropertyOptional({ description: '沟通风格' })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  communicationStyle?: string[];

  @ApiPropertyOptional({ description: '一句话状态' })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  status?: string;

  @ApiPropertyOptional({ description: '状态是否公开' })
  @IsOptional()
  @IsBoolean()
  isStatusPublic?: boolean;

  @ApiPropertyOptional({ description: '是否模糊资料卡' })
  @IsOptional()
  @IsBoolean()
  blurProfileCard?: boolean;
}
