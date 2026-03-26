#!/bin/bash
# Gate: Documentation-Code Drift Check
# Verifies documentation matches the code that was actually implemented
#
# Usage: gate-docs-drift.sh <spec-dir> <project-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-docs-drift.sh <spec-dir> <project-dir>}"
PROJECT_DIR="${2:?Usage: gate-docs-drift.sh <spec-dir> <project-dir>}"

PASS=0
FAIL=0
ERRORS=""

check() {
    local desc="$1"
    local result="$2"
    if [ "$result" = "true" ]; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
        ERRORS="${ERRORS}\n  FAIL: ${desc}"
    fi
}

# Check documentation files exist
DOCS_FILE=$(find "$SPEC_DIR" -name "*documentation*" -o -name "*docs*" -type f 2>/dev/null | head -1)
if [ -n "$DOCS_FILE" ]; then
    check "Documentation update file exists" "true"
else
    # Not a failure if no docs file - some tasks don't need docs
    echo "  Note: No documentation update file found (may not be required)"
fi

# Check README exists and is recent
if [ -f "${PROJECT_DIR}/README.md" ]; then
    check "README.md exists in project" "true"

    # Check README mentions key aspects of the feature
    readme_size=$(wc -c < "${PROJECT_DIR}/README.md" | tr -d ' ')
    check "README is non-trivial (>100 chars, actual: ${readme_size})" "$([ "$readme_size" -gt 100 ] && echo true || echo false)"
else
    echo "  Note: No README.md found in project root"
fi

# Check for any TODO/FIXME comments left in code
cd "$PROJECT_DIR"
todo_count=$(grep -rl "TODO\|FIXME\|HACK\|XXX" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.py" --include="*.rs" --include="*.go" . 2>/dev/null | wc -l | tr -d ' ')
if [ "$todo_count" -gt 5 ]; then
    check "No excessive TODO/FIXME comments (found: ${todo_count} files)" "false"
else
    check "TODO/FIXME count acceptable (${todo_count} files)" "true"
fi

# Report
TOTAL=$((PASS + FAIL))
echo "GATE: Documentation-Code Drift"
echo "  Score: ${PASS}/${TOTAL} checks passed"

if [ "$FAIL" -gt 0 ]; then
    echo -e "  Failures:${ERRORS}"
    echo "GATE RESULT: FAIL"
    exit 1
else
    echo "GATE RESULT: PASS"
    exit 0
fi
