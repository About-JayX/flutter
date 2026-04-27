import { IsString, IsNotEmpty, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class AppleLoginDto {
  @ApiProperty({ description: 'Apple Identity Token' })
  @IsString()
  @IsNotEmpty()
  identityToken: string;

  @ApiPropertyOptional({ description: 'Authorization Code' })
  @IsString()
  @IsOptional()
  authorizationCode?: string;

  @ApiPropertyOptional({ description: 'User Info' })
  @IsString()
  @IsOptional()
  user?: string;
}
