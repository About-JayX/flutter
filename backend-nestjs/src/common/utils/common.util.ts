import * as crypto from 'crypto';
import { randomInt, randomBytes } from 'crypto';

export class CommonUtil {
  /**
   * 生成唯一 Unique
   */
  //  SHA-1 已被证明存在碰撞风险
  //  ULID	26	时间有序、短、安全、可排序	需要额外包
  //  “nanoid@3 生成的 21 位字符串 ID” 是当前 NestJS 项目里最平衡的方案：
  static generateSecureUnique40BySHA1(): string {
    const randomBytes = crypto.randomBytes(32); // 32 字节随机数据
    return crypto
      .createHash('sha1')
      .update(randomBytes)
      .digest('hex');
  }
}