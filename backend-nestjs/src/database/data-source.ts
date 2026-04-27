// src/database/data-source.ts
import { Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import * as dotenv from 'dotenv';
import * as fs from 'fs';
import * as path from 'path';

// 👇 显式导入实体（保持不变）
import { OResponseChats } from '@/modules/petihope/entities/response_chats.entity';
import { NewsStatusLevelEntity } from '@/modules/news/entities/news.status.level.entity';
import { UserPushConfig } from '@/shared/push/entities/user-push-config.entity';
import { UserPushDevice } from '@/shared/push/entities/user-push-device.entity';
import { NewsConSystem } from '@/modules/news/entities/news.con.system.entity';
import { NewsStatusMainEntity } from '@/modules/news/entities/news.status.main.entity';
import { NewsStatusUserEntity } from '@/modules/news/entities/news.status.user.entity';
import { NewsStatusUserUnreadEntity } from '@/modules/news/entities/news.status.user.unread.entity';
import { NewsStatusUserUnreadLevelEntity } from '@/modules/news/entities/news.status.user.unread.level.entity';
import { Follows } from '@/entities/modules/follows.entity';
import { ReportDb } from '@/entities/modules/report_db.entity';
import { ReportUser } from '@/entities/modules/report_user.entity';
import { AppVersion } from '@/modules/system/entities/app.version.entity';
import { OoFun } from '@/modules/petihope/entities/oo_fun.entity';
import { NewsStatus } from '@/modules/news/entities/news.status.entity';
import { OoNews } from '@/modules/petihope/entities/oo_news.entity';
import { UserFirstAction } from '@/modules/users/entities/user_first_actions.entity';
import { User } from '@/modules/users/entities/user.entity';
import { PetihopePri } from '@/modules/petihope/entities/petihope_pri.entity';
import { Petihope } from '@/modules/petihope/entities/petihope.entity';
import { WithdrawalEntity } from '@/modules/pay/entities/withdraw.entity';
import { Refund } from '@/modules/pay/entities/refund.entity';
import { PetihopeDivideSummary } from '@/modules/pay/entities/divide/petihope-divide-summary.entity';
import { PetihopeDivideRecord } from '@/modules/pay/entities/divide/petihope-divide-record.entity';
import { Activities } from '@root/src/shared/activities/entities/activities.entity';
import { Product } from '@root/src/modules/product/entities/product.entity';
import { Order } from '@root/src/modules/order/entities/order.entity';
import { OrderProduct } from '@root/src/modules/order-product/entities/order-product.entity';
import { Pay } from '@/modules/pay/entities/pay.entity';
import { Post } from '@/modules/feed/entities/post.entity';
import { Swipe } from '@/modules/match/entities/swipe.entity';
import { Friendship } from '@/modules/match/entities/friendship.entity';
import { Message } from '@/modules/chat/entities/message.entity';
import { CallRecord } from '@/modules/call/entities/call-record.entity';
import { VIPSubscription } from '@/modules/vip/entities/vip-subscription.entity';
import { CallMinutes } from '@/modules/vip/entities/call-minutes.entity';
import { Gift } from '@/modules/gift/entities/gift.entity';
import { GiftRecord } from '@/modules/gift/entities/gift-record.entity';
import { Report } from '@/modules/report/entities/report.entity';
import { Block } from '@/modules/block/entities/block.entity';
import { ViewRecord } from '@/modules/privacy/entities/view-record.entity';

// 创建一个专门用于这个文件的 Logger 实例
const logger = new Logger('ValidationUtil');

// 🔧 根据 NODE_ENV 选择环境文件
const env = process.env.NODE_ENV || 'dev';
const envFile = `.env.${env}`; //env === 'prod' ? '.env.prod' : '.env.dev'

// 🔧 构建环境文件路径
const envPath = path.join(__dirname, '../../', envFile);

// 🔧 优先加载指定环境文件
if (fs.existsSync(envPath)) {
  dotenv.config({ path: envPath });
  logger.log(`✅ 已加载环境配置: ${envPath}`);
} else {
  // ❌ 如果没找到，给个严重警告
  logger.warn(`🚨 严重警告：环境文件未找到 → ${envPath}`);
  logger.warn(`💡 请确保文件存在且拼写正确（注意大小写）`);
  // 可选：抛出错误阻止启动（生产环境建议开启）
  // if (env === 'prod') {
  //   throw new Error('生产环境配置文件缺失，拒绝启动');
  // }
}

// 🚫 移除这行：它会覆盖上面的加载逻辑
// config({ path: resolve(__dirname, '../../.env') });  // ❌ 删除！

// 🔧 创建数据源实例
export const AppDataSource = new DataSource({
  type: 'mysql',
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '3306', 10),
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  charset: 'utf8mb4_unicode_ci',

  // 🔄 synchronize: 仅开发开启
  synchronize: false, //process.env.DB_SYNCHRONIZE === 'true'

  // 📦 实体：使用显式导入（推荐，类型安全）
  entities: [
    OResponseChats,
    NewsConSystem,
    NewsStatusMainEntity,
    NewsStatusUserEntity,
    NewsStatusLevelEntity,
    NewsStatusUserUnreadEntity,
    NewsStatusUserUnreadLevelEntity,
    NewsStatus,

    Follows,
    ReportDb,
    ReportUser,
    UserFirstAction,
    User,

    OoNews,
    OoFun,
    PetihopePri,
    Petihope,

    WithdrawalEntity,
    Refund,
    PetihopeDivideSummary,
    PetihopeDivideRecord,
    Product,
    Order,
    OrderProduct,
    Pay,

    UserPushConfig,
    UserPushDevice,
    AppVersion,
    Activities,

    Post,
    Swipe,
    Friendship,
    Message,
    CallRecord,
    VIPSubscription,
    CallMinutes,
    Gift,
    GiftRecord,
    Report,
    Block,
    ViewRecord,
  ],

  // 🗂️ 迁移文件路径（支持 .ts 和 .js）
  migrations: [path.join(__dirname, 'migrations', '*{.ts,.js}')],

  // 📝 日志：生产环境关闭
  logging: process.env.NODE_ENV !== 'prod',

  // 🧩 迁移表名
  migrationsTableName: 'migrations',
});
