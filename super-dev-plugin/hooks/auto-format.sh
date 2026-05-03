#!/usr/bin/env bash
# Hook #1: Auto-format every file Claude touches
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
  js|jsx|ts|tsx|css|scss|json|yaml|yml|html|vue|svelte|md)
    if [ -f "$PROJECT_ROOT/biome.json" ] || [ -f "$PROJECT_ROOT/biome.jsonc" ]; then
      npx @biomejs/biome format --write "$file" 2>/dev/null || true
    elif [ -f "$PROJECT_ROOT/deno.json" ] || [ -f "$PROJECT_ROOT/deno.jsonc" ]; then
      deno fmt "$file" 2>/dev/null || true
    elif [ -f "$PROJECT_ROOT/.prettierrc" ] || [ -f "$PROJECT_ROOT/.prettierrc.json" ] || \
         [ -f "$PROJECT_ROOT/.prettierrc.js" ] || [ -f "$PROJECT_ROOT/.prettierrc.mjs" ] || \
         [ -f "$PROJECT_ROOT/prettier.config.js" ] || [ -f "$PROJECT_ROOT/prettier.config.mjs" ] || \
         [ -f "$PROJECT_ROOT/prettier.config.cjs" ]; then
      npx prettier --write "$file" 2>/dev/null || true
    fi
    ;;
  py)
    if command -v ruff &>/dev/null; then
      ruff format "$file" 2>/dev/null || true
    elif command -v black &>/dev/null; then
      black --quiet "$file" 2>/dev/null || true
    fi
    ;;
  go)
    if command -v gofmt &>/dev/null; then
      gofmt -w "$file" 2>/dev/null || true
    fi
    ;;
  rs)
    if command -v rustfmt &>/dev/null; then
      rustfmt "$file" 2>/dev/null || true
    fi
    ;;
  rb)
    if command -v rubocop &>/dev/null; then
      rubocop -a --stderr "$file" 2>/dev/null || true
    fi
    ;;
  swift)
    if command -v swift-format &>/dev/null; then
      swift-format -i "$file" 2>/dev/null || true
    fi
    ;;
  kt|kts)
    if command -v ktlint &>/dev/null; then
      ktlint -F "$file" 2>/dev/null || true
    fi
    ;;
  cs)
    if command -v dotnet &>/dev/null; then
      dotnet format --include "$file" 2>/dev/null || true
    fi
    ;;
esac

exit 0
