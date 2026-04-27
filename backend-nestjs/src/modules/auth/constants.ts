// src/auth/constants.ts
export const AUTH_TYPE = {
  PHONE: 'phone',
  EMAIL: 'email',
  USERNAME_PASSWORD: 'username_password',
} as const;

export type AuthType = typeof AUTH_TYPE[keyof typeof AUTH_TYPE];