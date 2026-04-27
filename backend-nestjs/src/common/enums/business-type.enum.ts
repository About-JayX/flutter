import { NewsStatusLevelType } from '@/common/enums/news-status-level-type.enum';
/**
 * 业务类型枚举
 */
//  1、businessId: 表的id字段
export enum TableBusinessType {
  Petihope = 'petihope',
  OrderCancel = 'orderCancel',
  PayCancel = 'payCancel',
  
  SystemNews = NewsStatusLevelType.SystemNews,
  NewsSystem= 'newsSystem',//待废弃
}

/**
 * 获取业务类型描述
 */
export const BusinessTypeDescription = {
  [TableBusinessType.SystemNews]: '描述：系统消息表，表名：app_news_con_system',
  [TableBusinessType.NewsSystem]: '描述：系统消息表，表名：app_news_con_system',//待废弃
  [TableBusinessType.Petihope]: '描述：请愿主表，表名：app_oo',
  [TableBusinessType.OrderCancel]: '描述：订单主表，表名：app_order',
  [TableBusinessType.PayCancel]: '描述：订单主表，表名：app_order',
};