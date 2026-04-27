/**
 * app更新模式
 */
export enum AppUpdateMode {
  FORCE = 1,
  ByUser = 2,
  NONE = 0,
}

/**
 * 获取订单状态描述
 */
export const AppUpdateModeDescription = {
  [AppUpdateMode.FORCE]: '强制更新',
  [AppUpdateMode.ByUser]: '选择更新',
  [AppUpdateMode.NONE]: '不提示',
};