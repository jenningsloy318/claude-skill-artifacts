#!/usr/bin/env bash
# Hook #9: Stage gate validation
# PreToolUse hook for Agent tool
# Validates prerequisite artifacts exist before spawning stage agents
# Exit 2 to block (missing artifacts), 0 to allow
set -euo pipefail

INPUT=$(cat)
agent_type=$(echo "$INPUT" | jq -r '.tool_input.subagent_type // ""' 2>/dev/null || echo "")

# Only gate super-dev agents
[[ "$agent_type" != super-dev:* ]] && exit 0

# Skip team-lead (it's the orchestrator, not a stage worker)
[[ "$agent_type" == "super-dev:team-lead" ]] && exit 0

# Load manifest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="${SCRIPT_DIR}/stage-manifest.json"
[ ! -f "$MANIFEST" ] && exit 0

# Check if this agent type has gate requirements (direct lookup first, then groups)
GATE=$(jq -c --arg agent "$agent_type" '.gates[$agent] // empty' "$MANIFEST" 2>/dev/null || true)
if [ -z "$GATE" ]; then
  # Check groups for matching agent (compact output so head -1 gets full JSON)
  GATE=$(jq -c --arg agent "$agent_type" '
    .groups[]? | select(.match[] == $agent) | .gate
  ' "$MANIFEST" 2>/dev/null | head -1 || true)
fi
[ -z "$GATE" ] && exit 0
# Validate GATE is valid JSON before proceeding
echo "$GATE" | jq empty 2>/dev/null || exit 0

# Extract spec directory from agent prompt
# The team-lead always includes "specification/[spec-index]-[spec-name]" in the prompt
agent_prompt=$(echo "$INPUT" | jq -r '.tool_input.prompt // ""' 2>/dev/null || echo "")

# Try to find spec directory from the prompt
SPEC_DIR=""
SPEC_NAME=""

# Method 1: Extract from prompt (most reliable — team-lead always includes spec path)
if [ -n "$agent_prompt" ]; then
  # Match "specification/NNN-name" or "Spec directory: specification/NNN-name"
  SPEC_DIR=$(echo "$agent_prompt" | grep -oE 'specification/[^[:space:],)"]+' | head -1 || echo "")
  # Extract just the spec name (e.g., "94-settings-deferred-apply")
  if [ -n "$SPEC_DIR" ]; then
    SPEC_NAME=$(basename "$SPEC_DIR")
  fi
fi

# Method 2: Check SUPER_DEV_SPEC_DIR env var
if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
  SPEC_DIR="${SUPER_DEV_SPEC_DIR:-}"
fi

# Method 3: Scan for spec directories in current working directory
if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
  SPEC_DIR=$(ls -td specification/*/ 2>/dev/null | head -1 || echo "")
fi

# Method 4: Check worktree paths (hook runs from main repo root, but spec is inside worktree)
if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
  if [ -n "$SPEC_NAME" ]; then
    # Try the exact worktree path for this spec
    WT_CANDIDATE=".worktree/${SPEC_NAME}/specification/${SPEC_NAME}"
    if [ -d "$WT_CANDIDATE" ]; then
      SPEC_DIR="$WT_CANDIDATE"
    fi
  fi
  # Fallback: scan all worktrees for matching spec directories
  if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
    for wt in .worktree/*/; do
      if [ -d "$wt" ]; then
        candidate=$(ls -td "${wt}specification/"*/ 2>/dev/null | head -1 || echo "")
        if [ -n "$candidate" ] && [ -d "$candidate" ]; then
          SPEC_DIR="$candidate"
          break
        fi
      fi
    done
  fi
fi

# Method 5: Check parent directory (already inside worktree)
if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
  SPEC_DIR=$(ls -td ../specification/*/ 2>/dev/null | head -1 || echo "")
fi

# If no spec directory found, allow (early phases haven't created it yet)
if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
  exit 0
fi

# Remove trailing slash
SPEC_DIR="${SPEC_DIR%/}"

# Extract stage info once
STAGE=$(echo "$GATE" | jq -r '.stage' 2>/dev/null || echo "unknown")
DESCRIPTION=$(echo "$GATE" | jq -r '.description' 2>/dev/null || echo "")

# Check previous stage status in workflow-tracking.json
PREV_STAGES=$(echo "$GATE" | jq -r '.previousStages[]? // empty' 2>/dev/null)
if [ -n "$PREV_STAGES" ]; then
  # Find the workflow-tracking.json in the spec directory
  TRACKING_FILE=$(ls "$SPEC_DIR"/*-workflow-tracking.json 2>/dev/null | head -1 || echo "")
  if [ -n "$TRACKING_FILE" ] && [ -f "$TRACKING_FILE" ]; then
    BLOCKED_STAGES=""
    while IFS= read -r prev_stage_id; do
      [ -z "$prev_stage_id" ] && continue
      # Look up the stage status in the tracking JSON (id can be number or float like 3.5)
      # Supports both .stages[] (current format) and .phases[] (legacy format)
      # jq select() returns empty output (exit 0) when no match — default to "pending"
      prev_status=$(jq -r --argjson sid "$prev_stage_id" \
        '(.stages // .phases // [])[] | select(.id == $sid) | .status // "pending"' \
        "$TRACKING_FILE" 2>/dev/null || true)
      prev_status="${prev_status:-pending}"
      if [ "$prev_status" != "complete" ] && [ "$prev_status" != "skipped" ]; then
        prev_name=$(jq -r --argjson sid "$prev_stage_id" \
          '(.stages // .phases // [])[] | select(.id == $sid) | .name // "Unknown"' \
          "$TRACKING_FILE" 2>/dev/null || true)
        prev_name="${prev_name:-Unknown}"
        BLOCKED_STAGES="${BLOCKED_STAGES}  - Stage ${prev_stage_id} (${prev_name}): status is '${prev_status}', expected 'complete' or 'skipped'\n"
      fi
    done <<< "$PREV_STAGES"

    if [ -n "$BLOCKED_STAGES" ]; then
      echo "STAGE GATE BLOCKED: Cannot start Stage ${STAGE} (${agent_type})." >&2
      echo "Reason: Previous stage(s) not complete in workflow-tracking.json." >&2
      echo "" >&2
      echo "Incomplete prerequisite stages:" >&2
      echo -e "$BLOCKED_STAGES" >&2
      echo "Complete the previous stage(s) and update the tracking JSON before proceeding." >&2
      exit 2
    fi
  fi
fi

# Check required files
MISSING=""

while IFS= read -r req_file; do
  [ -z "$req_file" ] && continue

  # Replace [doc-index] with * for shell globbing (manifest uses [doc-index] as placeholder)
  glob_pattern="${req_file/\[doc-index\]/*}"

  found=false

  # Search in spec directory (glob for numbered prefixes like 01-requirements.md)
  for candidate in "$SPEC_DIR"/$glob_pattern; do
    if [ -f "$candidate" ] && [ -s "$candidate" ]; then
      # Check required sections if defined
      SECTIONS=$(echo "$GATE" | jq -r --arg f "$req_file" '.sections[$f][]? // empty' 2>/dev/null || echo "")

      if [ -n "$SECTIONS" ]; then
        section_ok=true
        while IFS= read -r section; do
          [ -z "$section" ] && continue
          if ! grep -qi "$section" "$candidate" 2>/dev/null; then
            MISSING="${MISSING}  - ${req_file} (exists but missing required section: '${section}')\n"
            section_ok=false
            break
          fi
        done <<< "$SECTIONS"

        if [ "$section_ok" = true ]; then
          found=true
        fi
      else
        found=true
      fi
      break
    fi
  done

  if [ "$found" = false ] && ! echo -e "$MISSING" | grep -q "$req_file"; then
    MISSING="${MISSING}  - ${req_file} (not found or empty in ${SPEC_DIR})\n"
  fi
done < <(echo "$GATE" | jq -r '.requires[]' 2>/dev/null)

if [ -n "$MISSING" ]; then
  echo "STAGE GATE BLOCKED: Cannot start Stage ${STAGE} (${agent_type})." >&2
  echo "Reason: ${DESCRIPTION}" >&2
  echo "" >&2
  echo "Missing prerequisite artifacts in ${SPEC_DIR}:" >&2
  echo -e "$MISSING" >&2
  echo "Complete the previous stage(s) and ensure all artifacts are written before proceeding." >&2
  exit 2
fi

# Run additional gate script if defined in manifest
GATE_SCRIPT=$(echo "$GATE" | jq -r '.gate // empty' 2>/dev/null)
if [ -n "$GATE_SCRIPT" ]; then
  GATE_SCRIPT_PATH="${SCRIPT_DIR}/../scripts/gates/${GATE_SCRIPT}"
  if [ -x "$GATE_SCRIPT_PATH" ]; then
    if ! "$GATE_SCRIPT_PATH" "$SPEC_DIR" 2>&1; then
      echo "" >&2
      echo "STAGE GATE BLOCKED: Gate script ${GATE_SCRIPT} FAILED for Stage ${STAGE} (${agent_type})." >&2
      exit 2
    fi
  fi
fi

exit 0
