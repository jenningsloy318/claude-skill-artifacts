# Requirements: Handoff Phase in Super-Dev Workflow

**Date:** 2026-03-15
**Type:** Feature (Plugin Enhancement)
**Priority:** High

## Executive Summary

The super-dev plugin currently completes each workflow run without producing a structured summary document for the next AI agent session. When a new session starts, the agent must rediscover context from scratch by reading specification artifacts, git logs, and code. A handoff phase at the end of each workflow run produces a standardized handoff document that gives the next agent immediate continuity: what was done, what decisions were made, what's unfinished, and what risks exist. Phase 0 is enhanced to read the previous spec's handoff automatically, creating a chain of context across sessions.

## The Real Need (Root Cause Analysis)

### Surface Request

Add a handoff phase after documentation (Phase 10) that generates a handoff document, and enhance Phase 0 to read the previous spec's handoff file for context continuity.

### 5 Whys Analysis

1. **Why a handoff document?** Each super-dev run ends with artifacts scattered across spec files (requirements, research, code review, implementation summary), and the next agent must piece together the full picture manually.
2. **Why is piecing together a problem?** Context assembly from 8+ spec files costs significant context window tokens and time, and the new agent risks missing critical decisions, risks, or unfinished items buried in individual documents.
3. **Why does missing context matter?** The next session may duplicate work already done, contradict decisions already made, or skip follow-up items that were explicitly deferred — reducing workflow reliability.
4. **Why can't the agent just read the implementation summary?** The implementation summary (`09-implementation-summary.md`) documents what was built and how, but does NOT capture: next session's recommended approach, risks/warnings about the codebase, unfinished items from prior sessions, or cross-session context (what the PREVIOUS feature taught us).
5. **Why does cross-session continuity matter?** The super-dev plugin produces increasingly complex projects where each feature builds on previous ones. Without explicit handoff, cumulative knowledge is lost — each agent starts cold instead of warm, leading to repeated mistakes, inconsistent patterns, and slower velocity.

### Job to Be Done

**When** finishing a super-dev workflow run,
**I want to** automatically generate a structured handoff document summarizing the work done, key decisions, unfinished items, and risks,
**So I can** ensure the next AI agent session starts with full context and can continue seamlessly without rediscovering what was already learned.

**Job Type:**
- Functional: Produce a machine-readable, human-readable handoff document per spec; read the previous spec's handoff at startup
- Emotional: Confidence that no context is lost between sessions; no anxiety about "did the previous agent leave notes?"
- Social: Demonstrate professional development practices (handoff is standard in human engineering teams)

## Workflow Context

### Current State

```
Session N ends:                           Session N+1 starts:

Phase 10: docs-executor                   Phase 0: dev-rules
  updates task list,                        loads coding standards,
  impl summary, spec                        git rules, quality standards
  ↓                                         ↓
Phase 11: Team Cleanup                    Phase 1: Setup
  verify teammates                          worktree, spec dir, team
  shut down                                 ↓
  ↓                                       Phase 2: Requirements
Phase 12: Commit & Merge                    starts FROM SCRATCH
  git operations                            (no knowledge of Session N)
  ↓
Phase 13: Final Verification
  verify clean state

  ─────── SESSION BOUNDARY ───────
  NO CONTEXT TRANSFER
```

### Pain Points

1. **No structured summary** — Artifacts exist but no single document synthesizes the session's story
2. **Context loss at session boundary** — New session starts cold; must re-read all spec files
3. **Deferred items get lost** — Follow-up items noted in code review or implementation summary may be overlooked
4. **Risk amnesia** — Warnings about tricky areas (e.g., "SKILL.md line numbers drift") are lost
5. **Duplicate effort** — Next agent may redo analysis the previous agent already completed
6. **No recommended path** — Next agent must figure out what to read and in what order

### Proposed Workflow with Handoff Phase

```
Session N ends:                           Session N+1 starts:

Phase 10: docs-executor                   Phase 0: dev-rules (ENHANCED)
  updates task list,                        loads coding standards +
  impl summary, spec                        READS previous handoff from
  ↓                                         specification/XX-prev/11-handoff.md
Phase 10.5 (NEW): handoff-writer            ↓
  generates 11-handoff.md                 Phase 1: Setup
  in spec directory                         worktree, spec dir, team
  ↓                                         (has full prior context)
Phase 11: Team Cleanup                      ↓
  (unchanged)                             Phase 2: Requirements
  ↓                                         starts WITH context from
Phase 12-13: (unchanged)                    previous session's handoff

  ─────── SESSION BOUNDARY ───────
  CONTEXT TRANSFERRED via 11-handoff.md
```

