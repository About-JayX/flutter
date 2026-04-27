// // src/auth/strategies/phone-verify.strategy.ts
// import { Injectable } from '@nestjs/common';
// import { PassportStrategy } from '@nestjs/passport';
// import { Strategy, IVerifyOptions } from 'passport-local'; // 我们借用 local 的思想

// @Injectable()
// export class PhoneVerifyStrategy extends PassportStrategy(Strategy, 'phone-verify') {
//   constructor() {
//     super({ passReqToCallback: true });
//   }

//   async validate(phone: string, code: string, done: Function) {
//     // 调用 service 验证
//     // 如果成功，返回 user 对象
//     // done(null, user);
//   }
// }