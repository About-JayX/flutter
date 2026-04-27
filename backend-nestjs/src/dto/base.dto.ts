import { IsString, IsNumber, IsOptional, ValidateNested, IsDefined, IsIn, IsObject} from 'class-validator';
import { Type } from 'class-transformer';

// 定义 head 对象的 DTO
export class HeadDto {
  @IsString({ message: 'version 必须是字符串' })
  // 或者如果允许数字，可以使用 @IsString() 或 @IsNumber()
  version?: string;

  @IsString({ message: 'screenWidth 必须是字符串' })
  screenWidth?: string;

  @IsString({ message: 'screenHeight 必须是字符串' })
  screenHeight?: string;

  @IsString({ message: 'screenDPR 必须是字符串' })
  screenDPR?: string;

  @IsString({ message: 'secret 必须是字符串' })
  @IsOptional() // 允许为 null 或 undefined
  secret?: string | null;

  @IsString({ message: 'timeout 必须是字符串' })
  @IsOptional()
  timeout?: string | null;
}

// 定义 params 的 DTO (可以是 null 或一个对象)
// 这里我们使用一个通用的 DTO，允许任意键值对，但也可以根据业务定义更具体的结构
export class ParamsDto {
  [key: string]: any;
}

// 定义整个请求体的 DTO
export class BaseRequestDto {
  @ValidateNested() // 表示 head 是一个嵌套对象，需要进一步验证
  @Type(() => HeadDto) // class-transformer 用于反序列化嵌套对象
  @IsDefined({ message: 'head 字段是必需的' })
  head: HeadDto;

  @IsOptional()
  @IsObject({ message: 'params 必须是一个对象' })
  params?: Record<string, any> | null; // 使用 Record<string, any> 更清晰
}