### Stakeholders

- **Coordinator (Team Lead)**: Orchestrates new Phase 10.5, spawns handoff-writer
- **handoff-writer agent (NEW)**: Produces the handoff document
- **dev-rules skill (Phase 0)**: Enhanced to find and read previous spec's handoff file
- **docs-executor**: Unchanged — handoff is a separate concern from documentation updates
- **All future agents**: Benefit from contextual warmup via Phase 0 handoff reading

## Requirements

### Functional Requirements

#### FR-1: Handoff Document Generation

A new phase (Phase 10.5) produces a handoff document in TWO locations:
- `specification/[spec-index]-[spec-name]/11-handoff.md` — permanent artifact in the spec directory
- `./{yymmdd}-handoff.md` — project root convenience copy (e.g., `260315-handoff.md`)

The document is written **FOR the next AI agent**, NOT as a user-facing summary. It must be specific, concrete, avoid filler, prioritize actionable information, and reference specific file paths, module names, commands, and decision points.

The document follows the user's 7-section template:

1. **Current Task Objective** — Problem being solved, deliverables, completion criteria
2. **Current Progress** — Analysis, decisions, changes, and outputs completed
3. **Key Context** — Background, user requirements, constraints, key decisions, assumptions
4. **Key Findings** — Conclusions, patterns, anomalies, root causes, design judgments
5. **Unfinished Items** — Remaining work sorted by priority
6. **Suggested Handoff Path** — Files to read first, what to verify, recommended next actions
7. **Risks and Warnings** — Pitfalls, areas prone to redundant effort, directions not worth pursuing

The document MUST end with a **"First steps for the next Agent"** section providing concrete, numbered steps for the next AI agent to begin work immediately.

#### FR-2: Handoff Writer Agent

A dedicated `handoff-writer` agent at `agents/handoff-writer.md` following the existing agent markdown pattern (YAML frontmatter with `name`, `description` fields, role statement, workflow steps, output template, quality gates).

#### FR-3: Phase 0 Enhancement — Read Previous Handoff

`skills/dev-rules/SKILL.md` (Phase 0) is enhanced with a new section that:
1. First checks for `*-handoff.md` files in the project root (the convenience copy)
2. If not found in root, scans `specification/` for all spec directories
3. Finds the highest-index directory (most recent completed spec)
4. Checks if `11-handoff.md` exists in that directory
5. If found: reads it and includes key context in the current session
6. If not found: proceeds normally (backward compatible with specs that predate the handoff phase)

#### FR-4: Handoff Document Inputs

The handoff-writer agent receives context from the coordinator including:
- All spec directory artifacts (requirements, research, assessment, specification, task list, implementation summary)
- Code review and adversarial review results
- Workflow tracking JSON (phases, tasks, iterations)
- Git diff summary (files changed, created, deleted)
- Any deferred/follow-up items from implementation or review

#### FR-5: Handoff Document Dual Location

The handoff document is stored in TWO locations:
1. **Spec directory (permanent):** `specification/[spec-index]-[spec-name]/11-handoff.md` — follows the spec directory numbering convention (next sequential number after existing documents)
2. **Project root (convenience):** `./{yymmdd}-handoff.md` (e.g., `260315-handoff.md`) — easy access for the next session without needing to know the spec index

Both files have identical content. The project root copy uses the date-based naming convention matching the user's existing handoff file (`260315-handoff.md`).

#### FR-6: Coordinator Integration

The coordinator (`agents/coordinator.md`) is updated to:
- Include Phase 10.5 in the phase flow
- Add handoff-writer to the delegate table
- Add spawn pattern for Phase 10.5
- Add termination entry for handoff-writer
- Add quality gate for Phase 10.5 → Phase 11 transition

#### FR-7: SKILL.md Integration

`skills/super-dev/SKILL.md` is updated to:
- Include Phase 10.5 in the workflow phases checklist
- Add handoff-writer to the teammate roles table
- Add Phase 10.5 to the phase enforcement table
- Include handoff-writer in team creation command

### Non-Functional Requirements

