import { Test, TestingModule } from '@nestjs/testing';
import { PetihopeService } from './petihope.service';

describe('PetihopeService', () => {
  let service: PetihopeService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PetihopeService],
    }).compile();

    service = module.get<PetihopeService>(PetihopeService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
