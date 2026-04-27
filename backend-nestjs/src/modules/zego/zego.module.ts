import { Module } from '@nestjs/common';
import { ZegoService } from './zego.service';
import { ZegoController } from './zego.controller';

@Module({
  controllers: [ZegoController],
  providers: [ZegoService],
  exports: [ZegoService],
})
export class ZegoModule {}
