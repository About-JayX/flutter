import { IsString, IsNotEmpty, IsEnum } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class InitiateCallDto {
  @ApiProperty({ description: '被叫者ID' })
  @IsString()
  @IsNotEmpty()
  calleeId: string;

  @ApiProperty({ description: '通话类型', enum: ['voice', 'video'] })
  @IsEnum(['voice', 'video'])
  type: string;
}
