import { IsString, Length, IsNotEmpty } from 'class-validator';

export class ArgsAuthDto {
    @IsString({ message: 'uniqid 必须是字符串' })
    @IsNotEmpty({ message: 'uniqid 不能为空' })
    @Length(40, 40, { message: 'uniqid 必须是恰好 40 个字符' })
    uniqid: string;
}
