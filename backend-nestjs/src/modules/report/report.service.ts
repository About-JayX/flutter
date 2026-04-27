import {
  Injectable,
  Logger,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Inject } from '@nestjs/common';
import type { Cache } from 'cache-manager';
import { Report } from './entities/report.entity';
import { User } from '../users/entities/user.entity';
import { CreateReportDto } from './dto/create-report.dto';
import { ProcessReportDto } from './dto/process-report.dto';

@Injectable()
export class ReportService {
  private readonly logger = new Logger(ReportService.name);

  constructor(
    @InjectRepository(Report)
    private readonly reportRepository: Repository<Report>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @Inject(CACHE_MANAGER)
    private readonly cacheManager: Cache,
  ) {}

  async createReport(
    reporterId: string,
    createReportDto: CreateReportDto,
  ): Promise<Report> {
    const { reportedId, types, description, screenshots } = createReportDto;

    if (!types || types.length === 0) {
      throw new BadRequestException('请选择至少 1 项举报类型');
    }

    if (types.length > 3) {
      throw new BadRequestException('最多选择 3 项举报类型');
    }

    for (const type of types) {
      if (!this.isValidReportType(type)) {
        throw new BadRequestException(`无效的举报类型: ${type}`);
      }
    }

    if (!screenshots || screenshots.length === 0) {
      throw new BadRequestException('请上传至少 1 张截图');
    }

    if (screenshots.length > 6) {
      throw new BadRequestException('最多上传 6 张截图');
    }

    const existingReport = await this.reportRepository.findOne({
      where: {
        reporterId,
        reportedId,
        status: 'pending',
      },
    });

    if (existingReport) {
      throw new BadRequestException('您已举报过该用户，请等待处理');
    }

    const report = this.reportRepository.create({
      reporterId,
      reportedId,
      type: types.join(','),
      description,
      screenshots,
      status: 'pending',
    });

    const savedReport = await this.reportRepository.save(report);

    await this.notifyAdmin(savedReport);

    return savedReport;
  }

  async processReport(
    reportId: string,
    processReportDto: ProcessReportDto,
  ): Promise<void> {
    const { result, adminId } = processReportDto;
    void adminId;

    const report = await this.reportRepository.findOne({
      where: { id: reportId },
    });

    if (!report) {
      throw new NotFoundException('举报记录不存在');
    }

    if (report.status !== 'pending') {
      throw new BadRequestException('该举报已处理');
    }

    report.status = 'resolved';
    report.result = result;
    await this.reportRepository.save(report);

    await this.executePunishment(report.reportedId, result);
    await this.notifyReporter(report.reporterId, reportId, result);
  }

  private async executePunishment(
    userId: string,
    result: string,
  ): Promise<void> {
    switch (result) {
      case 'warning':
        await this.warnUser(userId);
        break;
      case 'temp_ban':
        await this.tempBanUser(userId, 7);
        break;
      case 'permanent_ban':
        await this.permanentBanUser(userId);
        break;
      case 'content_removed':
        await this.removeContent(userId);
        break;
      default:
        this.logger.warn(`Unknown punishment result: ${result}`);
    }
  }

  private async warnUser(userId: string): Promise<void> {
    const warnKey = `warn:${userId}`;
    const warnCount = (await this.cacheManager.get<number>(warnKey)) || 0;
    await this.cacheManager.set(warnKey, warnCount + 1, 86400 * 30);
    this.logger.log(`User ${userId} warned. Total warnings: ${warnCount + 1}`);
  }

  private async tempBanUser(userId: string, days: number): Promise<void> {
    const banUntil = new Date();
    banUntil.setDate(banUntil.getDate() + days);

    await this.userRepository.update(
      { uniqid: userId },
      {
        usertype: 'banned',
      },
    );

    await this.cacheManager.set(
      `ban:${userId}`,
      banUntil.toISOString(),
      days * 86400,
    );
    this.logger.log(`User ${userId} temp banned for ${days} days`);
  }

  private async permanentBanUser(userId: string): Promise<void> {
    await this.userRepository.update(
      { uniqid: userId },
      { usertype: 'permanently_banned' },
    );
    this.logger.log(`User ${userId} permanently banned`);
  }

  private async removeContent(userId: string): Promise<void> {
    this.logger.log(`Content removed for user ${userId}`);
  }

  async getReports(
    status?: string,
    page = 1,
    limit = 20,
  ): Promise<{ reports: Report[]; total: number }> {
    const where: any = {};
    if (status) {
      where.status = status;
    }

    const [reports, total] = await this.reportRepository.findAndCount({
      where,
      order: { createdAt: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });

    return { reports, total };
  }

  private isValidReportType(type: string): boolean {
    const validTypes = [
      'harassment',
      'threats',
      'sexual_content',
      'hate_speech',
      'violence',
      'spam',
      'privacy',
      'underage',
      'copyright',
      'other',
    ];
    return validTypes.includes(type);
  }

  private async notifyAdmin(report: Report): Promise<void> {
    this.logger.log(`New report submitted: ${report.id}`);
  }

  private async notifyReporter(
    reporterId: string,
    reportId: string,
    result: string,
  ): Promise<void> {
    this.logger.log(
      `Report ${reportId} resolved with result: ${result} for reporter ${reporterId}`,
    );
  }
}
