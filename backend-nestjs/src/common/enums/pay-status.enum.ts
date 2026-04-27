/**
 * 支付状态枚举
 */
export enum PayStatus {
  UNPAID = 0,           // 未支付
  PAYING = 1,           // 支付中
  PAID = 2,             // 已支付
  PAY_FAILED = 3,       // 支付失败
  REFUNDED = 4,         // 已退款
}

/**
 * 获取支付状态描述
 */
export const PayStatusDescription = {
  [PayStatus.UNPAID]: '未支付',
  [PayStatus.PAYING]: '支付中',
  [PayStatus.PAID]: '已支付',
  [PayStatus.PAY_FAILED]: '支付失败',
  [PayStatus.REFUNDED]: '已退款',
};