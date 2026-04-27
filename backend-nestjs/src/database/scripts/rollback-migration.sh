#!/bin/bash
# src/database/scripts/rollback-migration.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

cd "$PROJECT_ROOT"

echo "🔄 开始回滚迁移..."

# 回滚最后一次迁移
npm run migration:revert

echo "✅ 回滚完成"