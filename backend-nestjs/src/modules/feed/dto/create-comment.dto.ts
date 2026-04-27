import { IsString, IsOptional, IsUUID } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateCommentDto {
  @ApiProperty({ description: '帖子ID' })
  @IsUUID()
  postId: string;

  @ApiProperty({ description: '评论内容' })
  @IsString()
  content: string;

  @ApiPropertyOptional({ description: '父评论ID（回复评论时填写）' })
  @IsOptional()
  @IsUUID()
  parentId?: string;
}
