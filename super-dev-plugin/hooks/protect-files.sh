#!/usr/bin/env bash
# Hook #3: Protect sensitive files from edits
# PreToolUse hook for Edit|Write tools
# Exit 2 to block, 0 to allow
set -euo pipefail

INPUT=$(cat)
file=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""' 2>/dev/null || echo "")

[ -z "$file" ] && exit 0

basename=$(basename "$file")

# Get relative path from project root
rel_path="$file"
if [ -n "${PWD:-}" ]; then
  rel_path="${file#$PWD/}"
fi

protected_basename_patterns=(
  '^\\.env$'
  '^\\.env\\.'
  '\\.pem$'
  '\\.key$'
  '\\.p12$'
  '\\.pfx$'
  '\\.keystore$'
  '^id_rsa'
  '^id_ed25519'
  '\\.secret$'
  '^token\\.json$'
  '^service-account.*\\.json$'
)

protected_path_patterns=(
  '^secrets/'
  '^\\.git/'
  '^credentials/'
)

for pattern in "${protected_basename_patterns[@]}"; do
  if echo "$basename" | grep -qiE "$pattern"; then
    echo "BLOCKED by super-dev safety hook: '$file' is a protected sensitive file." >&2
    echo "Explain why this edit is necessary and request an override." >&2
    exit 2
  fi
done

for pattern in "${protected_path_patterns[@]}"; do
  if echo "$rel_path" | grep -qiE "$pattern"; then
    echo "BLOCKED by super-dev safety hook: '$file' is in a protected directory." >&2
    echo "Explain why this edit is necessary and request an override." >&2
    exit 2
  fi
done

exit 0
