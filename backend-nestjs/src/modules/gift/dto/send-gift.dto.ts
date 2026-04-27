import { IsString, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SendGiftDto {
  @ApiProperty({ description: '接收者ID' })
  @IsString()
  @IsNotEmpty()
  receiverId: string;

  @ApiProperty({ description: '礼物ID' })
  @IsString()
  @IsNotEmpty()
  giftId: string;
}
