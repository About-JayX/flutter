import { Injectable, OnModuleDestroy, OnModuleInit, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Redis from 'ioredis';

@Injectable()
export class RedisService implements OnModuleInit, OnModuleDestroy {
  private redisClient: Redis;
  private readonly logger = new Logger(RedisService.name);

  constructor(private configService: ConfigService) {
    const redisConfig = this.configService.get('redis'); // 直接获取 redis 配置
    
    this.redisClient = new Redis({
      host: redisConfig.host,
      port: redisConfig.port,
      password: redisConfig.password,
      db: redisConfig.db,
    });
  }

  async onModuleInit() {
    this.logger.log('Redis connected successfully');
    
    try {
      await this.redisClient.ping();
      this.logger.log('Redis ping successful');
    } catch (error) {
      this.logger.error('Redis connection failed:', error);
    }
  }

  async onModuleDestroy() {
    await this.redisClient.quit();
  }

  getClient(): Redis {
    return this.redisClient;
  }
}