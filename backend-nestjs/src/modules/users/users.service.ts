import {
  Injectable,
  NotFoundException,
  Logger,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager, UpdateResult, In } from 'typeorm';
import * as crypto from 'crypto';
import { randomInt, randomBytes } from 'crypto';

import { PhoneUtil } from '@/common/utils/phone.util';

import { User } from './entities/user.entity';
import { UserNamesDB } from './entities/usernamesdb.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserColumn, USER_COLUMNS } from './types/user-column.type';

@Injectable()
export class UsersService {
  private readonly logger = new Logger(UsersService.name);

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(UserNamesDB)
    private readonly userNamesDBRepository: Repository<UserNamesDB>,
  ) {}

  //  SHA-1 已被证明存在碰撞风险
  //  ULID	26	时间有序、短、安全、可排序	需要额外包
  //  “nanoid@3 生成的 21 位字符串 ID” 是当前 NestJS 项目里最平衡的方案：
  private generateSecureUnique40(): string {
    const randomBytes = crypto.randomBytes(32); // 32 字节随机数据
    return crypto.createHash('sha1').update(randomBytes).digest('hex');
  }

  /**
   * 生成唯一 username
   * 策略：
   * 1. 从名字库随机选一个
   * 2. 检查是否唯一
   * 3. 若冲突，加 3 位随机数 (100-999)
   * 4. 若仍冲突，加 4 位 ULID 前缀
   */
  async generateUniqueUsername(): Promise<{
    userName: string;
    userNickName: string;
  }> {
    const totalCount = await this.userNamesDBRepository.count();
    if (totalCount === 0) throw new Error('名字库为空');

    // 随机选一个名字
    const randomIndex = randomInt(1, totalCount + 1);
    const entry = await this.userNamesDBRepository
      .createQueryBuilder()
      .skip(randomIndex - 1)
      .take(1)
      .getOne();

    if (!entry) {
      throw new Error('无法从名字库中获取条目，索引超出范围');
    }
    let baseUsername = this.shuffleString(entry.userName);
    let nickname = baseUsername;

    // 1. 检查 baseUsername 是否可用
    if (!(await this.isUsernameAvailable(baseUsername))) {
      // 2. 加 3 位随机数 (100-999)
      let candidate: string;
      let attempts = 0;
      do {
        const suffix = randomInt(100, 1000); // 100-999
        candidate = baseUsername + suffix;
        attempts++;
        if (attempts > 10) break; // 防止无限循环
      } while (!(await this.isUsernameAvailable(candidate)));

      if (attempts <= 10) {
        baseUsername = candidate;
      } else {
        // 3. 极端情况：使用 ULID 前缀
        const ulidPrefix = this.generateUlidPrefix();
        baseUsername = baseUsername + ulidPrefix;
      }
    }

    return { userName: baseUsername, userNickName: nickname };
  }
  private async isUsernameAvailable(userName: string): Promise<boolean> {
    const existing = await this.userRepository.findOne({
      where: { userName },
    });
    return !existing;
  }
  private generateUlidPrefix(): string {
    const timestamp = Date.now().toString(36).slice(-4);
    const random = randomBytes(2).toString('base64url').slice(0, 4);
    return (timestamp + random).replace(/[^a-zA-Z0-9]/g, '').slice(0, 4);
  }

  private shuffleString(str: string): string {
    const array = str.split('');
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]];
    }
    return array.join('');
  }

  create(createUserDto: CreateUserDto) {
    return 'This action adds a new user';
  }
  async createUserByPhoneGetCodeSer(phonenum: string): Promise<User> {
    //  判断用户是否存在
    /// 明文
    // const existingUser = await this.userRepository.findOne({
    //   where: { phonenum },
    // });
    /// hash
    const normalized = PhoneUtil.normalize(phonenum); // → '8613812345678'
    if (!normalized) throw new BadRequestException('无效的手机号');
    const phoneHash = PhoneUtil.hashForIndex(normalized);
    // 1. 先按新方式查（优先）
    let existingUser = await this.userRepository.findOne({
      where: { phoneHash },
    });
    /// ⚠️：老用户废弃中
    // if (!existingUser) {
    //   // 2. 如果没找到，尝试按旧明文查（兼容老用户）
    //   const extractLocalNumber = PhoneUtil.extractLocalNumber(phonenum);
    //   if (!extractLocalNumber) throw new BadRequestException('无效的手机号');
    //   existingUser = await this.userRepository.findOne({
    //     where: { phonenum: extractLocalNumber } // 或 inputPhone？看你怎么存的
    //   });
    //   // 3. 如果老用户存在，立即“升级”为新格式（在线迁移）
    //   if (existingUser) {
    //     /// 更新老用户
    //       existingUser.phoneHash = phoneHash;
    //       existingUser.phoneEncrypted = PhoneUtil.encrypt(normalized);
    //       const userResult = await this.userRepository.save(existingUser);

    //     // 可选：清空或保留 phonenum（建议保留一段时间）
    //       ///

    //     /// 测试手机解密效果
    //       // const phoneD = PhoneUtil.decrypt(userResult.phoneEncrypted);
    //       // if (!phoneD) throw new BadRequestException('无效的手机号');
    //       // const phoneDEx = PhoneUtil.extractLocalNumber(phoneD);
    //       // if (!phoneDEx) throw new BadRequestException('无效的手机号', phoneDEx ?? phoneD);
    //       // const phoneDDrag = PhoneUtil.mask(phoneDEx);
    //       // this.logger.log("测试将保存的加密手机号解密", phoneDDrag);
    //   }
    // }

    //  用户存在：返回数据
    if (existingUser) return existingUser;

    //  用户不存在：创建用户并返回数据
    //  数据组织
    //1、唯一标志
    const uniqid = this.generateSecureUnique40();
    //2、注册方式-手机号码
    //  phonenum废弃
    //  phoneHash
    // const normalized = PhoneUtil.normalize(phonenum); // → '8613812345678'
    // if (!normalized) throw new BadRequestException('无效的手机号');
    // const phoneHash = PhoneUtil.hashForIndex(normalized);
    //  phoneEncrypted
    const phoneEncrypted = PhoneUtil.encrypt(normalized);
    //3、用户名和用户昵称
    const { userName, userNickName } = await this.generateUniqueUsername();

    // 创建用户
    try {
      const userInfoCreate = this.userRepository.create({
        uniqid,
        // phonenum,
        phoneHash,
        phoneEncrypted,
        userName,
        userNickName,
      });
      return await this.userRepository.save(userInfoCreate);
    } catch (error) {
      // 处理可能的并发冲突
      // 1、（两个请求同时注册同一手机号）
      if (error.code === 'ER_DUP_ENTRY' || error.code === '23505') {
        // MySQL 或 PostgreSQL 唯一约束冲突
        return await this.userRepository.findOneOrFail({
          where: { phoneHash },
        });
        // return await this.userRepository.findOneOrFail({ where: { phonenum } });
      }
      throw error;
    }
  }

  /**
   * 按主键查，只返回指定字段
   */
  async findOnePick<K extends UserColumn>(
    id: number,
    fields: K[],
  ): Promise<Pick<User, K>> {
    // 运行期防护：防止手滑写错
    const invalid = fields.filter((f) => !USER_COLUMNS.includes(f));
    if (invalid.length) throw new Error(`Invalid fields: ${invalid.join(',')}`);

    return this.userRepository
      .createQueryBuilder('u')
      .select(fields.map((f) => `u.${f}` as const))
      .where('u.id = :id', { id })
      .getOneOrFail() as unknown as Pick<User, K>;
  }

  /**
   * 根据 Phone 查找用户
   * @param uniqueId 唯一标识符
   * @returns Promise<User | undefined>
   */
  /// findOneByUnique添加事务选型版本
  async findOneByPhone(
    phone: string,
    options?: {
      repo?: Repository<User>;
      throwIfNotFound?: boolean; // 是否在找不到时抛异常
    },
    // repo?: Repository<User>,
    // throwIfNotFound?: boolean, // 是否在找不到时抛异常
  ): Promise<User | null> {
    // 设置默认值
    const throwIfNotF = options?.throwIfNotFound ?? true; // 默认 true
    const repository = options?.repo ?? this.userRepository; // 优先使用传入的 repo

    /// hash
    const normalized = PhoneUtil.normalize(phone); // → '8613812345678'
    if (!normalized) throw new BadRequestException('无效的手机号');
    const phoneHash = PhoneUtil.hashForIndex(normalized);
    let user = await repository.findOne({
      where: { phoneHash },
    });
    if (!user) {
      // 2. 如果没找到，尝试按旧明文查（兼容老用户）
      const extractLocalNumber = PhoneUtil.extractLocalNumber(phone);
      if (!extractLocalNumber) throw new BadRequestException('无效的手机号');
      user = await this.userRepository.findOne({
        where: { phonenum: extractLocalNumber },
      });
      if (!user && throwIfNotF == true) {
        const phoneDDrag = PhoneUtil.mask(extractLocalNumber);
        throw new NotFoundException(`用户 ${phoneDDrag} 不存在`);
      }
    }
    return user;
  }

  /**
   * 查询用户的PhoneStart
   */
  async getPhoneStar(uniqid: string) {
    const repository = this.userRepository;
    const user = await repository.findOne({
      where: { uniqid },
    });
    if (!user) {
      throw new NotFoundException(`用户 ${uniqid} 不存在`);
    }

    const phoneD = PhoneUtil.decrypt(user.phoneEncrypted);
    if (!phoneD) throw new BadRequestException('无效的手机号');
    const phoneDEx = PhoneUtil.extractLocalNumber(phoneD);
    if (!phoneDEx)
      throw new BadRequestException('无效的手机号', phoneDEx ?? phoneD);
    const phoneDDrag = PhoneUtil.mask(phoneDEx);
    this.logger.log('将保存的加密手机号解密加星号', phoneDDrag);
    return phoneDDrag;
  }

  async findOneByPhoneHash(
    phoneHash: string,
    repo?: Repository<User>, // 可选的 Repository 参数，和 findOneByUnique 保持一致
  ): Promise<User | null> {
    //User | undefined | null
    // 优先使用传入的 repo，没有则使用类自身的 userRepository
    const repository = repo ?? this.userRepository;

    // 根据 phoneHash 查询用户
    const user = await repository.findOne({
      where: { phoneHash }, // 匹配数据库中的 phoneHash 字段
    });

    // 注意：这里不主动抛异常！因为更换手机号场景下，"手机号不存在"是正常情况
    // 仅在需要强制校验用户存在的场景下，才需要抛异常（可参考 findOneByUnique）
    return user;
  }

  /**
   * 根据 uniqueId 查找用户
   * @param uniqueId 唯一标识符
   * @returns Promise<User | undefined>
   */
  /// findOneByUnique添加事务选型版本
  async findOneByUnique(
    uniqid: string,
    repo?: Repository<User>,
  ): Promise<User> {
    const repository = repo ?? this.userRepository;
    const user = await repository.findOne({
      where: { uniqid },
    });
    if (!user) {
      throw new NotFoundException(`用户 ${uniqid} 不存在`);
    }
    return user;
  }

  async findByUniqids(uniqids: string[]): Promise<User[]> {
    if (uniqids.length === 0) return [];
    return this.userRepository.find({
      where: { uniqid: In(uniqids) },
      select: ['uniqid', 'userName', 'userNickName', 'avatar'],
    });
  }
  /// findOneByUnique普通版本
  // async findOneByUnique(uniqid: string): Promise<User> {
  //   const user = await this.userRepository.findOne({
  //     where: { uniqid },
  //   });
  //   if (!user) {
  //     throw new NotFoundException(`用户 ${uniqid} 不存在`);
  //   }
  //   return user;
  // }
  ///  专门的事物版本：EntityManager
  // async findOneByUniqueWithManager(
  //   uniqid: string,
  //   manager: EntityManager
  // ) {
  //   return manager.getRepository(User).findOne({ where: { uniqid } });
  // }

  findOne(id: number) {
    return `This action returns a #${id} user`;
  }

  /**
   * 查多条，同样动态字段
   */
  // async findManyPick<K extends UserColumn>(
  //   fields: K[],
  //   where?: Partial<User>,
  // ): Promise<Pick<User, K>[]> {
  //   const invalid = fields.filter(f => !USER_COLUMNS.includes(f));
  //   if (invalid.length) throw new Error(`Invalid fields: ${invalid.join(',')}`);

  //   return this.userRepository.find({
  //     select: fields as (keyof User)[],
  //     where,
  //   });
  // }
  findAll() {
    return `This action returns all users`;
  }

  async incrementDivideSourceMoney(
    userId: string,
    amount: number,
    manager: EntityManager,
  ): Promise<void> {
    if (amount <= 0) throw new ConflictException('Amount must be positive');

    // 原子累加，返回 UpdateResult
    const up = await manager
      .createQueryBuilder()
      .update(User)
      .set({
        divideSourceMoney: () => 'divide_source_money + :amt',
        withdrawSourceMoney: () => 'withdraw_source_money + :amt',
      })
      .where('id = :userId', { userId })
      .setParameter('amt', amount) // 参数绑定，零注入
      .execute();

    /* 明确区分“用户不存在” vs “其他错误” */
    if (up.affected === 0) {
      const user = await manager.findOneBy(User, { id: userId });
      if (!user) throw new ConflictException('User not found');
      // 如果以后加“上限”校验，这里可以继续细化
      throw new ConflictException('Update divide/withdraw failed');
    }
  }
  // async incrementDivideSourceMoney(userId: string, amount: number, manager: EntityManager) {
  //   await manager.update(User, userId, {
  //     divideSourceMoney: () => `COALESCE(divide_source_money, 0) + ${amount}`,
  //     withdrawSourceMoney: () => `COALESCE(withdraw_source_money, 0) + ${amount}`,
  //   });
  // }

  /**
   * 扣减用户的可提现额度（用于提现申请）
   * @param userId 用户ID
   * @param amount 要扣减的金额
   */
  async decrementAvailableWithdrawal(
    userId: string,
    amount: number,
  ): Promise<void> {
    if (amount <= 0) throw new BadRequestException('Amount must be positive');

    // 返回“实际变化的行数”
    const res: UpdateResult = await this.userRepository
      .createQueryBuilder()
      .update(User)
      .set({
        withdrawSourceMoney: () => `withdraw_source_money - :amount`,
      })
      .where('id = :userId', { userId })
      .andWhere('withdraw_source_money >= :amount', { amount }) // 关键：原子校验
      .setParameters({ amount })
      .execute();

    if (res.affected === 0) {
      // 能走到这里说明“用户不存在”或“余额不足”，再查一次区分
      const user = await this.userRepository.findOneBy({ id: userId });
      if (!user) throw new NotFoundException('User not found');
      throw new ConflictException('Insufficient withdraw balance');
    }
  }

  /**
   * 更新用户手机号码
   * @param userId 用户ID
   * @param phone 要更新的号码
   */
  // async updateUserPhoneById(
  //   id: string,
  //   phone: string,
  // ) {
  //   this.logger.log('usersservice updateUserPhoneById 进入, id：', id);
  //   this.logger.log('usersservice updateUserPhoneById 进入, updates：', phone);

  //   if (!user) {
  //     throw new NotFoundException(`updateUserPhoneById User with ID ${id} not found`);
  //   }

  //   return this.userRepository.save(user);
  // }

  async updateUserById(id: string, updates: Partial<User>) {
    this.logger.log('usersservice: updateUserById 进入, id：', id);
    this.logger.log('usersservice: updateUserById 进入, updates：', updates);
    const user = await this.userRepository.preload({
      id,
      ...updates,
    });

    if (!user) {
      throw new NotFoundException(
        `updateUserById - User with ID ${id} not found`,
      );
    }

    return this.userRepository.save(user);
  }
  async updateUserByIdManage(
    id: number,
    updates: Partial<User>,
    manager: EntityManager,
  ) {
    this.logger.log('在订单service中：updateUserByIdManage');
    this.logger.log('在订单service中 id：', id);
    this.logger.log('在订单service中 updates', updates);

    // 更新记录
    return await manager.getRepository(User).update(id, updates);
  }

  async updateUser(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    this.logger.log('usersservice updateUser 进入, 参数是：', updateUserDto);
    const user = await this.userRepository.preload({
      id,
      ...updateUserDto,
    });

    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return this.userRepository.save(user); // 👈 只更新传入的字段
  }

  update(id: number, updateUserDto: UpdateUserDto) {
    return `This action updates a #${id} user`;
  }

  remove(id: number) {
    return `This action removes a #${id} user`;
  }

  async findOneByGoogleId(googleId: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { googleId },
    });
  }

  async findOneByAppleId(appleId: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { appleId },
    });
  }

  async createUserByGoogle(googleUserInfo: {
    googleId: string;
    email: string;
    name: string;
    picture?: string;
  }): Promise<User> {
    const uniqid = this.generateSecureUnique40();
    const { userName, userNickName } = await this.generateUniqueUsername();

    const user = this.userRepository.create({
      uniqid,
      googleId: googleUserInfo.googleId,
      userName,
      userNickName,
      avatar: googleUserInfo.picture,
    });

    return this.userRepository.save(user);
  }

  async createUserByApple(appleUserInfo: {
    appleId: string;
    email?: string;
    isPrivateEmail?: boolean;
  }): Promise<User> {
    const uniqid = this.generateSecureUnique40();
    const { userName, userNickName } = await this.generateUniqueUsername();

    const user = this.userRepository.create({
      uniqid,
      appleId: appleUserInfo.appleId,
      userName,
      userNickName,
    });

    return this.userRepository.save(user);
  }

  async findOneByFirebaseUid(firebaseUid: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { firebaseUid },
    });
  }

  async findOneByEmail(email: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { email },
    });
  }

  async createUserByFirebase(firebaseUserInfo: {
    uid: string;
    email: string;
    name?: string;
    picture?: string;
  }): Promise<User> {
    const uniqid = this.generateSecureUnique40();
    const { userName, userNickName } = await this.generateUniqueUsername();

    const user = this.userRepository.create({
      uniqid,
      firebaseUid: firebaseUserInfo.uid,
      email: firebaseUserInfo.email,
      userName,
      userNickName: firebaseUserInfo.name || userNickName,
      avatar: firebaseUserInfo.picture,
    });

    return this.userRepository.save(user);
  }

  async bindFirebaseUid(userId: string, firebaseUid: string): Promise<void> {
    await this.userRepository.update(userId, { firebaseUid });
  }

  async updateProfile(uniqid: string, updateProfileDto: any): Promise<User> {
    const user = await this.findOneByUnique(uniqid);

    if (updateProfileDto.gender && user.gender) {
      throw new BadRequestException('性别一旦设置不可修改');
    }
    if (updateProfileDto.birthDate && user.birthDate) {
      throw new BadRequestException('出生日期一旦设置不可修改');
    }

    const updates: any = { ...updateProfileDto };
    if (updateProfileDto.isStatusPublic !== undefined) {
      updates.isStatusPublic = updateProfileDto.isStatusPublic ? 1 : 0;
    }
    if (updateProfileDto.blurProfileCard !== undefined) {
      updates.blurProfileCard = updateProfileDto.blurProfileCard ? 1 : 0;
    }

    Object.assign(user, updates);
    return this.userRepository.save(user);
  }

  async getProfile(uniqid: string): Promise<User> {
    return this.findOneByUnique(uniqid);
  }

  async updatePrivacySettings(
    uniqid: string,
    privacySettingsDto: any,
  ): Promise<User> {
    const user = await this.findOneByUnique(uniqid);
    user.privacySettings = {
      ...user.privacySettings,
      ...privacySettingsDto,
    };
    return this.userRepository.save(user);
  }

  async getPrivacySettings(uniqid: string): Promise<any> {
    const user = await this.findOneByUnique(uniqid);
    return (
      user.privacySettings || {
        hideAge: false,
        hideCountry: false,
        hideOnlineStatus: false,
        profileVisibility: 'everyone',
        allowStrangerMessage: true,
      }
    );
  }

  async markPersonalized(uniqid: string): Promise<User> {
    this.logger.log(`usersservice: markPersonalized 进入, uniqid：${uniqid}`);
    const user = await this.findOneByUnique(uniqid);
    user.personalizeEdit = 1;
    return this.userRepository.save(user);
  }

  async checkIsEarlyUser(): Promise<boolean> {
    const count = await this.userRepository.count();
    return count <= 100;
  }
}
