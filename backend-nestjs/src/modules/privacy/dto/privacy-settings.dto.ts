import { IsOptional, IsBoolean, IsEnum } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class PrivacySettingsDto {
  @ApiPropertyOptional({ description: '隐藏年龄' })
  @IsOptional()
  @IsBoolean()
  hideAge?: boolean;

  @ApiPropertyOptional({ description: '隐藏国家' })
  @IsOptional()
  @IsBoolean()
  hideCountry?: boolean;

  @ApiPropertyOptional({ description: '隐藏在线状态' })
  @IsOptional()
  @IsBoolean()
  hideOnlineStatus?: boolean;

  @ApiPropertyOptional({ description: '资料可见范围' })
  @IsOptional()
  @IsEnum(['everyone', 'friends', 'only_me'])
  profileVisibility?: string;

  @ApiPropertyOptional({ description: '允许陌生人消息' })
  @IsOptional()
  @IsBoolean()
  allowStrangerMessage?: boolean;

  @ApiPropertyOptional({ description: '隐身浏览' })
  @IsOptional()
  @IsBoolean()
  incognito?: boolean;

  @ApiPropertyOptional({ description: '允许记录浏览历史' })
  @IsOptional()
  @IsBoolean()
  allowViewHistory?: boolean;

  @ApiPropertyOptional({ description: '显示已读回执' })
  @IsOptional()
  @IsBoolean()
  showReadReceipt?: boolean;
}
