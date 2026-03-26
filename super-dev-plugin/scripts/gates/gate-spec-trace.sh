#!/bin/bash
# Gate: Spec-to-BDD Trace Coverage
# Cross-references spec tasks with BDD scenarios to ensure full traceability
#
# Usage: gate-spec-trace.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-spec-trace.sh <spec-dir>}"
SPEC_FILE="${SPEC_DIR}/06-specification.md"
BDD_FILE="${SPEC_DIR}/01.1-behavior-scenarios.md"

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

# Check both files exist
if [ ! -f "$SPEC_FILE" ]; then
    echo "GATE FAIL: Specification file not found: ${SPEC_FILE}"
    exit 1
fi

if [ ! -f "$BDD_FILE" ]; then
    echo "GATE FAIL: BDD scenarios file not found: ${BDD_FILE}"
    exit 1
fi

# Check spec references BDD scenarios
spec_refs=$(grep -cE 'SCENARIO-[0-9]+' "$SPEC_FILE" 2>/dev/null || echo "0")
check "Spec references BDD scenarios (found: ${spec_refs} refs)" "$([ "$spec_refs" -ge 1 ] && echo true || echo false)"

# Check for testing strategy section in spec
has_testing=$(grep -ci "testing strategy\|test plan\|test approach" "$SPEC_FILE" || echo "0")
check "Spec includes testing strategy" "$([ "$has_testing" -gt 0 ] && echo true || echo false)"

# Check for task list in spec
task_count=$(grep -cE '^\s*-\s*\[[ x]\]' "$SPEC_FILE" 2>/dev/null || echo "0")
check "Spec has task list (found: ${task_count} tasks)" "$([ "$task_count" -ge 1 ] && echo true || echo false)"

# Check spec has implementation plan
has_plan=$(grep -ci "implementation plan\|implementation phases\|task list" "$SPEC_FILE" || echo "0")
check "Spec includes implementation plan" "$([ "$has_plan" -gt 0 ] && echo true || echo false)"

# Report
TOTAL=$((PASS + FAIL))
echo "GATE: Spec-to-BDD Traceability"
echo "  Score: ${PASS}/${TOTAL} checks passed"
echo "  Spec → BDD references: ${spec_refs}"
echo "  Tasks in spec: ${task_count}"

if [ "$FAIL" -gt 0 ]; then
    echo -e "  Failures:${ERRORS}"
    echo "GATE RESULT: FAIL"
    exit 1
else
    echo "GATE RESULT: PASS"
    exit 0
fi
