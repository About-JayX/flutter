import { Injectable, Logger } from '@nestjs/common';
import * as dysmsapi from '@alicloud/dysmsapi20170525';
import { Config } from '@alicloud/openapi-client';

@Injectable()
export class SmsService {
  private readonly logger = new Logger(SmsService.name);
  private client: dysmsapi.default;

  constructor() {
    const config = new Config({
      accessKeyId: process.env.ALIBABA_CLOUD_ACCESS_KEY_ID,
      accessKeySecret: process.env.ALIBABA_CLOUD_ACCESS_KEY_SECRET,
      endpoint: 'dysmsapi.aliyuncs.com',
    });

    this.client = new dysmsapi.default(config);
  }

  async sendVerificationCode(phone: string, code: string): Promise<boolean> {
    try {
      const request = new dysmsapi.SendSmsRequest({
        phoneNumbers: phone,
        signName: process.env.SMS_SIGN_NAME || '你的签名',
        templateCode: process.env.SMS_TEMPLATE_CODE || 'SMS_123456789',
        templateParam: JSON.stringify({ code }),
      });

      const response = await this.client.sendSms(request);

      if (response?.body?.code === 'OK') {
        this.logger.log(`短信发送成功: ${phone}`);
        return true;
      } else {
        this.logger.error(`短信发送失败: ${response?.body?.message || '未知错误'}`);
        return false;
      }
    } catch (error) {
      this.logger.error(`短信发送异常: ${error.message}`);
      return false;
    }
  }
}