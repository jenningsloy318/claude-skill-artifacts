#!/usr/bin/env bash
# Hook #4: Run tests after every edit (opt-in)
# PostToolUse hook for Write|Edit tools
# Enable: export SUPER_DEV_TEST_ON_EDIT=1
set -euo pipefail

[ "${SUPER_DEV_TEST_ON_EDIT:-0}" != "1" ] && exit 0

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

INPUT=$(cat)
file=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""' 2>/dev/null || echo "")

[ -z "$file" ] && exit 0
[ ! -f "$file" ] && exit 0

ext="${file##*.}"
case "$ext" in
  md|txt|json|yaml|yml|toml|lock|log|csv) exit 0 ;;
esac

PROJECT_ROOT=$(find_project_root "$(dirname "$file")")
cd "$PROJECT_ROOT" 2>/dev/null || exit 0

# Detect and run test suite
if [ -f "package.json" ]; then
  if jq -e '.scripts.test' package.json &>/dev/null; then
    npm run test --silent 2>&1 | tail -20 || true
  fi
elif [ -f "Cargo.toml" ]; then
  cargo test 2>&1 | tail -20 || true
elif [ -f "go.mod" ]; then
  go test ./... 2>&1 | tail -20 || true
elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
  if command -v pytest &>/dev/null; then
    pytest --tb=short -q 2>&1 | tail -20 || true
  fi
elif [ -f "Makefile" ] && grep -q "^test:" Makefile 2>/dev/null; then
  make test 2>&1 | tail -20 || true
fi

exit 0
