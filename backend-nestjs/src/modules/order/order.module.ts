import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { OrderService } from './order.service';
import { OrderController } from './order.controller';
import { Order } from './entities/order.entity';
import { OrderProduct } from '../order-product/entities/order-product.entity';
import { Pay } from '@/modules/pay/entities/pay.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Order, OrderProduct, Pay])
  ],
  controllers: [OrderController],
  providers: [OrderService],
  exports: [OrderService],
})
export class OrderModule {}