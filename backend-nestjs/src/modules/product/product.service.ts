import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { Product } from './entities/product.entity';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';

@Injectable()
export class ProductService {
    constructor(
    @InjectRepository(Product)
    private productRepository: Repository<Product>,
  ) {}
  // =================== 业务 ================
  // ✅ 查询 product_type = 'petiself_source' 的数据，最多 20 条
  async petiHopeSourceContentGet(): Promise<Product[]> {
    return await this.productRepository.find({
      where: {
        productType: 'petiself_source',
      },
      take: 20, // 限制返回 20 条
      order: {
        id: 'DESC', // 可选：按最新创建的在前
      },
    });
  }
  // petiHopeSourceContentGet() {
  //   //product_type = petiself_source
  //   return `This action returns all product`;
  // }
  // 根据skuid查询 - manager版本
  async getProductBySkuId( 
    productSkuId: number,
    manager: EntityManager
  ): Promise<Product | null> {
    return await manager
      .getRepository(Product)
      .findOne({ where: { productSkuId } });
  }


  // =================== 标准 ================
  create(createProductDto: CreateProductDto) {
    return 'This action adds a new product';
  }

  findAllPetiHopeSource() {
    return `This action returns all product`;
  }

  findAll() {
    return `This action returns all product`;
  }

  findOne(id: number) {
    return `This action returns a #${id} product`;
  }

  update(id: number, updateProductDto: UpdateProductDto) {
    return `This action updates a #${id} product`;
  }

  remove(id: number) {
    return `This action removes a #${id} product`;
  }
}
