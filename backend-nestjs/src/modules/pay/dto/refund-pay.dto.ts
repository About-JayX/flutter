import { IsNumber, IsString, Min } from 'class-validator';

export class RefundPayDto {
  @IsNumber()
  @Min(0.01)
  refundAmount: number;

  @IsString()
  refundReason: string;
}