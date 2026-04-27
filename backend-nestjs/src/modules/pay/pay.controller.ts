import {
  Controller,
  UseGuards,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  Logger,
  HttpCode,
  HttpStatus,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiResponse,
  ApiTags,
  ApiQuery,
  ApiParam,
} from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { PayService } from './pay.service';

import { CreatePayDto } from './dto/create-pay.dto';
import { UpdatePayDto } from './dto/update-pay.dto';
import { RefundPayDto } from './dto/refund-pay.dto';

@Controller('pay')
export class PayController {
  private readonly logger = new Logger(PayController.name);

  constructor(private readonly payService: PayService) {}

  @Post('petihope/source')
  petihopeSourcPay(@Body() createPayDto: CreatePayDto) {
    return this.payService.petihopeSourcPay(createPayDto);
  }

  // =================== 标准 ================
  @Post()
  @HttpCode(HttpStatus.CREATED)
  create(@Body() createPayDto: CreatePayDto) {
    return this.payService.create(createPayDto);
  }

  @Get()
  findAll() {
    return this.payService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.payService.findOne(+id);
  }

  @Get('order/:orderId')
  findByOrderId(@Param('orderId') orderId: string) {
    return this.payService.findByOrderId(+orderId);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updatePayDto: UpdatePayDto) {
    return this.payService.update(+id, updatePayDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id') id: string) {
    return this.payService.remove(+id);
  }
}
