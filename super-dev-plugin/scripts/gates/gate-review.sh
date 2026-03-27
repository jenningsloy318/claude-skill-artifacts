#!/bin/bash
# Gate: Review Verdict Check
# Verifies code review and adversarial review verdicts before proceeding
#
# Usage: gate-review.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-review.sh <spec-dir>}"

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

# Find code review file
CODE_REVIEW=$(find "$SPEC_DIR" -name "*code-review*" -type f 2>/dev/null | head -1)
if [ -n "$CODE_REVIEW" ]; then
    # Check for approved verdict
    cr_verdict=$(grep -iE '(approved|changes requested|blocked)' "$CODE_REVIEW" | head -1 || echo "")
    is_approved=$(echo "$cr_verdict" | grep -ci "approved" || true)
    is_blocked=$(echo "$cr_verdict" | grep -ciE "(changes requested|blocked)" || true)

    check "Code review exists" "true"
    check "Code review approved (verdict: $(echo "$cr_verdict" | head -c 50))" "$([ "$is_approved" -gt 0 ] && [ "$is_blocked" -eq 0 ] && echo true || echo false)"

    # Check no critical issues remain
    critical_count=$(grep -cE '\*\*Critical\*\*|Critical.*[1-9]' "$CODE_REVIEW" 2>/dev/null || true)
    check "No critical issues (found: ${critical_count})" "$([ "$critical_count" -eq 0 ] && echo true || echo false)"
else
    check "Code review file exists" "false"
fi

# Find adversarial review file
ADV_REVIEW=$(find "$SPEC_DIR" -name "*adversarial*" -type f 2>/dev/null | head -1)
if [ -n "$ADV_REVIEW" ]; then
    # Check for PASS verdict
    adv_verdict=$(grep -iE '(PASS|CONTESTED|REJECT|HALT)' "$ADV_REVIEW" | head -1 || echo "")
    is_pass=$(echo "$adv_verdict" | grep -ci "PASS" || true)
    is_reject=$(echo "$adv_verdict" | grep -ci "REJECT" || true)

    check "Adversarial review exists" "true"
    check "Adversarial review PASS (verdict: $(echo "$adv_verdict" | head -c 50))" "$([ "$is_pass" -gt 0 ] && [ "$is_reject" -eq 0 ] && echo true || echo false)"
else
    check "Adversarial review file exists" "false"
fi

# Report
TOTAL=$((PASS + FAIL))
echo "GATE: Review Verdicts"
echo "  Score: ${PASS}/${TOTAL} checks passed"

if [ "$FAIL" -gt 0 ]; then
    echo -e "  Failures:${ERRORS}"
    echo "GATE RESULT: FAIL"
    exit 1
else
    echo "GATE RESULT: PASS"
    exit 0
fi
