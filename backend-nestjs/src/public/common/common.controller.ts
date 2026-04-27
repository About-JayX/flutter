import { Controller, Get, Post, Body, Patch, Param, Delete, Logger, } from '@nestjs/common';
import { CommonService } from './common.service';
import { CreateCommonDto } from './dto/create-common.dto';
import { CommonEncryptedPhoneToStarDto } from './dto/common-encryptedPhoneToStar.dto';
import { UpdateCommonDto } from './dto/update-common.dto';
import { Public } from '@/modules/auth/decorators/public.decorator';

@Controller('common')
export class CommonController {
  private readonly logger = new Logger(CommonController.name);
  constructor(private readonly commonService: CommonService) {}

  @Post()
  create(@Body() createCommonDto: CreateCommonDto) {
    return this.commonService.create(createCommonDto);
  }

  @Get()
  findAll() {
    return this.commonService.findAll();
  }

  @Public() // ✅ 不需要登录
  @Post('encryptedPhoneToStar')
  async encryptedPhoneToStar(
    @Body() encryptedPhoneDto: CommonEncryptedPhoneToStarDto,
  ){
    this.logger.log("common - encryptedPhoneToStar, encryptedPhone:", encryptedPhoneDto.encryptedPhone); 
    return this.commonService.encryptedPhoneToStar(
      encryptedPhoneDto.encryptedPhone
    );
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.commonService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateCommonDto: UpdateCommonDto) {
    return this.commonService.update(+id, updateCommonDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.commonService.remove(+id);
  }
}
