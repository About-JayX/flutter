// src/common/utils/phone.util.ts

import {
  PhoneNumberFormat,
  PhoneNumberUtil,
  PhoneNumber,
} from 'google-libphonenumber';
import * as crypto from 'crypto';

// // 密钥和加密配置（建议从环境变量读取）
// const PHONE_ENCRYPTION_KEY = Buffer.from(
//   process.env.PHONE_ENCRYPTION_KEY || '32-byte-long-secret-key-for-phone', // 必须 32 字节
//   'utf-8'
// ).subarray(0, 32); // 确保 32 字节

// const PHONE_HASH_SALT = process.env.PHONE_HASH_SALT || 'your-salt-for-phone-hashing';
// const ALGORITHM = 'aes-256-gcm';
// const IV_LENGTH = 12; // GCM 推荐 12 字节
// const AUTH_TAG_LENGTH = 16;

// 密钥必须是 32 字节（AES-256）
const PHONE_ENCRYPTION_KEY = Buffer.from(
  (process.env.PHONE_ENCRYPTION_KEY || '32-byte-long-secret-key-for-phone').padEnd(32).slice(0, 32),
  'utf-8'
);
const PHONE_HASH_SALT = process.env.PHONE_HASH_SALT || 'your-salt-for-phone-hashing'
const ALGORITHM = 'aes-256-gcm';
const IV_LENGTH = 12; // GCM 推荐 12 字节
const AUTH_TAG_LENGTH = 16;

export class PhoneUtil {
  private static phoneUtil = PhoneNumberUtil.getInstance();

    /**
     * 从任意格式的手机号中提取纯本地号码（不含国家码）
     * @param phoneInput 用户输入的手机号（如 '+8613812345678', '8613812345678', '13812345678'）
     * @param defaultRegion 可选：当输入无国家码时的默认国家（如 'CN'）
     * @returns 本地号码字符串（如 '13812345678'）或 null
     */
    static extractLocalNumber(phoneInput: string, defaultRegion = 'CN'): string | null {
      try {
          // 解析号码（自动处理 +86 / 86 / 0086 / (86) 等格式）
          const phoneNumber: PhoneNumber = this.phoneUtil.parse(phoneInput, defaultRegion);
          // 验证是否有效
          if (!this.phoneUtil.isValidNumber(phoneNumber)) {
          return null;
          }
          // 获取本地号码（不含国家码）
          const nationalNumber = phoneNumber.getNationalNumber().toString();
          return nationalNumber;
      } catch (error) {
          return null; // 无效号码
      }
    }

