import { 
  Controller, 
  Get, 
  Post, 
  Body, 
  Patch, 
  Param, 
  Delete, 
  Query, 
  HttpCode, 
  HttpStatus,
  ParseIntPipe,
  UsePipes,
  ValidationPipe
} from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags, ApiQuery, ApiParam } from '@nestjs/swagger';
import { OrderService } from './order.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { QueryOrderDto } from './dto/query-order.dto';

@Controller('orders')
export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  /// 业务
  @Get('sn/:orderSn')
  @ApiOperation({ summary: '根据订单号查询订单', description: '通过订单号获取订单详细信息' })
  @ApiParam({ name: 'orderSn', description: '订单编号', example: 'SO202310250001' })
  @ApiQuery({ name: 'fields', required: false, description: '选择返回的字段，用逗号分隔', example: 'orderTime,paymentAmount' })
  @UsePipes(new ValidationPipe({ transform: true }))
  findOrderBySn(
    @Param('orderSn') orderSn: string,
    @Query() queryDto,//: QueryOrderDto
    // @Query('fields') fields?: string,
  ) {
    const fieldList = queryDto.fields ? queryDto.fields.split(',') : undefined;
    return this.orderService.findOrderBySn(
      orderSn,{
        fields: fieldList,
      }
    );
  }

  /// 模版
  @Post('order/create')
  @HttpCode(HttpStatus.CREATED)
  create(@Body() createOrderDto: CreateOrderDto) {
    return this.orderService.create(createOrderDto);
  }

  // @Get()
  // findAll(@Query() queryOrderDto: QueryOrderDto) {
  //   return this.orderService.findAll(queryOrderDto);
  // }

  // @Get('user/:userId')
  // findByUserId(
  //   @Param('userId', ParseIntPipe) userId: number,
  //   @Query() queryOrderDto: QueryOrderDto
  // ) {
  //   return this.orderService.findByUserId(userId, queryOrderDto);
  // }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.orderService.findOne(id);
  }

  @Get('sn/:orderSn')
  findByOrderSn(@Param('orderSn') orderSn: string) {
    return this.orderService.findByOrderSn(orderSn);
  }

  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number, 
    @Body() updateOrderDto: UpdateOrderDto
  ) {
    return this.orderService.update(id, updateOrderDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.orderService.remove(id);
  }

  @Post(':id/cancel')
  cancel(@Param('id', ParseIntPipe) id: number) {
    return this.orderService.cancel(id);
  }

  @Post(':id/refund')
  applyRefund(
    @Param('id', ParseIntPipe) id: number, 
    @Body('reason') reason: string
  ) {
    return this.orderService.applyRefund(id, reason);
  }

  @Post(':id/ship')
  shipOrder(
    @Param('id', ParseIntPipe) id: number,
    @Body() shippingInfo: { 
      shippingName: string; 
      shippingCode: string; 
      trackingNumber: string; 
    }
  ) {
    return this.orderService.shipOrder(id, shippingInfo);
  }

  @Post(':id/confirm-receipt')
  confirmReceipt(@Param('id', ParseIntPipe) id: number) {
    return this.orderService.confirmReceipt(id);
  }
}