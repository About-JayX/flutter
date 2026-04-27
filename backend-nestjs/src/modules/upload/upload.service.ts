import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as fs from 'fs';
import * as path from 'path';
import { MulterFile } from './types/multer-file.type';

@Injectable()
export class UploadService {
  private readonly logger = new Logger(UploadService.name);
  private readonly baseUrl: string;
  private readonly imageStoragePath: string;

  constructor(private readonly configService: ConfigService) {
    this.baseUrl = this.configService.get<string>('BASE_URL') || 'http://192.168.1.241:3000';
    this.imageStoragePath = this.configService.get<string>('IMAGE_STORAGE_PATH') || '/sources/images';
  }

  async uploadAvatar(userId: string, file: MulterFile): Promise<string> {
    if (!file) {
      throw new BadRequestException('No file provided');
    }

    const allowedMimeTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    if (!allowedMimeTypes.includes(file.mimetype)) {
      throw new BadRequestException('Invalid file type. Only JPEG, PNG, GIF, and WebP are allowed');
    }

    const maxSize = 5 * 1024 * 1024;
    if (file.size > maxSize) {
      throw new BadRequestException('File size exceeds 5MB limit');
    }

    const timestamp = Date.now();
    const ext = path.extname(file.originalname) || '.jpg';
    const filename = `user_${userId}_${timestamp}${ext}`;
    
    const avatarDir = path.join(process.cwd(), this.imageStoragePath, 'avatars');
    if (!fs.existsSync(avatarDir)) {
      fs.mkdirSync(avatarDir, { recursive: true });
    }

    const filePath = path.join(avatarDir, filename);
    fs.writeFileSync(filePath, file.buffer);

    const avatarUrl = `${this.baseUrl}${this.imageStoragePath}/avatars/${filename}`;
    this.logger.log(`Avatar uploaded: ${avatarUrl}`);

    return avatarUrl;
  }

  async deleteAvatar(avatarUrl: string): Promise<void> {
    try {
      const urlPath = new URL(avatarUrl).pathname;
      const filePath = path.join(process.cwd(), urlPath);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        this.logger.log(`Avatar deleted: ${filePath}`);
      }
    } catch (error) {
      this.logger.error(`Failed to delete avatar: ${error.message}`);
    }
  }
}