  /**
   * 标准化手机号为 E.164 纯数字格式（不含 '+'），如 '8613812345678'
   * @param phone 用户输入的手机号（可带 +86、( )、-、空格等）
   * @param defaultRegion 默认国家码（如 'CN'），用于解析无国家码的号码
   * @returns 标准化后的纯数字字符串，或 null（无效）
   */
  static normalize(phone: string, defaultRegion = 'CN'): string | null {
    try {
      if (!phone) return null;
      const cleaned = phone.replace(/\s+/g, '');
      const number: PhoneNumber = this.phoneUtil.parse(cleaned, defaultRegion);
      if (this.phoneUtil.isValidNumber(number)) {
        const e164 = this.phoneUtil.format(number, PhoneNumberFormat.E164);
        return e164.replace('+', ''); // 返回纯数字，如 '8613812345678'
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  /**
   * 验证手机号是否有效（基于 libphonenumber）
   */
  static isValid(phone: string, defaultRegion = 'CN'): boolean {
    return this.normalize(phone, defaultRegion) !== null;
  }

  /**
   * 对标准化后的手机号进行 AES-GCM 加密（确定性加密需固定 IV？不！我们允许随机 IV，但查询时不能直接查）
   * ⚠️ 注意：此加密是非确定性的（每次结果不同），**不能用于数据库查询索引**！
   * 如需可查询，请使用 hashForIndex() + encryptForStorage() 分离设计。
   */
  static encrypt(phone: string): string {
    const iv = crypto.randomBytes(IV_LENGTH); // 随机 IV，保证安全性
    const cipher = crypto.createCipheriv(ALGORITHM, PHONE_ENCRYPTION_KEY, iv);
    // 可选：设置附加认证数据（AAD）
    cipher.setAAD(Buffer.from('phone'));
    const encrypted = Buffer.concat([
      cipher.update(phone, 'utf8'),
      cipher.final()
    ]);
    const authTag = cipher.getAuthTag(); // GCM 模式需要 Auth Tag
    // 拼接 iv:encrypted:authTag，用 hex 编码便于存储
    return `${iv.toString('hex')}:${encrypted.toString('hex')}:${authTag.toString('hex')}`;
  }
//   static encrypt(phone: string): string {
//     const iv = crypto.randomBytes(IV_LENGTH);
//     const cipher = crypto.createCipher(ALGORITHM, PHONE_ENCRYPTION_KEY);
//     cipher.setAAD(Buffer.from('phone'));
//     const encrypted = Buffer.concat([cipher.update(phone, 'utf8'), cipher.final()]);
//     const authTag = cipher.getAuthTag();

//     // 拼接 iv:encrypted:authTag，用 hex 编码
//     return `${iv.toString('hex')}:${encrypted.toString('hex')}:${authTag.toString('hex')}`;
//   }

  /**
   * 解密手机号
   */
  static decrypt(encryptedPhone: string): string | null {
    try {
      const parts = encryptedPhone.split(':');
      if (parts.length !== 3) return null;
      const [ivHex, encryptedHex, authTagHex] = parts;
      const iv = Buffer.from(ivHex, 'hex');
      const encrypted = Buffer.from(encryptedHex, 'hex');
      const authTag = Buffer.from(authTagHex, 'hex');
      const decipher = crypto.createDecipheriv(ALGORITHM, PHONE_ENCRYPTION_KEY, iv);
      decipher.setAAD(Buffer.from('phone'));
      decipher.setAuthTag(authTag);
      const decrypted = Buffer.concat([
        decipher.update(encrypted),
        decipher.final()
      ]);
      return decrypted.toString('utf8');
    } catch (error) {
      // 解密失败（如密钥错、数据篡改）
      return null;
    }
  }

//   static decrypt(encryptedPhone: string): string | null {
//     try {
//       const [ivHex, encryptedHex, authTagHex] = encryptedPhone.split(':');
//       if (!ivHex || !encryptedHex || !authTagHex) return null;

//       const decipher = crypto.createDecipher(ALGORITHM, PHONE_ENCRYPTION_KEY);
//       decipher.setAAD(Buffer.from('phone'));
//       decipher.setAuthTag(Buffer.from(authTagHex, 'hex'));
//       const decrypted = Buffer.concat([
//         decipher.update(Buffer.from(encryptedHex, 'hex')),
//         decipher.final(),
//       ]);
//       return decrypted.toString('utf8');
//     } catch (error) {
//       return null; // 解密失败
//     }
//   }

  /**
   * 生成用于数据库唯一索引的哈希值（确定性！相同输入 → 相同输出）
   * 用于“该手机号是否已注册”查询
   */
  static hashForIndex(normalizedPhone: string): string {
    return crypto
      .createHash('sha256')
      .update(normalizedPhone + PHONE_HASH_SALT)
      .digest('hex');
  }

  /**
   * 脱敏手机号（用于日志、接口返回）
   * 输入：'8613812345678' → 输出：'138****5678'
   */
  static mask(normalizedPhone: string): string {
    // 去掉国家码，只保留本地号码部分（简单处理，适用于中国）
    // 更健壮做法：用 libphonenumber 提取 national number
    let localNumber = normalizedPhone;
    if (normalizedPhone.startsWith('86') && normalizedPhone.length === 13) {
      localNumber = normalizedPhone.slice(2);
    } else if (normalizedPhone.length >= 10) {
      // 通用截取后11位（假设最短10位）
      localNumber = normalizedPhone.slice(-11);
    }

    if (localNumber.length < 7) return localNumber;
    return `${localNumber.slice(0, 3)}****${localNumber.slice(-4)}`;
  }
}