import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
// import { CacheModule } from '@nestjs/cache-manager';
import { PushModule } from '@shared/push/push.module'; // 导入 PushModule
import { AuthService } from '@/modules/auth/auth.service';
import { AuthController } from '@/modules/auth/auth.controller';
import { JwtStrategy } from './strategies/jwt.strategy';
import { SmsService } from './services/sms.service';
import { UsersService } from '@root/src/modules/users/users.service';
import { User } from '@root/src/modules/users/entities/user.entity';
import { UserNamesDB } from '@root/src/modules/users/entities/usernamesdb.entity';
import { GoogleAuthService } from './social-auth/google-auth.service';
import { AppleAuthService } from './social-auth/apple-auth.service';
import { FirebaseAuthService } from './social-auth/firebase-auth.service';

// 从环境变量中获取密钥，务必保证其安全性！
const jwtSecret =
  process.env.JWT_SECRET || 'your-super-secret-key-please-change-it';

@Module({
  imports: [
    TypeOrmModule.forFeature([User, UserNamesDB]),

    // 注册 Passport 模块，并设置默认策略为 'jwt'
    PassportModule.register({
      defaultStrategy: 'jwt',
    }),
    // 注册 JWT 模块，提供密钥和签发选项
    JwtModule.register({
      secret: jwtSecret,
      signOptions: { expiresIn: '24h' }, // 设置 token 过期时间，例如 1 小时
    }),
    PushModule, // ✅ 导入 PushModule 以使用 UserPushDeviceService 等
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    JwtStrategy,
    UsersService,
    SmsService, // 注册短信服务
    GoogleAuthService,
    AppleAuthService,
    FirebaseAuthService,
  ], // 注意：必须在这里声明 JwtStrategy
  exports: [
    AuthService,
    PassportModule,
    JwtModule,
    GoogleAuthService,
    AppleAuthService,
    FirebaseAuthService,
  ], // 导出以便其他模块使用
})
export class AuthModule {}
