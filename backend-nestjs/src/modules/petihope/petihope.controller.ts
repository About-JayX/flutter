import { Controller, UseGuards, Get, Post, Body, Patch, Param, Delete, Req, Logger } from '@nestjs/common';
import { Request } from 'express'; 
import { AuthGuard } from '@nestjs/passport';
import { PetihopeService } from './petihope.service';
import { CreatePetihopeDto } from './dto/create-petihope.dto';
import { UpdatePetihopeDto } from './dto/update-petihope.dto';
import { PetihopeMemberPostRequestDto } from './dto/member-post-request.dto';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';
// import { ArgsAuthDto } from '@/modules/auth/dto/args-auth.dto';
@Controller('petihope')
export class PetihopeController {
  private readonly logger = new Logger(PetihopeController.name);

  constructor(private readonly petihopeService: PetihopeService) {}
  
  // ================== 业务 ==================
  @Post('member/add/post')
  // @UseGuards(AuthGuard('jwt'))
  async memberAddPost(
    @CurrentUser() user: any,//  ArgsAuthDto
    @Body() body: PetihopeMemberPostRequestDto,
    @Req() req: Request
  ) {
    this.logger.log('✅进入memberAddPost控制器');
    this.logger.log('✅进入memberAddPost控制器数据：user', user);
    this.logger.log('✅进入memberAddPost控制器数据：body', body);
    const res = await this.petihopeService.memberAddPost(
      user,// {uniqid: '761a1047babb4b89c4775a0f0efb84a4b0ab7480'},
      body.params
    );
    req.customBody = res;
    this.logger.log('✅✅响应memberAddPost控制器');
    this.logger.log(`🪜响应memberAddPost控制器数据：res: ${JSON.stringify(res)}`);
    this.logger.log(`🪜响应memberAddPost控制器数据：req.customBody: ${JSON.stringify(req.customBody)}`);
    return res;
  }

  // ================== 标准 ==================
  @Post()
  create(@Body() createPetihopeDto: CreatePetihopeDto) {
    return this.petihopeService.create(createPetihopeDto);
  }

  @Get()
  findAll() {
    return this.petihopeService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.petihopeService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updatePetihopeDto: UpdatePetihopeDto) {
    return this.petihopeService.update(+id, updatePetihopeDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.petihopeService.remove(+id);
  }
}
