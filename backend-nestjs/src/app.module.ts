import { Module } from '@nestjs/common';
import { APP_FILTER, APP_INTERCEPTOR, APP_GUARD } from '@nestjs/core';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import * as dotenv from 'dotenv';
// import { MongooseModule } from '@nestjs/mongoose';
import databaseConfig from '@root/src/config/database.config';
import redisConfig from '@root/src/config/redis.config';
import { CacheModule } from '@nestjs/cache-manager';
import { redisStore } from 'cache-manager-redis-store';
// import configuration from '../config/configuration';
// import { validate } from '../config/configuration';
import { AppService } from './app.service';
import { AppController } from './app.controller';
import { ResponseInterceptor } from './interceptors/response.interceptor';
import { GlobalExceptionFilter } from './interceptors/response.exception.interceptor'; // 导入全局过滤器
// import { BadRequestResponse } from './interceptors/bad-request.response';
import { QueueModule } from './shared/queue/queue.module';
import { RedisModule } from './shared/redis/redis.module';
// import { BullBoardModule } from './bull-board/bull-board.module';
import { MonitoringModule } from './shared/monitoring/monitoring.module';
import { AuthModule } from '@/modules/auth/auth.module';
import { JwtAuthGuard } from '@/modules/auth/guards/jwt-auth.guard';
import { UsersModule } from './modules/users/users.module';
import { PayModule } from '@/modules/pay/pay.module';
import { ActivitiesModule } from './shared/activities/activities.module';
import { OrderModule } from './modules/order/order.module';
import { OrderProductModule } from './modules/order-product/order-product.module';
import { ProductModule } from './modules/product/product.module';
import { PetihopeModule } from './modules/petihope/petihope.module';
import { NewsModule } from './modules/news/news.module';
import { SystemModule } from './modules/system/system.module';
import { CommonModule } from './public/common/common.module';
import { PushModule } from './shared/push/push.module';
import { MobiModule } from './mobi/mobi.module';
import { FeedModule } from './modules/feed/feed.module';
import { MatchModule } from './modules/match/match.module';
import { ContentModule } from './modules/content/content.module';
import { ZegoModule } from './modules/zego/zego.module';
import { ChatModule } from './modules/chat/chat.module';
import { CallModule } from './modules/call/call.module';
import { RevenueCatModule } from './modules/revenuecat/revenuecat.module';
import { VIPModule } from './modules/vip/vip.module';
import { PrivacyModule } from './modules/privacy/privacy.module';
import { BlockModule } from './modules/block/block.module';
import { ReportModule } from './modules/report/report.module';
import { GiftModule } from './modules/gift/gift.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [databaseConfig, redisConfig],
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        type: 'mysql',
        host: configService.get('database.host'),
        port: configService.get('database.port'),
        username: configService.get('database.username'),
        password: configService.get('database.password'),
        database: configService.get('database.database'),
        entities: [__dirname + '/**/*.entity{.ts,.js}'],
        synchronize: configService.get('database.synchronize'),
        charset: 'utf8mb4_unicode_ci',
        // timezone: "Z", // 纠正时区偏差8小时  <<<<<<<<<------------------------ 这会导致进入数据库的时间被减掉8个小时
        // timezone: '+08:00', // 添加时区：效果与z一致
        // driver: require('mysql2'), // 明确指定使用 mysql2 驱动
        // 不要手动传 driver，而是通过安装 mysql2 包让 TypeORM 自动选择，这个写法 是旧版 TypeORM 的配置方式
      }),
      inject: [ConfigService],
    }),
    CacheModule.register({
      store: redisStore,
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT as string, 10) || 6379,
      ttl: 600, // 默认过期时间（秒），10分钟
      max: 1000, // 最大缓存数量
      isGlobal: true, // 关键：全局可用
    }),
    RedisModule,
    // BullBoardModule,
    MonitoringModule,
    QueueModule,
    AuthModule,
    UsersModule,
    PayModule,
    ActivitiesModule,
    OrderModule,
    OrderProductModule,
    ProductModule,
    PetihopeModule,
    NewsModule,
    SystemModule,
    CommonModule,
    PushModule,
    MobiModule,
    FeedModule,
    MatchModule,
    ContentModule,
    ZegoModule,
    ChatModule,
    CallModule,
    RevenueCatModule,
    VIPModule,
    PrivacyModule,
    BlockModule,
    ReportModule,
    GiftModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    // api响应
    //  全局拦截器
    {
      provide: APP_INTERCEPTOR,
      useClass: ResponseInterceptor,
    },
    // 全局异常过滤器（处理所有非 200 错误响应）
    {
      provide: APP_FILTER,
      useClass: GlobalExceptionFilter,
    },
    // // 400 异常过滤器
    // {
    //   provide: APP_FILTER,
    //   useClass: BadRequestResponse,
    // },
    // api请求
    //  全局验证器
    {
      provide: APP_GUARD,
      useClass: JwtAuthGuard,
    },
  ],
})
export class AppModule {}
