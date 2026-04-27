#!/bin/bash
# src/database/scripts/generate-migration.sh
# 功能：安全生成 TypeORM 迁移文件
# 特性：
#   - 遵循 TypeORM 标准：由 TypeORM 自动生成时间戳
#   - 自动修复常见问题（import、反引号）
#   - TypeScript 语法验证
#   - 跨平台兼容（macOS / Linux）
#   - 不污染当前工作目录

# 获取脚本所在目录和项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# 检查是否传入迁移名称
if [ -z "$1" ]; then
  echo "❌ 错误：未提供迁移名称"
  echo "用法: $0 <迁移名称>"
  echo "示例: $0 AddOrderTable"
  echo "注意: 不要包含时间戳，TypeORM 会自动生成"
  exit 1
fi

MIGRATION_NAME="$1"
MIGRATION_PATH="src/database/migrations/${MIGRATION_NAME}"

echo "📝 正在生成迁移文件..."
echo "💡 名称: $MIGRATION_NAME"
echo "📁 路径: \$PROJECT_ROOT/src/database/migrations/*-${MIGRATION_NAME}.ts"

# 在项目根目录下执行迁移生成
(
  cd "$PROJECT_ROOT" || {
    echo "❌ 无法进入项目根目录: $PROJECT_ROOT"
    exit 1
  }

  # 确保 migrations 目录存在
  MIGRATIONS_DIR="./src/database/migrations"
  if [ ! -d "$MIGRATIONS_DIR" ]; then
    echo "🔧 创建迁移目录: $MIGRATIONS_DIR"
    mkdir -p "$MIGRATIONS_DIR"
  fi

  # 执行 TypeORM 迁移生成（让 TypeORM 自动加时间戳）
  echo "⚙️  执行: npm run migration:generate -- \"$MIGRATION_PATH\""
  npm run migration:generate -- "$MIGRATION_PATH"
)

# 检查执行结果
if [ $? -ne 0 ]; then
  echo "❌ 迁移生成失败，请检查以下内容："
  echo "   - package.json 中是否定义了 migration:generate 脚本"
  echo "   - data-source.ts 配置是否正确"
  echo "   - 数据库连接是否正常"
  echo "   - 是否已安装依赖 (npm install)"
  exit 1
fi

# 查找生成的文件（TypeORM 会加时间戳前缀）
GENERATED_FILE=$(find "$PROJECT_ROOT/src/database/migrations" -name "*-${MIGRATION_NAME}.ts" -type f | sort | tail -n1)

if [ ! -f "$GENERATED_FILE" ]; then
  echo "❌ 未找到生成的迁移文件"
  echo "   期望文件名包含: *-${MIGRATION_NAME}.ts"
  echo "   检查目录: $PROJECT_ROOT/src/database/migrations/"
  exit 1
fi

echo "✅ 迁移文件已生成: $(basename "$GENERATED_FILE")"

# ✅ 修复 1：确保 import { MigrationInterface, QueryRunner } 存在
if ! grep -q "import.*MigrationInterface.*QueryRunner" "$GENERATED_FILE"; then
  TMP_FILE=$(mktemp)
  cat > "$TMP_FILE" << 'EOF'
import { MigrationInterface, QueryRunner } from 'typeorm';
EOF
  echo "" >> "$TMP_FILE"
  tail -n +1 "$GENERATED_FILE" >> "$TMP_FILE"
  mv "$TMP_FILE" "$GENERATED_FILE"
  echo "✅ 已插入缺失的 import 语句"
else
  echo "✅ import 语句已存在"
fi

# ✅ 修复 2：转义 SQL 模板中的反引号（避免 TypeScript 报错）
echo "🔧 正在转义反引号..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS (BSD sed)
  sed -i '' 's/`\([a-zA-Z0-9_]\+\)`/\\\`\1\\\`/g' "$GENERATED_FILE"
else
  # Linux (GNU sed)
  sed -i.bak 's/`\([a-zA-Z0-9_]\+\)`/\\\`\1\\\`/g' "$GENERATED_FILE"
  rm -f "$GENERATED_FILE.bak"
fi
echo "✅ 反引号已成功转义"

# ✅ TypeScript 语法验证
echo "🔍 正在进行 TypeScript 语法验证..."
if npx tsc "$GENERATED_FILE" --noEmit --skipLibCheck; then
  echo "✅ TypeScript 编译通过！"
else
  echo "❌ TypeScript 编译失败，请手动检查文件语法"
  exit 1
fi

# ✅ 完成提示
echo ""
echo "🎉 迁移文件已生成并修复完成！"
echo "📄 文件路径: $GENERATED_FILE"
echo ""
echo "💡 下一步建议："
echo "   git add '$GENERATED_FILE'"
echo "   npm run db:run"

exit 0