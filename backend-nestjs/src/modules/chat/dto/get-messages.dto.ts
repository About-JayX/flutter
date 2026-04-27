import { IsOptional, IsString, IsInt, Min } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class GetMessagesDto {
  @ApiPropertyOptional({ description: '目标用户ID' })
  @IsOptional()
  @IsString()
  targetId?: string;

  @ApiPropertyOptional({ description: '页码', default: 1 })
  @IsOptional()
  @IsInt()
  @Min(1)
  page?: number;

  @ApiPropertyOptional({ description: '每页数量', default: 50 })
  @IsOptional()
  @IsInt()
  @Min(1)
  limit?: number;

  @ApiPropertyOptional({ description: '从此消息ID之前获取更早的消息' })
  @IsOptional()
  @IsString()
  beforeId?: string;
}
