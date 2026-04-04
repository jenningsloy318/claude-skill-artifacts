#!/usr/bin/env bash
# Hook #2: Block dangerous commands before execution
# PreToolUse hook for Bash tool
# Exit 2 to block, 0 to allow
set -euo pipefail

INPUT=$(cat)
cmd=$(echo "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

[ -z "$cmd" ] && exit 0

dangerous_patterns=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \.\."
  "git reset --hard"
  "git push.*--force[^-]"
  "git push.*-f "
  "git push -f$"
  "git clean -fd"
  "git branch -D"
  "DROP TABLE"
  "DROP DATABASE"
  "TRUNCATE TABLE"
  "DELETE FROM [^ ]*$"
  "curl.*\|.*sh"
  "curl.*\|.*bash"
  "wget.*\|.*sh"
  "wget.*\|.*bash"
  "chmod 777"
  "chmod -R 777"
  "chmod \+s"
  "kubectl delete namespace"
  "kubectl delete.*--all"
  "npm unpublish"
  "cargo yank"
  "mkfs\."
  "dd if=.* of=/dev/"
  "> /dev/sd"
)

for pattern in "${dangerous_patterns[@]}"; do
  if echo "$cmd" | grep -qiE "$pattern"; then
    echo "BLOCKED by super-dev safety hook: command matches dangerous pattern '$pattern'." >&2
    echo "Propose a safer alternative." >&2
    exit 2
  fi
done

exit 0
