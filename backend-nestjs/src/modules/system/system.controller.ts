import { Controller, Get, Post, Body, Patch, Param, Delete, Req, Logger, } from '@nestjs/common';
import { SystemService } from './system.service';
import { CreateSystemDto } from './dto/create-system.dto';
import { UpdateSystemDto } from './dto/update-system.dto';
import { Public } from '@/modules/auth/decorators/public.decorator';

@Controller('system')
export class SystemController {
  private readonly logger = new Logger(SystemController.name);
  constructor(private readonly systemService: SystemService) {}

  @Post()
  create(@Body() createSystemDto: CreateSystemDto) {
    return this.systemService.create(createSystemDto);
  }

  @Get()
  findAll() {
    return this.systemService.findAll();
  }

  @Public() // ✅ 不需要登录
  @Get('app/update/info')
  async findAppUpdateVersionInfo(
    @Req() request: Request
  ) {
    this.logger.log('app/update/info - All headers:', request.headers);
    const version = request.headers['x-app-version'];
    const os = request.headers['x-os'];
    return this.systemService.findAppUpdateVersionInfo(
      version,
      os
    );
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.systemService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateSystemDto: UpdateSystemDto) {
    return this.systemService.update(+id, updateSystemDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.systemService.remove(+id);
  }
}
