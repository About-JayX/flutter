import { Test, TestingModule } from '@nestjs/testing';
import { BullBoardController } from './bull-board.controller';
import { BullBoardService } from './bull-board.service';

describe('BullBoardController', () => {
  let controller: BullBoardController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [BullBoardController],
      providers: [BullBoardService],
    }).compile();

    controller = module.get<BullBoardController>(BullBoardController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
