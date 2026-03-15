# Task List: BDD Integration into Super-Dev Workflow

**Specification:** `./05-specification.md`
**Architecture:** `./04-architecture-design.md`
**Total Tasks:** 14
**Status:** Complete (14/14)
**Completed:** 2026-03-15

---

## Phase 1: Foundation (New Files)

### T1.1 -- Create `bdd-scenario-writer` Agent

- **ID:** T1.1
- **Status:** ✅ Complete
- **Description:** Create the new BDD scenario writer agent file with full agent markdown specification including YAML frontmatter, role statement, workflow steps, output template, quality gates (Q1-Q10, D1-D8), banned words list, and few-shot examples.
- **Files Created:**
  - `agents/bdd-scenario-writer.md` (198 lines)
- **Dependencies:** None
- **AC Coverage:** AC-01, AC-03, AC-10
- **Acceptance:**
  - File exists at `agents/bdd-scenario-writer.md`
  - YAML frontmatter contains `name: bdd-scenario-writer` and `description`
  - Agent follows existing agent markdown structure (frontmatter + role + workflow + output template + quality gates)
  - Output template defines `01.1-behavior-scenarios.md` format with Given/When/Then, traceability matrix, and coverage summary
  - Quality gates Q1-Q10 (per-scenario) and D1-D8 (per-document) embedded
  - Banned words list present
  - Few-shot examples (2 good, 1 bad) included

---

### T1.2 -- Create `bdd-patterns.md` Reference Template

- **ID:** T1.2
- **Status:** ✅ Complete
- **Description:** Create a BDD reference template in the templates directory with Gherkin-like syntax reference, scenario writing guidelines, banned words, test reference patterns per language, and quality checklists.
- **Files Created:**
  - `templates/reference/bdd-patterns.md` (120 lines)
