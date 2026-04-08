#!/usr/bin/env bash
# Hook #9: Phase gate validation
# PreToolUse hook for Agent tool
# Validates prerequisite artifacts exist before spawning phase agents
# Exit 2 to block (missing artifacts), 0 to allow
set -euo pipefail

INPUT=$(cat)
agent_type=$(echo "$INPUT" | jq -r '.tool_input.subagent_type // ""' 2>/dev/null || echo "")

# Only gate super-dev agents
[[ "$agent_type" != super-dev:* ]] && exit 0

# Skip team-lead (it's the orchestrator, not a phase worker)
[[ "$agent_type" == "super-dev:team-lead" ]] && exit 0

# Load manifest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="${SCRIPT_DIR}/phase-manifest.json"
[ ! -f "$MANIFEST" ] && exit 0

# Check if this agent type has gate requirements
GATE=$(jq -r --arg agent "$agent_type" '.gates[$agent] // empty' "$MANIFEST" 2>/dev/null)
[ -z "$GATE" ] && exit 0

# Extract spec directory from agent prompt
# The team-lead always includes "specification/[spec-index]-[spec-name]" in the prompt
agent_prompt=$(echo "$INPUT" | jq -r '.tool_input.prompt // ""' 2>/dev/null || echo "")

# Try to find spec directory from the prompt
SPEC_DIR=""

# Method 1: Extract from prompt (most reliable — team-lead always includes spec path)
if [ -n "$agent_prompt" ]; then
  # Match "specification/NNN-name" or "Spec directory: specification/NNN-name"
  SPEC_DIR=$(echo "$agent_prompt" | grep -oP 'specification/[^\s,)"]+' | head -1 || echo "")
fi

# Method 2: Check SUPER_DEV_SPEC_DIR env var
if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
  SPEC_DIR="${SUPER_DEV_SPEC_DIR:-}"
fi

# Method 3: Scan for spec directories in current working directory
if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
  for candidate in specification/*/; do
    if [ -d "$candidate" ]; then
      # Pick the most recently modified spec directory
      SPEC_DIR=$(ls -td specification/*/ 2>/dev/null | head -1 || echo "")
      break
    fi
  done
fi

# Method 4: Check parent directory (worktree scenario)
if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
  for candidate in ../specification/*/; do
    if [ -d "$candidate" ]; then
      SPEC_DIR=$(ls -td ../specification/*/ 2>/dev/null | head -1 || echo "")
      break
    fi
  done
fi

# If no spec directory found, allow (early phases haven't created it yet)
if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
  exit 0
fi

# Remove trailing slash
SPEC_DIR="${SPEC_DIR%/}"

# Check required files
PHASE=$(echo "$GATE" | jq -r '.phase')
DESCRIPTION=$(echo "$GATE" | jq -r '.description')
MISSING=""

while IFS= read -r req_file; do
  [ -z "$req_file" ] && continue

  found=false

  # Search in spec directory (exact match and glob for numbered prefixes)
  for candidate in "$SPEC_DIR/$req_file" "$SPEC_DIR"/*"$req_file"; do
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
  echo "PHASE GATE BLOCKED: Cannot start Phase ${PHASE} (${agent_type})." >&2
  echo "Reason: ${DESCRIPTION}" >&2
  echo "" >&2
  echo "Missing prerequisite artifacts in ${SPEC_DIR}:" >&2
  echo -e "$MISSING" >&2
  echo "Complete the previous phase(s) and ensure all artifacts are written before proceeding." >&2
  exit 2
fi

exit 0
