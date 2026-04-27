import { IsString, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class ProcessReportDto {
  @ApiProperty({ description: '处理结果' })
  @IsString()
  @IsNotEmpty()
  result: string;

  @ApiProperty({ description: '管理员ID' })
  @IsString()
  @IsNotEmpty()
  adminId: string;
}
