#!/usr/bin/env bash
# Hook #4: Run tests after every edit (opt-in)
# PostToolUse hook for Write|Edit tools
# Enable: export SUPER_DEV_TEST_ON_EDIT=1
# Provides immediate feedback loop — Claude sees failures and self-corrects
set -euo pipefail

# Opt-in only — skip if not enabled
[ "${SUPER_DEV_TEST_ON_EDIT:-0}" != "1" ] && exit 0

INPUT=$(cat)
file=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""' 2>/dev/null || echo "")

[ -z "$file" ] && exit 0
[ ! -f "$file" ] && exit 0

# Skip non-source files (docs, configs, etc.)
ext="${file##*.}"
case "$ext" in
  md|txt|json|yaml|yml|toml|lock|log|csv) exit 0 ;;
esac

# Find project root
find_project_root() {
  local dir
  dir="$(dirname "$file")"
  while [ "$dir" != "/" ]; do
    for marker in package.json Cargo.toml go.mod pyproject.toml setup.py .git; do
      [ -e "$dir/$marker" ] && echo "$dir" && return
    done
    dir="$(dirname "$dir")"
  done
  dirname "$file"
}

PROJECT_ROOT=$(find_project_root)
cd "$PROJECT_ROOT" 2>/dev/null || exit 0

# Detect and run test suite (summary only to preserve context)
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
