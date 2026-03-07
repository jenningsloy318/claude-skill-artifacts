# Implementation Plan: Adversarial Review Enhancement

**Date:** 2026-03-07
**Phase:** 6 - Specification
**Spec:** 03-specification.md

---

## Overview

Three markdown files to modify, in order. All changes are additive. No code, no tests, no build steps.

---

## Milestone 1: Update Agent File (Primary)

**File:** `super-dev-plugin/agents/adversarial-reviewer.md`
**Estimated effort:** Largest change -- this is the source of truth for the review workflow.

### Step 1.1: Add Attack Vector Sub-Checklists to Each Lens (Step 2)

Insert vector sub-checklist blocks after each lens's existing questions in Step 2:

- **Skeptic lens:** Add sub-checks for V1, V2, V3, V4, V5, V6
- **Architect lens:** Add sub-checks for V1, V3, V5, V7
- **Minimalist lens:** Add sub-check for V7

Preserve all existing lens questions verbatim. Append the `**Attack Vector Sub-Checks:**` block after each lens's `Ask:` list.

### Step 1.2: Insert New Step 2.5 -- Apply Attack Vectors

Add a brief instruction between Step 2 and Step 3 that tells the reviewer:
- Review each lens's vector sub-checklist
- Record findings with combined `Lens/Vector` tags (e.g., `Skeptic/V2`)
- Each vector check must be explicitly addressed (checked or noted as not applicable)

### Step 1.3: Insert New Step 3 -- Destructive Action Gate

Add the full gate specification:
- Five categories: Data Destruction, Irreversible State, Production Impact, Permission Escalation, Secret Operations
- Pattern examples for each category
- Gate logic (CLEAR/BLOCKED)
- HALT finding format (DAG-XXX)
- Verdict override rules

### Step 1.4: Renumber Existing Step 3 to Step 4

Change `### Step 3 — Synthesize Verdict` to `### Step 4 — Synthesize Verdict`.

### Step 1.5: Update Verdict Logic

Add HALT-related rules to the verdict logic in Step 4:
- Single HALT finding -> CONTESTED minimum
- Multiple HALT findings -> REJECT
- HALT findings cannot be downgraded

### Step 1.6: Extend Output Template

Update the output template to include:
- `Attack vectors applied` row in Change Scope table
- Destructive Action Gate section (with 5-category check table and HALT findings)
- Combined `Lens/Vector` tags in Findings section
- Vector Coverage summary table
- DAG-XXX finding format for gate findings

### Step 1.7: Extend Severity Reference

Add HALT severity to the severity reference table.

---

## Milestone 2: Update Command File

**File:** `super-dev-plugin/commands/adversarial-review.md`

### Step 2.1: Update "What This Command Does" List

Change the numbered steps from 5 to 7:
1. Determine scope (unchanged)
2. State intent (unchanged)
3. Apply lenses with attack vector sub-checklists (updated)
4. Run Destructive Action Gate (new)
5. Synthesize verdict (renumbered)
6. Generate report (renumbered)

### Step 2.2: Fix Output File Naming

Change `### Output: Creates [doc-index]-adversarial-review-report.md` to:
`### Output: Creates [spec-index]-[spec-name]-adversarial-review-report.md`

### Step 2.3: Add Attack Vectors Section

Add a new section after "Reviewer Lenses" that briefly describes the 7 vectors and explains they run as sub-checklists within each lens.

### Step 2.4: Add Destructive Action Gate Section

Add a new section describing:
- What the gate does
- The 5 categories
- HALT severity
- How it affects the verdict

### Step 2.5: Update Verdicts Table

Add notes about HALT findings:
- HALT from gate forces CONTESTED minimum
- Multiple HALTs force REJECT

### Step 2.6: Update Notes

Add bullets mentioning attack vectors and the destructive action gate.

---

## Milestone 3: Update SKILL.md Phase 10

**File:** `super-dev-plugin/skills/super-dev/SKILL.md`

### Step 3.1: Update Phase 10 Section

Modify the Phase 10 section (lines ~469-488) to add:
- Mention of attack vector sub-checklists (V1-V7) within each lens
- Mention of the Destructive Action Gate (always-on, HALT severity)
- Updated verdict logic noting HALT -> CONTESTED/REJECT
- Note that gate BLOCKED forces loop back to Phase 8

### Step 3.2: Update Adversarial-Reviewer Description in Teammate Tables

Update the adversarial-reviewer entries in the teammate role tables to mention vectors and gate. Specifically:
- Row in "Teammate Roles" table (line ~248)
- Row in "Teammate Roles by Category" table (line ~545)

---

## Milestone 4: Verification

### Step 4.1: Cross-File Consistency Check

Verify all three files agree on:
- Output file naming pattern: `[spec-index]-[spec-name]-adversarial-review-report.md`
- The 7 vector names and IDs
- The 5 gate categories
- Verdict override rules (HALT -> CONTESTED/REJECT)
- Workflow step numbering (1, 2, 2.5, 3, 4)

### Step 4.2: Backward Compatibility Check

Verify:
- All existing Skeptic questions preserved verbatim
- All existing Architect questions preserved verbatim
- All existing Minimalist questions preserved verbatim
- Lens activation thresholds unchanged
- Core finding format (AF-XXX) unchanged
- Iteration behavior unchanged

---

## Execution Order

```
Milestone 1 (Agent file)     -- do first, it's the source of truth
    |
    v
Milestone 2 (Command file)   -- references agent, do second
    |
    v
Milestone 3 (SKILL.md)       -- references agent, do third
    |
    v
Milestone 4 (Verification)   -- cross-check all three files
```

All milestones can be done by a single `dev-executor` agent in one pass, since they are all markdown edits with no dependencies on external systems.
