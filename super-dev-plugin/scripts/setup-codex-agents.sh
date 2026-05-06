#!/usr/bin/env bash
# Setup script to install super-dev agents to ~/.codex/agents/
# Usage: ./scripts/setup-codex-agents.sh [--global | --project]
#   --global   Install to ~/.codex/agents/ (default)
#   --project  Install to .codex/agents/ in the current project

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
AGENTS_SOURCE="$PLUGIN_ROOT/.codex/agents"

MODE="${1:---global}"

case "$MODE" in
  --global)
    TARGET_DIR="$HOME/.codex/agents"
    ;;
  --project)
    TARGET_DIR=".codex/agents"
    ;;
  *)
    echo "Usage: $0 [--global | --project]"
    echo "  --global   Install to ~/.codex/agents/ (default)"
    echo "  --project  Install to .codex/agents/ in the current project"
    exit 1
    ;;
esac

if [ ! -d "$AGENTS_SOURCE" ]; then
  echo "Error: Agents source directory not found: $AGENTS_SOURCE"
  exit 1
fi

mkdir -p "$TARGET_DIR"

count=0
for agent_file in "$AGENTS_SOURCE"/*.toml; do
  [ -f "$agent_file" ] || continue
  agent_name="$(basename "$agent_file")"
  cp "$agent_file" "$TARGET_DIR/$agent_name"
  count=$((count + 1))
done

echo "Installed $count agents to $TARGET_DIR"

# Also copy config.toml if installing to project
if [ "$MODE" = "--project" ] && [ -f "$PLUGIN_ROOT/.codex/config.toml" ]; then
  mkdir -p ".codex"
  cp "$PLUGIN_ROOT/.codex/config.toml" ".codex/config.toml"
  echo "Copied config.toml to .codex/config.toml"
fi

# Copy AGENTS.md to project root if installing to project
if [ "$MODE" = "--project" ] && [ -f "$PLUGIN_ROOT/AGENTS.md" ]; then
  cp "$PLUGIN_ROOT/AGENTS.md" "./AGENTS.md"
  echo "Copied AGENTS.md to project root"
fi

echo ""
echo "Setup complete. Available agents:"
ls "$TARGET_DIR"/*.toml 2>/dev/null | xargs -I{} basename {} .toml | sed 's/^/  - /'
