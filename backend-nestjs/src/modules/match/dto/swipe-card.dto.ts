import { IsString, IsEnum } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SwipeCardDto {
  @ApiProperty({ description: '目标用户ID' })
  @IsString()
  targetId: string;

  @ApiProperty({ description: '操作类型', enum: ['like', 'dislike', 'rewind'] })
  @IsEnum(['like', 'dislike', 'rewind'])
  action: string;
}
