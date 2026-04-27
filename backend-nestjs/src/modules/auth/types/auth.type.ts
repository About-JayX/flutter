export interface JwtPayload {
  sub: number; // 用户ID
  username: string;
  // 可以添加其他字段，如 role, email 等
}