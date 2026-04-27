import { IsString, IsNotEmpty, IsOptional, IsEnum } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class SendMessageDto {
  @ApiProperty({ description: '接收者ID' })
  @IsString()
  @IsNotEmpty()
  receiverId: string;

  @ApiProperty({
    description: '消息类型',
    enum: ['text', 'image', 'audio', 'video', 'gift'],
  })
  @IsEnum(['text', 'image', 'audio', 'video', 'gift'])
  type: string;

  @ApiProperty({ description: '消息内容' })
  @IsString()
  @IsNotEmpty()
  content: string;
}
