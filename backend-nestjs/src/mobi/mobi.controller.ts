import { Controller, Get } from '@nestjs/common';
import { Public } from '@/modules/auth/decorators/public.decorator';

@Controller('mobi')
export class MobiController {
  @Get()
  getHello() {
    return { message: 'Hello from mobi module!' };
  }

  @Public()
  @Get('test')
  getTest() {
    return { message: 'Test endpoint without token validation!' };
  }
}
