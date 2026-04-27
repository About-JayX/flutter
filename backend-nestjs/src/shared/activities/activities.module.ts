import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { QueueModule } from '@/shared/queue/queue.module';

import { Pay } from '@/modules/pay/entities/pay.entity';
import { Refund } from '@/modules/pay/entities/refund.entity';
import { WithdrawalEntity } from '@/modules/pay/entities/withdraw.entity';
import { Order } from '@root/src/modules/order/entities/order.entity';
import { Product } from '@root/src/modules/product/entities/product.entity';
import { OrderProduct } from '@root/src/modules/order-product/entities/order-product.entity';
import { User } from '@root/src/modules/users/entities/user.entity';
import { UserNamesDB } from '@root/src/modules/users/entities/usernamesdb.entity';
import { Petihope } from '@root/src/modules/petihope/entities/petihope.entity';
import { PetihopePri } from '@root/src/modules/petihope/entities/petihope_pri.entity';

import { PayService } from '@/modules/pay/pay.service';
import { UsersService } from '@root/src/modules/users/users.service';
import { PetihopeService } from '@root/src/modules/petihope/petihope.service';
import { OrderService } from '@root/src/modules/order/order.service';
import { ProductService } from '@root/src/modules/product/product.service';
import { OrderProductService } from '@root/src/modules/order-product/order-product.service';

import { Activities } from './entities/activities.entity';
// import { Activity } from './entities/activity.entity';
import { ActivitiesService } from './activities.service';
import { ActivityCompletionProcessor } from './processors/activity-completion.processor';
import { ActivitiesController } from './activities.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Product,
      Pay,
      WithdrawalEntity,
      Refund,
      Order,
      OrderProduct,
      User,
      UserNamesDB,
      Petihope,
      PetihopePri,
      Activities,
    ]),
    QueueModule,
  ],
  providers: [
    // 基础服务放在前面
    UsersService,
    OrderService,
    OrderProductService,
    ProductService,

    // ActivitiesService 必须在 PetihopeService 之前
    ActivitiesService,

    // 依赖其他服务的服务放在后面
    PetihopeService,
    PayService,

    // 其他服务
    ActivityCompletionProcessor,
  ],
  controllers: [ActivitiesController],
  exports: [ActivitiesService],
})
export class ActivitiesModule {}
