import { IsString, IsNotEmpty, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class GoogleLoginDto {
  @ApiProperty({ description: 'Google ID Token' })
  @IsString()
  @IsNotEmpty()
  idToken: string;
}