- **Dependencies:** None (can run in parallel with T1.1)
- **AC Coverage:** Supporting reference (no direct AC)
- **Acceptance:**
  - File exists at `templates/reference/bdd-patterns.md`
  - Contains: scenario structure, ID convention, priority levels, writing guidelines (DO/DON'T), banned words, traceability matrix pattern, test reference patterns (JS/TS, Python, Rust, Go), quality checklists (Q1-Q10, D1-D8)
  - Follows style/structure of existing templates in `templates/reference/`

---

## Phase 2: Core Workflow Integration

### T2.1 -- Update `rules/testing.md` with BDD Section

- **ID:** T2.1
- **Status:** ✅ Complete
- **Description:** Append a new "BDD (Behavior-Driven Development)" section to the end of `rules/testing.md` with the 9 mandatory rules and agent support list.
- **Files Modified:**
  - `rules/testing.md` -- BDD section appended (lines 32-51)
- **Dependencies:** None
- **AC Coverage:** AC-09 (backward compatibility -- BDD augments TDD)
- **Acceptance:**
  - BDD section appended at end of file
  - Contains 9 numbered rules (scenarios before implementation, file location, format, no Scenario Outlines, unique IDs, AC coverage, test mapping, hard gate, augments TDD)
  - Lists agent support: bdd-scenario-writer, qa-agent, code-reviewer, adversarial-reviewer
  - Existing TDD content unchanged

---

### T2.2 -- Update `skills/super-dev/SKILL.md`

- **ID:** T2.2
- **Status:** ✅ Complete
- **Description:** Modify SKILL.md to integrate Phase 2.5 across all relevant sections: success criteria, workflow phase checklist, iteration rule, teammate roles table, phase enforcement table, Phase 9 pass criteria, team creation command, teammate roles by category, team creation at Phase 1 list, and when-to-spawn table.
- **Files Modified:**
  - `skills/super-dev/SKILL.md` -- 10 insertion/modification points (+45 lines, -24 lines)
- **Dependencies:** T1.1 (agent must exist before referencing it)
- **AC Coverage:** AC-07
- **Acceptance:**
  - Phase 2.5 appears in workflow phase checklist (after Phase 2, marked MANDATORY)
  - Iteration rule includes "BDD scenario coverage is 100%"
  - Phase enforcement table has row: `2.5 | Use Task tool → super-dev:bdd-scenario-writer | bdd-scenario-writer`
  - Phase 9 Combined Pass Criteria includes "BDD Scenario Coverage = 100%"
  - Team creation command includes `super-dev:bdd-scenario-writer`
  - Teammate roles table includes `bdd-scenario-writer` in Planning category
  - When-to-spawn table has Phase 2.5 row
  - All existing content preserved (no deletions)

---

### T2.3 -- Update `agents/coordinator.md`

- **ID:** T2.3
- **Status:** ✅ Complete
- **Description:** Modify the coordinator to integrate Phase 2.5 across all relevant sections: phase flow, delegate mode table, iteration rule, skip conditions, team creation, teammate roles, spawn table, spawn patterns, termination table, quality gates, and final verification checklist.
- **Files Modified:**
  - `agents/coordinator.md` -- 11 insertion/modification points (+25 lines, -6 lines)
- **Dependencies:** T1.1 (agent must exist), T2.2 (SKILL.md must be consistent)
- **AC Coverage:** AC-02, AC-06, AC-08
- **Acceptance:**
  - Phase Flow includes `Phase 2.5: BDD Scenario Writing → Spawn bdd-scenario-writer teammate (MANDATORY)` between Phase 2 and Phase 3
  - Delegate mode table has Phase 2.5 row
  - Iteration rule includes `ScenarioCoverageMet (100%)`
  - Skip conditions table has `Phase 2.5 | Never skip` row
  - Team creation includes `super-dev:bdd-scenario-writer`
  - Teammate roles table has `bdd-scenario-writer` in Planning category
  - Spawn table has Phase 2.5 → bdd-scenario-writer
  - Spawn pattern for Phase 2.5 included
  - Termination table has Phase 2.5 → `01.1-behavior-scenarios.md complete`
  - Quality gate for → Phase 3 requires `01.1-behavior-scenarios.md` exists
  - Final verification checklist includes `behavior-scenarios.md`

---

## Phase 3: Downstream Consumer Updates

### T3.1 -- Update `agents/spec-writer.md`

- **ID:** T3.1
- **Status:** ✅ Complete
- **Description:** Add BDD scenario input to the spec-writer's Input Context, add BDD Scenario References sub-section to the testing strategy template, and add BDD cross-reference to quality standards.
- **Files Modified:**
  - `agents/spec-writer.md` -- 3 insertion points (+16 lines)
- **Dependencies:** T1.1 (agent must exist)
- **AC Coverage:** Supporting (spec-writer consumes scenarios)
- **Acceptance:**
  - Input Context lists `bdd_scenarios` as required for features
  - Testing strategy template includes Section 5.4 "BDD Scenario References" with scenario-to-test mapping table
  - Quality standards checklist includes BDD cross-reference item

---

### T3.2 -- Update `agents/qa-agent.md`

- **ID:** T3.2
- **Status:** ✅ Complete
- **Description:** Add BDD-aligned principle to Core Principles, add scenario parsing to Execution Responsibilities, add BDD Scenario Coverage section to Test Plan template, and add scenario coverage gate to Quality Gates.
- **Files Modified:**
  - `agents/qa-agent.md` -- 4 insertion points (+18 lines)
- **Dependencies:** T1.1 (agent must exist, scenarios must be defined)
- **AC Coverage:** AC-04
- **Acceptance:**
  - Core Principles includes principle 6: BDD-aligned test plan derivation
  - Execution Responsibilities includes: parse BDD scenarios and map to test cases
  - Test Plan template includes "BDD Scenario Coverage" section with Scenario-Test Mapping table and Coverage Summary
  - Quality Gates includes: all BDD scenarios have corresponding test implementations
  - Existing qa-agent functionality unchanged

---

## Phase 4: Review Gate Updates

### T4.1 -- Update `agents/code-reviewer.md`

- **ID:** T4.1
- **Status:** ✅ Complete
- **Description:** Add BDD Scenario Coverage Validation as step 6.1 in the review workflow, add BDD Scenario Coverage section to the output template, and update verdict logic to include scenario coverage check.
- **Files Modified:**
  - `agents/code-reviewer.md` -- 3 insertion/modification points (+22 lines, -2 lines)
- **Dependencies:** T3.2 (qa-agent must produce coverage report for code-reviewer to consume)
- **AC Coverage:** AC-05
- **Acceptance:**
  - Review workflow has step 6.1 "BDD Scenario Coverage Validation" after step 6
  - Step 6.1 reads scenario document and QA coverage report, verifies every SCENARIO-XXX has passing test
  - Output template has "BDD Scenario Coverage" section with table and gate result
  - Verdict logic: `scenario coverage < 100% → Changes Requested`
  - Existing review dimensions and workflow unchanged

---

### T4.2 -- Update `agents/adversarial-reviewer.md`

- **ID:** T4.2
- **Status:** ✅ Complete
- **Description:** Add V8 Behavior Coverage attack vector under Skeptic lens, add D9 document-level pre-check step, update vector-to-lens mapping, add V8 to vector coverage table, and update change scope output.
- **Files Modified:**
  - `agents/adversarial-reviewer.md` -- 5 insertion/modification points (+23 lines, -4 lines)
- **Dependencies:** T3.2 (qa-agent must produce scenario data)
- **AC Coverage:** AC-05 (deterministic check via V8/D9)
- **Acceptance:**
  - Skeptic lens includes V8 Behavior Coverage sub-check with 4 verification points
  - Step 2.1 D9 Document-Level Pre-Check exists before lens reviews with 3 validation checks
  - Vector-to-lens mapping shows `Skeptic is primary for V1-V6, V8`
  - Vector coverage table has V8 row: `V8: Behavior Coverage | Skeptic | 0 | --`
  - Change scope output template shows `V1-V6, V8 [+ V7]`
  - Existing V1-V7 vectors and Destructive Action Gate unchanged

---

## Final Tasks

### TF.1 -- Verify All File Modifications

- **ID:** TF.1
- **Status:** ✅ Complete (QA Verdict: PASS)
- **Description:** Read every modified file and verify all insertions are correct, no existing content was accidentally removed, and all cross-references are consistent.
- **Files Verified:**
  - `agents/bdd-scenario-writer.md` (new)
  - `templates/reference/bdd-patterns.md` (new)
  - `agents/coordinator.md` (modified)
  - `skills/super-dev/SKILL.md` (modified)
  - `agents/qa-agent.md` (modified)
  - `agents/code-reviewer.md` (modified)
  - `agents/adversarial-reviewer.md` (modified)
  - `agents/spec-writer.md` (modified)
  - `rules/testing.md` (modified)
- **Dependencies:** T1.1, T1.2, T2.1, T2.2, T2.3, T3.1, T3.2, T4.1, T4.2
- **AC Coverage:** AC-09 (no regression)
- **Acceptance:**
  - All 9 files have correct content
  - No existing functionality removed or broken
  - Phase 2.5 consistently referenced across coordinator, SKILL.md, and rules
  - V8 and D9 consistently referenced across adversarial-reviewer
  - Scenario coverage gate consistently referenced across code-reviewer, SKILL.md, coordinator

---

### TF.2 -- Cross-Reference AC Verification

- **ID:** TF.2
- **Status:** ✅ Complete (All 10 ACs satisfied)
- **Description:** Verify each acceptance criterion (AC-01 through AC-10) is satisfied by reading the implementation and confirming against the verification plan in specification Section 7.
- **Dependencies:** TF.1
- **AC Coverage:** AC-01 through AC-10
- **Acceptance:**
  - AC-01: `agents/bdd-scenario-writer.md` exists with correct frontmatter
  - AC-02: `agents/coordinator.md` has Phase 2.5 in phase flow, spawn table, delegate table
  - AC-03: Agent output template defines `01.1-behavior-scenarios.md` with Given/When/Then + AC mapping
  - AC-04: `agents/qa-agent.md` has BDD Scenario Coverage section and quality gate
  - AC-05: `agents/code-reviewer.md` has step 6.1 + verdict logic; adversarial has V8 + D9
  - AC-06: Coordinator spawn pattern includes Phase 2.5 in workflow JSON phases
  - AC-07: `skills/super-dev/SKILL.md` has Phase 2.5 in checklist, enforcement table, team roles, spawn table
  - AC-08: Skip conditions table shows "Never skip" for Phase 2.5
  - AC-09: All existing TDD/phase content preserved; BDD additions are purely additive
  - AC-10: Agent output template includes traceability matrix section

---

### TF.3 -- Code Review

- **ID:** TF.3
- **Status:** ✅ Complete (Code Review: Approved with Comments, Adversarial: PASS)
- **Description:** Run code-reviewer and adversarial-reviewer on all changes.
- **Agent:** `super-dev:code-reviewer` + `super-dev:adversarial-reviewer`
- **Dependencies:** TF.2
- **Acceptance:** Code Review verdict = Approved, Adversarial verdict = PASS

---

### TF.4 -- Commit and Push Changes

- **ID:** TF.4
- **Status:** ⏳ In Progress (documentation update, pending commit)
- **Description:** Stage all created and modified files, generate commit message using the generating-commit-messages skill, commit, and merge to main.
- **Files Staged:**
  - `agents/bdd-scenario-writer.md` (new)
  - `templates/reference/bdd-patterns.md` (new)
  - `agents/coordinator.md` (modified)
  - `skills/super-dev/SKILL.md` (modified)
  - `agents/qa-agent.md` (modified)
  - `agents/code-reviewer.md` (modified)
  - `agents/adversarial-reviewer.md` (modified)
  - `agents/spec-writer.md` (modified)
  - `rules/testing.md` (modified)
  - `specification/20-bdd-integration/` (all spec artifacts)
- **Message Format:** `feat spec-20-bdd-integration: <description>`
- **Dependencies:** TF.3
- **Acceptance:** Changes committed and merged to main, git status clean

---

## Task Dependencies

```
T1.1 ──┬──> T2.2 ──> T2.3
       │
T1.2   ├──> T3.1
       │
T2.1   ├──> T3.2 ──┬──> T4.1
       │           │
       │           └──> T4.2
       │
       └──> TF.1 ──> TF.2 ──> TF.3 ──> TF.4
```

**Parallel opportunities:**
- T1.1 and T1.2 can run in parallel (independent new files)
- T1.1/T1.2 and T2.1 can run in parallel (independent new files vs rule update)
- T3.1 and T3.2 can run in parallel (independent downstream updates)
- T4.1 and T4.2 can run in parallel (independent review gate updates)

---

## Priority Order

1. **T1.1** -- Foundation: bdd-scenario-writer agent (all other tasks reference this)
2. **T1.2** -- Foundation: BDD reference template (independent, can parallel with T1.1)
3. **T2.1** -- Core: testing rules BDD section (independent foundation)
4. **T2.2** -- Core: SKILL.md Phase 2.5 integration (depends on T1.1)
5. **T2.3** -- Core: coordinator Phase 2.5 integration (depends on T1.1, T2.2)
6. **T3.1** -- Downstream: spec-writer BDD input (depends on T1.1)
7. **T3.2** -- Downstream: qa-agent scenario consumption (depends on T1.1)
8. **T4.1** -- Review: code-reviewer scenario gate (depends on T3.2)
9. **T4.2** -- Review: adversarial-reviewer V8 + D9 (depends on T3.2)
10. **TF.1** -- Verification: all files correct (depends on all above)
11. **TF.2** -- Verification: AC satisfaction (depends on TF.1)
12. **TF.3** -- Review: code review pass (depends on TF.2)
13. **TF.4** -- Commit: merge to main (depends on TF.3)

---

## File Inventory Summary

### Files to be Created (2)

| File Path | Purpose |
|-----------|---------|
| `agents/bdd-scenario-writer.md` | New BDD scenario writer agent definition |
| `templates/reference/bdd-patterns.md` | BDD reference template with syntax, guidelines, examples |

### Files to be Modified (7)

| File Path | Changes Required |
|-----------|-----------------|
| `agents/coordinator.md` | Phase 2.5 in 11 sections (flow, delegate, iteration, skip, team, roles, spawn, patterns, termination, gates, verification) |
| `skills/super-dev/SKILL.md` | Phase 2.5 in 10 sections (success, checklist, iteration, roles, enforcement, Phase 9, team creation x2, category, spawn) |
| `agents/qa-agent.md` | BDD in 4 sections (principles, responsibilities, test plan template, quality gates) |
| `agents/code-reviewer.md` | BDD in 3 sections (step 6.1, output template, verdict logic) |
| `agents/adversarial-reviewer.md` | BDD in 5 sections (V8 vector, D9 pre-check, mapping, coverage table, scope output) |
| `agents/spec-writer.md` | BDD in 3 sections (input context, testing strategy, quality standards) |
| `rules/testing.md` | Append BDD section with 9 rules and agent support |

### Files to be Deleted (0)

None.

### Summary

- **Total Files Created:** 2
- **Total Files Modified:** 7
- **Total Files Deleted:** 0
- **Total Files Affected:** 9
