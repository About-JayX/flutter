import { IsString } from 'class-validator';

export class PetihopeMemberPostRequestCon {
  @IsString({ message: 'hopeId 必须传，格式必须是字符串' })
  hopeId: string;
}