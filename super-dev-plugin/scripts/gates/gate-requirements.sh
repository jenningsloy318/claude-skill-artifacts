#!/bin/bash
# Gate: Requirements Completeness Check
# Verifies requirements.md has minimum quality before proceeding to BDD scenarios
#
# Usage: gate-requirements.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-requirements.sh <spec-dir>}"
REQ_FILE="${SPEC_DIR}/01-requirements.md"

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

# Check file exists
if [ ! -f "$REQ_FILE" ]; then
    echo "GATE FAIL: Requirements file not found: ${REQ_FILE}"
    exit 1
fi

# Check for acceptance criteria section
has_ac=$(grep -ci "acceptance criteria" "$REQ_FILE" || true)
check "Has acceptance criteria section" "$([ "$has_ac" -gt 0 ] && echo true || echo false)"

# Check for at least 2 acceptance criteria items
ac_count=$(grep -cE '^\s*-\s*\[' "$REQ_FILE" 2>/dev/null || true)
check "Has at least 2 acceptance criteria items (found: ${ac_count})" "$([ "$ac_count" -ge 2 ] && echo true || echo false)"

# Check for non-functional requirements
has_nfr=$(grep -ci "non-functional\|performance\|security\|accessibility" "$REQ_FILE" || true)
check "Has non-functional requirements" "$([ "$has_nfr" -gt 0 ] && echo true || echo false)"

# Check for executive summary
has_summary=$(grep -ci "executive summary\|summary" "$REQ_FILE" || true)
check "Has executive summary" "$([ "$has_summary" -gt 0 ] && echo true || echo false)"

# Check minimum file size (at least 500 chars = not just a template)
file_size=$(wc -c < "$REQ_FILE" | tr -d ' ')
check "Requirements not just a template (>500 chars, actual: ${file_size})" "$([ "$file_size" -gt 500 ] && echo true || echo false)"

# Report
TOTAL=$((PASS + FAIL))
echo "GATE: Requirements Completeness"
echo "  Score: ${PASS}/${TOTAL} checks passed"

if [ "$FAIL" -gt 0 ]; then
    echo -e "  Failures:${ERRORS}"
    echo "GATE RESULT: FAIL"
    exit 1
else
    echo "GATE RESULT: PASS"
    exit 0
fi
