import { Controller, Post, Body, Logger } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ZegoService } from './zego.service';
import { Public } from '@/modules/auth/decorators/public.decorator';

@ApiTags('ZEGO')
@Controller('zego')
export class ZegoController {
  private readonly logger = new Logger(ZegoController.name);

  constructor(private readonly zegoService: ZegoService) {}

  @Public()
  @Post('token')
  @ApiOperation({ summary: '生成ZEGO Token' })
  async generateToken(
    @Body('userId') userId: string,
    @Body('roomId') roomId?: string,
  ) {
    const token = this.zegoService.generateToken(userId, roomId);
    return { status: '0', data: { token } };
  }
}
