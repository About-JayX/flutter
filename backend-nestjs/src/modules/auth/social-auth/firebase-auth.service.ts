import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UsersService } from '@root/src/modules/users/users.service';
import { AuthService } from '@/modules/auth/auth.service';

export interface FirebaseUserInfo {
  uid: string;
  email: string;
  name?: string;
  picture?: string;
  phoneNumber?: string;
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
export class FirebaseAuthService {
  private readonly logger = new Logger(FirebaseAuthService.name);

  constructor(
    private readonly configService: ConfigService,
    private readonly usersService: UsersService,
    private readonly authService: AuthService,
  ) {}

  async verifyFirebaseToken(idToken: string): Promise<FirebaseUserInfo> {
    this.logger.log('🔵 [Firebase] Verifying Firebase ID Token...');
    this.logger.log(`🔵 [Firebase] Token length: ${idToken.length}`);
    this.logger.log(`🔵 [Firebase] API Key: ${this.configService.get('FIREBASE_API_KEY')?.substring(0, 10)}...`);

    try {
      const response = await fetch(
        `https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=${this.configService.get('FIREBASE_API_KEY')}`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            idToken: idToken,
          }),
        },
      );

      this.logger.log(`🔵 [Firebase] Response status: ${response.status}`);

      if (!response.ok) {
        const error = await response.json();
        this.logger.error('🔴 [Firebase] Token verification failed', error);
        throw new BadRequestException('Invalid Firebase token');
      }

      const data = await response.json();
      const user = data.users[0];

      if (!user) {
        this.logger.error('🔴 [Firebase] User not found in token');
        throw new BadRequestException('User not found');
      }

      this.logger.log(`🟢 [Firebase] Token verified for user: ${user.email}`);
      this.logger.log(`🟢 [Firebase] User UID: ${user.localId}`);

      return {
        uid: user.localId,
        email: user.email || '',
        name: user.displayName || '',
        picture: user.photoUrl,
        phoneNumber: user.phoneNumber,
      };
    } catch (error) {
      this.logger.error('🔴 [Firebase] Token verification error', error);
      throw new BadRequestException('Firebase login failed');
    }
  }

  async loginOrRegister(firebaseUserInfo: FirebaseUserInfo): Promise<AuthResult> {
    this.logger.log('🔵 [Auth] Starting loginOrRegister process...');
    this.logger.log(`🔵 [Auth] Firebase UID: ${firebaseUserInfo.uid}`);
    this.logger.log(`🔵 [Auth] Email: ${firebaseUserInfo.email}`);

    let user = await this.usersService.findOneByFirebaseUid(
      firebaseUserInfo.uid,
    );

    if (user) {
      this.logger.log(`🟢 [Auth] Found existing user by Firebase UID: ${user.id}`);
    } else {
      this.logger.log('🔵 [Auth] No user found by Firebase UID, trying email...');
      
      if (firebaseUserInfo.email) {
        user = await this.usersService.findOneByEmail(firebaseUserInfo.email);
      }

      if (user) {
        this.logger.log(`🟢 [Auth] Found existing user by email: ${user.id}`);
        this.logger.log('🔵 [Auth] Binding Firebase UID to existing user...');
        await this.usersService.bindFirebaseUid(user.id, firebaseUserInfo.uid);
        this.logger.log('🟢 [Auth] Firebase UID bound successfully');
      } else {
        this.logger.log('🔵 [Auth] Creating new user...');
        user = await this.usersService.createUserByFirebase(firebaseUserInfo);
        this.logger.log(`🟢 [Auth] New user created: ${user.id}`);
      }
    }

    const access_token = this.authService.generateToken(user.uniqid);
    this.logger.log(`🟢 [Auth] JWT token generated for user: ${user.uniqid}`);

    const result = {
      status: '0',
      statusInfo: '登录成功',
      data: {
        access_token,
        uniqid: user.uniqid,
        userId: user.id,
        personalizeEdit: user.personalizeEdit || 0,
      },
    };

    this.logger.log(`🟢 [Auth] Login result: ${JSON.stringify(result)}`);
    return result;
  }
}