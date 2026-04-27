import { Test, TestingModule } from '@nestjs/testing';
import { PetihopeController } from './petihope.controller';
import { PetihopeService } from './petihope.service';

describe('PetihopeController', () => {
  let controller: PetihopeController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PetihopeController],
      providers: [PetihopeService],
    }).compile();

    controller = module.get<PetihopeController>(PetihopeController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
