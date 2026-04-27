export interface PaymentStrategy {
  createPayment(data: any): Promise<any>;
  handleNotify(rawData: any, signature: string): Promise<boolean>;
  queryOrder(orderId: string): Promise<any>;
  closeOrder(orderId: string): Promise<any>;
  refund(orderId: string, amount: number): Promise<any>;
}