#!/bin/bash
# src/database/scripts/clear-migrations.sh

echo "⚠️  警告：即将清除所有 TypeORM 迁移记录！"
read -p "确认要继续吗？(y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 操作已取消"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
cd "$PROJECT_ROOT"

# 从 .env 加载数据库配置
if [ -f .env ]; then
    export $(grep -E '^(DB_|NODE_ENV)' .env | grep -v '^#' | xargs)
else
    echo "❌ .env 文件不存在"
    exit 1
fi

# 默认值
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_USERNAME="${DB_USERNAME:-root}"
DB_PASSWORD="${DB_PASSWORD:-password}"
DB_NAME="${DB_NAME:-mydb}"

MIGRATIONS_DIR="src/database/migrations"

echo "🗑️  正在清除迁移记录..."

# 1. 清空 migrations 表
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_NAME" << EOF
DELETE FROM migrations;
EOF

if [ $? -eq 0 ]; then
    echo "✅ migrations 表已清空"
else
    echo "❌ 清空 migrations 表失败"
    exit 1
fi

# 2. 删除所有迁移文件（.ts 和 .js）
rm -f "$MIGRATIONS_DIR"/*.ts "$MIGRATIONS_DIR"/*.js

echo "✅ 所有迁移文件已删除"

echo ""
echo "🎉 迁移系统已重置！"
echo "💡 下次可运行 first-init.sh 重新初始化，或使用:"
echo "   npm run db:create <name>    # 创建新迁移"