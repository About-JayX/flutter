import { IsString} from 'class-validator';

export class StatusInfo {
  @IsString()
  status: string;

  @IsString()
  statusInfo: string;
}