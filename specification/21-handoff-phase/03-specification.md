# Technical Specification: Handoff Phase in Super-Dev Workflow

**Date:** 2026-03-15
**Author:** super-dev:spec-writer
**Status:** Draft

---

## 1. Overview

### 1.1 Summary

Add a mandatory Phase 10.5 (Handoff Writing) to the super-dev workflow that produces `11-handoff.md` in the spec directory after every workflow run. A new `handoff-writer` agent synthesizes all spec artifacts, review results, and workflow context into a structured 7-section handoff document designed for the next AI agent session. Phase 0 (`dev-rules`) is enhanced to discover and read the most recent previous handoff file at session start.

### 1.2 Goals

- Eliminate context loss at session boundaries by producing a standardized handoff document per workflow run
- Enable the next AI agent session to start warm (with full prior context) instead of cold
- Follow established patterns: dedicated agent per phase, sub-phase numbering (10.5), agent markdown format matching `bdd-scenario-writer.md`
- Integrate seamlessly into coordinator, SKILL.md, and dev-rules without renumbering existing Phases 11-13

### 1.3 Non-Goals

- Machine-readable JSON summary section (future enhancement)
- Handoff chain visualization across specs (future enhancement)
- Aggregating multiple handoff documents into a project knowledge base (future enhancement)
- Handoff quality scoring by adversarial reviewer (future enhancement)
- Project root convenience copy of handoff file (user decision: spec directory only)

---

## 2. Background

### 2.1 Context

> From Requirements: Each super-dev run ends with artifacts scattered across 8+ spec files. The next agent must piece together the full picture manually, costing significant context window tokens and risking missed decisions, risks, or unfinished items.

> From Code Assessment: The handoff phase fits naturally as Phase 10.5 between Documentation Update (Phase 10) and Team Cleanup (Phase 11), following the established sub-phase convention (2.5, 5.3, 5.4, 5.5, 11.5).

### 2.2 Current State

> From Code Assessment: The current workflow produces spec artifacts up to `10-implementation-summary.md`. Phase 10 (docs-executor) is retrospective — it summarizes what happened. There is no forward-looking document that prepares the next session with decisions, risks, unfinished items, and recommended paths.

The coordinator (`agents/coordinator.md`) currently defines phases 0-13 with 15 teammates. The SKILL.md (`skills/super-dev/SKILL.md`) mirrors these definitions across 10 sections. The BDD integration (spec-20) recently added Phase 2.5 with `bdd-scenario-writer`, establishing the pattern this spec follows.

### 2.3 Problem Statement

> From Requirements: Context assembly from 8+ spec files costs significant context window tokens and time. The next session may duplicate work already done, contradict decisions already made, or skip follow-up items that were explicitly deferred.

---

## 3. New Agent: `handoff-writer`

The complete agent markdown specification below is ready to be copied into `super-dev-plugin/agents/handoff-writer.md`.

