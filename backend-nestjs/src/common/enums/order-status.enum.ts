/**
 * 订单状态枚举
 */
export enum OrderStatus {
  PENDING_PAYMENT = 0,      // 待付款
  PENDING_SHIPMENT = 1,     // 待发货
  SHIPPED = 2,              // 已发货/待收货
  COMPLETED = 3,            // 已完成
  CANCELLED = 4,            // 已取消：用户取消订单，暂无
  REFUNDING = 5,            // 退款中
  REFUNDED = 6,             // 已退款
  CLOSED = 7,                // 已关闭
}

/**
 * 获取订单状态描述
 */
export const OrderStatusDescription = {
  [OrderStatus.PENDING_PAYMENT]: '待付款',
  [OrderStatus.PENDING_SHIPMENT]: '待发货',
  [OrderStatus.SHIPPED]: '已发货',
  [OrderStatus.COMPLETED]: '已完成',
  [OrderStatus.CANCELLED]: '已取消',
  [OrderStatus.REFUNDING]: '退款中',
  [OrderStatus.REFUNDED]: '已退款',
  [OrderStatus.CLOSED]: '已关闭',
};