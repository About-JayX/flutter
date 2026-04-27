/**
 * 提现渠道枚举
 */
export enum WithdrawChannel {
  BANK = 'bank',
}

/**
 * 获取提现渠道描述
 */
export const WithdrawChannelDescription = {
  [WithdrawChannel.BANK]: '银行提现',
};
