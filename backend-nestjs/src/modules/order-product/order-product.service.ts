import { Injectable, NotFoundException, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { v4 as uuidv4 } from 'uuid';
import { OrderProduct } from './entities/order-product.entity';
import { CreateOrderProductDto } from './dto/create-order-product.dto';
import { UpdateOrderProductDto } from './dto/update-order-product.dto';

@Injectable()
export class OrderProductService {
  private readonly logger = new Logger(OrderProductService.name);
  constructor(
    @InjectRepository(OrderProduct)
    private orderProductRepository: Repository<OrderProduct>,
  ) {}


  // ================== 业务 ==================
   async createProductOrder(createOrderProductDto: CreateOrderProductDto): Promise<OrderProduct> {
    const { productPrice, quantity } = createOrderProductDto;
    
    const orderProduct = this.orderProductRepository.create({
      ...createOrderProductDto,
      totalPrice: productPrice * quantity,
    });

    return await this.orderProductRepository.save(orderProduct);
  }
  async createProductOrderManager(
    orderId: number,
    productId: number,
    productSkuId: number,
    productName: string,
    productPrice: number,
    quantity: number,
    totalPrice: number,
    manager: EntityManager
  ) {
    // 1. 先检查是否已存在（使用同一个 manager）
    const existing = await manager
      .createQueryBuilder(OrderProduct, 'orderproduct')
      .where('orderproduct.orderId = :orderId', { orderId })
      .andWhere('orderproduct.productId = :productId', { productId })
      .getOne();

    if (existing) {
      this.logger.log(`订单商品已经存在: orderId[${orderId}] - productId[${productId}]`);
      return { generatedMaps: [], raw: [], identifiers: [] };
    }

    // 2. 插入新记录（同样使用 execManager）
    const uniqueId = uuidv4();
    return await manager
      .createQueryBuilder()
      .insert()
      .into(OrderProduct)
      .values({ 
        uniqueId,
        orderId,
        productId,
        productSkuId,
        productName,
        productPrice,
        quantity,
        totalPrice,
       })
      .execute()//  失败抛出异常 使用manager整个事务回滚
  }

  // ================== 标准 ==================

  async create(createOrderProductDto: CreateOrderProductDto): Promise<OrderProduct> {
    const { productPrice, quantity } = createOrderProductDto;
    
    const orderProduct = this.orderProductRepository.create({
      ...createOrderProductDto,
      totalPrice: productPrice * quantity,
    });

    return await this.orderProductRepository.save(orderProduct);
  }

  async findAll(): Promise<OrderProduct[]> {
    return await this.orderProductRepository.find({
      relations: ['order'],
    });
  }

  async findOne(id: number): Promise<OrderProduct> {
    const orderProduct = await this.orderProductRepository.findOne({
      where: { id },
      relations: ['order'],
    });

    if (!orderProduct) {
      throw new NotFoundException(`订单商品 #${id} 不存在`);
    }

    return orderProduct;
  }

  async update(id: number, updateOrderProductDto: UpdateOrderProductDto): Promise<OrderProduct> {
    const orderProduct = await this.findOne(id);
    
    const updatedOrderProduct = this.orderProductRepository.merge(
      orderProduct, 
      updateOrderProductDto
    );

    // 如果价格或数量有更新，重新计算总价
    if (updateOrderProductDto.productPrice !== undefined || updateOrderProductDto.quantity !== undefined) {
      const price = updateOrderProductDto.productPrice ?? orderProduct.productPrice;
      const quantity = updateOrderProductDto.quantity ?? orderProduct.quantity;
      updatedOrderProduct.totalPrice = price * quantity;
    }

    return await this.orderProductRepository.save(updatedOrderProduct);
  }

  async remove(id: number): Promise<void> {
    const orderProduct = await this.findOne(id);
    await this.orderProductRepository.remove(orderProduct);
  }

  async findByOrderId(orderId: number): Promise<OrderProduct[]> {
    return await this.orderProductRepository.find({
      where: { orderId },
      relations: ['order'],
    });
  }

  /**
   * 批量创建订单商品
   */
  async createBatch(createDtos: CreateOrderProductDto[]): Promise<OrderProduct[]> {
    const orderProducts = createDtos.map(dto => {
      const { productPrice, quantity } = dto;
      return this.orderProductRepository.create({
        ...dto,
        totalPrice: productPrice * quantity,
      });
    });

    return await this.orderProductRepository.save(orderProducts);
  }
}