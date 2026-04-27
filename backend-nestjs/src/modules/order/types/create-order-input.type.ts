// types/create-order-input.type.ts
export interface CreateOrderInput {
    bussinesstype: string;
    bussinessid: string;
    userId: string;
    validTime: Date;
    // validPayTime: Date;
    totalAmount: number;
    actualAmount: number;
    receiverName: string;
    // receiverPhone: string;
    receiverPhoneEncrypted: string;
}