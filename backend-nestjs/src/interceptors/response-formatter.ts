// src/utils/response-formatter.ts
import { ConfigService } from '@nestjs/config';

// 关键修改：新增 undefined 类型支持
export type ResponseData = null | string | number | object | Array<{ field: string; message: string }> | undefined;

/**
 * 通用响应格式化工具（支持成功/失败场景）
 */
export function formatResponse(
  configService: ConfigService,
  data: ResponseData = null,
  // errorData: ResponseData = null,
  customHead: Record<string, any> = {},
  customBody: Record<string, any> = {},
  isError = false,
  errorMessage = '请求失败',
  statusCode = 200, // 新增：记录 HTTP 状态码
) {
  return {
    head: {
      version: configService.get('APP_VERSION', '1.0.0'),
      statusCode, // 头部携带 HTTP 状态码（可选）
      ...customHead,
    },
    body: {
      status: isError ? '1' : '0', // 1=错误，0=成功
      statusInfo: isError ? errorMessage : customBody.statusInfo || 'success',
      // errorData,
      data, // 现在支持 undefined 类型
      ...customBody,
    },
  };
}

// // src/utils/response-formatter.ts
// import { ConfigService } from '@nestjs/config';

// // 定义通用的响应数据类型，覆盖所有可能的场景
// export type ResponseData = null | string | number | object | Array<{ field: string; message: string }>;

// /**
//  * 通用响应格式化工具
//  * @param configService 配置服务
//  * @param data 响应数据（支持任意合法类型）
//  * @param customHead 自定义头部
//  * @param customBody 自定义体部
//  * @param isError 是否为错误响应
//  * @param errorMessage 错误提示信息
//  */
// export function formatResponse(
//   configService: ConfigService,
//   data: ResponseData = null, // 显式声明支持数组类型
//   customHead: Record<string, any> = {},
//   customBody: Record<string, any> = {},
//   isError = false,
//   errorMessage = '请求失败',
// ) {
//   return {
//     head: {
//       version: configService.get('APP_VERSION', '1.0.0'),
//       ...customHead,
//     },
//     body: {
//       status: isError ? '1' : '0', // 1=错误，0=成功
//       statusInfo: isError ? errorMessage : customBody.statusInfo || 'success',
//       data, // 现在可以接收数组/对象/null，无类型报错
//       ...customBody,
//     },
//   };
// }
