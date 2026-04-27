import { Injectable, BadRequestException, Logger, } from '@nestjs/common';
import { CreateCommonDto } from './dto/create-common.dto';
import { UpdateCommonDto } from './dto/update-common.dto';
import { PhoneUtil } from '@/common/utils/phone.util';

@Injectable()
export class CommonService {
  private readonly logger = new Logger(CommonService.name);

  create(createCommonDto: CreateCommonDto) {
    return 'This action adds a new common';
  }

  /**
   * 将加密手机号码转成star
   */
    async encryptedPhoneToStar(
      encryptedPhone: string,
    ){
      const phoneD = PhoneUtil.decrypt(encryptedPhone);
      if (!phoneD) throw new BadRequestException('无效的手机号');
      const phoneDEx = PhoneUtil.extractLocalNumber(phoneD);
      if (!phoneDEx) throw new BadRequestException('无效的手机号', phoneDEx ?? phoneD);
      const phoneDDrag = PhoneUtil.mask(phoneDEx);
      this.logger.log("将保存的加密手机号解密加星号", phoneDDrag);
      return phoneDDrag;
    }

  findAll() {
    return `This action returns all common`;
  }

  findOne(id: number) {
    return `This action returns a #${id} common`;
  }

  update(id: number, updateCommonDto: UpdateCommonDto) {
    return `This action updates a #${id} common`;
  }

  remove(id: number) {
    return `This action removes a #${id} common`;
  }
}
