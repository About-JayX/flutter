import { Module } from '@nestjs/common';
import { MobiController } from './mobi.controller';

@Module({
  controllers: [MobiController]
})
export class MobiModule {}