```markdown
---
name: handoff-writer
description: Generate structured session handoff documents for seamless AI agent continuity. Synthesizes all spec artifacts, review results, and workflow context into a 7-section handoff written FOR the next AI agent.
---

You are a Handoff Writer Agent specialized in synthesizing a completed super-dev workflow run into a structured handoff document that enables the next AI agent session to continue work seamlessly.

## Core Principles

1. **Written FOR the next AI agent**: The handoff document is NOT a user-facing summary. Every sentence must be actionable for an AI agent picking up where you left off.
2. **Specific and concrete**: Reference specific file paths, module names, commands, decision points. No filler, no pleasantries, no vague language.
3. **Prioritize actionable information**: The next agent needs to know what to do, not just what was done. Emphasize unfinished items, risks, and recommended next actions.
4. **Synthesize, do not duplicate**: Pull insights from all spec artifacts into a coherent narrative. Do not copy-paste entire documents — distill the key points.
5. **Forward-looking**: The handoff is the bridge between sessions. Focus on what the next agent needs to succeed.

## Required Inputs

- `spec_directory`: Path to the specification directory (e.g., `specification/21-handoff-phase`)
- `feature_name`: Name of the feature or fix
- `workflow_tracking_json`: Path to the workflow tracking JSON file
- All spec directory artifacts that exist:
  - `01-requirements.md` — Requirements and acceptance criteria
  - `01.1-behavior-scenarios.md` — BDD scenarios (if created)
  - `02-research-report.md` — Research findings (if created)
  - `03-code-assessment.md` or `04-assessment.md` — Code assessment
  - `05-architecture.md` or `05-design-spec.md` — Architecture/design (if created)
  - `06-specification.md` — Technical specification
  - `07-implementation-plan.md` — Implementation plan
  - `08-task-list.md` — Task list with completion status
  - Code review report (if created)
  - Adversarial review report (if created)
  - `09-implementation-summary.md` or `10-implementation-summary.md` — Implementation summary
- Git diff summary: `git diff --stat main..HEAD` output
- Any deferred/follow-up items mentioned in code review or adversarial review

## Handoff Writing Workflow

### Step 1 — Gather Context

1. Read the workflow tracking JSON for phase completion status and iteration count
2. Read ALL spec directory artifacts listed above
3. Run `git diff --stat main..HEAD` to get file-level change summary
4. Run `git log --oneline main..HEAD` to get commit history for the workflow
5. Identify any deferred items, follow-up notes, or "future work" mentions across all artifacts

### Step 2 — Synthesize Handoff Sections

For each of the 7 sections, extract and distill from the source artifacts:

| Section | Primary Sources |
|---------|----------------|
| 1. Current Task Objective | requirements.md (goals, AC), workflow JSON (feature name) |
| 2. Current Progress | implementation-summary.md, task-list.md (completion state), workflow JSON (phases) |
| 3. Key Context | requirements.md (constraints, decisions), specification.md (tech decisions), architecture.md |
| 4. Key Findings | code-assessment.md (patterns), research-report.md (conclusions), code-review.md (findings) |
| 5. Unfinished Items | task-list.md (incomplete tasks), code-review.md (deferred items), adversarial-review.md (noted risks) |
| 6. Suggested Handoff Path | specification.md (key files), implementation-plan.md (structure), git diff (changed files) |
| 7. Risks and Warnings | adversarial-review.md (concerns), code-review.md (warnings), implementation-summary.md (challenges) |

### Step 3 — Write the Handoff Document

Write `11-handoff.md` in the spec directory using the 7-section template below. Ensure:
- Every file path is relative to the project root
- Every decision references its rationale
- Every unfinished item has a priority level (P0/P1/P2)
- The "First steps for the next Agent" section has 3-5 concrete, numbered steps

### Step 4 — Validate Quality

Self-validate the handoff document against the Quality Gates below. Fix any violations before signaling completion.

## Output Template

The output file is `11-handoff.md` in the spec directory:

```
# Handoff Document: [Feature/Fix Name]

**Date:** [timestamp]
**From:** AI Agent (Session N)
**To:** Next AI Agent
**Spec Directory:** specification/[spec-index]-[spec-name]

---

## 1. Current Task Objective

### Problem
[What problem was being solved — one paragraph, specific]

### Deliverables
[Bulleted list of what was expected to be produced]

### Completion Criteria
[How "done" is defined — reference specific AC IDs from requirements.md]

---

## 2. Current Progress

### Analysis & Decisions
[Key analysis performed, options evaluated, decisions made with rationale]

### Changes Made
[Files created/modified/deleted, with specific paths — use git diff summary]

### Outputs Produced
[Spec artifacts, code modules, test suites — bulleted list with file paths]

---

## 3. Key Context

### Background
[Why this task exists, what preceded it, how it fits into the project]

### User Requirements & Constraints
[Explicit user conventions: git rules, workflow preferences, commit format, etc.]

### Key Decisions & Rationale
[Architecture choices, design trade-offs, option selections — each with reasoning]

### Assumptions
[What was assumed but not verified — flag these clearly]

---

## 4. Key Findings

### Conclusions
[What was learned during implementation]

### Patterns & Anomalies
[Codebase patterns discovered, unexpected behaviors, naming conventions found]

### Root Causes
[For bug fixes: what caused the issue and how it was confirmed]

### Design Judgments
[Trade-offs made, alternatives considered and rejected, with reasons]

---

## 5. Unfinished Items (Priority Order)

### P0: Critical
[Items that MUST be addressed next — blocking issues, broken functionality]

### P1: Important
[Items deferred from this session — follow-ups, enhancements noted in review]

### P2: Nice-to-Have
[Low-priority items noted during implementation — code quality improvements, future optimizations]

---

## 6. Suggested Handoff Path

### Files to Read First
[Ordered list of most important files to read, with paths and WHY each matters]

