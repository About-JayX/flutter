import { PartialType } from '@nestjs/swagger';
import { CreateBullBoardDto } from './create-bull-board.dto';

export class UpdateBullBoardDto extends PartialType(CreateBullBoardDto) {}
