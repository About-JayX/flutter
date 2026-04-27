import { IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class LikePostDto {
  @ApiProperty({ description: '帖子ID' })
  @IsString()
  postId: string;
}
