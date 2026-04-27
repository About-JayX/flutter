import { IsString, IsOptional, ValidateNested, IsDefined } from 'class-validator';
import { Type } from 'class-transformer';

export class ResponseHeadDto {
  @IsString()
  @IsDefined()
  version: string;
}

export class ResponseBodyDto<T = any> {
  @IsString()
  @IsDefined()
  status: string;

  @IsString()
  @IsOptional()
  statusInfo?: string;

  @IsOptional()
  data?: T;
}

export class ApiResponseDto<T = any> {
  @ValidateNested()
  @Type(() => ResponseHeadDto)
  @IsDefined()
  head: ResponseHeadDto;

  @ValidateNested()
  @Type(() => ResponseBodyDto)
  @IsDefined()
  body: ResponseBodyDto<T>;
}