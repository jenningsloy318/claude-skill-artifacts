#!/bin/bash
# Gate: Specification Review Quality
# Validates spec-review output has required structure, dimensions, and verdict
#
# Usage: gate-spec-review.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-spec-review.sh <spec-dir>}"
source "$(dirname "$0")/gate-lib.sh"

REVIEW_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name '*-spec-review.md' -type f 2>/dev/null | head -1)

# Check review file exists
if [ -z "$REVIEW_FILE" ] || [ ! -f "$REVIEW_FILE" ]; then
    echo "GATE FAIL: No *-spec-review.md file found in: ${SPEC_DIR}"
    exit 1
fi

# SR1: Verdict exists
has_verdict=$(grep -ci "APPROVED\|REVISIONS NEEDED\|REJECTED" "$REVIEW_FILE" || true)
check "SR1: Verdict text exists (APPROVED/REVISIONS NEEDED/REJECTED)" "$([ "$has_verdict" -gt 0 ] && echo true || echo false)"

# SR2: All 8 dimensions present as headings
dim_count=0
for dim in "Completeness" "Consistency" "Feasibility" "Testability" "Traceability" "Grounding" "Complexity" "Ambiguity"; do
    if grep -qi "$dim" "$REVIEW_FILE" 2>/dev/null; then
        dim_count=$((dim_count + 1))
    fi
done
check "SR2: All 8 review dimensions present (found: ${dim_count}/8)" "$([ "$dim_count" -ge 8 ] && echo true || echo false)"

# SR3: No REJECTED in verdict line when intent is approval
# Check for contradictory verdict (both APPROVED and REJECTED on same line)
contradictory=$(grep -ci "APPROVED.*REJECTED\|REJECTED.*APPROVED" "$REVIEW_FILE" || true)
check "SR3: No contradictory verdict text" "$([ "$contradictory" -eq 0 ] && echo true || echo false)"

# SR4: Grounding section has verification content
has_grounding_check=$(grep -ci "verified\|exists\|not found\|hallucinated\|confirmed\|grounding" "$REVIEW_FILE" || true)
check "SR4: Grounding section contains verification results (found: ${has_grounding_check} refs)" "$([ "$has_grounding_check" -ge 1 ] && echo true || echo false)"

# SR5: Finding count summary exists
has_summary=$(grep -ci "Critical\|High\|Medium\|Low\|finding" "$REVIEW_FILE" || true)
check "SR5: Finding severity summary exists" "$([ "$has_summary" -ge 1 ] && echo true || echo false)"

gate_report "Specification Review Quality"
