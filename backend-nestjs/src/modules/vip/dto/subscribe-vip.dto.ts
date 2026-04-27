import { IsString, IsNotEmpty, IsEnum } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SubscribeVipDto {
  @ApiProperty({ description: '收据', required: false })
  @IsString()
  @IsNotEmpty()
  receipt: string;

  @ApiProperty({ description: '平台', enum: ['ios', 'android'] })
  @IsEnum(['ios', 'android'])
  platform: 'ios' | 'android';
}