- **Backward compatible**: Specs created before handoff phase integration have no `11-handoff.md` — Phase 0 handles this gracefully
- **Mandatory phase**: Phase 10.5 is NOT skippable — every workflow run produces a handoff document
- **Minimal disruption**: No changes to Phases 0-9, 11-13 behavior (only Phase 0 gains reading capability; Phases 11-13 numbering unchanged)
- **Agent pattern consistency**: handoff-writer follows the same agent markdown pattern as all existing agents
- **Spec directory convention**: `11-handoff.md` follows the existing numbering scheme

### Anticipated Downstream Needs

Based on workflow analysis:

1. **Handoff chain visualization**: Over time, handoff documents create a chain across specs — future enhancement could visualize this chain
2. **Automated priority detection**: The handoff writer could tag unfinished items with priority levels for the next session to triage
3. **Cross-spec knowledge base**: Multiple handoff documents could be aggregated into a project-level knowledge base — future enhancement
4. **Handoff quality scoring**: Adversarial reviewer could audit handoff documents for completeness — future enhancement

## Proposed Solution Options

### Option A: Extend docs-executor to Also Produce Handoff (Phase 10 Extension)

Extend the docs-executor agent to produce `11-handoff.md` as an additional output alongside task list updates, implementation summary, and spec deviation tracking.

**What changes:**
- `agents/docs-executor.md`: Extended with handoff document generation section
- `skills/dev-rules/SKILL.md`: Add previous handoff reading
- No new agents, no new phases

```
Phase 10: docs-executor (EXTENDED)
  1. Update task list         (existing)
  2. Compile impl summary     (existing)
  3. Update specification      (existing)
  4. Generate handoff document (NEW)
  ↓
Phase 11: Team Cleanup (unchanged)
```

**Pros:**
- No new agent to maintain
- No new phase to track
- Simplest structural change

**Cons:**
- docs-executor scope creep — it handles documentation UPDATE (marking tasks done, compiling summaries), while the handoff document is a SYNTHESIS of the entire workflow run for an external audience (the next agent session). These are different concerns.
- docs-executor receives its input from the coordinator via Phase 9 results. The handoff document needs broader context: the full workflow story, including phases the docs-executor doesn't typically receive (research decisions, architecture choices, risk patterns).
- Increases the already-complex docs-executor prompt, making it harder to maintain.

### Option B: New handoff-writer Agent + Phase 10.5 (Recommended)

Introduce a dedicated `handoff-writer` agent and Phase 10.5 between documentation (Phase 10) and team cleanup (Phase 11). This follows the established sub-phase convention (2.5, 5.3, 5.4, 5.5, 11.5).

**What changes:**
- **NEW agent**: `agents/handoff-writer.md`
- `agents/coordinator.md`: Add Phase 10.5 to phase flow, delegate table, spawn patterns, termination rules, quality gates
- `skills/super-dev/SKILL.md`: Add Phase 10.5 to checklist, teammate roles, enforcement table, team creation
- `skills/dev-rules/SKILL.md`: Add previous handoff reading section in Phase 0
- Workflow tracking JSON: Include Phase 10.5

```
Phase 10:   docs-executor (unchanged)
  ↓
Phase 10.5: handoff-writer (NEW)
  generates 11-handoff.md
  ↓
Phase 11:   Team Cleanup (unchanged)
```

**Pros:**
- Clean separation of concerns — dedicated agent for a distinct task
- Follows the project's established pattern: one agent per phase responsibility
- Sub-phase numbering (10.5) avoids disruptive renumbering of Phases 11-13
- handoff-writer can be specialized with full context about what makes a good handoff
- Consistent with how BDD was integrated (Phase 2.5 with dedicated agent)

**Cons:**
- One more agent file to maintain
- Adds a sequential step (~30s-1min overhead)
- Requires coordinator and SKILL.md updates (but this is standard for any new phase)

### Option C: New Phase 11, Renumber Existing 11-13 to 12-14

Add handoff as Phase 11 with integer numbering, and renumber the current Phase 11 (Team Cleanup) through Phase 13 (Final Verification) to 12-14.

**What changes:**
- **NEW agent**: `agents/handoff-writer.md`
- `agents/coordinator.md`: Renumber Phase 11→12, 11.5→12.5, 12→13, 13→14; add Phase 11 as handoff
- `skills/super-dev/SKILL.md`: Renumber all phase references
- All agent files that reference Phase 11/12/13: Update references
- `skills/dev-rules/SKILL.md`: Add previous handoff reading

