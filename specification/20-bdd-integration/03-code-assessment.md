# Code Assessment: Super-Dev Plugin for BDD Integration

**Date:** 2026-03-15
**Scope:** `super-dev-plugin/` (agents, skills, rules, templates)
**Focus:** Architecture, patterns, integration points for BDD

## Executive Summary

1. All agents follow a strict markdown pattern: YAML frontmatter (`name`, `description`) + role statement + workflow steps + output template + quality gates
2. The coordinator defines phases 0-13 with explicit skip conditions, quality gates, and iteration rules
3. Phase 2.5 inserts cleanly between Phase 2 (requirements-clarifier) and Phase 3 (research) with no conflict
4. TDD workflow exists but has NO BDD layer — Gherkin scenarios are completely absent from the testing pipeline
5. Nine files need modification; one new agent file and one new template file need creation

---

## 1. Agent Pattern Analysis

### 1.1 Common Agent Markdown Structure

Every agent in `agents/` follows this exact pattern:

```markdown
---
name: [agent-name]                    # kebab-case identifier
description: [one-line description]   # used in Agent tool registry
---

[Role statement paragraph]            # "You are a [Role] Agent specialized in..."

## Core Principles / Capabilities     # numbered list of 3-8 items

## Required Inputs                    # what the agent consumes
- `input_name`: description

## [Workflow / Process]               # numbered steps (3-8 steps)
### Step 1 — [Name]
### Step 2 — [Name]
...

## Output Template                    # markdown template in fenced block
```markdown
# [Document Title]: [Feature/Fix Name]
**Date:** [timestamp]
**Reviewer/Author:** super-dev:[agent-name]
...
```

## Quality Gates / Standards          # checklist at bottom
- [ ] Gate 1
- [ ] Gate 2
```

### 1.2 Agent-Specific Patterns

| Agent | Frontmatter Fields | Key Sections | Output File Pattern |
|-------|-------------------|--------------|---------------------|
| `requirements-clarifier` | `name`, `description` | Philosophy, Methodologies, Question Templates, Output Format | `01-requirements.md` |
| `qa-agent` | `name`, `description` | Core Capabilities, Execution Responsibilities, Test Plan Structure, Quality Gates | Test reports, JUnit XML |
| `code-reviewer` | `name`, `description` | Required Inputs, Review Workflow (7 steps), Output Template, Severity Reference | `[spec]-code-review.md` |
| `adversarial-reviewer` | `name`, `description` | Required Inputs, Review Workflow (4 steps), Destructive Action Gate, Output Template | `[spec]-adversarial-review-report.md` |
| `coordinator` | `name`, `description` | Phase Flow, Iteration Rule, Skip Conditions, Quality Gates, Teammate Termination | `[spec]-workflow-tracking.json` |
| `spec-writer` | `name`, `description` | Input Context, Specification Process, Output Documents (3 docs), Quality Standards | `06-specification.md`, `07-implementation-plan.md`, `08-task-list.md` |
| `dev-executor` | `name`, `description` | Execution Rules, Specialist Agent Mapping, Build Queue, Error Handling | Task completion reports |

### 1.3 Pattern for New `bdd-scenario-writer` Agent

The new agent MUST follow this exact structure:

```markdown
---
name: bdd-scenario-writer
description: [one-line description of BDD role]
---

[Role statement]

## Core Principles
[3-5 numbered items]

## Required Inputs
- `requirements`: Path to 01-requirements.md
- `worktree_path`: Current worktree path
- `spec_directory`: Specification directory path

## Scenario Writing Workflow
### Step 1 — [Parse Requirements]
### Step 2 — [Write Gherkin Scenarios]
### Step 3 — [Validate Coverage]

## Output Template
[Fenced markdown template for 01.1-behavior-scenarios.md]

## Quality Gates
[Checklist]
```

---

## 2. Coordinator Workflow Analysis

### 2.1 Current Phase Flow

Source: `agents/coordinator.md:93-114`

