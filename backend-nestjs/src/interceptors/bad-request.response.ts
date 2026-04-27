// // src/filters/bad-request.filter.ts
// import { ExceptionFilter, Catch, ArgumentsHost, BadRequestException } from '@nestjs/common';
// import { ConfigService } from '@nestjs/config';
// import { Response } from 'express';
// import { formatResponse, ResponseData } from '@/interceptors/response-formatter'; // 导入定义的类型
// import { ValidationError } from 'class-validator';

// @Catch(BadRequestException)
// export class BadRequestResponse implements ExceptionFilter {
//   constructor(private configService: ConfigService) {}

//   catch(exception: BadRequestException, host: ArgumentsHost) {
//     const ctx = host.switchToHttp();
//     const response = ctx.getResponse<Response>();
//     const request = ctx.getRequest();
//     const status = exception.getStatus();

//     // 获取原始异常信息
//     const exceptionResponse: any = exception.getResponse();
    
//     // 解析验证错误信息（显式声明 errorData 类型为 ResponseData）
//     let errorMessage = '参数验证失败';
//     let errorData: ResponseData = null; // 关键：用定义的类型声明

//     // 处理 class-validator 的验证错误数组
//     if (typeof exceptionResponse.message === 'object' && exceptionResponse.message.length) {
//       // 格式化验证错误（此时 errorData 会被赋值为数组类型，无报错）
//       errorData = (exceptionResponse.message as ValidationError[]).map((error) => ({
//         field: error.property,
//         message: Object.values(error.constraints || {})[0] || '字段验证失败',
//       }));
//       // 拼接第一个错误信息作为 statusInfo
//       errorMessage = Object.values((exceptionResponse.message[0] as ValidationError).constraints || {})[0] || errorMessage;
//     } else {
//       // 处理普通的 400 错误
//       errorMessage = exceptionResponse.message || errorMessage;
//       errorData = exceptionResponse;
//     }

//     // 获取请求中的自定义字段
//     const customHead = request.customHead ?? {};
//     const customBody = request.customBody ?? {};

//     // 生成格式化响应（类型完全匹配）
//     const formattedResponse = formatResponse(
//       this.configService,
//       errorData, // 现在无类型报错
//       customHead,
//       customBody,
//       true,
//       errorMessage,
//     );

//     // 返回响应
//     response.status(status).json(formattedResponse);
//   }
// }
