# Task List: Handoff Phase in Super-Dev Workflow

**Specification:** `./03-specification.md`
**Total Tasks:** 9

---

## Phase A: Foundation — Create Handoff Writer Agent

- [ ] **T1.1** Create `handoff-writer` agent markdown file
  - **Files:** `super-dev-plugin/agents/handoff-writer.md` (CREATE)
  - **Details:** Copy the complete agent spec from Section 3 of `03-specification.md` into the new file. Verify YAML frontmatter (`name: handoff-writer`, `description: ...`), role statement, Required Inputs, Handoff Writing Workflow (Steps 1-4), Output Template (7-section + "First steps"), and Quality Gates (H1-H7, HD1-HD5) are all present.
  - **Acceptance:** File exists, follows the same structural pattern as `agents/bdd-scenario-writer.md` (YAML frontmatter, role paragraph, sections with headers)
  - **AC Coverage:** AC-01

---

## Phase B: Core Workflow — Coordinator and SKILL.md Integration

- [ ] **T2.1** Update coordinator delegate/enforcement table
  - **Files:** `super-dev-plugin/agents/coordinator.md` (MODIFY)
  - **Details:** Add Phase 10.5 row to the delegate/enforcement table (after Phase 10 row). Add row: `| 10.5 | Writing handoff document | Spawn handoff-writer |`
  - **Acceptance:** Table contains Phase 10.5 row between Phase 10 and Phase 11 entries
  - **AC Coverage:** AC-05
  - **Dependencies:** None

- [ ] **T2.2** Update coordinator Phase Flow diagram
  - **Files:** `super-dev-plugin/agents/coordinator.md` (MODIFY)
  - **Details:** Add `Phase 10.5: Handoff Writing → Spawn handoff-writer teammate (MANDATORY)` between Phase 10 and Phase 11 lines in the Phase Flow code block
  - **Acceptance:** Phase Flow diagram shows contiguous flow 10 → 10.5 → 11
  - **AC Coverage:** AC-02

- [ ] **T2.3** Update coordinator skip conditions, spawn table, spawn patterns, termination, quality gates, and verification checklist
  - **Files:** `super-dev-plugin/agents/coordinator.md` (MODIFY)
  - **Details:** Apply all remaining coordinator modifications from spec Section 4:
    - Skip Conditions table: Add Phase 10.5 "Never skip" row (Section 4.3)
    - Team Creation Command: Add `- super-dev:handoff-writer` (Section 4.4)
    - Teammate Roles table: Add `| **Docs** | handoff-writer | Generate session handoff document |` (Section 4.5)
    - Spawn Table: Add `| 10.5 | handoff-writer |` (Section 4.6)
    - Spawn Patterns: Add Phase 10.5 spawn pattern block (Section 4.7)
    - Per-Phase Termination: Add `| 10.5 | handoff-writer | 11-handoff.md complete |` (Section 4.8)
    - Quality Gates: Split `→ Phase 11` gate into `→ Phase 10.5` and `→ Phase 11` (Section 4.9)
    - Final Verification Checklist: Add `handoff.md` to Documents line (Section 4.10)
  - **Acceptance:** All 8 sections in coordinator.md reference Phase 10.5 and handoff-writer consistently
  - **AC Coverage:** AC-05, AC-10, AC-11, AC-12
  - **Dependencies:** T2.1, T2.2

- [ ] **T2.4** Update SKILL.md workflow phases, teammate roles, enforcement, team creation, roles by category, and spawn table
  - **Files:** `super-dev-plugin/skills/super-dev/SKILL.md` (MODIFY)
  - **Details:** Apply all SKILL.md modifications from spec Section 5:
    - Workflow Phases checklist: Add `- [ ] Phase 10.5: Handoff Writing (MANDATORY)` (Section 5.1)
    - Teammate Roles table: Add Phase 10.5 handoff-writer row (Section 5.2)
    - Phase Enforcement table: Add Phase 10.5 row with Task tool spawn command (Section 5.3)
    - Team Creation Command: Add `16. super-dev:handoff-writer` (Section 5.4)
    - Roles by Category table: Add handoff-writer Docs row (Section 5.5)
    - Spawn Table: Add `| 10.5 | handoff-writer |` (Section 5.6)
    - Success Criteria: Add handoff document to Outcome list (Section 5.7)
  - **Acceptance:** All 7 sections in SKILL.md reference Phase 10.5 and handoff-writer consistently
  - **AC Coverage:** AC-06, AC-09, AC-11
  - **Dependencies:** T1.1

