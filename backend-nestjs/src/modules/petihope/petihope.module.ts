import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { QueueModule } from '@/shared/queue/queue.module';

import { Activities } from '@/shared/activities/entities/activities.entity';
import { Order } from '@root/src/modules/order/entities/order.entity';
import { OrderProduct } from '@root/src/modules/order-product/entities/order-product.entity';
import { Product } from '@root/src/modules/product/entities/product.entity';
import { Pay } from '@/modules/pay/entities/pay.entity';
import { User } from '@root/src/modules/users/entities/user.entity';
import { UserNamesDB } from '@root/src/modules/users/entities/usernamesdb.entity';
import { Refund } from '@/modules/pay/entities/refund.entity';
import { WithdrawalEntity } from '@/modules/pay/entities/withdraw.entity';

import { PayService } from '@/modules/pay/pay.service';
import { UsersService } from '@root/src/modules/users/users.service';
import { OrderService } from '@root/src/modules/order/order.service';
import { ProductService } from '@root/src/modules/product/product.service';
import { OrderProductService } from '@root/src/modules/order-product/order-product.service';
import { ActivitiesService } from '@/shared/activities/activities.service';

import { PetihopeController } from './petihope.controller';
import { Petihope } from './entities/petihope.entity';
import { PetihopePri } from './entities/petihope_pri.entity';
import { PetihopeService } from './petihope.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Order,
      OrderProduct,
      Product,
      User,
      UserNamesDB,
      Pay,
      WithdrawalEntity,
      Refund,
      Petihope,
      PetihopePri,
      Activities,
    ]),
    QueueModule,
  ],
  controllers: [PetihopeController],
  providers: [
    /// 基础服务放在前面
    UsersService,
    OrderService,
    OrderProductService,
    ProductService,
    PayService,

    /// PetihopeService 必须在 ActivitiesService 之前
    PetihopeService,

    /// 依赖其他服务的服务放在后面
    ActivitiesService,
  ],
})
export class PetihopeModule {}
