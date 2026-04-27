import { IsString, IsNotEmpty, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class FirebaseAuthDto {
  @ApiProperty({ description: 'Firebase ID Token' })
  @IsString()
  @IsNotEmpty()
  idToken: string;

  @ApiProperty({ description: '用户资料元数据', required: false })
  @IsOptional()
  profileMetaData?: {
    email?: string;
    displayName?: string;
    photoURL?: string;
  };
}