```
Phase 0:   Apply Dev Rules           → Skill
Phase 1:   Specification Setup       → Team Lead (worktree + team)
Phase 2:   Requirements Clarification → requirements-clarifier
                                                                    ← Phase 2.5 INSERTS HERE
Phase 3:   Research                  → research-agent
Phase 4:   Debug Analysis (bugs)     → debug-analyzer
Phase 5:   Code Assessment           → code-assessor
Phase 5.3: Architecture (complex)    → architecture-agent
Phase 5.4: Product Design (arch+UI)  → product-designer
Phase 5.5: UI/UX (with UI)          → ui-ux-designer
Phase 6:   Specification Writing     → spec-writer
Phase 7:   Specification Review      → Team Lead validates
Phase 8:   Execution & QA (PARALLEL) → dev-executor + qa-agent
Phase 9:   Review (PARALLEL)         → code-reviewer + adversarial-reviewer
Phase 10:  Documentation Update      → docs-executor
Phase 11:  Team Cleanup              → Final verification
Phase 11.5: Manual Confirmation      → User review
Phase 12:  Commit & Merge to Main    → Team Lead git ops
Phase 13:  Final Verification        → Worktree preserved
```

### 2.2 How Phases Are Enforced

**Phase transitions** are gated by quality gates at `coordinator.md:304-316`:

| Transition | Gate Condition |
|------------|---------------|
| → Phase 2 | specDirectory defined, worktree created, workflow JSON exists, agent team created |
| → Phase 3 | `01-requirements.md` exists |
| → Phase 5 | `02-research-report.md` exists |
| → Phase 6 | `04-assessment.md` exists (+ design docs) |
| → Phase 8 | All spec documents reviewed |
| → Phase 10 | Code review Approved AND adversarial PASS |
| → Phase 12 | All changes committed and merged |

**New gate needed for Phase 2.5 → Phase 3:**
- `01-requirements.md` exists (already required)
- `01.1-behavior-scenarios.md` exists (NEW — must add)

### 2.3 How Coordinator Spawns Agents

Source: `coordinator.md:73-87` and `SKILL.md:318-337`

The coordinator uses Task tool with `subagent_type`:
```
Task(subagent_type: "super-dev:[agent-name]", prompt: "...")
```

Phase mapping table at `coordinator.md:198-212`:
```
| Phase | Spawn These Teammates |
| 2     | requirements-clarifier |
| 3     | research-agent |
| ...   | ...                    |
```

**For Phase 2.5, add:**
```
| 2.5   | bdd-scenario-writer |
```

### 2.4 Iteration Rule (Phase 8/9 Loop)

Source: `coordinator.md:128-141`

Loop until: `Critical=0, High=0, Medium=0, AcceptanceCriteriaMet, CodeReviewVerdict=Approved, AdversarialVerdict=PASS`

**BDD impact:** Add scenario coverage to the loop exit criteria. Phase 9 must verify all BDD scenarios have corresponding test implementations.

### 2.5 Skip Conditions

Source: `coordinator.md:143-151`

Current skip conditions:
- Phase 4: Not a bug fix
- Phase 5.3: No architecture work
- Phase 5.4: Not both architecture AND UI
- Phase 5.5: No UI components
- Phase 9: Never skip

**BDD decision:** Phase 2.5 is MANDATORY for all features (per user decision). Add to skip conditions table:
```
| Phase 2.5 | Never skip — BDD scenarios are mandatory for all features |
```

---

## 3. SKILL.md Analysis

### 3.1 Workflow Phase Checklist

Source: `skills/super-dev/SKILL.md:126-143`

```
- [ ] Phase 0:  Apply Dev Rules
- [ ] Phase 1:  Specification Setup
- [ ] Phase 2:  Requirements Clarification
- [ ] Phase 3:  Research
...
```

**Change needed:** Insert `Phase 2.5: BDD Scenario Writing` after Phase 2.

### 3.2 Phase Enforcement Table

Source: `skills/super-dev/SKILL.md:318-337`

