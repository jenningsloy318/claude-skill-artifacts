#!/bin/bash
# Gate: BDD Scenario Quality Check
# Verifies behavior scenarios are complete and traceable to acceptance criteria
#
# Usage: gate-bdd.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-bdd.sh <spec-dir>}"
BDD_FILE="${SPEC_DIR}/01.1-behavior-scenarios.md"
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

# Check BDD file exists
if [ ! -f "$BDD_FILE" ]; then
    echo "GATE FAIL: BDD scenarios file not found: ${BDD_FILE}"
    exit 1
fi

# Check for SCENARIO-XXX IDs
scenario_count=$(grep -cE 'SCENARIO-[0-9]+' "$BDD_FILE" 2>/dev/null || true)
check "Has SCENARIO-IDs (found: ${scenario_count})" "$([ "$scenario_count" -ge 1 ] && echo true || echo false)"

# Check for Given/When/Then structure
gwt_count=$(grep -ciE '^\s*(given|when|then|and)\b' "$BDD_FILE" 2>/dev/null || true)
check "Has Given/When/Then structure (found: ${gwt_count} keywords)" "$([ "$gwt_count" -ge 3 ] && echo true || echo false)"

# Check for AC references (traceability)
ac_refs=$(grep -cE 'AC-[0-9]+' "$BDD_FILE" 2>/dev/null || true)
check "Has AC references for traceability (found: ${ac_refs})" "$([ "$ac_refs" -ge 1 ] && echo true || echo false)"

# Check scenario count >= acceptance criteria count (if requirements exist)
if [ -f "$REQ_FILE" ]; then
    ac_count=$(grep -cE '^\s*-\s*\[' "$REQ_FILE" 2>/dev/null || true)
    check "Scenarios (${scenario_count}) >= acceptance criteria (${ac_count})" "$([ "$scenario_count" -ge "$ac_count" ] && echo true || echo false)"
fi

# Check minimum file size
file_size=$(wc -c < "$BDD_FILE" | tr -d ' ')
check "BDD file not just a template (>300 chars, actual: ${file_size})" "$([ "$file_size" -gt 300 ] && echo true || echo false)"

# Report
TOTAL=$((PASS + FAIL))
echo "GATE: BDD Scenario Quality"
echo "  Score: ${PASS}/${TOTAL} checks passed"
echo "  Scenarios: ${scenario_count}"
echo "  GWT keywords: ${gwt_count}"

if [ "$FAIL" -gt 0 ]; then
    echo -e "  Failures:${ERRORS}"
    echo "GATE RESULT: FAIL"
    exit 1
else
    echo "GATE RESULT: PASS"
    exit 0
fi
