import { IsDate, IsString, IsNumber, Min, IsIn, IsOptional, IsUrl } from 'class-validator';
import { Transform, Type } from 'class-transformer';
export class CreateActivityDto {
    // 必传
    @Transform(({ value }) => {
    // 已经是 Date 实例就直接用
    if (value instanceof Date) return value;
    // 字符串就转一下，转失败会触发 @IsDate 报错
    return new Date(value);
    })
    @IsDate({ message: 'endTime 必须传，格式必须是日期字符串 或 Date对象' })
    endTime: Date;

    @Transform(({ value }) => String(value)) // 数字→字符串
    @IsString({ message: 'bussinessId 必须传，格式必须是字符串 或 数字' })
    bussinessId: string;

    @IsString({ message: 'bussinessType 必须传，格式必须是字符串' })
    bussinessType: string;

    @IsString({ message: 'title 必须传，格式必须是字符串' })
    title: string;

    // 可选
    // 打 TypeScript 的 ? 标记（让 TS 知道属性可有可无）；
    // 用 class-validator 的 @IsOptional()（让校验器跳过空值）；
    @IsOptional()
    @IsString({ message: 'desc 可选，格式必须是字符串' })
    desc?: string;
}
