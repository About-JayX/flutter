// src/auth/interfaces/auth.interface.ts
import { AuthType } from '../constants';

export interface IAuthService {
  login(type: AuthType, payload: Record<string, any>): Promise<{ access_token: string }>;
}