### What to Verify First
[Specific commands to run, state to check — e.g., "run tests", "check git status"]

### Recommended Next Actions
[Concrete actionable steps for the next session, in order]

---

## 7. Risks and Warnings

### Pitfalls
[Known tricky areas, file complexity warnings, things that can go wrong]

### Areas Prone to Redundant Effort
[Work already completed that should NOT be repeated — be very specific]

### Directions Not Worth Pursuing
[Approaches already explored and rejected, with reasons why they failed]

---

## First Steps for the Next Agent

1. Read this handoff document completely
2. [Concrete step — e.g., "Check git status and verify working tree is clean"]
3. [Concrete step — e.g., "Read specification/21-handoff-phase/06-specification.md for technical context"]
4. [Concrete step — e.g., "Run: npm test to verify all tests still pass"]
5. [Context-specific next action — e.g., "Start implementing the first P0 unfinished item"]
```

## Quality Gates

### Per-Section Checks (H1-H7)

| # | Check | Pass Criteria |
|---|-------|--------------|
| H1 | **Specificity** | Every section references specific file paths, module names, or commands — no vague language like "some files" or "various changes" |
| H2 | **Agent Audience** | Written FOR an AI agent, NOT a user — no pleasantries, no "feel free to", no hedging language |
| H3 | **Actionability** | Unfinished Items (section 5) and Suggested Handoff Path (section 6) contain concrete, actionable steps an agent can execute immediately |
| H4 | **Completeness** | All 7 sections are present and non-empty. "First steps for the next Agent" section exists with 3-5 numbered steps |
| H5 | **No Duplication** | Handoff synthesizes insights, does not copy-paste from source artifacts. Each section adds value beyond what the source documents provide individually |
| H6 | **Priority Assignment** | All unfinished items in section 5 have P0/P1/P2 priority levels |
| H7 | **Decision Traceability** | Key decisions in section 3 include rationale (why this option was chosen over alternatives) |

### Per-Document Checks (HD1-HD5)

| # | Check | Pass Criteria |
|---|-------|--------------|
| HD1 | **All Sources Referenced** | Handoff reflects content from ALL available spec artifacts — nothing important is omitted |
| HD2 | **Forward-Looking** | Sections 5, 6, 7 collectively provide enough context for the next agent to start work within 1-2 minutes of reading |
| HD3 | **No Stale Information** | All file paths, module names, and commands are current (verified against git diff and actual directory contents) |
| HD4 | **Risks Documented** | At least one risk or warning is documented in section 7 (every workflow has at least one lesson learned) |
| HD5 | **First Steps Concrete** | "First steps for the next Agent" contains executable steps, not generic advice |
```

---

## 4. Coordinator Modifications

All modifications are to `super-dev-plugin/agents/coordinator.md`. Each change shows the exact before/after with surrounding context for precise insertion.

### 4.1 Delegate/Enforcement Table (lines 75-89)

**Add after the Phase 10 row (line 88):**

```markdown
| 10.5 | Writing handoff document | Spawn handoff-writer |
```

The table will read:
```
| 10 | Updating documentation | Spawn docs-executor |
| 10.5 | Writing handoff document | Spawn handoff-writer |
```

### 4.2 Phase Flow Diagram (lines 96-116)

**Add after line 111 (`Phase 10: Documentation Update`):**

```markdown
Phase 10.5: Handoff Writing          → Spawn handoff-writer teammate (MANDATORY)
```

The flow will read:
```
Phase 10: Documentation Update      → Spawn docs-executor teammate
Phase 10.5: Handoff Writing          → Spawn handoff-writer teammate (MANDATORY)
Phase 11: Team Cleanup              → Final verification (teammates already terminated per-phase, keep worktree)
```

### 4.3 Skip Conditions Table (lines 144-154)

**Add after the Phase 2.5 row (line 153):**

```markdown
| Phase 10.5 | Never skip — handoff document is mandatory for all workflow runs |
```

### 4.4 Team Creation Command (lines 163-180)

**Add after line 179 (`- super-dev:docs-executor`):**

```markdown
- super-dev:handoff-writer
```

### 4.5 Teammate Roles by Category Table (lines 182-200)

**Add after the `docs-executor` row (line 200):**

```markdown
| **Docs** | handoff-writer | Generate session handoff document |
```

### 4.6 Spawn Table (lines 204-218)

