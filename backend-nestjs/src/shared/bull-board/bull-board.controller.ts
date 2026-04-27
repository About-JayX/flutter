import { Controller, Get, Res, Req, Post, Delete, Param } from '@nestjs/common';
import { Response, Request } from 'express';
import { BullBoardService } from './bull-board.service';

@Controller('admin/queues')
export class BullBoardController {
  constructor(private readonly bullBoardService: BullBoardService) {}

  // 将所有 BullBoard 路由转发到 Express 路由器
  @Get('*')
  async getBullBoard(@Req() req: Request, @Res() res: Response) {
    const router = this.bullBoardService.getRouter();
    router(req, res);
  }

  @Post('*')
  async postBullBoard(@Req() req: Request, @Res() res: Response) {
    const router = this.bullBoardService.getRouter();
    router(req, res);
  }

  @Delete('*')
  async deleteBullBoard(@Req() req: Request, @Res() res: Response) {
    const router = this.bullBoardService.getRouter();
    router(req, res);
  }
}