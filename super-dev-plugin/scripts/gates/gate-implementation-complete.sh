#!/bin/bash
# Gate: Implementation Completeness Verification
# Verifies ALL implementation-plan phases are complete before proceeding to Stage 11
#
# Usage: gate-implementation-complete.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-implementation-complete.sh <spec-dir>}"
source "$(dirname "$0")/gate-lib.sh"

# Find implementation plan
IMPL_PLAN=$(find "$SPEC_DIR" -name "*implementation-plan*" -type f 2>/dev/null | head -1)
if [ -z "$IMPL_PLAN" ]; then
    check "Implementation plan exists" "false"
    gate_report "Implementation Completeness"
fi
check "Implementation plan exists" "true"

# Count phases in implementation plan (matches multiple heading formats)
PLAN_PHASE_COUNT=$(grep -cE '(Phase [0-9]+[[:space:]]*:|\bPhase [0-9]+\b.*Objective)' "$IMPL_PLAN" 2>/dev/null || echo "0")
if [ "$PLAN_PHASE_COUNT" -eq 0 ]; then
    # Fallback: XML template format or markdown headings
    PLAN_PHASE_COUNT=$(grep -cE '(title="Phase [0-9]+|## Phase [0-9]+|### Phase [0-9]+)' "$IMPL_PLAN" 2>/dev/null || echo "0")
fi
check "Implementation plan has phases (found: ${PLAN_PHASE_COUNT})" "$([ "$PLAN_PHASE_COUNT" -gt 0 ] && echo true || echo false)"

# Find workflow tracking JSON
TRACKING_JSON=$(find "$SPEC_DIR" -name "*workflow-tracking*" -type f 2>/dev/null | head -1)
if [ -z "$TRACKING_JSON" ]; then
    check "Workflow tracking JSON exists" "false"
    gate_report "Implementation Completeness"
fi
check "Workflow tracking JSON exists" "true"

# Check implementationPhases array exists and has entries
JSON_PHASE_COUNT=$(jq '.implementationPhases | length' "$TRACKING_JSON" 2>/dev/null || echo "0")
check "Tracking JSON has implementationPhases (found: ${JSON_PHASE_COUNT})" "$([ "$JSON_PHASE_COUNT" -gt 0 ] && echo true || echo false)"

# Verify counts match (plan phases vs tracking entries)
if [ "$PLAN_PHASE_COUNT" -gt 0 ] && [ "$JSON_PHASE_COUNT" -gt 0 ]; then
    check "Phase counts match (plan: ${PLAN_PHASE_COUNT}, tracking: ${JSON_PHASE_COUNT})" "$([ "$PLAN_PHASE_COUNT" -eq "$JSON_PHASE_COUNT" ] && echo true || echo false)"
fi

# Check all phases are complete
if [ "$JSON_PHASE_COUNT" -gt 0 ]; then
    COMPLETE_COUNT=$(jq '[.implementationPhases[] | select(.status == "complete")] | length' "$TRACKING_JSON" 2>/dev/null || echo "0")
    PENDING_COUNT=$(jq '[.implementationPhases[] | select(.status != "complete")] | length' "$TRACKING_JSON" 2>/dev/null || echo "0")

    check "All implementation phases complete (${COMPLETE_COUNT}/${JSON_PHASE_COUNT})" "$([ "$COMPLETE_COUNT" -eq "$JSON_PHASE_COUNT" ] && echo true || echo false)"

    if [ "$PENDING_COUNT" -gt 0 ]; then
        # List incomplete phases for debugging
        INCOMPLETE=$(jq -r '.implementationPhases[] | select(.status != "complete") | "    Phase \(.phaseNumber): \(.name) [status: \(.status)]"' "$TRACKING_JSON" 2>/dev/null || echo "")
        if [ -n "$INCOMPLETE" ]; then
            ERRORS="${ERRORS}\n  Incomplete phases:\n${INCOMPLETE}"
        fi
    fi
fi

# Check implementation-summary exists
IMPL_SUMMARY=$(find "$SPEC_DIR" -name "*implementation-summary*" -type f 2>/dev/null | head -1)
check "Implementation summary exists" "$([ -n "$IMPL_SUMMARY" ] && [ -s "$IMPL_SUMMARY" ] && echo true || echo false)"

gate_report "Implementation Completeness"
