#!/bin/bash
# src/database/scripts/run-migration.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

cd "$PROJECT_ROOT"

echo "🚀 开始数据库迁移..."

# 运行迁移
npm run migration:run

echo "✅ 迁移完成"

# 显示迁移状态
npm run db:status