```
| Phase | Team Lead Action | Agent to Spawn |
| 2     | Use Task tool → requirements-clarifier | requirements-clarifier |
| 3     | Use Task tool → research-agent | research-agent |
```

**Change needed:** Insert row for Phase 2.5:
```
| 2.5   | Use Task tool → super-dev:bdd-scenario-writer | bdd-scenario-writer |
```

### 3.3 Team Roles Table

Source: `skills/super-dev/SKILL.md:588-603`

**Change needed:** Add new row:
```
| **Planning** | bdd-scenario-writer | Write Gherkin BDD scenarios from requirements | `super-dev:bdd-scenario-writer` |
```

### 3.4 Team Creation Command

Source: `skills/super-dev/SKILL.md:569-584`

**Change needed:** Add `super-dev:bdd-scenario-writer` to the team member list.

---

## 4. TDD Workflow Analysis

### 4.1 Current TDD Workflow

Source: `skills/tdd-workflow/SKILL.md:1-410`

The TDD workflow follows Red-Green-Refactor:
1. Write User Journeys (informal format: `As a [role], I want to [action], so that [benefit]`)
2. Generate Test Cases (code-level `describe`/`it` blocks)
3. Run Tests (expect FAIL)
4. Implement Code
5. Run Tests (expect PASS)
6. Refactor
7. Verify Coverage (80%+)

### 4.2 Gap: No BDD Layer

The TDD workflow has **no Gherkin layer**. User journeys in Step 1 are informal user stories, NOT structured Given/When/Then scenarios. Test cases in Step 2 jump directly to code-level test functions.

**Where BDD augments TDD:**

```
CURRENT:
  User Story → Test Code → Implementation → Refactor

WITH BDD:
  User Story → Gherkin Scenarios → Test Code → Implementation → Refactor
       ↑               ↑                ↑
  Phase 2          Phase 2.5        Phase 8
  (requirements)   (BDD scenarios)  (qa-agent uses scenarios)
```

BDD adds a **specification layer** between requirements and test code. The Gherkin scenarios become:
- A living specification document (`01.1-behavior-scenarios.md`)
- Input for test case generation (qa-agent consumes them)
- Coverage verification target (Phase 9 gate)

### 4.3 Testing Rules

Source: `rules/testing.md:1-31`

Current rules:
- Minimum 80% coverage
- TDD mandatory (Red-Green-Refactor)
- Three test types: Unit, Integration, E2E
- Agent support: tdd-guide, e2e-runner

**Change needed:** Add BDD rules section:
```markdown
## BDD (Behavior-Driven Development)

MANDATORY for all features:
1. Gherkin scenarios written BEFORE implementation (Phase 2.5)
2. All scenarios in `01.1-behavior-scenarios.md`
3. Format: Feature → Scenario → Given/When/Then
4. No Scenario Outlines in v1
5. Every scenario must have corresponding test implementation
6. Phase 9 gate: scenario coverage verification
```

---

## 5. Templates Analysis

### 5.1 Existing Templates

Source: `templates/reference/` directory

| Template | Purpose |
|----------|---------|
| `specification-templates.md` | Tech spec, implementation plan, task list templates |
| `testing-patterns.md` | CLI/Desktop/Web testing patterns |
| `architecture-patterns.md` | Architecture reference |
| `coding-standards.md` | Coding conventions |
| `frontend-patterns.md` | Frontend patterns |
| `backend-patterns.md` | Backend patterns |
| `research-methodology.md` | Research process |
| `debugging-patterns.md` | Debug patterns |
| `ui-ux-patterns.md` | UI/UX patterns |

### 5.2 BDD Template Needed

No BDD/Gherkin template exists. A new `templates/reference/bdd-patterns.md` is recommended to provide:
- Gherkin syntax reference
- Scenario writing best practices
- Coverage mapping patterns
- Examples of well-written scenarios

---

## 6. Integration Blueprint

### 6.1 Files to Create (2 files)

| File | Purpose |
|------|---------|
| `agents/bdd-scenario-writer.md` | New BDD agent definition |
| `templates/reference/bdd-patterns.md` | BDD reference template |

