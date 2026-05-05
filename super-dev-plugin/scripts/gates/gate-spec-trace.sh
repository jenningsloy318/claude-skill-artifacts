#!/bin/bash
# Gate: Spec-to-BDD Trace Coverage
# Cross-references spec tasks with BDD scenarios to ensure full traceability
#
# Usage: gate-spec-trace.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-spec-trace.sh <spec-dir>}"
source "$(dirname "$0")/gate-lib.sh"

SPEC_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name '*-specification.md' -type f 2>/dev/null | head -1)
BDD_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name '*-bdd-scenarios.md' -type f 2>/dev/null | head -1)
TASK_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name '*-task-list.md' -type f 2>/dev/null | head -1)
PLAN_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name '*-implementation-plan.md' -type f 2>/dev/null | head -1)

# Check both files exist (dynamic discovery)
if [ -z "$SPEC_FILE" ] || [ ! -f "$SPEC_FILE" ]; then
    echo "GATE FAIL: No *-specification.md file found in: ${SPEC_DIR}"
    exit 1
fi

if [ -z "$BDD_FILE" ] || [ ! -f "$BDD_FILE" ]; then
    echo "GATE FAIL: No *-bdd-scenarios.md file found in: ${SPEC_DIR}"
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

gate_report "Spec-to-BDD Traceability"