---

## Phase C: Phase 0 Enhancement — Read Previous Handoff

- [ ] **T3.1** Add "Session Continuity: Read Previous Handoff" section to dev-rules
  - **Files:** `super-dev-plugin/skills/dev-rules/SKILL.md` (MODIFY)
  - **Details:** Insert the new section from spec Section 6.1 after line 8 (after "These rules define coding standards...") and before the "## Figma MCP Integration Rules" section. Include: Handoff Discovery Process (4 steps), Skip Conditions, and Context Application subsections.
  - **Acceptance:** Section exists near the top of dev-rules, describes the scan-sort-read-present discovery process, handles edge cases (no prior specs, no handoff files)
  - **AC Coverage:** AC-07, AC-08

---

## Phase D: Cross-File Consistency Verification

- [ ] **T4.1** Verify cross-file consistency
  - **Files:** All modified files (READ-ONLY verification)
  - **Details:** Read all 4 modified/created files and verify:
    1. `handoff-writer` appears in both `coordinator.md` team creation AND `SKILL.md` team creation
    2. Phase 10.5 appears in all phase-related tables (coordinator: delegate, flow, skip, spawn, termination, quality gates; SKILL.md: phases checklist, roles, enforcement, spawn)
    3. The handoff-writer agent file references `11-handoff.md` as its output
    4. Dev-rules references `11-handoff.md` in its discovery process
    5. No existing phase numbering was changed (Phases 0-10, 11-13 unchanged)
    6. Phase 10.5 is consistently marked as mandatory/never-skip in both coordinator.md and SKILL.md
  - **Acceptance:** All cross-references are consistent, no orphaned references, no naming mismatches
  - **AC Coverage:** AC-12

---

## Final Tasks

- [ ] **TF.1** Run final review of all changes
  - **Agent:** `super-dev:code-reviewer`
  - **Acceptance:** No blocking issues, all changes are markdown-only (no code to build/test)

- [ ] **TF.2** Commit and push changes
  - **Message format:** `feat spec-21-handoff-phase: add handoff writing phase to super-dev workflow`
  - **Files to commit:**
    - `super-dev-plugin/agents/handoff-writer.md` (new)
    - `super-dev-plugin/agents/coordinator.md` (modified)
    - `super-dev-plugin/skills/super-dev/SKILL.md` (modified)
    - `super-dev-plugin/skills/dev-rules/SKILL.md` (modified)
    - `specification/21-handoff-phase/` (all spec artifacts)
  - **Acceptance:** Changes committed to branch `21-handoff-phase`, merged to main

---

## Task Dependencies

```
T1.1 (Create agent) ──┬──► T2.1 ──► T2.3 (Coordinator bulk)
                       │   T2.2 ──┘
                       │
                       └──► T2.4 (SKILL.md bulk)
                       │
                       └──► T3.1 (Dev-rules)
                              │
                              ▼
                           T4.1 (Cross-file verify)
                              │
                              ▼
                           TF.1 (Review)
                              │
                              ▼
                           TF.2 (Commit)
```

**Parallel opportunities:**
- T2.1 + T2.2 can run in parallel (both modify coordinator.md but different sections)
- T2.4 + T3.1 can run in parallel (different files: SKILL.md vs dev-rules)
- T2.3 depends on T2.1 + T2.2 (same file, builds on their changes)
- T4.1 depends on all T2.x and T3.1 (verification of all changes)

## Priority Order

1. **T1.1** — Foundation: the agent file is the core deliverable
2. **T2.1 + T2.2** — Coordinator phase flow and delegate table (parallel)
3. **T2.3** — Remaining coordinator sections (depends on T2.1, T2.2)
4. **T2.4** — SKILL.md integration (can parallel with T2.3 but different file)
5. **T3.1** — Dev-rules Phase 0 enhancement (independent of T2.x)
6. **T4.1** — Cross-file consistency check (depends on all above)
7. **TF.1** — Code review
8. **TF.2** — Commit
