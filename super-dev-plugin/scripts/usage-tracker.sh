#!/usr/bin/env bash
# Usage tracker for super-dev plugin
# Logs skill and agent invocations to ${CLAUDE_PLUGIN_DATA}/global/usage.log
#
# Called by PreToolUse hook when Skill or Agent tools are invoked.
# Input: JSON via stdin with tool_name, tool_input fields
# Output: None (append-only logging)

set -euo pipefail

GLOBAL_DATA="${CLAUDE_PLUGIN_DATA:-/tmp}/global"
mkdir -p "$GLOBAL_DATA"
USAGE_LOG="${GLOBAL_DATA}/usage.log"
STATS_FILE="${GLOBAL_DATA}/stats.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Read tool input from stdin
INPUT=$(cat)

# Extract tool name and relevant context
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"' 2>/dev/null || echo "unknown")
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // {}' 2>/dev/null || echo "{}")

# Determine what was invoked
case "$TOOL_NAME" in
  Skill)
    SKILL_NAME=$(echo "$TOOL_INPUT" | jq -r '.skill_name // .name // "unknown"' 2>/dev/null || echo "unknown")
    echo "{\"ts\":\"$TIMESTAMP\",\"type\":\"skill\",\"name\":\"$SKILL_NAME\"}" >> "$USAGE_LOG"
    ;;
  Agent)
    AGENT_TYPE=$(echo "$TOOL_INPUT" | jq -r '.subagent_type // "general"' 2>/dev/null || echo "general")
    AGENT_DESC=$(echo "$TOOL_INPUT" | jq -r '.description // ""' 2>/dev/null || echo "")
    echo "{\"ts\":\"$TIMESTAMP\",\"type\":\"agent\",\"name\":\"$AGENT_TYPE\",\"desc\":\"$AGENT_DESC\"}" >> "$USAGE_LOG"
    ;;
  *)
    # Not a skill/agent invocation, skip
    ;;
esac

# Update stats.json (create if missing)
if [ ! -f "$STATS_FILE" ]; then
  cat > "$STATS_FILE" << 'INIT'
{"version":"1.0.0","total_invocations":0,"skills":{},"agents":{},"last_updated":""}
INIT
fi

# Increment counters using jq (atomic write via temp file + mv)
case "$TOOL_NAME" in
  Skill)
    UPDATED=$(jq --arg name "$SKILL_NAME" --arg ts "$TIMESTAMP" '
      .total_invocations += 1 |
      .skills[$name] = ((.skills[$name] // 0) + 1) |
      .last_updated = $ts
    ' "$STATS_FILE" 2>/dev/null)
    if [ -n "$UPDATED" ]; then
      TMP_STATS=$(mktemp)
      echo "$UPDATED" > "$TMP_STATS"
      mv "$TMP_STATS" "$STATS_FILE"
    fi
    ;;
  Agent)
    UPDATED=$(jq --arg name "$AGENT_TYPE" --arg ts "$TIMESTAMP" '
      .total_invocations += 1 |
      .agents[$name] = ((.agents[$name] // 0) + 1) |
      .last_updated = $ts
    ' "$STATS_FILE" 2>/dev/null)
    if [ -n "$UPDATED" ]; then
      TMP_STATS=$(mktemp)
      echo "$UPDATED" > "$TMP_STATS"
      mv "$TMP_STATS" "$STATS_FILE"
    fi
    ;;
esac

exit 0
