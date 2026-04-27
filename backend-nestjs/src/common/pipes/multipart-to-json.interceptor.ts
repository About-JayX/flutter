import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  BadRequestException,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { Request } from 'express';
import * as multer from 'multer';

@Injectable()
export class MultipartToJsonInterceptor implements NestInterceptor {
  // 创建一个 multer 实例，用于解析 multipart
  // single('data') 表示我们期望一个名为 'data' 的文本字段
  private multerInstance = multer().single('data');

  async intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Promise<Observable<any>> {
    const ctx = context.switchToHttp();
    const req = ctx.getRequest<Request>();

    // ✅ 只处理 Content-Type 为 multipart/form-data 的请求
    if (!req.is('multipart/form-data')) {
      return next.handle();
    }

    // 返回一个 Promise，包装异步的 multer 处理逻辑
    await new Promise<void>((resolve, reject) => {
      // 使用 multer 解析请求
      this.multerInstance(req, req.res, (err) => {
        if (err) {
          // multer 解析错误（如字段名不匹配、格式错误等）
          return reject(new BadRequestException('Multipart parsing error: ' + err.message));
        }

        // 检查 req.body 和 req.body.data 是否存在
        if (!req.body || !req.body.data) {
          return reject(new BadRequestException('Missing "data" field in multipart'));
        }

        let jsonData: any;
        try {
          // 尝试解析 JSON 字符串
          jsonData = JSON.parse(req.body.data);
        } catch (parseError) {
          return reject(new BadRequestException('Invalid JSON format in "data" field'));
        }

        // 将解析后的 JSON 对象赋值给 req.body
        // 这样后续的 ValidationPipe 和 @Body() 才能正常工作
        req.body = jsonData;

        // 解析成功，继续
        resolve();
      });
    });

    // ✅ 如果上面的 Promise 成功 resolve，说明 multipart 解析和 JSON 转换已完成
    // 此时 req.body 已经是解析后的对象，可以安全地调用 next.handle()
    return next.handle();
  }
}