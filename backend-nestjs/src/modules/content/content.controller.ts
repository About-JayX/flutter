import { Controller, Post, Body, Logger } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ContentService } from './content.service';
import { Public } from '@/modules/auth/decorators/public.decorator';

@ApiTags('内容审核')
@Controller('content')
export class ContentController {
  private readonly logger = new Logger(ContentController.name);

  constructor(private readonly contentService: ContentService) {}

  @Public()
  @Post('audit')
  @ApiOperation({ summary: '审核内容' })
  async auditContent(
    @Body('content') content: string,
    @Body('images') images?: string[],
  ) {
    return this.contentService.auditContent(content, images);
  }
}
