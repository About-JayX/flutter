/**
 * 提现状态枚举
 */
export enum WithdrawalStatus {
  PENDING = 'pending',      // 待处理
  PROCESSING = 'processing', // 处理中
  SUCCESS = 'success',      // 成功
  FAILED = 'failed',        // 失败
  CANCELLED = 'cancelled',  // 已取消
}

/**
 * 获取提现状态描述
 */
export const WithdrawalStatusDescription = {
  [WithdrawalStatus.PENDING]: '待处理',
  [WithdrawalStatus.PROCESSING]: '处理中',
  [WithdrawalStatus.SUCCESS]: '已提现',
  [WithdrawalStatus.FAILED]: '提现失败',
  [WithdrawalStatus.CANCELLED]: '已取消',
};