**Add after the Phase 10 row (line 217):**

```markdown
| 10.5 | handoff-writer |
```

### 4.7 Spawn Patterns Section (lines 219-256)

**Add after the Phase 9 spawn patterns (before line 258 "## Monitoring & Oversight"):**

```markdown
**Phase 10.5 (Handoff Writing):**
```
"Spawn a handoff-writer teammate with this context:
- Task: Generate session handoff document
- Spec directory: specification/[spec-index]-[spec-name]
- Feature name: [feature name]
- Workflow JSON: specification/[spec-index]-[spec-name]/[spec-index]-[spec-name]-workflow-tracking.json
- All spec artifacts in the spec directory
- Git diff: run `git diff --stat main..HEAD`

Your role is to synthesize all workflow artifacts into 11-handoff.md following the 7-section template.
Write FOR the next AI agent. Be specific, concrete, and actionable."
```
```

### 4.8 Per-Phase Termination Table (lines 303-318)

**Add after the Phase 10 row (line 317):**

```markdown
| 10.5 | handoff-writer | 11-handoff.md complete |
```

### 4.9 Quality Gates Table (lines 321-335)

**Change the `→ Phase 11` gate (line 333). BEFORE:**

```markdown
| → Phase 11 | Documentation updated, teammates shut down (worktree preserved) |
```

**AFTER:**

```markdown
| → Phase 10.5 | Documentation updated |
| → Phase 11 | 11-handoff.md exists in spec directory, teammates shut down (worktree preserved) |
```

### 4.10 Final Verification Checklist (lines 366-372)

**Change the Documents line (line 367). BEFORE:**

```markdown
- Documents: requirements.md, behavior-scenarios.md, research-report.md, assessment.md, specification.md, implementation-plan.md, task-list.md (all complete), implementation-summary.md
```

**AFTER:**

```markdown
- Documents: requirements.md, behavior-scenarios.md, research-report.md, assessment.md, specification.md, implementation-plan.md, task-list.md (all complete), implementation-summary.md, handoff.md
```

### 4.11 Final Report Template (lines 431-441)

No structural change needed — the `## Documents: [list]` line already uses a dynamic list placeholder. The handoff document will be included automatically when the coordinator lists all spec directory files.

---

## 5. SKILL.md Modifications

All modifications are to `super-dev-plugin/skills/super-dev/SKILL.md`.

### 5.1 Workflow Phases Checklist (lines 126-145)

**Add after line 141 (`- [ ] Phase 10: Documentation Update`):**

```markdown
- [ ] Phase 10.5: Handoff Writing (MANDATORY)
```

The checklist will read:
```
- [ ] Phase 10: Documentation Update
- [ ] Phase 10.5: Handoff Writing (MANDATORY)
- [ ] Phase 11: Team Cleanup (keep worktree)
```

### 5.2 Teammate Roles Table (lines 236-251)

**Add after the `docs-executor` row (line 251):**

```markdown
| 10.5 | handoff-writer | Generate session handoff document |
```

### 5.3 Phase Enforcement Table (lines 321-342)

**Add after the Phase 10 row (line 337):**

```markdown
| 10.5 | Use Task tool → `super-dev:handoff-writer` | handoff-writer |
```

### 5.4 Team Creation Command (lines 573-589)

**Add after line 588 (`15. super-dev:docs-executor`):**

```markdown
16. super-dev:handoff-writer
```

### 5.5 Roles by Category Table (lines 594-610)

**Add after the `docs-executor` row (line 610):**

```markdown
| **Docs** | handoff-writer | Generate session handoff | `super-dev:handoff-writer` |
```

### 5.6 Spawn Table (lines 639-655)

**Add after the Phase 10 row (line 654):**

```markdown
| 10.5 | handoff-writer |
```

### 5.7 Success Criteria / Outcome Section (lines 104-109)

**Add to the Outcome list (after line 109 "Documentation updated to reflect changes"):**

```markdown
- Handoff document generated in spec directory (`11-handoff.md`)
```

---

## 6. Dev-Rules Modifications

Modification to `super-dev-plugin/skills/dev-rules/SKILL.md`.

### 6.1 New Section: Session Continuity (after line 8)

**Add after line 8 (`These rules define coding standards and practices that MUST be followed for all development work.`) and before line 10 (`## Figma MCP Integration Rules`):**