```
Phase 10:   docs-executor (unchanged)
  ↓
Phase 11:   handoff-writer (NEW, integer phase)
  ↓
Phase 12:   Team Cleanup (was 11)
Phase 12.5: Manual Confirmation (was 11.5)
Phase 13:   Commit & Merge (was 12)
Phase 14:   Final Verification (was 13)
```

**Pros:**
- Clean integer numbering for all major phases
- No sub-phases needed

**Cons:**
- **Extremely high blast radius** — Phases 11, 11.5, 12, 13 are referenced in 10+ sections across `coordinator.md` and `SKILL.md`, plus in `docs-executor.md`, error handling sections, and quality gate definitions
- Every existing reference to "Phase 12 (commit)" or "Phase 13 (verification)" must be updated
- Risk of missed references causing inconsistencies
- Contradicts the established convention of using sub-phases for non-major additions (2.5, 5.3, 5.4, 5.5, 11.5)
- The BDD integration (spec-20) chose Phase 2.5 over renumbering for exactly this reason

## Impact Assessment

### Business Outcome

Eliminates context loss at session boundaries, enabling continuous development velocity across AI agent sessions. Each new session starts warm instead of cold, reducing the time-to-productive from 5-10 minutes of context gathering to immediate productive work.

### Success Metrics

- **Handoff generation**: 100% of super-dev runs produce both `11-handoff.md` in spec dir and `{yymmdd}-handoff.md` in project root
- **Phase 0 context loading**: Phase 0 successfully finds and reads the most recent handoff file when one exists
- **Context continuity**: Next agent session can reference specific details from the handoff document (decisions, risks, follow-ups)
- **No workflow regression**: All existing phases (0-13) continue to work without changes to their behavior

### Behavior Change Expected

- Coordinator spawns handoff-writer agent after Phase 10 docs-executor completes
- Phase 0 (dev-rules) now includes a "read previous handoff" step before existing content
- Handoff document becomes the primary onboarding artifact for new sessions
- Follow-up items from one session are explicitly tracked for the next session

## Technical Considerations

### Integration Points

| Component | Change Type | Effort |
|-----------|-------------|--------|
| `agents/handoff-writer.md` | **New file** | Medium |
| `agents/coordinator.md` | Modify (add Phase 10.5 to ~8 sections) | Medium |
| `skills/super-dev/SKILL.md` | Modify (add Phase 10.5 to ~6 sections) | Small |
| `skills/dev-rules/SKILL.md` | Modify (add previous handoff reading) | Small |
| Workflow tracking JSON schema | Schema update (Phase 10.5) | Small |

### Technical Constraints

1. **Agent markdown pattern**: `handoff-writer.md` must follow the YAML frontmatter format (`name`, `description`) with role statement, workflow steps, output template, quality gates
2. **Spec directory convention**: Handoff file is `11-handoff.md` (next sequential number after existing spec documents which go up to ~10)
3. **Phase 0 is a Skill, not an Agent**: The previous handoff reading goes in `skills/dev-rules/SKILL.md`, which is loaded via the Skill tool before the coordinator starts. The coordinator is NOT involved in reading the previous handoff.
4. **Scanning specification/ directory**: Phase 0 must scan for `specification/*/11-handoff.md`, sort by spec index, and read the highest one. Edge cases: no specs exist, specs exist but none have handoff files, multiple specs exist.
5. **No changes to existing Phase 11-13 numbering**: Phase 10.5 fits cleanly between Phase 10 and Phase 11.

### Handoff Document Template

**Audience:** The next AI agent session (NOT a user-facing summary)
**Tone:** Specific, concrete, actionable — no filler
**References:** Always use specific file paths, module names, commands, decision points

