#!/usr/bin/env bash
# Hook #6: Auto-lint and fix errors after edit
# PostToolUse hook for Write|Edit tools
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

INPUT=$(cat)
file=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""' 2>/dev/null || echo "")

[ -z "$file" ] && exit 0
[ ! -f "$file" ] && exit 0

ext="${file##*.}"
PROJECT_ROOT=$(find_project_root "$(dirname "$file")")

case "$ext" in
  js|jsx|ts|tsx)
    if [ -f "$PROJECT_ROOT/biome.json" ] || [ -f "$PROJECT_ROOT/biome.jsonc" ]; then
      npx @biomejs/biome lint --write "$file" 2>&1 | tail -10 || true
    elif [ -f "$PROJECT_ROOT/eslint.config.js" ] || [ -f "$PROJECT_ROOT/eslint.config.mjs" ] || \
         [ -f "$PROJECT_ROOT/eslint.config.cjs" ] || [ -f "$PROJECT_ROOT/.eslintrc.json" ] || \
         [ -f "$PROJECT_ROOT/.eslintrc.js" ] || [ -f "$PROJECT_ROOT/.eslintrc.cjs" ]; then
      npx eslint --fix "$file" 2>&1 | tail -10 || true
    fi
    ;;
  py)
    if command -v ruff &>/dev/null; then
      ruff check --fix "$file" 2>&1 | tail -10 || true
    elif command -v flake8 &>/dev/null; then
      flake8 "$file" 2>&1 | tail -10 || true
    fi
    ;;
  go)
    if command -v golangci-lint &>/dev/null; then
      golangci-lint run --fix "$file" 2>&1 | tail -10 || true
    fi
    ;;
  rs)
    if command -v cargo &>/dev/null; then
      (cd "$PROJECT_ROOT" && cargo clippy --fix --allow-dirty --allow-staged 2>&1 | tail -10 || true)
    fi
    ;;
  rb)
    if command -v rubocop &>/dev/null; then
      rubocop -a --stderr "$file" 2>&1 | tail -10 || true
    fi
    ;;
esac

exit 0