### 6.2 Files to Modify (7 files)

#### File 1: `agents/coordinator.md`

| Section | Line Range | Change |
|---------|-----------|--------|
| Phase Flow | Lines 93-114 | Insert `Phase 2.5: BDD Scenario Writing → Spawn bdd-scenario-writer teammate` after Phase 2 |
| Delegate Mode Table | Lines 73-87 | Add row: `2.5 \| Writing BDD scenarios \| Spawn bdd-scenario-writer` |
| Quality Gates | Lines 304-316 | Add gate: `→ Phase 3 \| 01-requirements.md exists AND 01.1-behavior-scenarios.md exists` |
| Skip Conditions | Lines 143-151 | Add row: `Phase 2.5 \| Never skip — BDD is mandatory for all features` |
| Spawn Table | Lines 198-212 | Add row: `2.5 \| bdd-scenario-writer` |
| Termination Table | Lines 286-299 | Add row: `2.5 \| bdd-scenario-writer \| 01.1-behavior-scenarios.md complete` |
| Team Definition | Lines 158-176 | Add `super-dev:bdd-scenario-writer` to team member list |
| Phase 9 section | Lines 128-141 | Add scenario coverage to iteration exit criteria |
| Teammate Roles Table | Lines 178-196 | Add row: `Planning \| bdd-scenario-writer \| Write Gherkin scenarios from requirements` |
| Final Verification | Lines 347-354 | Add `01.1-behavior-scenarios.md` to documents checklist |

#### File 2: `skills/super-dev/SKILL.md`

| Section | Line Range | Change |
|---------|-----------|--------|
| Workflow Phase Checklist | Lines 126-143 | Insert `- [ ] Phase 2.5: BDD Scenario Writing` after Phase 2 |
| Phase Enforcement Table | Lines 318-337 | Insert row for Phase 2.5 |
| Teammate Roles Table | Lines 588-603 | Add bdd-scenario-writer row |
| Team Creation Command | Lines 569-584 | Add `super-dev:bdd-scenario-writer` |
| When to Spawn Table | Lines 631-645 | Add `2.5 \| bdd-scenario-writer` |
| Phase 9 Description | Lines 467-518 | Add scenario coverage gate to combined pass criteria |
| Success Criteria | Lines 101-121 | Add BDD scenario coverage to Outcome section |

#### File 3: `agents/qa-agent.md`

| Section | Line Range | Change |
|---------|-----------|--------|
| Core Principles | Lines 23-29 | Add: "BDD-aligned: derive test cases from Gherkin scenarios in `01.1-behavior-scenarios.md`" |
| Execution Responsibilities | Lines 33-37 | Add: "Parse BDD scenarios and map to test cases" |
| Test Plan Structure | Lines 46-93 | Add: "BDD Scenario Mapping" section showing scenario → test case traceability |
| Quality Gates | Lines 825-841 | Add: "All BDD scenarios have corresponding test implementations" |

#### File 4: `agents/code-reviewer.md`

| Section | Line Range | Change |
|---------|-----------|--------|
| Review Workflow Step 6 | Lines 196-207 | Add scenario coverage validation: verify every BDD scenario in `01.1-behavior-scenarios.md` has a corresponding test |
| Output Template | Lines 236-325 | Add "BDD Scenario Coverage" section to report template |
| Verdict Logic | Lines 227-233 | Add: scenario coverage gap → "Changes Requested" |

#### File 5: `agents/adversarial-reviewer.md`

| Section | Line Range | Change |
|---------|-----------|--------|
| Skeptic Lens | Lines 45-61 | Add V8 sub-check: "BDD Scenario Gaps — Are all user-facing behaviors covered by Gherkin scenarios? Are there code paths with no scenario?" |
| Vector Coverage Table | Lines 238-248 | Add V8 row |

#### File 6: `rules/testing.md`

| Section | Line Range | Change |
|---------|-----------|--------|
| After line 31 | End of file | Add `## BDD (Behavior-Driven Development)` section with mandatory rules |

