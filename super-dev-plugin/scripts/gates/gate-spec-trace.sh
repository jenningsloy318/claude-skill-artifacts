#!/bin/bash
# Gate: Spec-to-BDD Trace Coverage
# Cross-references spec tasks with BDD scenarios to ensure full traceability
#
# Usage: gate-spec-trace.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-spec-trace.sh <spec-dir>}"

# Dynamic file discovery: find *-specification.md, *-behavior-scenarios.md, *-task-list.md, *-implementation-plan.md (incremental index)
SPEC_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name '*-specification.md' -type f 2>/dev/null | head -1)
BDD_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name '*-behavior-scenarios.md' -type f 2>/dev/null | head -1)
TASK_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name '*-task-list.md' -type f 2>/dev/null | head -1)
PLAN_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name '*-implementation-plan.md' -type f 2>/dev/null | head -1)

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

# Check both files exist (dynamic discovery)
if [ -z "$SPEC_FILE" ] || [ ! -f "$SPEC_FILE" ]; then
    echo "GATE FAIL: No *-specification.md file found in: ${SPEC_DIR}"
    exit 1
fi

if [ -z "$BDD_FILE" ] || [ ! -f "$BDD_FILE" ]; then
    echo "GATE FAIL: No *-behavior-scenarios.md file found in: ${SPEC_DIR}"
    exit 1
fi

# Check spec references BDD scenarios
spec_refs=$(grep -cE 'SCENARIO-[0-9]+' "$SPEC_FILE" 2>/dev/null || true)
check "Spec references BDD scenarios (found: ${spec_refs} refs)" "$([ "$spec_refs" -ge 1 ] && echo true || echo false)"

# Check for testing strategy section in spec
has_testing=$(grep -ci "testing strategy\|test plan\|test approach\|test coverage\|unit test\|integration test" "$SPEC_FILE" || true)
check "Spec includes testing strategy" "$([ "$has_testing" -gt 0 ] && echo true || echo false)"

# Check *-task-list.md exists as separate file
check "Task list file exists (*-task-list.md)" "$([ -n "$TASK_FILE" ] && [ -f "$TASK_FILE" ] && echo true || echo false)"

# Check *-implementation-plan.md exists as separate file
check "Implementation plan file exists (*-implementation-plan.md)" "$([ -n "$PLAN_FILE" ] && [ -f "$PLAN_FILE" ] && echo true || echo false)"

# Report
TOTAL=$((PASS + FAIL))
echo "GATE: Spec-to-BDD Traceability"
echo "  Score: ${PASS}/${TOTAL} checks passed"
echo "  Spec → BDD references: ${spec_refs}"
echo "  Task list file: ${TASK_FILE:-NOT FOUND}"
echo "  Implementation plan file: ${PLAN_FILE:-NOT FOUND}"

if [ "$FAIL" -gt 0 ]; then
    echo -e "  Failures:${ERRORS}"
    echo "GATE RESULT: FAIL"
    exit 1
else
    echo "GATE RESULT: PASS"
    exit 0
fi
