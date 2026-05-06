#!/bin/bash
# Gate: BDD Scenario Quality Check
# Verifies behavior scenarios are complete and traceable to acceptance criteria
#
# Usage: gate-bdd.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-bdd.sh <spec-dir>}"
source "$(dirname "$0")/gate-lib.sh"

BDD_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name '*-bdd-scenarios.md' -type f 2>/dev/null | head -1)
REQ_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name '*-requirements.md' -type f 2>/dev/null | head -1)

# Check BDD file exists (dynamic discovery)
if [ -z "$BDD_FILE" ] || [ ! -f "$BDD_FILE" ]; then
    echo "GATE FAIL: No *-bdd-scenarios.md file found in: ${SPEC_DIR}"
    exit 1
fi

# Check for SCENARIO-XXX IDs
scenario_count=$(grep -cE 'SCENARIO-[0-9]+' "$BDD_FILE" 2>/dev/null || true)
check "Has SCENARIO-IDs (found: ${scenario_count})" "$([ "$scenario_count" -ge 1 ] && echo true || echo false)"

# Check for Given/When/Then structure (supports plain, bold markdown **Given**, and bullet-prefixed: - Given / * Given)
gwt_count=$(grep -ciE '^\s*(-\s+|\*\s+)?\*{0,2}(given|when|then|and)' "$BDD_FILE" 2>/dev/null || true)
check "Has Given/When/Then structure (found: ${gwt_count} keywords)" "$([ "$gwt_count" -ge 3 ] && echo true || echo false)"

# Check for AC references (traceability)
ac_refs=$(grep -cE 'AC-[0-9]+' "$BDD_FILE" 2>/dev/null || true)
check "Has AC references for traceability (found: ${ac_refs})" "$([ "$ac_refs" -ge 1 ] && echo true || echo false)"

# Check scenario count >= acceptance criteria count (if requirements exist)
if [ -f "$REQ_FILE" ]; then
    ac_checkbox=$(grep -cE '^\s*-\s*\[' "$REQ_FILE" 2>/dev/null || true)
    ac_id=$(grep -cE '^\s*-\s*\*{0,2}AC-[0-9]' "$REQ_FILE" 2>/dev/null || true)
    ac_count=$((ac_checkbox + ac_id))
    check "Scenarios (${scenario_count}) >= acceptance criteria (${ac_count})" "$([ "$scenario_count" -ge "$ac_count" ] && echo true || echo false)"
fi

# Check minimum file size
file_size=$(wc -c < "$BDD_FILE" | tr -d ' ')
check "BDD file not just a template (>300 chars, actual: ${file_size})" "$([ "$file_size" -gt 300 ] && echo true || echo false)"

gate_report "BDD Scenario Quality"