```markdown

## Session Continuity: Read Previous Handoff

At the start of every super-dev session, check for context from the previous completed spec.

### Handoff Discovery Process

1. **Scan spec directories**: List all directories in `specification/` and extract the numeric prefix from each directory name (e.g., `20` from `20-bdd-integration`)
2. **Sort descending**: Order directories by numeric prefix, highest first
3. **Find the most recent handoff**: Starting from the highest-index directory, check if `11-handoff.md` exists
   - If found: Read the handoff file — proceed to step 4
   - If not found: Try the next-highest directory (graceful fallback for pre-handoff specs)
   - If no handoff found in any directory: Skip silently — this is the first run or all specs predate the handoff phase
4. **Present prior context**: Display a brief summary to the Team Lead:
   - What was done in the previous session (from section 2)
   - Key decisions made (from section 3)
   - Unfinished items / follow-ups (from section 5)
   - Risks and warnings (from section 7)
   - First steps recommended (from "First steps for the next Agent")

### Skip Conditions

- If no prior spec directory exists, or no handoff file is found in any spec directory, skip silently
- The first run of super-dev in a project has no handoff to read
- Do NOT fail or warn if no handoff exists — backward compatible with specs that predate the handoff phase

### Context Application

The handoff context from the previous session informs:
- Phase 2 (Requirements): Awareness of prior decisions and constraints
- Phase 5 (Code Assessment): Knowledge of recently changed areas and patterns
- All phases: Avoidance of redundant work, awareness of known risks
```

---

## 7. Data Flow

### Phase 10.5 → Phase 0 Bridge

```
Session N:                                Session N+1:

Phase 10: docs-executor                   Phase 0: dev-rules (ENHANCED)
  produces implementation-summary,          │
  updated task list                         ├─ 1. Scan specification/*
  ↓                                         ├─ 2. Find highest-index dir with 11-handoff.md
Phase 10.5: handoff-writer                  ├─ 3. Read handoff file
  │                                         ├─ 4. Present summary to Team Lead
  ├─ Reads: ALL spec artifacts              └─ 5. Context available for Phase 2+
  ├─ Reads: workflow-tracking.json
  ├─ Reads: git diff --stat main..HEAD      Phase 1: Setup
  ├─ Reads: git log --oneline main..HEAD      (starts WITH prior context)
  │                                           ↓
  └─ Writes: specification/[spec]/          Phase 2: Requirements
              11-handoff.md                   (informed by prior handoff)
  ↓
Phase 11: Team Cleanup (unchanged)
  ↓
Phase 12: Commit & Merge
  (11-handoff.md committed as part of
   specification/[spec-index]-[spec-name]/)
```

### Input/Output Matrix

| Component | Inputs | Outputs |
|-----------|--------|---------|
| handoff-writer (Phase 10.5) | All spec artifacts, workflow JSON, git diff, git log | `11-handoff.md` in spec directory |
| dev-rules (Phase 0) | `specification/*/11-handoff.md` (scanned) | Summary context for Team Lead |
| coordinator (Phase 10.5) | handoff-writer completion signal | Phase transition to Phase 11 |

---

## 8. Quality Gates

### What Makes a Good Handoff Document

A handoff document passes quality when:

1. **All 7 sections are present and non-empty** — no section is skipped or left as placeholder
2. **Written for AI agent audience** — no user-facing language, no hedging, no "feel free to"
3. **Specific file paths throughout** — every reference to code, config, or spec uses actual paths
4. **Unfinished items are prioritized** — P0/P1/P2 levels with actionable descriptions
5. **First steps section is executable** — 3-5 concrete steps the next agent can follow immediately
6. **Risks section has at least one entry** — every workflow run has at least one lesson learned
7. **No copy-paste from source artifacts** — synthesized insights, not duplicated content

### Phase 10.5 → Phase 11 Transition Gate

The coordinator verifies before moving to Phase 11:
- `11-handoff.md` exists in the spec directory
- The file is non-empty and contains all 7 section headers
- The "First steps for the next Agent" section exists

---

## 9. Edge Cases

### 9.1 First Run (No Previous Handoff)

**Situation:** No `specification/*/11-handoff.md` exists in any spec directory.
**Behavior:** Phase 0 skips the handoff reading step silently. No warning, no error. The session proceeds normally without prior context.

### 9.2 Previous Specs Predate Handoff Phase

