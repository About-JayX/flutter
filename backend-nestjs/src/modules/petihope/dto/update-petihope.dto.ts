import { PartialType } from '@nestjs/swagger';
import { CreatePetihopeDto } from './create-petihope.dto';

export class UpdatePetihopeDto extends PartialType(CreatePetihopeDto) {}