#### File 7: `agents/spec-writer.md`

| Section | Line Range | Change |
|---------|-----------|--------|
| Input Context | Lines 17-25 | Add: `bdd_scenarios`: BDD scenarios from bdd-scenario-writer (required for features) |
| Specification Template Section 5 | Lines 247-267 | Add "BDD Scenario References" subsection linking scenarios to test strategy |
| Quality Standards | Lines 542-578 | Add: "BDD scenarios cross-referenced in testing strategy" |

### 6.3 Summary of Changes

| Category | Count | Files |
|----------|-------|-------|
| **New Files** | 2 | `agents/bdd-scenario-writer.md`, `templates/reference/bdd-patterns.md` |
| **Modified Files** | 7 | `coordinator.md`, `SKILL.md`, `qa-agent.md`, `code-reviewer.md`, `adversarial-reviewer.md`, `testing.md`, `spec-writer.md` |
| **Total** | 9 | |

---

## 7. Risks and Conflicts

### 7.1 No Conflicts Detected

- Phase numbering uses `2.5` which follows the existing `5.3/5.4/5.5` sub-phase pattern
- The output file `01.1-behavior-scenarios.md` follows the existing numbering pattern (between `01-requirements.md` and `02-research-report.md`)
- No existing agent consumes Gherkin scenarios, so no breaking changes

### 7.2 Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Phase 2.5 adds latency to every workflow | Medium | Low | BDD agent should be fast (consume requirements, output scenarios) — no external research needed |
| Scenario quality depends on requirements quality | Medium | Medium | bdd-scenario-writer validates requirements completeness as part of its workflow |
| Phase 9 scenario gate may cause false rejections | Low | Medium | Gate should check scenario-to-test mapping, not scenario quality |
| Coordinator phase numbering gets complex | Low | Low | 2.5 follows existing 5.3/5.4/5.5 pattern |

### 7.3 Dependency Chain

```
Phase 2 (requirements-clarifier)
    │
    ▼ produces: 01-requirements.md
Phase 2.5 (bdd-scenario-writer)         ← NEW
    │
    ▼ produces: 01.1-behavior-scenarios.md
Phase 3 (research-agent)
    │
    ...
Phase 6 (spec-writer)                   ← consumes 01.1-behavior-scenarios.md
    │
Phase 8 (qa-agent)                      ← maps scenarios to test cases
    │
Phase 9 (code-reviewer + adversarial)   ← verifies scenario coverage
```

---

## 8. Files Examined

| File | Purpose | Lines |
|------|---------|-------|
| `agents/requirements-clarifier.md` | Phase 2 agent — BDD consumes its output | 428 |
| `agents/qa-agent.md` | Phase 8 agent — needs to consume BDD scenarios | 856 |
| `agents/code-reviewer.md` | Phase 9 agent — needs scenario coverage gate | 349 |
| `agents/adversarial-reviewer.md` | Phase 9 agent — parallel reviewer | 270 |
| `agents/coordinator.md` | Orchestrator — needs Phase 2.5 added | 528 |
| `agents/spec-writer.md` | Phase 6 agent — needs BDD reference | 739 |
| `agents/dev-executor.md` | Phase 8 agent — no changes needed | 262 |
| `skills/super-dev/SKILL.md` | Workflow phases and enforcement | 662 |
| `skills/tdd-workflow/SKILL.md` | TDD workflow — BDD augments this | 410 |
| `rules/testing.md` | Testing rules — needs BDD section | 31 |
| `rules/agents.md` | Agent orchestration rules | 76 |
| `templates/reference/specification-templates.md` | Spec templates | 545 |
| `templates/reference/testing-patterns.md` | Testing patterns | 929 |
| `.claude-plugin/plugin.json` | Plugin metadata | 23 |

**Coverage:** 14/78 files examined (18% of total plugin files). All files in the BDD integration scope were read. Excluded files are unrelated agents (android-developer, ios-developer, etc.), scripts, and domain-specific templates.
