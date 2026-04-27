import { Injectable, UnauthorizedException, Logger } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { JwtPayload } from '@/modules/auth/types/auth.type'; // 引入我们定义的类型

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  private readonly logger = new Logger(JwtStrategy.name);

  constructor() {
    super({
      // 从请求头的 Authorization 字段提取 Bearer Token
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      // 是否忽略 JWT 的过期时间检查。false 表示会检查，过期则拒绝
      ignoreExpiration: false,
      // 用于验证 JWT 签名的密钥，必须与签发时使用的密钥一致
      secretOrKey: process.env.JWT_SECRET || 'your-super-secret-key',
    });
  }

  /**
   * validate 方法是 Passport 自动调用的。
   * 当 JWT 验证通过（签名有效且未过期）后，
   * Passport 会解码 payload 并将其传递给此方法。
   * 我们在此方法中通常会查询数据库确认用户是否存在，
   * 并返回一个用户对象（或 payload），该对象会被附加到 Request 对象上。
   * @param payload - 解码后的 JWT 载荷
   * @returns 返回的对象将被附加到 req.user
   */
  async validate(payload: JwtPayload): Promise<JwtPayload> {
    this.logger.log('JWT Payload validated', payload);
    // TODO: 在实际项目中，这里应该查询数据库，检查用户是否仍然存在且状态正常
    // 例如：const user = await this.userService.findOneById(payload.sub);
    // if (!user) {
    //   throw new UnauthorizedException('User not found or inactive');
    // }
    // return user; // 或者只返回 payload

    // 为了简化，我们直接返回 payload。
    // 在后续的控制器中，可以通过 req.user 访问这些信息。
    return payload;
  }
}