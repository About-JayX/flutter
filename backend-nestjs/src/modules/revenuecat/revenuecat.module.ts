import { Module } from '@nestjs/common';
import { RevenueCatService } from './revenuecat.service';
import { RevenueCatController } from './revenuecat.controller';

@Module({
  controllers: [RevenueCatController],
  providers: [RevenueCatService],
  exports: [RevenueCatService],
})
export class RevenueCatModule {}
