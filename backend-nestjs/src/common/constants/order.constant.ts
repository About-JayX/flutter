/**
 * 订单相关常量
 */
export const ORDER_CONSTANTS = {
  // 订单ID前缀
    ORDER_ID_PREFIX: 'ORD',
  // 支付单号前缀
    PAY_ID_PREFIX: 'PAY',
  //  自动取消时间（秒）
    AUTO_CANCEL_SECONDS: 8*60,//1.0.1: 5*60；1.0.2:8*60
  //  自动取消容错时间（秒）
    AUTO_CANCEL_FIX_SECONDS: 2*60,
    
  ///  待废弃
  // 自动取消时间（分钟）
  AUTO_CANCEL_MINUTES: 5,
  // 自动确认收货时间（天）
  AUTO_CONFIRM_DAYS: 7,
};