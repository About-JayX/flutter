import { IsString, IsNotEmpty, IsEnum } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class ChatLockDto {
  @ApiProperty({ description: '密码' })
  @IsString()
  @IsNotEmpty()
  password: string;

  @ApiProperty({ description: '操作类型', enum: ['set', 'remove'] })
  @IsEnum(['set', 'remove'])
  action: string;
}
