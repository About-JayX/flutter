import { IsString, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class EndCallDto {
  @ApiProperty({ description: '通话记录ID' })
  @IsString()
  @IsNotEmpty()
  callId: string;
}
