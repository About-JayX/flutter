/*
* customResponse
* fun: 自定义拦截控制器核心逻辑
*/
import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

@Injectable()
export class ResponseCustomBaseInterceptor implements NestInterceptor {
  constructor(
    private customHead: { version?: string } = {},
    private customBody: { status?: string; statusInfo?: string; data?: any } = {},
  ) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      map((data) => 
      ({
        head: {
          version: '1.0.0', // 默认值
          ...this.customHead,
        },
        body: {
          status: '0',
          statusInfo: 'success',
          data: data ?? this.customBody.data ?? null,
          ...this.customBody,
        },
      })
    ),
    );
  }
}