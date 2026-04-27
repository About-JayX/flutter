// src/middleware/raw-body.middleware.ts
import { Injectable, NestMiddleware } from '@nestjs/common';
import * as getRawBody from 'raw-body';

@Injectable()
export class RawBodyMiddleware implements NestMiddleware {
  async use(req: any, res: any, next: Function) {
    // 只对特定类型的内容保留 rawBody
    if (req.headers['content-type']?.includes('application/x-www-form-urlencoded')) {
      try {
        req.rawBody = await getRawBody(req, {
          length: req.headers['content-length'], // 正确长度
          limit: '1mb', // 最大 1MB
          encoding: 'utf8', // 强制 utf8 编码
        });
      } catch (err) {
        console.error('Failed to read raw body:', err);
        return res.status(400).send('Bad Request');
      }
    }
    next();
  }
}