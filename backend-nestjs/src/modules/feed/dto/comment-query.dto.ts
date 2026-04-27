import { IsOptional, IsUUID, IsInt, Min } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class CommentQueryDto {
  @ApiPropertyOptional({ description: '帖子ID' })
  @IsOptional()
  @IsUUID()
  postId?: string;

  @ApiPropertyOptional({ description: '页码', default: 1 })
  @IsOptional()
  @IsInt()
  @Min(1)
  page?: number;

  @ApiPropertyOptional({ description: '每页数量', default: 20 })
  @IsOptional()
  @IsInt()
  @Min(1)
  limit?: number;
}