**Situation:** Multiple spec directories exist (e.g., `01-user-auth`, `02-payment`, `03-billing`) but none contain `11-handoff.md` because they were created before the handoff phase was integrated.
**Behavior:** Phase 0 scans from highest to lowest index, finds no handoff in any directory, and skips silently.

### 9.3 Incomplete Spec Directory

**Situation:** The highest-index spec directory exists but is incomplete (e.g., workflow was interrupted, only `01-requirements.md` exists).
**Behavior:** Phase 0 looks for `11-handoff.md` specifically. If it does not exist in the highest-index directory, Phase 0 tries the next-highest directory. An incomplete spec directory (without `11-handoff.md`) is simply skipped.

### 9.4 Current Spec Directory Already Exists

**Situation:** The current workflow's spec directory (e.g., `21-handoff-phase`) already exists from a previous interrupted session.
**Behavior:** Phase 0 should NOT read the handoff from the current spec directory — it should read the handoff from the previous (different) spec directory. The discovery logic finds the highest-index directory that is NOT the current spec directory.

**Implementation note:** The coordinator provides the current spec index to dev-rules. The discovery logic excludes directories with the current spec index.

### 9.5 Workflow Fails Partway

**Situation:** The workflow encounters a non-recoverable error before reaching Phase 10.5.
**Behavior:** No `11-handoff.md` is produced. The next session's Phase 0 will not find a handoff for this spec and will fall back to the previous spec's handoff (if one exists). This is acceptable — the handoff is a product of a completed workflow.

### 9.6 Phase 10.5 Handoff Writer Fails

**Situation:** The handoff-writer agent encounters an error and cannot produce `11-handoff.md`.
**Behavior:** The coordinator follows standard error handling (max 3 attempts). If all attempts fail, the coordinator documents the failure in the implementation summary and proceeds to Phase 11. The handoff document is valuable but not workflow-blocking — the next session simply starts cold.

---

## 10. AC Verification Plan

| AC ID | Verification Method | What to Check |
|-------|-------------------|---------------|
| AC-01 | File inspection | `agents/handoff-writer.md` exists with YAML frontmatter (`name`, `description`), role statement, workflow steps, output template, quality gates |
| AC-02 | Read `coordinator.md` Phase Flow section | Phase 10.5 (Handoff Writing) appears between Phase 10 and Phase 11 |
| AC-03 | Manual workflow test | Run a complete super-dev workflow and verify `11-handoff.md` is created in spec directory with all 7 sections + "First steps" section |
| AC-04 | Content inspection of `11-handoff.md` | Document is agent-focused (no user language), specific (file paths present), concrete (no filler), ends with "First steps for the next Agent" |
| AC-05 | Read `coordinator.md` | Delegate table, spawn patterns, termination rules, quality gates all include handoff-writer for Phase 10.5 |
| AC-06 | Read `skills/super-dev/SKILL.md` | Workflow phases checklist, teammate roles table, phase enforcement table, team creation command all include Phase 10.5 and handoff-writer |
| AC-07 | Read `skills/dev-rules/SKILL.md` | "Session Continuity: Read Previous Handoff" section exists with discovery logic |
| AC-08 | Manual test with no prior handoff | Start a session in a project with no `specification/*/11-handoff.md` — Phase 0 completes normally without errors |
| AC-09 | Read workflow tracking JSON | Verify Phase 10.5 appears in the phases array with correct status tracking |
| AC-10 | Read `coordinator.md` skip conditions | Phase 10.5 is listed as "Never skip" |
| AC-11 | Read both `coordinator.md` and `SKILL.md` team creation lists | `super-dev:handoff-writer` appears in both team creation commands |
| AC-12 | Diff inspection | Compare Phases 0-10 and 11-13 behavior before and after changes — no behavioral changes, no renumbering |
| AC-13 | Removed — dual-location requirement was removed per user decision (spec directory only) |

---

## 11. References

- Requirements: `./01-requirements.md`
- Code Assessment: `./02-code-assessment.md`
- BDD Scenario Writer (agent pattern reference): `super-dev-plugin/agents/bdd-scenario-writer.md`
- Docs Executor (unchanged reference): `super-dev-plugin/agents/docs-executor.md`
- Coordinator: `super-dev-plugin/agents/coordinator.md`
- SKILL.md: `super-dev-plugin/skills/super-dev/SKILL.md`
- Dev-Rules: `super-dev-plugin/skills/dev-rules/SKILL.md`
