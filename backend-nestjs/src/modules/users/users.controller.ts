import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Logger,
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiOperation, ApiConsumes } from '@nestjs/swagger';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { PrivacySettingsDto } from '../privacy/dto/privacy-settings.dto';
import { CurrentUser } from '@/modules/auth/decorators/current-user.decorator';
import { UploadService } from '@/modules/upload/upload.service';

@Controller('users')
export class UsersController {
  private readonly logger = new Logger(UsersController.name);
  constructor(
    private readonly usersService: UsersService,
    private readonly uploadService: UploadService,
  ) {}

  @Post()
  create(@Body() createUserDto: CreateUserDto) {
    return this.usersService.create(createUserDto);
  }

  @Post('getPhoneStar')
  async getPhoneStar(
    @CurrentUser() user: any, //  ArgsAuthDto
  ) {
    this.logger.log('user信息uniqid: ', user.uniqid);
    return this.usersService.getPhoneStar(user.uniqid);
  }

  @Get()
  findAll() {
    return this.usersService.findAll();
  }

  @Get('profile')
  @ApiOperation({ summary: '获取用户资料' })
  async getProfile(@CurrentUser() user: any) {
    this.logger.log(`UsersController: getProfile called for user: ${user.uniqid}`);
    
    const profile = await this.usersService.getProfile(user.uniqid);
    this.logger.log(`UsersController: profile retrieved, personalizeEdit=${profile.personalizeEdit}`);
    
    const response = {
      status: '0',
      statusInfo: '获取成功',
      data: {
        user: {
          id: profile.id,
          username: profile.userName,
          displayName: profile.userNickName,
          avatarUrl: profile.avatar,
          email: profile.email,
          blocked: false,
          coins: 0,
          membership: null,
          personalize_edit: profile.personalizeEdit || 0,
          gender: profile.gender,
          birthDate: profile.birthDate,
          country: profile.country,
          language: profile.language,
          occupation: profile.occupation,
          interests: profile.interests,
          personality: profile.personality,
          chatPurpose: profile.chatPurpose,
          communicationStyle: profile.communicationStyle,
          status: profile.status,
          isStatusPublic: profile.isStatusPublic == 1,
          blurProfileCard: profile.blurProfileCard == 1,
        }
      }
    };
    
    this.logger.log(`UsersController: returning profile response: ${JSON.stringify(response)}`);
    return response;
  }

  @Get('by-id/:id')
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(+id);
  }

  @Patch('by-id/:id')
  update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return this.usersService.update(+id, updateUserDto);
  }

  @Delete('by-id/:id')
  remove(@Param('id') id: string) {
    return this.usersService.remove(+id);
  }

  @Post('profile')
  @ApiOperation({ summary: '更新用户资料' })
  async updateProfile(
    @CurrentUser() user: any,
    @Body() updateProfileDto: UpdateProfileDto,
  ) {
    this.logger.log(`🔵 [UsersController] updateProfile called`);
    this.logger.log(`🔵 [UsersController] User: ${user.uniqid}`);
    this.logger.log(`🔵 [UsersController] Received data: ${JSON.stringify(updateProfileDto)}`);
    
    try {
      const result = await this.usersService.updateProfile(user.uniqid, updateProfileDto);
      this.logger.log(`🟢 [UsersController] Profile updated successfully`);
      return {
        status: '0',
        statusInfo: 'success',
        data: result,
      };
    } catch (error) {
      this.logger.error(`🔴 [UsersController] Update failed: ${error.message}`);
      if (error.response) {
        this.logger.error(`🔴 [UsersController] Validation errors: ${JSON.stringify(error.response)}`);
      }
      throw error;
    }
  }

  @Post('personalize')
  @ApiOperation({ summary: '标记个性化完成' })
  async markPersonalized(@CurrentUser() user: any) {
    const result = await this.usersService.markPersonalized(user.uniqid);
    return {
      status: '0',
      statusInfo: 'success',
      data: result,
    };
  }

  @Get('is-early-user')
  @ApiOperation({ summary: '检查是否是前100名用户' })
  async checkIsEarlyUser(@CurrentUser() user: any) {
    const isEarlyUser = await this.usersService.checkIsEarlyUser();
    return {
      status: '0',
      statusInfo: 'success',
      data: { isEarlyUser },
    };
  }

  @Post('privacy-settings')
  @ApiOperation({ summary: '更新隐私设置' })
  async updatePrivacySettings(
    @CurrentUser() user: any,
    @Body() privacySettingsDto: PrivacySettingsDto,
  ) {
    const result = await this.usersService.updatePrivacySettings(
      user.uniqid,
      privacySettingsDto,
    );
    return {
      status: '0',
      statusInfo: 'success',
      data: result,
    };
  }

  @Get('privacy-settings')
  @ApiOperation({ summary: '获取隐私设置' })
  async getPrivacySettings(@CurrentUser() user: any) {
    const result = await this.usersService.getPrivacySettings(user.uniqid);
    return {
      status: '0',
      statusInfo: 'success',
      data: result,
    };
  }

  @Post('avatar')
  @ApiOperation({ summary: '上传头像' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('file'))
  async uploadAvatar(
    @CurrentUser() user: any,
    @UploadedFile() file: any,
  ) {
    this.logger.log(`UsersController: uploadAvatar called`);
    this.logger.log(`UsersController: user.id = ${user.id}`);
    this.logger.log(`UsersController: user.uniqid = ${user.uniqid}`);
    this.logger.log(`UsersController: file received = ${JSON.stringify({
      originalname: file?.originalname,
      mimetype: file?.mimetype,
      size: file?.size,
      fieldname: file?.fieldname,
    })}`);

    try {
      const avatarUrl = await this.uploadService.uploadAvatar(user.id, file);
      this.logger.log(`UsersController: avatarUrl = ${avatarUrl}`);
      
      await this.usersService.updateProfile(user.uniqid, { avatar: avatarUrl });
      this.logger.log(`UsersController: profile updated with avatar`);
      
      return {
        status: '0',
        statusInfo: '上传成功',
        data: { avatarUrl },
      };
    } catch (error) {
      this.logger.error(`UsersController: uploadAvatar error = ${error.message}`);
      throw error;
    }
  }
}
