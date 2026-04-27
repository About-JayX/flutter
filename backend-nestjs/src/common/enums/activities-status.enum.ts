/**
 * 业务类型枚举
 */
//  1、businessId: 表的id字段

export enum ActivitiesStatus {
  PENDING = 'pending',     // 等待开始
  ONGOING = 'ongoing',     // 进行中
  COMPLETED = 'completed', // 已完成
  CANCELLED = 'cancelled', // 已取消
}

/**
 * 获取业务类型描述
 */
export const ActivitiesStatusDescription = {
  [ActivitiesStatus.PENDING]: '等待开始',
  [ActivitiesStatus.ONGOING]: '进行中',
  [ActivitiesStatus.COMPLETED]: '已完成',
  [ActivitiesStatus.CANCELLED]: '已取消',
};