```markdown
# Handoff Document: [Feature/Fix Name]

**Date:** [timestamp]
**From:** AI Agent (Session N)
**To:** Next AI Agent
**Project:** [project path]
**Spec Directory:** specification/[spec-index]-[spec-name]

---

## 1. Current Task Objective

### Problem
[What problem was being solved]

### Deliverables
[What was expected to be produced]

### Completion Criteria
[How "done" is defined]

---

## 2. Current Progress

### Analysis & Decisions
[Key analysis performed, options evaluated, decisions made with rationale]

### Changes Made
[Files created/modified/deleted, with specific paths]

### Outputs Produced
[Spec artifacts, code modules, test suites — with file paths]

---

## 3. Key Context

### Background
[Why this task exists, what preceded it]

### User Requirements & Constraints
[Explicit user conventions: git rules, workflow preferences, commit format]

### Key Decisions & Rationale
[Architecture choices, design trade-offs, option selections with reasoning]

### Assumptions
[What was assumed but not verified]

---

## 4. Key Findings

### Conclusions
[What was learned during implementation]

### Patterns & Anomalies
[Codebase patterns discovered, unexpected behaviors found]

### Root Causes
[For bug fixes: what caused the issue]

### Design Judgments
[Trade-offs made, alternatives considered and rejected]

---

## 5. Unfinished Items (Priority Order)

### P0: Critical
[Items that must be addressed next — blocking issues]

### P1: Important
[Items deferred from this session — follow-ups, enhancements]

### P2: Nice-to-Have
[Low-priority items noted during implementation]

---

## 6. Suggested Handoff Path

### Files to Read First
[Ordered list of most important files, with paths and why each matters]

### What to Verify First
[Specific commands to run, state to check]

### Recommended Next Actions
[Concrete actionable steps for the next session]

---

## 7. Risks and Warnings

### Pitfalls
[Known tricky areas, file complexity warnings, things that can go wrong]

### Areas Prone to Redundant Effort
[Work already completed that shouldn't be repeated — be specific]

### Directions Not Worth Pursuing
[Approaches already explored and rejected, with reasons]

---

## First Steps for the Next Agent

1. [Concrete step 1 — e.g., "Read this handoff document completely"]
2. [Concrete step 2 — e.g., "Run: git log --oneline -5 on main branch"]
3. [Concrete step 3 — e.g., "Verify: check worktree state with git worktree list"]
4. [Concrete step 4 — e.g., "Start: /super-dev:super-dev with task description"]
5. [Concrete step 5 — context-specific next action]
```

### Phase 0 Previous Handoff Discovery Logic

```
1. Check project root for *-handoff.md files (e.g., 260315-handoff.md)
2. If found in root: Read the most recent one (by date prefix) — DONE
3. If NOT found in root: Fall back to spec directory scan:
   a. List all directories in specification/
   b. Extract numeric prefix from each directory name (e.g., "20" from "20-bdd-integration")
   c. Sort by numeric prefix descending
   d. For the highest-index directory, check if 11-handoff.md exists
   e. If exists: Read and include as "Previous Session Context"
   f. If not exists: Try the next-highest directory (graceful fallback for pre-handoff specs)
4. If no handoff found anywhere: Proceed normally with no prior context
```

## Assumptions

1. **Dual-location handoff files**: The handoff document is written to both `specification/[spec-index]-[spec-name]/11-handoff.md` (permanent spec artifact) and `./{yymmdd}-handoff.md` in the project root (convenience copy for quick access by the next session).
2. **Phase 10.5 runs after docs-executor completes**: The handoff writer needs the updated documentation as input (implementation summary, finalized task list).
3. **Only the most recent handoff is read in Phase 0**: Reading all previous handoffs would consume too much context. The most recent one captures the latest state.
4. **Phase 10.5 is mandatory**: Unlike Phase 4 (bugs only) or Phase 2.5 (features only), every workflow run benefits from a handoff document, including bug fixes and refactoring.
5. **The handoff document template is fixed**: The 7-section format provided by the user is the canonical format, plus a mandatory "First steps for the next Agent" closing section. The handoff-writer agent uses this exact structure.
6. **Handoff audience is the next AI agent**: The document is NOT a user-facing summary. It is written to maximize the next agent's ability to continue work immediately.

## Open Questions

- [ ] **Q1**: Should the handoff-writer agent also include a machine-readable section (JSON summary) for potential future automation, or is markdown-only sufficient?
- [ ] **Q2**: When Phase 0 reads the previous handoff, should it present a summary to the user, or silently absorb the context?
- [x] **Q3**: ~~Should the handoff file be named `11-handoff.md` (fixed number) or use the next available number in the spec directory (dynamic)?~~ **Resolved**: Fixed as `11-handoff.md` in spec dir + `{yymmdd}-handoff.md` in project root.
- [ ] **Q4**: If a workflow run fails partway (non-recoverable error), should Phase 10.5 still generate a partial handoff document?
- [ ] **Q5**: Should the handoff document include the full git diff summary, or just a file-level change list?

