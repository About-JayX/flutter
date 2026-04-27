// src/filters/global-exception.filter.ts
import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Response, Request } from 'express';
import { formatResponse, ResponseData } from '@/interceptors/response-formatter'
import { ValidationError } from 'class-validator';

// 捕获所有异常（先捕获 HttpException，再捕获所有未知异常）
@Catch(HttpException, Error)
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  constructor(private configService: ConfigService) {}

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    // 1. 初始化默认错误信息
    let statusCode = HttpStatus.INTERNAL_SERVER_ERROR; // 默认 500
    let errorMessage = '服务器内部错误';
    let errorData: ResponseData = null;

    // 2. 区分异常类型处理
    if (exception instanceof HttpException) {
      // 处理 NestJS 内置的 HTTP 异常（400/401/403/404/500 等）
      statusCode = exception.getStatus();
      const exceptionResponse: any = exception.getResponse();

      // 细分处理不同 HTTP 异常
      switch (statusCode) {
        case HttpStatus.BAD_REQUEST: // 400
          errorMessage = '参数验证失败';
          // 解析 DTO 验证错误
          this.logger.error('400错误:', exceptionResponse.message); // 400记录错误日志
          // 先判断是否是数组，再区分数组元素类型
          if (Array.isArray(exceptionResponse.message)) {
            if (exceptionResponse.message.length > 0) {
              const firstItem = exceptionResponse.message[0];
              // 情况1: 数组元素是ValidationError对象（原有逻辑）
              if (typeof firstItem === 'object' && firstItem !== null && 'property' in firstItem) {
                errorData = (exceptionResponse.message as ValidationError[]).map((error) => ({
                  field: error.property,
                  message: Object.values(error.constraints || {})[0] || '字段验证失败',
                }));
                errorMessage = Object.values((exceptionResponse.message[0] as ValidationError).constraints || {})[0] || errorMessage;
              } 
              // 情况2: 数组元素是字符串（处理params.前缀）
              else if (typeof firstItem === 'string') {
                const matchResult = firstItem.match(/^params\.(.+)$/);
                errorMessage = matchResult ? matchResult[1] : firstItem; // 提取params.后内容，无则用原字符串
                errorData = exceptionResponse;
              }
            } else {
              // 空数组兜底
              errorMessage = '服务器异常！请稍后重试';
              errorData = exceptionResponse;
            }
          } 
          // 非数组的对象类型
          else if (typeof exceptionResponse.message === 'object' && exceptionResponse.message !== null) {
            errorMessage = '服务器异常！请稍后重试';
            errorData = exceptionResponse;
          } 
          // 字符串/数字等基础类型
          else {
            errorMessage = exceptionResponse.message || '服务器异常！请稍后重试';
            errorData = exceptionResponse;
          }
          break;
        case HttpStatus.UNAUTHORIZED: // 401
          errorMessage = exceptionResponse.message || '请先登录或注册';//exceptionResponse.message || '未授权，请先登录'
          errorData = exceptionResponse;
          break;
        case HttpStatus.FORBIDDEN: // 403
          errorMessage = '服务器异常！请稍后重试';//exceptionResponse.message || '没有权限访问该资源'
          errorData = exceptionResponse;
          break;
        case HttpStatus.NOT_FOUND: // 404
          errorMessage =  '服务器异常！请稍后重试';//exceptionResponse.message || '请求的资源不存在'
          errorData = exceptionResponse;
          break;
        case HttpStatus.INTERNAL_SERVER_ERROR: // 500
          errorMessage = '服务器异常！请稍后重试';//exceptionResponse.message || '服务器内部错误'
          // 关键修改：增加空值处理，确保 stack 为 undefined 时返回 null
          const stack = (exception as Error).stack; // 先断言为 Error 类型
          errorData = process.env.NODE_ENV === 'dev' ? (stack || null) : null; 
          break;
        // case HttpStatus.INTERNAL_SERVER_ERROR: // 500
        //   errorMessage = exceptionResponse.message || '服务器内部错误';
        //   errorData = process.env.NODE_ENV === 'dev' ? exception.stack : null; // 开发环境返回堆栈，生产环境隐藏
        //   break;
        default: // 其他 HTTP 异常（如 405/409 等）
          errorMessage = '服务器异常！请稍后重试';//exceptionResponse.message || `请求失败（${statusCode}）`
          errorData = exceptionResponse;
          break;
      }
    } else {
      // 处理未知异常（非 HttpException，如代码报错）
      this.logger.error('未知服务器错误:', exception); // 记录错误日志
      errorMessage = '服务器异常！请稍后重试';//process.env.NODE_ENV === 'dev' ? (exception as Error).message : '服务器异常！请稍后重试'
      errorData = process.env.NODE_ENV === 'dev' ? (exception as Error).stack : null;
    }

    // 3. 获取请求中的自定义字段（和响应拦截器逻辑一致）
    const customHead = request.customHead ?? {};
    const customBody = request.customBody ?? {};

    // 4. 格式化错误响应
    const formattedResponse = formatResponse(
      this.configService,
      errorData,
      // null,
      // errorData,
      customHead,
      customBody,
      true, // 标记为错误响应
      errorMessage,
      statusCode, // 传入 HTTP 状态码
    );

    // 5. 返回统一格式的错误响应
    response.status(statusCode).json(formattedResponse);
  }
}
