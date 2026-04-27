/*
* customResponse
* fun: 自定义拦截控制器方法
* use: 
*/
// 控制器级别
// @UseInterceptors(
//   customResponse(
//     { version: '2.1.0' }, // 自定义版本
//     { statusInfo: 'Payment service success' }, // 自定义提示
//   ),
// )
// @Controller('pay')
// 方法级别
// @Post('retry-all-failed')
// @UseInterceptors(
//   customResponse(
//     { version: '2.1.0' }, // 自定义版本
//     { statusInfo: 'Payment service success' }, // 自定义提示
//   ),
// )
import { ResponseCustomBaseInterceptor } from './response.custom.base.interceptor';

export const customResponse = (
  head: { version?: string } = {},
  body: { status?: string; statusInfo?: string; data?: any } = {},
) => {
  return new ResponseCustomBaseInterceptor(head, body);
};