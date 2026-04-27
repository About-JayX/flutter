import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { OAuth2Client } from 'google-auth-library';
import { UsersService } from '@root/src/modules/users/users.service';
import { AuthService } from '@/modules/auth/auth.service';

export interface GoogleUserInfo {
  googleId: string;
  email: string;
  name: string;
  picture?: string;
}

export interface AuthResult {
  status: string;
  statusInfo: string;
  data: {
    access_token: string;
    uniqid: string;
    userId: string;
  };
}

@Injectable()
export class GoogleAuthService {
  private readonly logger = new Logger(GoogleAuthService.name);
  private readonly googleClient: OAuth2Client;

  constructor(
    private readonly configService: ConfigService,
    private readonly usersService: UsersService,
    private readonly authService: AuthService,
  ) {
    this.googleClient = new OAuth2Client(
      this.configService.get('GOOGLE_CLIENT_ID'),
      this.configService.get('GOOGLE_CLIENT_SECRET'),
    );
  }

  async verifyGoogleToken(idToken: string): Promise<GoogleUserInfo> {
    try {
      const ticket = await this.googleClient.verifyIdToken({
        idToken,
        audience: this.configService.get('GOOGLE_CLIENT_ID'),
      });

      const payload = ticket.getPayload();
      if (!payload) {
        throw new BadRequestException('Invalid Google token');
      }

      return {
        googleId: payload.sub,
        email: payload.email || '',
        name: payload.name || '',
        picture: payload.picture,
      };
    } catch (error) {
      this.logger.error('Google token verification failed', error);
      throw new BadRequestException('Google login failed');
    }
  }

  async loginOrRegister(googleUserInfo: GoogleUserInfo): Promise<AuthResult> {
    let user = await this.usersService.findOneByGoogleId(
      googleUserInfo.googleId,
    );

    if (!user) {
      user = await this.usersService.createUserByGoogle(googleUserInfo);
    }

    const access_token = this.authService.generateToken(user.uniqid);

    return {
      status: '0',
      statusInfo: '登录成功',
      data: {
        access_token,
        uniqid: user.uniqid,
        userId: user.id,
      },
    };
  }
}
