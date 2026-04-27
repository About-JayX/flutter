// utils/order-input.util.ts
import { CreateOrderInput } from '../types/create-order-input.type'; // ✅ 正确路径
export class OrderInputFactory {
  static forPetihope(options: {
    bussinesstype: string,
    bussinessid: string,
    userId: string,
    validTime: Date,
    // validPayTime: Date,
    totalAmount: number,
    actualAmount: number,
    receiverName?: string,
    // receiverPhone: string,
    receiverPhoneEncrypted?: string,
  }
): CreateOrderInput {
    return {
        bussinesstype: options.bussinesstype,
        bussinessid: options.bussinessid,
        userId: options.userId,
        validTime: options.validTime,
        // validPayTime: options.validPayTime,
        totalAmount: options.totalAmount,
        actualAmount: options.actualAmount,
        receiverName: options.receiverName || 'none',
        // receiverPhone: options.receiverPhone,
        receiverPhoneEncrypted: options.receiverPhoneEncrypted || 'none',
    };
  }
}