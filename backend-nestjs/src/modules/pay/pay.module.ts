import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { PayController } from './pay.controller';
import { PayService } from './pay.service';
import { Pay } from './entities/pay.entity';
import { WithdrawalEntity } from './entities/withdraw.entity';
import { Refund } from './entities/refund.entity';

import { AuthModule } from '@/modules/auth/auth.module';
import { UsersModule } from '@/modules/users/users.module';
import { ActivitiesModule } from '@/shared/activities/activities.module';
import { RevenueCatModule } from '@/modules/revenuecat/revenuecat.module';
import { VIPModule } from '@/modules/vip/vip.module';

import { Activities } from '@/shared/activities/entities/activities.entity';
import { Order } from '@root/src/modules/order/entities/order.entity';
import { Product } from '@root/src/modules/product/entities/product.entity';
import { OrderProduct } from '@root/src/modules/order-product/entities/order-product.entity';
import { Petihope } from '@root/src/modules/petihope/entities/petihope.entity';
import { PetihopePri } from '@root/src/modules/petihope/entities/petihope_pri.entity';
import { CallMinutes } from '@/modules/vip/entities/call-minutes.entity';

import { PetihopeService } from '@root/src/modules/petihope/petihope.service';
import { OrderService } from '@root/src/modules/order/order.service';
import { ProductService } from '@root/src/modules/product/product.service';
import { OrderProductService } from '@root/src/modules/order-product/order-product.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Activities,
      Petihope,
      PetihopePri,
      Product,
      Pay,
      WithdrawalEntity,
      Refund,
      Order,
      OrderProduct,
      CallMinutes,
    ]),
    AuthModule,
    UsersModule,
    ActivitiesModule,
    RevenueCatModule,
    VIPModule,
  ],
  controllers: [PayController],
  providers: [
    PetihopeService,
    PayService,
    OrderService,
    OrderProductService,
    ProductService,
  ],
  exports: [PayService],
})
export class PayModule {}
