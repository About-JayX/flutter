/**
 * 售后状态枚举
 */
export enum AfterSalesStatus {
  NONE = 0,                 // 无售后
  APPLYING = 1,             // 售后申请中
  REFUNDING = 2,            // 退款中
  EXCHANGING = 3,           // 换货中
  COMPLETED = 4,            // 售后完成
}

/**
 * 获取售后状态描述
 */
export const AfterSalesStatusDescription = {
  [AfterSalesStatus.NONE]: '无售后',
  [AfterSalesStatus.APPLYING]: '售后申请中',
  [AfterSalesStatus.REFUNDING]: '退款中',
  [AfterSalesStatus.EXCHANGING]: '换货中',
  [AfterSalesStatus.COMPLETED]: '售后完成',
};