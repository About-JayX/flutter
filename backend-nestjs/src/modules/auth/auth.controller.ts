import {
  Controller,
  Post,
  Body,
  UseGuards,
  Req,
  Res,
  UsePipes,
  ValidationPipe,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { AuthService } from '@/modules/auth/auth.service';
import { LoginByPhoneDto } from './dto/login-by-phone.dto';
import { CheckLoginPhoneDto } from './dto/check-login-phone.dto';
import { SendSmsDto } from './dto/send-sms.dto';
import { GoogleLoginDto } from './dto/google-login.dto';
import { AppleLoginDto } from './dto/apple-login.dto';
import { FirebaseAuthDto } from './dto/firebase-auth.dto';
import { AUTH_TYPE } from './constants';
import { Public } from './decorators/public.decorator';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';
import { UserPushDeviceService } from '@/shared/push/user-push-device.service';
import { UserPushConfigService } from '@/shared/push/user-push-config.service';
import { GoogleAuthService } from './social-auth/google-auth.service';
import { AppleAuthService } from './social-auth/apple-auth.service';
import { FirebaseAuthService } from './social-auth/firebase-auth.service';
@Controller('auth')
@ApiTags('认证') // Swagger 标签
export class AuthController {
  private readonly logger = new Logger(AuthController.name);
  constructor(
    private readonly authService: AuthService,
    private readonly pushDeviceService: UserPushDeviceService,
    private readonly pushConfigService: UserPushConfigService,
    private readonly googleAuthService: GoogleAuthService,
    private readonly appleAuthService: AppleAuthService,
    private readonly firebaseAuthService: FirebaseAuthService,
  ) {}

  @Public() // ✅ 不需要登录
  @Post('login')
  @ApiOperation({ summary: '用户名密码登录' })
  @ApiResponse({ status: 200, description: '成功返回 JWT' })
  async loginWithPassword(
    @Body() loginDto: { username: string; password: string },
  ) {
    return this.authService.login(AUTH_TYPE.USERNAME_PASSWORD, loginDto);
  }
  // @Post('login')
  // @ApiOperation({ summary: '用户登录' })
  // @ApiResponse({ status: 200, description: '成功返回 JWT' })
  // @ApiResponse({ status: 401, description: '认证失败' })
  // async login(
  //   @Body() loginDto: { username: string; password: string },
  // ) {
  //   return this.authService.login(loginDto.username, loginDto.password);
  // }

  @Public() // ✅ 不需要登录
  @Post('send-sms')
  @ApiOperation({ summary: '发送短信验证码' })
  async sendSms(
    // @CurrentUser() user: any,//  ArgsAuthDto
    @Body() body: SendSmsDto,
    @Req() req: Request,
  ) {
    const responseData = await this.authService.sendSmsCode(
      body.params.phone,
      // {user: user,
      //   businessType: body.params.businessType,
      // }
    );
    req.customBody = responseData;
    return responseData; // success ? { message: '验证码已发送' } : { message: '发送失败' }
  }

  @Post('send-sms-byLoginPhone')
  @ApiOperation({ summary: '验证登录手机号码获取验证码' })
  async sendSmsByLoginPhone(
    @CurrentUser() user: any, //  ArgsAuthDto
    @Req() req: Request,
  ) {
    const responseData = await this.authService.sendSmsByLoginPhone(user);
    req.customBody = responseData;
    return responseData; // success ? { message: '验证码已发送' } : { message: '发送失败' }
  }

  @Public() // ✅ 不需要登录
  @Post('login-by-phone')
  @ApiOperation({ summary: '手机号+验证码登录' })
  @UsePipes(
    new ValidationPipe({
      transform: true, // 关键：自动转换请求体为DTO实例
      whitelist: true, // 可选：过滤掉DTO中未定义的字段
    }),
  )
  async loginByPhone(@Body() body: LoginByPhoneDto, @Req() req: Request) {
    /// 核心
    /// 登录服务
    const responseData = await this.authService.login(AUTH_TYPE.PHONE, {
      phone: body.params.phone,
      code: body.params.code,
    });
    req.customBody = responseData;

    /// 可选
    /// 推送
    // 前端传了pushInfo则处理，没传则为undefined
    this.logger.log('loginByPhone, body.params: ', body.params);
    this.logger.log('loginByPhone, pushInfo: ', body.params.pushInfo);
    this.logger.log('loginByPhone, responseData: ', responseData);
    if (
      body.params.pushInfo?.rid &&
      responseData.status == '0' &&
      responseData.data &&
      'userId' in responseData.data && // 关键：检查是否有userId属性
      responseData.data.userId // 双重确认：userId有值
    ) {
      this.logger.log('✅loginByPhone, 登录成功而且有推送数据: ');
      // 调用保存推送信息的方法
      const pushResult = await this.pushDeviceService.saveOrUpdatePushDevice(
        responseData.data.userId,
        body.params.pushInfo,
      );
      this.logger.log('✅loginByPhone, 推送信息保存结果: ', pushResult);
    }
    return responseData;
  }

  @Post('check-login-phone')
  @ApiOperation({ summary: '验证已登录手机号' })
  async checkloginPhone(
    @CurrentUser() user: any, //  ArgsAuthDto
    @Body() body: CheckLoginPhoneDto,
    @Req() req: Request,
  ) {
    const responseData = await this.authService.checkloginPhone(
      user,
      body.params.code,
    );
    req.customBody = responseData;
    return responseData;
  }

  @Post('change-phone')
  @ApiOperation({ summary: '手机号更换' })
  async changePhone(
    @CurrentUser() user: any,
    @Body() body: LoginByPhoneDto,
    @Req() req: Request,
  ) {
    const responseData = await this.authService.changePhone(
      user,
      body.params.phone,
      body.params.code,
    );
    req.customBody = responseData;
    return responseData;
  }

  @Public()
  @Post('login-google')
  @ApiOperation({ summary: 'Google 登录' })
  async loginWithGoogle(@Body() body: GoogleLoginDto, @Req() req: Request) {
    const googleUserInfo = await this.googleAuthService.verifyGoogleToken(
      body.idToken,
    );
    const responseData =
      await this.googleAuthService.loginOrRegister(googleUserInfo);
    req.customBody = responseData;
    return responseData;
  }

  @Public()
  @Post('login-apple')
  @ApiOperation({ summary: 'Apple 登录' })
  async loginWithApple(@Body() body: AppleLoginDto, @Req() req: Request) {
    const appleUserInfo = await this.appleAuthService.verifyAppleToken(
      body.identityToken,
    );
    const responseData =
      await this.appleAuthService.loginOrRegister(appleUserInfo);
    req.customBody = responseData;
    return responseData;
  }

  @Public()
  @Post('firebaseAuth')
  @ApiOperation({ summary: 'Firebase 统一认证' })
  async loginWithFirebase(@Body() body: FirebaseAuthDto, @Req() req: Request) {
    this.logger.log('🔵 [API] ==========================================');
    this.logger.log(`🔵 [API] Request: POST /api/auth/firebaseAuth`);
    this.logger.log(`🔵 [API] Headers: ${JSON.stringify(req.headers)}`);
    this.logger.log(`🔵 [API] Body: ${JSON.stringify(body)}`);
    this.logger.log('🔵 [API] ==========================================');

    try {
      const firebaseUserInfo = await this.firebaseAuthService.verifyFirebaseToken(
        body.idToken,
      );
      this.logger.log(`🟢 [API] Firebase token verified for user: ${firebaseUserInfo.email}`);

      const responseData =
        await this.firebaseAuthService.loginOrRegister(firebaseUserInfo);
      
      this.logger.log('🟢 [API] ==========================================');
      this.logger.log(`🟢 [API] Response Status: 200`);
      this.logger.log(`🟢 [API] Response Data: ${JSON.stringify(responseData)}`);
      this.logger.log('🟢 [API] ==========================================');

      req.customBody = responseData;
      return responseData;
    } catch (error) {
      this.logger.error('🔴 [API] ==========================================');
      this.logger.error(`🔴 [API] Request Failed: ${error.message}`);
      this.logger.error(`🔴 [API] Error Stack: ${error.stack}`);
      this.logger.error('🔴 [API] ==========================================');
      throw error;
    }
  }
}
