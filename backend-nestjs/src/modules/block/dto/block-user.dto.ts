import { IsString, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class BlockUserDto {
  @ApiProperty({ description: '被拉黑用户ID' })
  @IsString()
  @IsNotEmpty()
  blockedId: string;
}
