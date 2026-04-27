import { Controller, Get, Post, Body, Query, Logger } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ReportService } from './report.service';
import { CreateReportDto } from './dto/create-report.dto';
import { ProcessReportDto } from './dto/process-report.dto';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';

@ApiTags('举报')
@Controller('report')
export class ReportController {
  private readonly logger = new Logger(ReportController.name);

  constructor(private readonly reportService: ReportService) {}

  @Post('create')
  @ApiOperation({ summary: '提交举报' })
  async createReport(
    @CurrentUser() user: any,
    @Body() createReportDto: CreateReportDto,
  ) {
    return this.reportService.createReport(user.uniqid, createReportDto);
  }

  @Post('process')
  @ApiOperation({ summary: '处理举报（管理员）' })
  async processReport(
    @Body('reportId') reportId: string,
    @Body() processReportDto: ProcessReportDto,
  ) {
    await this.reportService.processReport(reportId, processReportDto);
    return { status: '0', statusInfo: '举报已处理' };
  }

  @Get('list')
  @ApiOperation({ summary: '获取举报列表（管理员）' })
  async getReports(
    @Query('status') status?: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.reportService.getReports(status, page || 1, limit || 20);
  }
}
