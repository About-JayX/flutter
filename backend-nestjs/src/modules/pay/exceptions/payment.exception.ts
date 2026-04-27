import { HttpException, HttpStatus } from '@nestjs/common';

export class PaymentException extends HttpException {
  constructor(message: string, code = 'PAYMENT_ERROR') {
    super({ message, code }, HttpStatus.BAD_REQUEST);
  }
}
