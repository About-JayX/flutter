import { IsString, } from 'class-validator';
export class CommonEncryptedPhoneToStarDto {
    @IsString({ message: 'encryptedPhone 必须传，格式必须是字符串' })
    encryptedPhone: string;
}
