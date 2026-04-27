/*
* ResponseInterceptor
* fun: 全局拦截器默认包转Interceptor
*/
import { Injectable, NestInterceptor, ExecutionContext, CallHandler, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

@Injectable()
export class ResponseInterceptor implements NestInterceptor {
  private readonly logger = new Logger(ResponseInterceptor.name);

  constructor(private configService: ConfigService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    
    // ✅ 这里不再立即判断 skipGlobalWrap
    // 因为控制器还没执行

    return next.handle().pipe(
      map((data) => {
        const req = context.switchToHttp().getRequest();
        // // ① 业务是否想跳过全局包装
          this.logger.log(`🪜🪜🍎🍎🍎🍎🪜🪜🪜req?.skipGlobalWrap: ${req.skipGlobalWrap}`);
          if (req.skipGlobalWrap === true) {
            this.logger.log(`🪜🪜🍎ioooo🍎🍎🪜🪜🪜req?.skipGlobalWrap: ${req.skipGlobalWrap}`);
            return data; // 直接透传，不包
          }
        // // // 1. 跳过包装
        // // req.skipGlobalWrap = true;
        // // return { fileUrl: 'http://xxx/file.xlsx' };

        // ② 业务是否想自定义部分字段
          const customHead = req.customHead ?? {};
          const customBody = req.customBody ?? {};
          // this.logger.log(`🪜🪜🍐🍐🍐🍐🪜🪜🪜req.customBody: ${JSON.stringify(req.customBody)}`);
          // return {
          //   head: {
          //     version: this.configService.get('APP_VERSION', '1.0.0'),
          //     ...customHead,
          //   },
          //   body: customBody,
          // };
        // 3. 或者只改 statusInfo
        // req.customBody = { statusInfo: '导出完成' };
        // return { fileUrl: 'http://xxx/file.xlsx' };

        // 4 若已经是 { head, body } 结构，则合并自定义字段
        if (data && typeof data === 'object' && 'head' in data && 'body' in data) {
          return {
            head: { ...data.head, ...customHead },
            body: { ...data.body, ...customBody },
          };
        }

        if (data && typeof data === 'object' && 'status' in data && 'data' in data) {
          return {
            head: {
              version: this.configService.get('APP_VERSION', '1.0.0'),
              ...customHead,
            },
            body: {
              ...data,
              ...customBody,
            },
          };
        }

        return {
          head: {
            version: this.configService.get('APP_VERSION', '1.0.0'),
            ...customHead,
          },
          body: {
            status: '0',
            statusInfo: 'success',
            data,
            ...customBody,
          },
        };
      }),
    );
  }

  // intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
  //   return next.handle().pipe(
  //     map((data) => {
  //       // const req = context.switchToHttp().getRequest();
  //       // if (req.skipGlobalWrap === true) {
  //       //   this.logger.log(`🪜🪜🍎ioooo🍎🍎🪜🪜🪜req?.skipGlobalWrap: ${req.skipGlobalWrap}`);
  //       //   return data;
  //       // }

  //       // ✅ 关键：判断是否已经是 { head, body } 结构
  //       if (data && typeof data === 'object' && 'head' in data && 'body' in data) {
  //         return data; // 已包装，不再处理
  //       }

  //       // ✅ 正常情况：包装成标准结构
  //       return {
  //         head: {
  //           version: '1.0.0',
  //         },
  //         body: {
  //           status: '0',
  //           statusInfo: 'success',
  //           data,
  //         },
  //       };
  //     }
  //   ),
  // );}
}