## Acceptance Criteria

- [ ] **AC-01**: A new `handoff-writer` agent exists at `agents/handoff-writer.md` following the existing agent markdown pattern (YAML frontmatter, role statement, workflow steps, output template, quality gates)
- [ ] **AC-02**: The coordinator workflow includes Phase 10.5 (Handoff Generation) in the phase flow, triggered after Phase 10 (Documentation) completion
- [ ] **AC-03**: Phase 10.5 produces `11-handoff.md` in the spec directory AND `./{yymmdd}-handoff.md` in the project root, both with identical content following the user's 7-section template (Current Task Objective, Current Progress, Key Context, Key Findings, Unfinished Items, Suggested Handoff Path, Risks and Warnings)
- [ ] **AC-04**: The handoff document is written FOR the next AI agent (not user-facing), is specific and concrete, avoids filler, references specific file paths/module names/commands, and ends with a "First steps for the next Agent" section
- [ ] **AC-05**: The coordinator's delegate table, spawn patterns, termination rules, and quality gates include the handoff-writer agent for Phase 10.5
- [ ] **AC-06**: `skills/super-dev/SKILL.md` is updated: workflow phases checklist, teammate roles table, phase enforcement table, and team creation command all include Phase 10.5 and handoff-writer
- [ ] **AC-07**: `skills/dev-rules/SKILL.md` (Phase 0) is enhanced to find the most recent handoff file — first checking project root for `*-handoff.md`, then falling back to `specification/*/11-handoff.md`
- [ ] **AC-08**: Phase 0 handoff reading is backward compatible — gracefully handles specs without `11-handoff.md` and projects without any handoff files
- [ ] **AC-09**: The workflow tracking JSON schema includes Phase 10.5 in the phases array
- [ ] **AC-10**: Phase 10.5 is mandatory (never skipped) — every workflow run produces a handoff document
- [ ] **AC-11**: The handoff-writer is added to the team creation list in both `coordinator.md` and `SKILL.md`
- [ ] **AC-12**: Existing phases (0-13) continue to work without regression — no renumbering, no behavior changes
- [ ] **AC-13**: Both handoff files (`11-handoff.md` in spec dir AND `{yymmdd}-handoff.md` in project root) are included in the Phase 12 commit

## Recommendations

Based on the analysis, I recommend:

1. **Immediate (this spec)**: Implement **Option B** — New `handoff-writer` agent + Phase 10.5. This follows the project's established pattern (one agent per phase, sub-phase numbering for non-major additions), provides clean separation of concerns, and avoids the high blast radius of renumbering Phases 11-13.

2. **Next iteration**: Add machine-readable JSON summary section to the handoff document for potential future automation (handoff quality scoring, cross-spec knowledge aggregation).

3. **Future roadmap**: Consider a "handoff chain viewer" that aggregates handoff documents across specs to build a project-level knowledge timeline.

## Dependencies Map

```
Phase 10: docs-executor
    |
    | completes task list, impl summary, spec updates
    |
    v
Phase 10.5 (NEW): handoff-writer  <-- Consumes ALL spec artifacts
    |                                   + workflow tracking JSON
    | produces 11-handoff.md            + git diff summary
    | + {yymmdd}-handoff.md             + review results
    v
Phase 11: Team Cleanup (unchanged)
    |
    v
Phase 12: Commit & Merge (unchanged, but now includes 11-handoff.md in spec dir)
    |
    v
Phase 13: Final Verification (unchanged)


--- NEXT SESSION ---

Phase 0: dev-rules (ENHANCED)
    |
    | reads specification/[highest-index]-*/11-handoff.md
    | provides context from previous session
    |
    v
Phase 1: Setup (starts with prior context)
```

## Components Affected Summary

| Component | Change Type | Effort |
|-----------|-------------|--------|
| `agents/handoff-writer.md` | **New file** | Medium |
| `agents/coordinator.md` | Modify (~8 sections: phase flow, delegate table, spawn patterns, termination, quality gates, team creation, teammate roles, spawn table) | Medium |
| `skills/super-dev/SKILL.md` | Modify (~6 sections: phase checklist, teammate roles, enforcement table, team creation command, team roles table, spawn table) | Small-Medium |
| `skills/dev-rules/SKILL.md` | Modify (add previous handoff reading section) | Small |
| Workflow tracking JSON | Schema update (include Phase 10.5) | Small |
