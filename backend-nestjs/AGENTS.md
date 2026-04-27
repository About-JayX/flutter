# AGENTS.md

## Project Overview

NestJS + TypeORM + MySQL2 backend application with Redis caching, BullMQ queues, and Swagger documentation.

## Quick Commands

```bash
# Development
npm run start:dev          # Watch mode with NODE_ENV=dev

# Production
npm run build:prod         # Build for production
npm run start:prod         # Run production build

# Database (TypeORM migrations)
npm run migration:generate -- src/database/migrations/MigrationName  # Generate migration
npm run migration:run      # Run pending migrations
npm run migration:revert   # Revert last migration
npm run db:status          # Show migration status

# Code quality
npm run lint               # ESLint with auto-fix
npm run format             # Prettier formatting
npm run test               # Run Jest tests (NODE_ENV=test)
```

## Environment Setup

- Copy `.env.example` to `.env.dev` (or `.env.prod`, `.env.stage`)
- Required vars: `DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD`, `DB_NAME`, `DB_SYNCHRONIZE`
- Environment auto-loaded based on `NODE_ENV` (defaults to `dev`)

## Architecture Notes

### Path Aliases (tsconfig.json)

- `@/*` → `src/*`
- `@root/*` → `./*`
- `@modules/*` → `src/modules/*`
- `@shared/*` → `src/shared/*`
- `@public/*` → `src/public/*`

### Database Configuration

- **Driver**: mysql2 (TypeORM auto-detects, don't manually specify)
- **Charset**: Use `charset: 'utf8mb4_unicode_ci'` (not `extra.collation`)
- **Migrations**: Stored in `src/database/migrations/`
- **DataSource**: Defined in `src/database/data-source.ts`

### Key Conventions

1. **MySQL2 charset**: Always use `utf8mb4_unicode_ci` directly in `charset` field. Never put `collation` in `extra` object - causes deprecation warnings.

2. **Environment loading**:
   - `src/config/database.config.ts` loads `.env.{NODE_ENV}`
   - `src/database/data-source.ts` has its own env loading for CLI usage
   - Never use `dotenv.config()` in multiple places redundantly

3. **Timezone**: Hardcoded to `Asia/Shanghai` in `main.ts` (line 38). Database uses system default (don't set `timezone` in TypeORM config - it causes time drift).

4. **Global prefix**: All routes prefixed with `/api` (configured in `main.ts`)

5. **Swagger**: Available at `/api-docs` in all environments

6. **Validation**: Global `ValidationPipe` enabled with `whitelist: true` (strips undefined DTO properties)

7. **Authentication**: JWT guard applied globally (`JwtAuthGuard`), whitelist public routes with `@Public()` decorator

## Testing

- Unit tests: `*.spec.ts` files, run with `npm run test`
- E2E tests: `test/*.e2e-spec.ts`, run with `npm run test:e2e`
- Test environment uses `.env.test`

## Module Structure

```
src/
├── modules/          # Feature modules (auth, users, pay, order, etc.)
├── shared/           # Shared utilities (queue, redis, push, activities)
├── public/           # Public/common utilities
├── config/           # Configuration files
├── database/         # Migrations and data source
├── interceptors/     # Global interceptors and filters
└── main.ts          # Application entry point
```

## Important Gotchas

- **Alipay webhooks**: Use raw-body middleware at `/api/pay/notify/alipay` (configured in `main.ts`)
- **Redis**: Required for cache and queues (BullMQ)
- **Mongoose**: Imported but unused (legacy dependency)
- **Type strictness**: `noImplicitAny: false` in tsconfig (relaxed type checking)
