#!/bin/bash
# src/database/scripts/init-migrations.sh
# 功能：为已有数据库结构生成 TypeORM 初始迁移文件，并初始化 migrations 表
# 注意：此脚本应仅运行一次！

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
cd "$PROJECT_ROOT" || exit 1

echo "🚀 快速第一次迁移初始化"

# 从 .env 文件加载配置
if [ -f .env ]; then
    echo "🔧 从 .env 文件加载配置..."
    export $(grep -E '^(DB_|NODE_ENV)' .env | grep -v '^#' | xargs)
else
    echo "❌ .env 文件不存在"
    exit 1
fi

# 设置默认值
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_USERNAME="${DB_USERNAME:-root}"
DB_PASSWORD="${DB_PASSWORD:-password}"
DB_NAME="${DB_NAME:-mydb}"
NODE_ENV="${NODE_ENV:-dev}"

echo "📋 当前配置:"
echo "  环境: $NODE_ENV"
echo "  主机: $DB_HOST"
echo "  端口: $DB_PORT"
echo "  用户: $DB_USERNAME"
echo "  数据库: $DB_NAME"

MIGRATIONS_DIR="src/database/migrations"
mkdir -p "$MIGRATIONS_DIR"

# === 步骤0: 检查是否已初始化 ===
echo ""
echo "=== 步骤0: 检查是否已初始化 ==="
INIT_COUNT=$(mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" -sN "$DB_NAME" -e "SELECT COUNT(*) FROM migrations WHERE name LIKE 'InitSchema%' LIMIT 1;" 2>/dev/null || echo "0")

if [ "$INIT_COUNT" -gt 0 ] 2>/dev/null; then
    echo "❌ 错误：数据库已初始化过迁移系统，禁止重复运行"
    exit 1
fi
echo "✅ 未检测到初始迁移，继续..."

# === 步骤1: 测试数据库连接 ===
echo ""
echo "=== 步骤1: 测试数据库连接 ==="
if ! mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" -e "USE $DB_NAME" 2>/dev/null; then
    echo "❌ 数据库连接失败！"
    exit 1
fi
echo "✅ 数据库连接成功"

# === 步骤2: 提取数据库结构 ===
echo ""
echo "=== 步骤2: 提取数据库结构 ==="
SCHEMA_DUMP=$(mysqldump -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" \
    --no-data \
    --skip-add-locks \
    --compact \
    --quote-names \
    --skip-triggers \
    --skip-comments \
    --set-charset=false \
    --skip-set-charset \
    --default-character-set=utf8mb4 \
    "$DB_NAME" 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$SCHEMA_DUMP" ]; then
    echo "❌ 数据库结构导出失败或数据库为空"
    exit 1
fi

# ✅ 关键修复：正确转义 \、" 和 `
# 并添加缩进（每行前面加 12 个空格）
SCHEMA_SQL=$(echo "$SCHEMA_DUMP" | sed 's/\\/\\\\/g; s/"/\\"/g; s/`/\\\`/g; s/^/            /')

echo "✅ 成功提取并转义数据库结构"

# === 步骤3: 创建初始迁移文件 ===
echo ""
echo "=== 步骤3: 创建初始迁移文件 ==="
# 生成 13 位毫秒级时间戳
TIMESTAMP=$(date +%s)000  # 简单补0（适用于单次生成）
# 更精确的方式：TIMESTAMP=$(node -e 'console.log(Date.now())')
# TIMESTAMP=$(date +%s)

MIGRATION_FILE="$MIGRATIONS_DIR/${TIMESTAMP}-InitSchema.ts"

# 提取表名用于 down() 方法（倒序删除，避免外键冲突）
echo "$SCHEMA_DUMP" | grep -oE 'CREATE TABLE `[^`]+`' | sed 's/CREATE TABLE `//; s/`.*$//' | grep -v '^$' > /tmp/tables.$$
TABLES=()
while IFS= read -r line; do
    TABLES=("$line" "${TABLES[@]}")
done < <(cat /tmp/tables.$$)
rm -f /tmp/tables.$$

# 生成 down() 的 DROP 语句
DROP_STATEMENTS=""
for TABLE in "${TABLES[@]}"; do
    DROP_STATEMENTS="$DROP_STATEMENTS        await queryRunner.query(\"DROP TABLE IF EXISTS \\\\\`$TABLE\\\\\`;\");\n"
done
DROP_STATEMENTS=$(echo -e "$DROP_STATEMENTS" | sed '$d') # 移除最后多余换行

# 生成迁移文件
cat > "$MIGRATION_FILE" << EOF
import { MigrationInterface, QueryRunner } from "typeorm";

export class InitSchema${TIMESTAMP} implements MigrationInterface {
    name = 'InitSchema${TIMESTAMP}';

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(\`
${SCHEMA_SQL}
\`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
${DROP_STATEMENTS}
    }
}
EOF

if [ -f "$MIGRATION_FILE" ]; then
    echo "✅ 迁移文件已创建: $MIGRATION_FILE"
else
    echo "❌ 迁移文件创建失败"
    exit 1
fi

# === 步骤4: 初始化 migrations 表并插入记录 ===
echo ""
echo "=== 步骤4: 初始化迁移系统 ==="
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_NAME" << MYSQL_CMD
CREATE TABLE IF NOT EXISTS migrations (
    id int NOT NULL AUTO_INCREMENT,
    timestamp bigint NOT NULL,
    name varchar(255) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO migrations (timestamp, name) VALUES ($TIMESTAMP, 'InitSchema${TIMESTAMP}');
MYSQL_CMD

if [ $? -eq 0 ]; then
    echo "✅ migrations 表初始化完成"
else
    echo "❌ migrations 表初始化失败"
    exit 1
fi

# === 步骤5: 验证结果 ===
echo ""
echo "=== 步骤5: 验证结果 ==="
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_NAME" -e "SELECT * FROM migrations ORDER BY id;"
echo ""
echo "🎉 第一次迁移初始化完成！"
echo "📄 生成的迁移文件: $MIGRATION_FILE"