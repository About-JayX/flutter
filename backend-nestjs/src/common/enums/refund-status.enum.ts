/**
 * 退款状态枚举
 */
// 可选：定义枚举
export enum RefundStatus {
  PENDING = 0,      // 待处理
  APPROVED = 1,     // 已同意
  REJECTED = 2,     // 已拒绝
  REFUNDED = 3,     // 已退款（第三方成功）
  FAILED = 4,       // 退款失败
  CANCELLED = 5,    // 用户取消
}

export enum RefundType {
  FULL = 0,         // 全额退款
  PARTIAL = 1,      // 部分退款
}

export enum RefundMethod {
  ORIGINAL = 0,     // 原路退回
  WALLET = 1,       // 退回至用户钱包
  BANK_TRANSFER = 2,// 银行转账
}

/**
 * 获取退款状态描述
 */
// export const PayStatusDescription = {
//   [PayStatus.UNPAID]: '未支付',
//   [PayStatus.PAYING]: '支付中',
//   [PayStatus.PAID]: '已支付',
//   [PayStatus.PAY_FAILED]: '支付失败',
//   [PayStatus.REFUNDED]: '已退款',
// };