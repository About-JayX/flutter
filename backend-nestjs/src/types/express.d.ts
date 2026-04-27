import { Request } from 'express';

declare global {
  namespace Express {
    interface Request {
      skipGlobalWrap?: boolean;
      customHead?: Record<string, any>;
      customBody?: Record<string, any>;
    }
  }
}

export {};