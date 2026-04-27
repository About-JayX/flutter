// guards/jwt-auth.guard.ts
import { Injectable, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  constructor(private reflector: Reflector) {
    super();
  }

  canActivate(context: ExecutionContext) {
    /// 公共路由也能获取token信息版本
    const isPublic = this.reflector.getAllAndOverride<boolean>('isPublic', [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) {
      // 对于公共路由，我们仍然执行认证但不强制要求
      // 这样用户信息会被附加到请求（如果token有效）
      const result = super.canActivate(context);
      
      // 如果结果是Promise，捕获错误但不阻止访问
      if (result instanceof Promise) {
        return result.catch(() => true);
      }
      
      // 如果结果不是Promise，直接返回true
      return true;
    }
    // 非公共路由，正常要求认证
    return super.canActivate(context);

    // const isPublic = this.reflector.getAllAndOverride<boolean>('isPublic', [
    //   context.getHandler(),
    //   context.getClass(),
    // ]);
    // if (isPublic) return true;
    // return super.canActivate(context);
  }
}