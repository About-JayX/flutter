import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

export interface AuditResult {
  approved: boolean;
  reason?: string;
  violations?: string[];
}

export interface FilterResult {
  blocked: boolean;
  content: string;
}

@Injectable()
export class ContentService {
  private readonly logger = new Logger(ContentService.name);

  constructor(private readonly configService: ConfigService) {}

  async auditContent(content: string, images?: string[]): Promise<AuditResult> {
    try {
      const textResult = await this.auditText(content);

      let imageResult: AuditResult = { approved: true };
      if (images && images.length > 0) {
        imageResult = await this.auditImages(images);
      }

      const approved = textResult.approved && imageResult.approved;

      return {
        approved,
        reason: approved ? undefined : textResult.reason || imageResult.reason,
        violations: [
          ...(textResult.violations || []),
          ...(imageResult.violations || []),
        ],
      };
    } catch (error) {
      this.logger.error('Content audit failed', error);
      return { approved: true };
    }
  }

  async filterSensitiveWords(
    content: string,
    blockedWords: string[],
  ): Promise<FilterResult> {
    if (!blockedWords || blockedWords.length === 0) {
      return { blocked: false, content };
    }

    let filteredContent = content;
    let isBlocked = false;

    for (const word of blockedWords) {
      if (content.toLowerCase().includes(word.toLowerCase())) {
        isBlocked = true;
        const regex = new RegExp(
          word.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'),
          'gi',
        );
        filteredContent = filteredContent.replace(regex, '***');
      }
    }

    return {
      blocked: isBlocked,
      content: filteredContent,
    };
  }

  private async auditText(content: string): Promise<AuditResult> {
    void content;
    return { approved: true };
  }

  private async auditImages(images: string[]): Promise<AuditResult> {
    void images;
    return { approved: true };
  }
}
