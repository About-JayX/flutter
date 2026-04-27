import { Module } from '@nestjs/common';
import { PushService } from './push.service';
import { PushController } from './push.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserPushDevice } from './entities/user-push-device.entity';
import { UserPushConfig } from './entities/user-push-config.entity';
import { UserPushDeviceService } from './user-push-device.service';
import { UserPushConfigService } from './user-push-config.service';
// import { AuthModule } from '@/modules/auth/auth.module';
// import { AuthController } from '@/modules/auth/auth.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      UserPushDevice, UserPushConfig
    ]),
    // AuthModule, // ✅ 通过导入 AuthModule，间接获得了 PassportModule 和 JwtModule
  ],
  controllers: [
    PushController,
    // AuthController
  ],
  providers: [
    PushService,
    UserPushDeviceService, 
    UserPushConfigService
  ],
  exports: [
    UserPushDeviceService, 
    UserPushConfigService
  ], // 供其他模块调用
})
export class PushModule {}
