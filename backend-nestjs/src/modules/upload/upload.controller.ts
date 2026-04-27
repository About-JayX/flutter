import { Injectable } from '@nestjs/common';

export interface MulterFile {
  fieldname: string;
  originalname: string;
  encoding: string;
  mimetype: string;
  size: number;
  buffer: Buffer;
}

@Injectable()
export class UploadService {
  uploadAvatar(userId: string, file: MulterFile): string {
    return `avatar_url_for_user_${userId}`;
  }
}
