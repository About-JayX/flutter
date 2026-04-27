# UME Backend API

## 项目介绍

**UME** 是莫比森（Mobisen）开发的北美青年即时通讯AI社交软件后端服务。

本项目基于 NestJS 框架构建，为 UME 的移动端 App、后台管理系统和官方网站提供完整的 API 服务支持。系统采用模块化架构设计，集成了用户认证、即时通讯、支付系统、订单管理、推送通知等核心功能模块。

### 核心功能

- **用户认证与授权**：JWT 认证体系，支持手机号验证
- **即时通讯**：AI 驱动的社交对话功能
- **支付系统**：集成支付宝支付，支持订单、退款、分账
- **内容管理**：新闻资讯、动态发布、关注系统
- **推送通知**：多渠道消息推送服务
- **后台管理**：Bull Board 队列监控、系统监控面板

---

## 技术栈

### 核心框架

| 技术                                          | 版本    | 说明                       |
| --------------------------------------------- | ------- | -------------------------- |
| [NestJS](https://nestjs.com/)                 | ^11.0.1 | Node.js 渐进式框架         |
| [TypeScript](https://www.typescriptlang.org/) | ^5.7.3  | 类型安全的 JavaScript 超集 |
| [Node.js](https://nodejs.org/)                | 20.x    | JavaScript 运行时环境      |

### 数据库与缓存

| 技术                                               | 版本    | 说明           |
| -------------------------------------------------- | ------- | -------------- |
| [TypeORM](https://typeorm.io/)                     | ^0.3.28 | ORM 框架       |
| [MySQL2](https://github.com/sidorares/node-mysql2) | ^3.14.1 | MySQL 驱动     |
| [Redis](https://redis.io/)                         | -       | 缓存与消息队列 |
| [ioredis](https://github.com/redis/ioredis)        | ^5.8.1  | Redis 客户端   |

### 消息队列与任务调度

| 技术                                                      | 版本    | 说明                  |
| --------------------------------------------------------- | ------- | --------------------- |
| [BullMQ](https://docs.bullmq.io/)                         | ^5.61.0 | 基于 Redis 的队列系统 |
| [@nestjs/bull](https://docs.nestjs.com/techniques/queues) | ^11.0.3 | NestJS Bull 集成      |
| [@bull-board](https://github.com/felixmosh/bull-board)    | ^6.13.0 | 队列管理 UI           |

### 认证与安全

| 技术                                                                | 版本    | 说明          |
| ------------------------------------------------------------------- | ------- | ------------- |
| [@nestjs/passport](https://docs.nestjs.com/security/authentication) | ^11.0.5 | Passport 集成 |
| [passport-jwt](https://github.com/mikenicholson/passport-jwt)       | ^4.0.1  | JWT 策略      |
| [@nestjs/jwt](https://docs.nestjs.com/security/authentication)      | ^11.0.0 | JWT 工具      |

### 支付集成

| 技术                                                          | 版本    | 说明       |
| ------------------------------------------------------------- | ------- | ---------- |
| [alipay-sdk](https://github.com/alipay/alipay-sdk-nodejs-all) | ^4.14.0 | 支付宝 SDK |

### 云服务

| 技术                                                             | 版本   | 说明           |
| ---------------------------------------------------------------- | ------ | -------------- |
| [@alicloud/dysmsapi20170525](https://www.aliyun.com/product/sms) | ^4.2.0 | 阿里云短信服务 |

### 开发工具

| 技术                             | 版本    | 说明         |
| -------------------------------- | ------- | ------------ |
| [ESLint](https://eslint.org/)    | ^9.18.0 | 代码检查     |
| [Prettier](https://prettier.io/) | ^3.4.2  | 代码格式化   |
| [Jest](https://jestjs.io/)       | ^29.7.0 | 单元测试框架 |
| [SWC](https://swc.rs/)           | ^1.10.7 | 快速编译器   |

---

## 项目架构

### 目录结构

```
src/
├── app.module.ts              # 应用根模块
├── app.controller.ts          # 应用控制器
├── app.service.ts             # 应用服务
├── main.ts                    # 应用入口
│
├── modules/                   # 业务模块
│   ├── auth/                  # 认证模块（JWT、登录、注册）
│   ├── users/                 # 用户模块
│   ├── pay/                   # 支付模块（支付宝、订单、退款、分账）
│   ├── order/                 # 订单模块
│   ├── order-product/         # 订单商品模块
│   ├── product/               # 商品模块
│   ├── petihope/              # AI 社交对话模块
│   ├── news/                  # 新闻资讯模块
│   └── system/                # 系统模块（版本管理、配置）
│
├── shared/                    # 共享模块
│   ├── queue/                 # 队列模块（BullMQ）
│   ├── redis/                 # Redis 模块
│   ├── push/                  # 推送通知模块
│   ├── activities/            # 活动模块
│   ├── monitoring/            # 监控模块
│   └── bull-board/            # Bull Board 管理界面
│
├── public/                    # 公共模块
│   └── common/                # 通用工具模块
│
├── entities/                  # 实体定义
│   ├── modules/               # 模块实体
│   └── shared/                # 共享实体
│
├── config/                    # 配置文件
│   ├── database.config.ts     # 数据库配置
│   ├── redis.config.ts        # Redis 配置
│   └── configuration.ts       # 通用配置
│
├── database/                  # 数据库相关
│   ├── data-source.ts         # TypeORM 数据源
│   ├── migrations/            # 数据库迁移文件
│   └── scripts/               # 数据库脚本
│
├── interceptors/              # 拦截器
│   ├── response.interceptor.ts           # 响应包装拦截器
│   ├── response.exception.interceptor.ts # 全局异常过滤器
│   └── response-formatter.ts             # 响应格式化工具
│
├── middleware/                # 中间件
│   └── raw-body.middleware.ts # 原始请求体中间件（支付宝回调）
│
├── common/                    # 通用工具
│   ├── utils/                 # 工具函数
│   ├── enums/                 # 枚举定义
│   ├── embeds/                # 嵌入实体
│   ├── pipes/                 # 管道
│   └── transformers/          # 转换器
│
└── types/                     # 类型定义
    └── express.d.ts           # Express 类型扩展
```

### 模块说明

#### 核心模块

| 模块        | 路径              | 功能描述                     |
| ----------- | ----------------- | ---------------------------- |
| **Auth**    | `modules/auth`    | JWT 认证、登录注册、权限守卫 |
| **Users**   | `modules/users`   | 用户管理、用户信息、用户行为 |
| **Pay**     | `modules/pay`     | 支付宝支付、退款、提现、分账 |
| **Order**   | `modules/order`   | 订单生命周期管理             |
| **Product** | `modules/product` | 商品管理                     |

#### AI 与内容模块

| 模块         | 路径               | 功能描述                     |
| ------------ | ------------------ | ---------------------------- |
| **Petihope** | `modules/petihope` | AI 对话、聊天记录、OO 功能   |
| **News**     | `modules/news`     | 新闻资讯、阅读状态、系统通知 |

#### 系统与工具模块

| 模块           | 路径                | 功能描述               |
| -------------- | ------------------- | ---------------------- |
| **System**     | `modules/system`    | 应用版本管理、系统配置 |
| **Push**       | `shared/push`       | 推送设备管理、推送配置 |
| **Queue**      | `shared/queue`      | 任务队列、延迟任务     |
| **Monitoring** | `shared/monitoring` | 系统监控、队列监控     |
| **Activities** | `shared/activities` | 活动记录、用户行为追踪 |

### 架构设计模式

#### 1. 全局响应格式

所有 API 响应统一包装为以下格式：

```json
{
  "head": {
    "version": "1.0.0"
  },
  "body": {
    "status": "0",
    "statusInfo": "success",
    "data": { ... }
  }
}
```

通过 `ResponseInterceptor` 全局拦截器自动包装。

#### 2. 全局异常处理

通过 `GlobalExceptionFilter` 统一处理异常，返回标准化错误响应。

#### 3. JWT 认证

- 全局启用 `JwtAuthGuard`
- 使用 `@Public()` 装饰器标记公开路由
- 支持在公开路由中可选获取用户信息

#### 4. 数据库迁移

使用 TypeORM 迁移管理数据库结构变更，支持多环境（dev/stage/prod）。

---

## 环境要求

### 系统要求

- **Node.js**: >= 20.x
- **npm**: >= 10.x
- **MySQL**: >= 8.0
- **Redis**: >= 6.0

### 开发环境

| 组件       | 版本    |
| ---------- | ------- |
| Node.js    | 20.18.0 |
| npm        | 10.8.2  |
| TypeScript | 5.7.3   |

### 配置文件

项目使用环境变量配置文件，支持多环境：

- `.env.dev` - 开发环境
- `.env.stage` - 测试环境
- `.env.prod` - 生产环境

#### 必需的环境变量

```env
# 应用环境
NODE_ENV=dev

# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=your_password
DB_NAME=ume_db
DB_SYNCHRONIZE=false

# Redis 配置
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DB=0

# JWT 配置
JWT_SECRET=your_jwt_secret
JWT_EXPIRATION=7d

# 支付宝配置
ALIPAY_APP_ID=your_app_id
ALIPAY_PRIVATE_KEY=your_private_key
ALIPAY_PUBLIC_KEY=alipay_public_key

# 阿里云短信
ALIBABA_CLOUD_ACCESS_KEY_ID=your_key
ALIBABA_CLOUD_ACCESS_KEY_SECRET=your_secret

# 服务器配置
PORT=3000
HOST=0.0.0.0
```

---

## 安装与运行

### 1. 克隆项目

```bash
git clone <repository-url>
cd app-nestjs
```

### 2. 安装依赖

```bash
npm install
```

### 3. 配置环境变量

```bash
# 复制环境文件模板
cp .env.example .env.dev

# 编辑 .env.dev 文件，填写必要的配置
```

### 4. 数据库迁移

```bash
# 运行迁移
npm run migration:run

# 查看迁移状态
npm run db:status

# 生成新的迁移（开发时使用）
npm run migration:generate -- src/database/migrations/MigrationName
```

### 5. 启动开发服务器

```bash
# 开发模式（热重载）
npm run start:dev

# 调试模式
npm run start:debug
```

应用将在 `http://localhost:3000` 启动。

### 6. 访问 API 文档

Swagger UI: `http://localhost:3000/api-docs`

---

## 打包与部署

### 开发环境打包

```bash
npm run build
```

### 生产环境打包

```bash
npm run build:prod
```

### 生产环境运行

```bash
# 先运行数据库迁移
npm run db:run:prod

# 启动应用
npm run start:prod
```

### 测试环境

```bash
# 打包
npm run build:stage

# 运行迁移
npm run db:run:stage

# 启动
npm run start:stage
```

---

## 常用命令

### 开发命令

```bash
# 启动开发服务器
npm run start:dev

# 调试模式
npm run start:debug

# 代码格式化
npm run format

# 代码检查
npm run lint
```

### 测试命令

```bash
# 运行单元测试
npm run test

# 测试覆盖率
npm run test:cov

# 端到端测试
npm run test:e2e

# 测试监听模式
npm run test:watch
```

### 数据库命令

```bash
# 运行迁移
npm run migration:run

# 回滚迁移
npm run migration:revert

# 查看迁移状态
npm run db:status

# 生成迁移
npm run migration:generate -- src/database/migrations/MigrationName

# 备份迁移
npm run db:backup
```

### 生产环境专用命令

```bash
# 生产构建
npm run build:prod

# 生产运行
npm run start:prod

# 生产环境迁移
npm run db:run:prod

# 生产环境回滚
npm run db:rollback:prod
```

---

## API 端点

### 基础路径

所有 API 端点以 `/api` 为前缀。

### 主要端点

| 端点                          | 说明         |
| ----------------------------- | ------------ |
| `POST /api/auth/login`        | 用户登录     |
| `POST /api/auth/register`     | 用户注册     |
| `GET /api/users/profile`      | 获取用户信息 |
| `POST /api/pay/create`        | 创建支付     |
| `POST /api/pay/notify/alipay` | 支付宝回调   |
| `GET /api/orders`             | 订单列表     |
| `GET /api/news`               | 新闻列表     |
| `GET /api/petihope/chats`     | AI 对话历史  |
| `GET /api/system/version`     | 应用版本     |

### 管理端点

| 端点                         | 说明                |
| ---------------------------- | ------------------- |
| `GET /api/admin/queues`      | Bull Board 队列管理 |
| `GET /api/admin`             | 监控面板            |
| `GET /api/monitoring/health` | 健康检查            |

---

## 项目规范

### 代码规范

- 使用 ESLint + Prettier 进行代码格式化和检查
- 提交前自动运行 lint 检查
- 遵循 NestJS 官方代码风格指南

### Git 提交规范

```
feat: 新功能
fix: 修复问题
docs: 文档更新
style: 代码格式（不影响功能）
refactor: 重构
test: 测试相关
chore: 构建过程或辅助工具的变动
```

### 分支管理

- `main` - 生产分支
- `develop` - 开发分支
- `feature/*` - 功能分支
- `hotfix/*` - 紧急修复分支

---

## 注意事项

### 时区配置

- 应用时区固定设置为 `Asia/Shanghai`（北京时间）
- 数据库使用系统默认时区
- **不要在 TypeORM 配置中设置 `timezone`**，会导致时间漂移

### 支付宝回调

- 支付宝异步通知使用 `raw-body` 中间件处理
- 端点：`/api/pay/notify/alipay`
- 确保服务器能够接收支付宝的回调请求

### 数据库字符集

- 使用 `utf8mb4_unicode_ci` 字符集
- 支持完整的 Unicode 字符（包括 emoji）

### 缓存配置

- Redis 用于缓存和消息队列
- 默认缓存过期时间：10 分钟
- 最大缓存数量：1000

---

## 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'feat: add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

---

## 许可证

[UNLICENSED](LICENSE)

---

## 联系方式

- **公司**: 莫比森（Mobisen）
- **项目**: UME - 北美青年即时通讯AI社交软件
- **技术栈**: NestJS + TypeORM + MySQL + Redis + BullMQ

---

## 更新日志

### v1.1.8

- 修复延迟任务订单取消问题

### v1.1.7

- 生产环境 Python 脚本部署测试

### v1.1.1 - v1.1.6

- 测试环境部署脚本优化
- 数据库迁移流程改进
