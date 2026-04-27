/**
 * 支付渠道枚举
 */
export enum PayChannel {
  FREE = 'free',
}

/**
 * 获取支付渠道描述
 */
export const PayChannelDescription = {
  [PayChannel.FREE]: '0元支付',
};
