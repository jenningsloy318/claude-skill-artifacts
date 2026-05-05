#!/bin/bash
# Gate: Documentation Completeness Check
# Verifies spec directory docs are complete (no placeholders/TODOs) and key artifacts exist
#
# Usage: gate-docs-drift.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-docs-drift.sh <spec-dir>}"
source "$(dirname "$0")/gate-lib.sh"

# Check key spec documents exist and are non-empty
SPEC_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name "*-specification.md" -type f 2>/dev/null | head -1)
check "Specification exists" "$([ -n "$SPEC_FILE" ] && [ -s "$SPEC_FILE" ] && echo true || echo false)"

IMPL_PLAN=$(find "$SPEC_DIR" -maxdepth 1 -name "*-implementation-plan.md" -type f 2>/dev/null | head -1)
check "Implementation plan exists" "$([ -n "$IMPL_PLAN" ] && [ -s "$IMPL_PLAN" ] && echo true || echo false)"

TASK_LIST=$(find "$SPEC_DIR" -maxdepth 1 -name "*-task-list.md" -type f 2>/dev/null | head -1)
check "Task list exists" "$([ -n "$TASK_LIST" ] && [ -s "$TASK_LIST" ] && echo true || echo false)"

IMPL_SUMMARY=$(find "$SPEC_DIR" -maxdepth 1 -name "*-implementation-summary.md" -type f 2>/dev/null | head -1)
check "Implementation summary exists" "$([ -n "$IMPL_SUMMARY" ] && [ -s "$IMPL_SUMMARY" ] && echo true || echo false)"

# Check spec directory markdown files for leftover TODOs/placeholders
TODO_COUNT=0
PLACEHOLDER_FILES=""
for md_file in "$SPEC_DIR"/*.md; do
    [ -f "$md_file" ] || continue
    file_todos=$(grep -ciE 'TODO|FIXME|TBD|PLACEHOLDER|\[INSERT\]|\[FILL' "$md_file" 2>/dev/null) || true
    file_todos=${file_todos:-0}
    if [ "$file_todos" -gt 0 ]; then
        TODO_COUNT=$((TODO_COUNT + file_todos))
        PLACEHOLDER_FILES="${PLACEHOLDER_FILES}    $(basename "$md_file"): ${file_todos} placeholders\n"
    fi
done

if [ "$TODO_COUNT" -gt 3 ]; then
    check "No excessive placeholders in docs (found: ${TODO_COUNT})" "false"
    if [ -n "$PLACEHOLDER_FILES" ]; then
        ERRORS="${ERRORS}\n  Files with placeholders:\n${PLACEHOLDER_FILES}"
    fi
else
    check "Placeholder count acceptable (${TODO_COUNT})" "true"
fi

# Check workflow tracking JSON exists and is valid
TRACKING=$(find "$SPEC_DIR" -maxdepth 1 -name "*-workflow-tracking.json" -type f 2>/dev/null | head -1)
if [ -n "$TRACKING" ] && [ -s "$TRACKING" ]; then
    check "Workflow tracking JSON exists" "true"
    # Verify it's valid JSON
    if jq empty "$TRACKING" 2>/dev/null; then
        check "Workflow tracking JSON is valid" "true"
    else
        check "Workflow tracking JSON is valid" "false"
    fi
else
    check "Workflow tracking JSON exists" "false"
fi

gate_report "Documentation Completeness"
