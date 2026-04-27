import {
  Inject,
  Injectable,
  Logger,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt'; // 确保已导入
import { CACHE_MANAGER } from '@nestjs/cache-manager'; // 新的导入方式
import type { Cache } from 'cache-manager'; // v5 类型
// import Keyv from 'keyv'; // 真实类型
// import { JwtPayload } from '../types/auth.type';

import { PHONE_CONSTANTS } from '@/common/constants/phone.constant';
import { PhoneUtil } from '@/common/utils/phone.util';

import { SmsService } from './services/sms.service';
import { UsersService } from '@root/src/modules/users/users.service';
import { AUTH_TYPE, AuthType } from './constants';
import { UserAccountType } from '../users/entities/user.entity';

@Injectable()
export class AuthService {
  private readonly verificationCodesKeyPrefix = 'sms:code:';
  // private readonly verificationCodes = new Map<string, { code: string; expiresAt: number }>();
  private readonly logger = new Logger(AuthService.name);

  // ✅ 正确：直接注入 JwtService
  constructor(
    private readonly jwtService: JwtService,
    private readonly smsService: SmsService,
    private readonly usersService: UsersService,
    @Inject(CACHE_MANAGER)
    private readonly cacheManager: Cache, //v5
    // private readonly cacheManager: Keyv,
    // @Inject(CACHE_MANAGER) private cacheManager: Cache, // 注入 CacheService
  ) {}
  // constructor(private readonly jwtService: JwtService) {}

  // 生成随机验证码
  private generateCode(length: number = 6): string {
    return Math.random()
      .toString()
      .slice(2, 2 + length);
  }

  /// 验证手机+验证码
  private async checkPhoneAndCode(phone: string, code: string) {
    this.logger.log(
      'checkPhoneAndCode: ========================= 验证短信验证码开始 =========================',
    );
    /// 验证码获取
    this.logger.log(`用户传上来的数据, phone：${phone}, code: ${code}`);

    const key = `${this.verificationCodesKeyPrefix}${phone}`;
    this.logger.log('验证的的key【用key换取redis中的验证码】: ', key);

    /// 验证码验证
    const cachedCode = await this.cacheManager.get<string>(key);
    this.logger.log('获取redis中的验证码：cachedCode: ', cachedCode);
    return {
      status: !cachedCode || cachedCode !== code ? '1' : '0',
      statusInfo: !cachedCode
        ? '验证码未发送或已过期'
        : cachedCode !== code
          ? '验证码错误'
          : '验证码验证成功',
      data: {
        checkPAndC: null,
      },
    };
  }

  // 统一入口：根据类型调用不同登录逻辑
  async login(type: AuthType, payload: Record<string, any>) {
    // : Promise<{ access_token: string }>
    switch (type) {
      case AUTH_TYPE.PHONE:
        return this.loginByPhone(payload.phone, payload.code);
      default:
        throw new Error(`Unsupported auth type: ${type}`);
    }
  }
  // // ... 其余代码保持不变
  // async login(username: string, password: string): Promise<{ access_token: string }> {
  //   // 模拟用户验证逻辑
  //   // const user = await this.validateUser(username, password);
  //   // if (!user) {
  //   //   throw new UnauthorizedException('Invalid credentials');
  //   // }

  //   const payload: JwtPayload = { sub: 123, username: username };
  //   const access_token = this.jwtService.sign(payload);
  //   return {
  //     access_token,
  //   };
  // }

  // ... 其他方法

  // 发送短信验证码
  async sendSmsCode(
    phone: string,
    // options?: {
    //   user?: any;
    //   businessType?: number;
    // }
  ) {
    //: Promise<boolean>
    this.logger.log(
      'sendSmsCode: ========================= 发送短信验证码开始 =========================',
    );
    this.logger.log('phone：', phone);
    // this.logger.log("user", options?.user);
    // this.logger.log("businessType", options?.businessType);

    //
    var phoneToUse = phone;
    // const userG = options?.user;
    // const businessTypeG = options?.businessType;

    //  验证
    /// 已登录获取验证码
    // if(userG && userG.uniqid && businessTypeG == 1){
    //   this.logger.log("获取用户开始:已登录用户 - 获取验证码");
    //   const userInfo = await this.usersService.findOneByUnique(userG.uniqid);
    //   const phoneD = PhoneUtil.decrypt(userInfo.phoneEncrypted);
    //   phoneToUse = phoneD ?? phone;
    //   this.logger.log("已登录用户解密后的手机号码：", phoneD);
    //   if (!phoneD) throw new BadRequestException('无效的手机号');
    // }

    /// 手机号码获取验证码
    const normalized = PhoneUtil.normalize(phoneToUse); // → '8613812345678'
    if (!normalized) throw new BadRequestException('无效的手机号');

    //  数据
    //  key
    const key = `${this.verificationCodesKeyPrefix}${phoneToUse}`;

    //  验证码
    const code = this.generateCode(); // 6位随机数
    // Math.floor(100000 + Math.random() * 900000).toString()
    //  有效期
    //  ⚠️发送的有效期
    ///
    //  验证的有效期
    const expiresAt = Date.now() + PHONE_CONSTANTS.CODE_VALID_SECONDS * 1000; // 5分钟有效期

    //  存储
    //  map方式
    // this.verificationCodes.set(phone, { code, expiresAt });
    // 存入 Redis，自动过期
    await this.cacheManager.set(key, code, expiresAt);
    this.logger.log('sendSmsCode: 生成的验证吗');
    this.logger.log('key: ', key);
    this.logger.log('code: ', code);
    this.logger.log('expiresAt: ', expiresAt);

    //  执行
    //  实际发送短信
    //  发送
    const success = true;
    // await this.smsService.sendVerificationCode(phoneToUse, code)
    //  回调
    if (!success) {
      await this.cacheManager.del(key); // 发送失败则清理
      // this.verificationCodes.delete(phoneToUse); // 失败则清理
    }
    /// 响应
    /// 数据处理
    /// 用户类型
    ///市场测试用户账号
    let mrUserData: any;
    try {
      const userInfo = await this.usersService.findOneByPhone(phoneToUse, {
        throwIfNotFound: false,
      });
      if (userInfo && userInfo.accountType == UserAccountType.MarketReview) {
        const userType = userInfo.accountType;
        const vCode =
          userInfo.accountType == UserAccountType.MarketReview ? code : '';
        mrUserData = {
          type: userType,
          code: vCode,
        };
      }
    } catch (e) {
      this.logger.log(
        '❌：获取用户信息异常，usersService.findOneByPhone，错误为：',
        e,
      );
    }

    /// 数据组织
    // let res = {
    //     status: success? '0' : '1',
    //     statusInfo: success? '短信发送成功': '短信发送失败',
    //     data: success? mrUserData : null
    // };
    /// 回调
    return {
      status: success ? '0' : '1',
      statusInfo: success ? '短信发送成功' : '短信发送失败',
      data: success ? mrUserData : null,
    };
  }

  /// 发送短信验证码通过登录的手机号
  async sendSmsByLoginPhone(user: any) {
    this.logger.log(
      'sendSmsByLoginPhone: ========================= 发送短信验证码通过登录的手机号开始 =========================',
    );
    this.logger.log('user', user);

    //
    var phoneToUse: any;
    const userG = user;

    //  验证
    /// 已登录获取手机号
    if (userG && userG.uniqid) {
      this.logger.log('获取用户开始:已登录用户 - 获取验证码');
      const userInfo = await this.usersService.findOneByUnique(userG.uniqid);
      const phoneD = PhoneUtil.decrypt(userInfo.phoneEncrypted);
      this.logger.log('已登录用户解密后的手机号码：', phoneD);
      if (!phoneD) throw new BadRequestException('无效的手机号');
      phoneToUse = phoneD;
    } else {
      throw new NotFoundException(`已登录获取手机号: 用户 ${userG} 不存在`);
    }

    //  执行
    return this.sendSmsCode(phoneToUse);
  }

  // 手机号+验证码登录
  async loginByPhone(phone: string, code: string) {
    // : Promise<{
    //     access_token: string
    //   }>
    this.logger.log(
      'loginByPhone: ========================= 验证短信验证码开始 =========================',
    );
    this.logger.log('用户传上来的数据：');
    this.logger.log('phone：', phone);
    this.logger.log('code', code);

    // this.logger.log("系统的key数据：");
    // const key = `${this.verificationCodesKeyPrefix}${phone}`;
    // this.logger.log("key: ", key);

    //  验证用户
    //  验证码验证
    const codeCheckResult = await this.checkPhoneAndCode(phone, code);
    this.logger.log(
      'loginByPhone- codeCheckResult: codeCheckResul',
      codeCheckResult,
    );
    if (codeCheckResult && codeCheckResult['status'] == '1')
      return codeCheckResult;

    //  库取用户
    //  查库取用户 ｜ 创建用户
    //  TODO: 查库取用户
    //  用户存在：返回数据；用户不存在：创建用户并返回数据
    //  返回数据：uniqid
    this.logger.log('loginByPhone: 获取用户开始');
    const userInfo = await this.usersService.createUserByPhoneGetCodeSer(phone);
    const unique = userInfo.uniqid;
    const payload = { uniqid: unique };
    const access_token = this.jwtService.sign(payload);
    this.logger.log('用户数据：');
    this.logger.log('loginByPhone - userInfo: ', userInfo);
    this.logger.log('loginByPhone - userInfo.uniqid: ', userInfo.uniqid);
    this.logger.log('loginByPhone - access_token: ', access_token);
    //  返回用户
    //  验证码清除
    const key = `${this.verificationCodesKeyPrefix}${phone}`;
    this.logger.log('验证的的key【用key换取redis中的验证码】: ', key);
    await this.cacheManager.del(key);

    //  返回用户
    // 响应
    this.logger.log('loginByPhone: 响应用户开始');
    const respon = {
      status: '0',
      statusInfo: '登录｜注册成功', /// ⚠️：判断是注册还是登录【1、添加一个登录时间的字段；2、使用第一次行为记录
      data: {
        access_token: access_token,
        uniqid: userInfo.uniqid,
        userId: userInfo.id,
      },
    };
    this.logger.log('loginByPhone - respon: ', respon);
    return respon;
  }

  /// 验证已登录手机号
  async checkloginPhone(user: any, code: string) {
    this.logger.log(
      'checkloginPhone: ========================= 验证已登录手机号 =========================',
    );
    this.logger.log('user', user);
    this.logger.log('code', code);

    ///
    var phoneToUse: any;
    const userG = user;

    //  验证用户
    /// 已登录获取手机号
    if (userG && userG.uniqid) {
      this.logger.log('获取用户开始:已登录用户 - 验证已登录手机号');
      const userInfo = await this.usersService.findOneByUnique(userG.uniqid);
      const phoneD = PhoneUtil.decrypt(userInfo.phoneEncrypted);
      this.logger.log('已登录用户解密后的手机号码：', phoneD);
      if (!phoneD) throw new BadRequestException('无效的手机号');
      phoneToUse = phoneD;
    } else {
      throw new NotFoundException(`已登录获取手机号: 用户 ${userG} 不存在`);
    }
    /// 验证码验证
    const codeCheckResult = await this.checkPhoneAndCode(phoneToUse, code);
    this.logger.log(
      'checkloginPhone- codeCheckResult: codeCheckResul',
      codeCheckResult,
    );
    if (codeCheckResult && codeCheckResult['status'] == '1')
      return codeCheckResult;

    /// 验证码清除
    const key = `${this.verificationCodesKeyPrefix}${phoneToUse}`;
    this.logger.log('验证的的key【用key换取redis中的验证码】: ', key);
    await this.cacheManager.del(key);

    /// 返回用验证
    /// 响应
    this.logger.log('checkloginPhone: 响应用户开始');
    const respon = {
      status: '0',
      statusInfo: '已登录手机号验证成功',
      data: {
        clp: null,
      },
    };
    this.logger.log('checkloginPhone - respon: ', respon);
    return respon;
  }

  /// 更换手机号
  async changePhone(user: any, phone: string, code: string) {
    this.logger.log(
      'changePhone: ========================= 更换手机号开始 =========================',
    );
    this.logger.log('user', user);
    this.logger.log('phone：', phone);
    this.logger.log('code', code);

    ///
    const userG = user;

    //  验证用户
    /// 已登录获取手机号
    this.logger.log('获取用户开始:已登录用户 - 更换手机号');
    if (!(userG && userG.uniqid)) {
      throw new NotFoundException(`更换手机号: 用户 ${userG} 不存在`);
    }

    ///  验证码验证
    const codeCheckResult = await this.checkPhoneAndCode(phone, code);
    this.logger.log(
      'loginByPhone- codeCheckResult: codeCheckResul',
      codeCheckResult,
    );
    if (codeCheckResult && codeCheckResult['status'] == '1')
      return codeCheckResult;

    //  库取用户
    //  查库取用户 ｜ 创建用户
    //  TODO: 查库取用户
    //  用户存在：返回数据；用户不存在：创建用户并返回数据
    //  返回数据：uniqid
    this.logger.log('changePhone: 获取用户开始');
    const userInfo = await this.usersService.findOneByUnique(userG.uniqid);
    const userId = userInfo.id;
    this.logger.log('用户数据：changePhone - userInfo: ', userInfo);
    this.logger.log('用户数据：changePhone - userInfo.id: ', userId);

    // ========== 新增：校验手机号是否已存在 ==========
    this.logger.log('changePhone: 校验新手机号是否已被占用开始');
    // 1. 标准化手机号并生成hash（和更新逻辑保持一致）
    const normalizedNewPhone = PhoneUtil.normalize(phone);
    if (!normalizedNewPhone)
      throw new BadRequestException('changePhone: 无效的手机号');
    const newPhoneHash = PhoneUtil.hashForIndex(normalizedNewPhone);

    // 2. 根据phoneHash查询是否有其他用户使用该手机号
    const existingUser =
      await this.usersService.findOneByPhoneHash(newPhoneHash);

    // 3. 如果存在//且不是当前用户，返回已存在提示
    if (existingUser) {
      // && existingUser.id !== userId
      this.logger.log(
        `changePhone: 手机号 ${phone} 已被其他用户占用，用户ID: ${existingUser.id}`,
      );
      return {
        status: '1',
        statusInfo: '该手机号码已被其他账号绑定，无法更换',
        data: {
          cp: null,
        },
      };
    }
    // ========== 新增结束 ==========

    this.logger.log('changePhone: 更新手机号码开始');
    const normalized = PhoneUtil.normalize(phone); // → '8613812345678'
    if (!normalized)
      throw new BadRequestException('changePhone: 更新手机号码 - 无效的手机号');
    const phoneHash = PhoneUtil.hashForIndex(normalized);
    const phoneEncrypted = PhoneUtil.encrypt(normalized);
    const updates = {
      phoneHash: phoneHash,
      phoneEncrypted: phoneEncrypted,
    };
    const updateUserRes = await this.usersService.updateUserById(
      userId,
      updates,
    );
    this.logger.log('changePhone: updateUserRes更新情况回调:', updateUserRes);
    if (!updateUserRes) {
      return {
        status: '1',
        statusInfo: '更换手机失败！稍后重试',
        data: {
          cp: null,
        },
      };
    }

    //  返回用户
    //  验证码清除
    const key = `${this.verificationCodesKeyPrefix}${phone}`;
    this.logger.log('验证的的key【用key换取redis中的验证码】: ', key);
    await this.cacheManager.del(key);

    //  返回用户
    // 响应
    this.logger.log('changePhone: 响应用户开始');
    const respon = {
      status: '0',
      statusInfo: '更换手机号码成功',
      data: {
        myPhoneNum: PhoneUtil.mask(phone),
      },
    };
    this.logger.log('changePhone - respon: ', respon);
    return respon;
  }

  generateToken(uniqid: string): string {
    const payload = { uniqid };
    return this.jwtService.sign(payload);
  }
}
