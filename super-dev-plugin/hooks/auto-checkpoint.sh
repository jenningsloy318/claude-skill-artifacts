#!/usr/bin/env bash
# Hook #8: Auto-checkpoint on stop
# Stop hook — creates a recoverable git checkpoint of uncommitted changes
# Uses `git stash create` to make a commit object WITHOUT modifying the working tree
set -euo pipefail

# Only run if in a git repo
git rev-parse --is-inside-work-tree &>/dev/null || exit 0

# Check if there are any changes to checkpoint
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
  # No changes to checkpoint
  exit 0
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")

# git stash create: makes a stash commit without touching working tree or stash list
STASH_SHA=$(git stash create "super-dev checkpoint: ${BRANCH} at ${TIMESTAMP}" 2>/dev/null || echo "")

if [ -n "$STASH_SHA" ]; then
  # Store the checkpoint SHA in a log file for recovery
  LOG_DIR="${CLAUDE_PLUGIN_DATA:-/tmp}"
  LOG_FILE="${LOG_DIR}/checkpoints.log"
  echo "${TIMESTAMP} ${BRANCH} ${STASH_SHA}" >> "$LOG_FILE" 2>/dev/null || true

  # Also store as a git ref for easier discovery
  git update-ref "refs/super-dev-checkpoints/$(date -u +%Y%m%d-%H%M%S)" "$STASH_SHA" 2>/dev/null || true
fi

exit 0
