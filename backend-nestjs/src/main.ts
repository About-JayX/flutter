import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger } from '@nestjs/common';
import * as express from 'express';
import { ConfigService } from '@nestjs/config';
import { AppModule } from './app.module';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppDataSource } from './database/data-source';
import * as path from 'path';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  app.use(express.json({ limit: '10mb' }));

  // ==================== 时区 配置 ====================
  // 设置时区为东八区（北京时间）
  process.env.TZ = 'Asia/Shanghai';
  // 验证时区设置
  const logger = new Logger('Bootstrap');
  logger.log(`🚀 应用启动时间: ${new Date()}`);
  logger.log(
    `⏰ 系统时区: ${Intl.DateTimeFormat().resolvedOptions().timeZone}`,
  );
  logger.log(`🌍 当前时间: ${new Date().toISOString()}`);
  logger.log(
    `📍 本地时间: ${new Date().toLocaleString('zh-CN', { timeZone: 'Asia/Shanghai' })}`,
  );
  // ===================================================

  // ==================== API 配置 ====================
  // 设置统一的全局前缀
  app.setGlobalPrefix('api');
  // ===================================================

  // ==================== Swagger 配置 ====================
  const config = new DocumentBuilder()
    .setTitle('Your API Title') // 设置 API 文档标题
    .setDescription('API description') // 设置描述
    .setVersion('1.0') // 设置版本
    .addTag('auth') // 添加标签
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api-docs', app, document); // Swagger UI 将在 /api-docs 路径下可用
  // ===================================================

  // ==================== dto全局启用验证管道 ====================
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true, // 自动去除 DTO 中不存在的属性
      // forbidNonWhitelisted: true, // 如果请求体包含 DTO 中未定义的属性，抛出错误
      transform: true, // 自动将请求体数据转换为 DTO 类的实例
      stopAtFirstError: true, // 遇到第一个验证错误就停止，提高性能
    }),
  );
  // 可选：全局启用拦截器（如果所有 API 都是 multipart）
  // app.useGlobalInterceptors(new MultipartToJsonInterceptor());
  // ===================================================

  const imageStoragePath =
    configService.get<string>('IMAGE_STORAGE_PATH') || '/sources/images';
  const staticPath = path.join(__dirname, '..', imageStoragePath);
  app.use(imageStoragePath, express.static(staticPath));
  logger.log(`📁 静态文件服务: ${imageStoragePath} -> ${staticPath}`);

  await app.listen(process.env.PORT ?? 3000, process.env.HOST || '0.0.0.0');
}
bootstrap();
