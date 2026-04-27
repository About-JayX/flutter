/**
 * 现场状态枚举
 */
//  是否已进入现场
export enum SceneStatus {
  PENDING_SCENE = 0,      // 未进入
  PENDING_ENTER = 1,      // 已进入
  PENDING_ENING = 2,      // 进入中
}
//  现场响应状态 
export enum SceneResponseStatus {
  AUTO = 1,      // 自动响应
  MANUEL = 0,     // 手动响应
}

/**
 * 现场状态描述
 */
export const SceneStatusDescription = {
  [SceneStatus.PENDING_SCENE]: '未进入',
  [SceneStatus.PENDING_ENTER]: '已进入',
};

export const SceneResponseStatusDescription = {
  [SceneResponseStatus.AUTO]: '自动响应',
  [SceneResponseStatus.MANUEL]: '手动响应',
};