import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as jwt from 'jsonwebtoken';
import * as NodeRSA from 'node-rsa';
import { UsersService } from '@root/src/modules/users/users.service';
import { AuthService } from '@/modules/auth/auth.service';
import { AuthResult } from './google-auth.service';

export interface AppleUserInfo {
  appleId: string;
  email?: string;
  isPrivateEmail?: boolean;
}

interface AppleJwtPayload {
  sub: string;
  email?: string;
  is_private_email?: string;
}

interface AppleJWK {
  kid: string;
  n: string;
  e: string;
}

interface AppleKeysResponse {
  keys: AppleJWK[];
}

@Injectable()
export class AppleAuthService {
  private readonly logger = new Logger(AppleAuthService.name);

  constructor(
    private readonly configService: ConfigService,
    private readonly usersService: UsersService,
    private readonly authService: AuthService,
  ) {}

  async verifyAppleToken(identityToken: string): Promise<AppleUserInfo> {
    try {
      const decodedToken = jwt.decode(identityToken, { complete: true });
      if (!decodedToken) {
        throw new BadRequestException('Invalid Apple token');
      }

      const applePublicKey = await this.getApplePublicKey(
        decodedToken.header.kid || '',
      );

      const verified = jwt.verify(identityToken, applePublicKey, {
        algorithms: ['RS256'],
        issuer: 'https://appleid.apple.com',
        audience: this.configService.get('APPLE_CLIENT_ID') || undefined,
      }) as AppleJwtPayload;

      return {
        appleId: verified.sub,
        email: verified.email,
        isPrivateEmail: verified.is_private_email === 'true',
      };
    } catch (error) {
      this.logger.error('Apple token verification failed', error);
      throw new BadRequestException('Apple login failed');
    }
  }

  private async getApplePublicKey(kid: string): Promise<string> {
    const response = await fetch('https://appleid.apple.com/auth/keys');
    const data = (await response.json()) as AppleKeysResponse;
    const key = data.keys.find((k: AppleJWK) => k.kid === kid);

    if (!key) {
      throw new BadRequestException('Apple public key not found');
    }

    const rsaKey = new NodeRSA();
    rsaKey.importKey(
      { n: Buffer.from(key.n, 'base64'), e: Buffer.from(key.e, 'base64') },
      'components-public',
    );
    return rsaKey.exportKey('public');
  }

  async loginOrRegister(appleUserInfo: AppleUserInfo): Promise<AuthResult> {
    let user = await this.usersService.findOneByAppleId(appleUserInfo.appleId);

    if (!user) {
      user = await this.usersService.createUserByApple(appleUserInfo);
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
