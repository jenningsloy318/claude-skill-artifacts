# Architecture Design: BDD Integration into Super-Dev Workflow

**Date:** 2026-03-15
**Author:** super-dev:architecture-agent
**Status:** Draft
**Inputs:**
- Requirements: `./01-requirements.md`
- Research: `./02-research-report.md`
- Code Assessment: `./03-code-assessment.md`

---

## 1. Architecture Overview

### 1.1 High-Level Flow

```
Phase 2                Phase 2.5 (NEW)           Phase 6             Phase 8              Phase 9
requirements-          bdd-scenario-             spec-writer          qa-agent             code-reviewer +
clarifier              writer                                                             adversarial-reviewer
    |                      |                        |                    |                      |
    v                      v                        v                    v                      v
01-requirements.md --> 01.1-behavior-       06-specification.md   Tests reference      Scenario Coverage
  (acceptance            scenarios.md          (references            SCENARIO-IDs        Hard Gate
   criteria)           (Given/When/Then        scenarios in         in test names/       (deterministic
                        + traceability          testing              comments             pass/fail)
                        matrix)                 strategy)
```

### 1.2 Phase Flow (Modified)

```
Phase 0:   Apply Dev Rules           --> Skill
Phase 1:   Specification Setup       --> Team Lead (worktree + team)
Phase 2:   Requirements Clarification --> requirements-clarifier
Phase 2.5: BDD Scenario Writing      --> bdd-scenario-writer (NEW, MANDATORY)
Phase 3:   Research                  --> research-agent
Phase 4:   Debug Analysis (bugs)     --> debug-analyzer
Phase 5:   Code Assessment           --> code-assessor
Phase 5.3: Architecture (complex)    --> architecture-agent
Phase 5.4: Product Design (arch+UI)  --> product-designer
Phase 5.5: UI/UX (with UI)          --> ui-ux-designer
Phase 6:   Specification Writing     --> spec-writer
Phase 7:   Specification Review      --> Team Lead validates
Phase 8:   Execution & QA (PARALLEL) --> dev-executor + qa-agent
Phase 9:   Review (PARALLEL)         --> code-reviewer + adversarial-reviewer
Phase 10:  Documentation Update      --> docs-executor
Phase 11:  Team Cleanup              --> Final verification
Phase 11.5: Manual Confirmation      --> User review
Phase 12:  Commit & Merge to Main    --> Team Lead git ops
Phase 13:  Final Verification        --> Worktree preserved
```

### 1.3 Data Flow Diagram

```
                    01-requirements.md
                    (Acceptance Criteria)
                           |
                           | Phase 2.5: bdd-scenario-writer reads AC
                           v
              01.1-behavior-scenarios.md
              +----------------------------+
              | Feature: [Name]            |
              |                            |
              | SCENARIO-001: [Title]      |
              |   AC: AC-01                |
              |   Given [precondition]     |
              |   When [action]            |
              |   Then [outcome]           |
              |                            |
              | SCENARIO-002: [Title]      |
              |   ...                      |
              |                            |
              | Traceability Matrix:       |
              |   AC-01 -> SCENARIO-001    |
              |   AC-02 -> SCENARIO-002,003|
              +----------------------------+
                    |              |
         +----------+              +----------+
         |                                    |
         v                                    v
   Phase 6: spec-writer               Phase 8: qa-agent
   (references scenarios               (maps SCENARIO-IDs
    in testing strategy)                to test cases)
                                              |
                                              v
                                    Test files with SCENARIO-ID
                                    references in names/comments
                                    (e.g., // SCENARIO-001)
                                              |
                                              v
                                    Scenario Coverage Report
                                    (SCENARIO-ID -> test -> pass/fail)
                                              |
                                              v
                               Phase 9: code-reviewer + adversarial-reviewer
                               +---------------------------------------+
                               | code-reviewer:                        |
                               |   Check scenario coverage section     |
                               |   Gap -> "Changes Requested"          |
                               |                                       |
                               | adversarial-reviewer:                 |
                               |   V8: Behavior Gap Detection          |
                               |   Missing scenarios -> finding        |
                               +---------------------------------------+
                                              |
                                              v
                               Combined Pass Criteria:
                               - Code Review: Approved
                               - Adversarial: PASS
                               - Scenario Coverage: 100%
                               (all three must pass)
```

---

## 2. Architectural Decisions Requiring User Selection

### Decision 1: QA Agent Scenario Consumption Model

**Context:** The qa-agent in Phase 8 needs to read `01.1-behavior-scenarios.md` and map BDD scenarios to test implementations. How should this consumption work?

#### Option A: Inline Reference Model

**Description:** The qa-agent reads the scenario document as context and references SCENARIO-IDs in test names/comments. Test-to-scenario mapping is by naming convention only.

**How it works:**
- qa-agent reads `01.1-behavior-scenarios.md` at test plan time
- Tests reference scenarios via naming: `describe('SCENARIO-001: Successful Login', ...)`
- Coverage check: grep for SCENARIO-XXX in test files

**Strengths:**
- Simplest implementation - no new data structures
- Follows existing qa-agent patterns (reads specs, writes tests)
- Low cognitive overhead for the agent

**Weaknesses:**
- Grep-based coverage check could miss references or produce false positives
- No structured coverage report format
- Relies on naming discipline

**Complexity:** Low
**Risk:** Low

#### Option B: Structured Scenario-Test Mapping with Coverage Report

**Description:** The qa-agent parses scenarios into a structured list, generates tests mapped to each scenario, and produces a dedicated "Scenario Coverage Report" section in its QA output.

**How it works:**
- qa-agent parses `01.1-behavior-scenarios.md` to extract: `{id, title, acRef, priority}`
- For each scenario, generates or maps at least one test
- Tests reference scenarios: `// SCENARIO-001` or `describe('SCENARIO-001: ...')`
- Produces a Scenario Coverage Report:
  ```markdown
  ## Scenario Coverage Report
  | Scenario ID | Title | AC Ref | Test File | Test Name | Status |
  |-------------|-------|--------|-----------|-----------|--------|
  | SCENARIO-001 | Successful Login | AC-01 | auth.test.ts | testSuccessfulLogin | PASS |
  | SCENARIO-002 | Failed Login | AC-02 | auth.test.ts | testFailedLogin | PASS |

  Coverage: 5/5 scenarios covered (100%)
  Uncovered: None
  ```

**Strengths:**
- Deterministic coverage verification (structured table, not grep)
- Phase 9 reviewers have a clear, parseable coverage report
- Traceability chain is complete: AC -> Scenario -> Test -> Result
- Report format is explicit - no ambiguity about what's covered

**Weaknesses:**
- More complex qa-agent changes
- Requires qa-agent to parse scenario document structure
- Slightly more agent prompt complexity

**Complexity:** Medium
**Risk:** Low

#### Option C: Dual-Output Model (Coverage Report + Living Documentation)

**Description:** Same as Option B, plus the qa-agent produces a standalone "Behavior Verification Report" file (`[spec]-behavior-verification.md`) that serves as living documentation.

**How it works:**
- Everything from Option B
- Additionally produces a separate file: `[spec-index]-[spec-name]-behavior-verification.md`
- This file shows each scenario with pass/fail status, forming a living behavior specification
- File persists alongside spec artifacts for ongoing reference

**Strengths:**
- Creates living documentation (FR-5 from requirements)
- Separate file can be consumed by docs-executor in Phase 10
- Full auditability of behavior verification

**Weaknesses:**
- Additional file to maintain
- More complex qa-agent output
- May be over-engineering for v1

**Complexity:** Medium-High
**Risk:** Low

### Comparison Matrix: Scenario Consumption

| Criteria | Weight | Option A (Inline) | Option B (Structured) | Option C (Dual-Output) |
|----------|--------|-------------------|----------------------|----------------------|
| Modularity | 0.10 | 3 | 4 | 5 |
| Coupling/Cohesion | 0.10 | 4 | 4 | 3 |
| Scalability | 0.10 | 2 | 4 | 5 |
| Performance | 0.10 | 5 | 4 | 3 |
| Security | 0.10 | 3 | 3 | 3 |
| Implementation Complexity | 0.08 | 5 | 4 | 3 |
| Risk | 0.08 | 4 | 4 | 3 |
| Time-to-Value | 0.07 | 5 | 4 | 3 |
| Maintainability | 0.04 | 3 | 4 | 3 |
| Testability | 0.03 | 3 | 5 | 5 |
| Observability | 0.05 | 2 | 5 | 5 |
| Reliability | 0.05 | 3 | 4 | 4 |
| Cost | 0.05 | 5 | 4 | 3 |
| Supportability | 0.03 | 3 | 4 | 4 |
| Reversibility | 0.02 | 5 | 4 | 3 |
| **Weighted Total** | | **3.54** | **4.02** | **3.62** |

**Recommendation:** Option B - Structured Scenario-Test Mapping with Coverage Report

**Rationale:** Option B provides the right balance: a deterministic, structured coverage report that Phase 9 reviewers can parse unambiguously, without the overhead of maintaining a separate living documentation file. The structured table makes the Phase 9 hard gate trivially verifiable (count covered vs. total). Option C's living documentation is a v2 enhancement.

**Please Select:** Option A, B, or C

---

### Decision 2: Phase 9 Hard Gate Threshold

**Context:** Phase 9 includes a hard gate on BDD scenario coverage. What threshold should block progress?

#### Option A: 100% Coverage (All Scenarios Must Have Passing Tests)

**Description:** Every scenario in `01.1-behavior-scenarios.md` must have at least one corresponding test that passes. Zero tolerance for gaps.

**Gate logic:**
```
IF uncovered_scenarios > 0:
  code-reviewer verdict = "Changes Requested"
  adversarial-reviewer adds V8 finding (High severity)
```

**Strengths:**
- Maximum confidence - every stated behavior is verified
- No ambiguity about what "covered" means
- Aligns with the core value proposition (deterministic verification)

**Weaknesses:**
- No flexibility for scenarios that can't be tested (e.g., infrastructure constraints)
- Could block progress on edge cases that are hard to automate

**Best For:** Projects where all scenarios are genuinely testable

#### Option B: 100% Coverage with Explicit Exemption Mechanism

**Description:** 100% coverage is required, BUT the bdd-scenario-writer can mark specific scenarios as `[NOT-AUTOMATABLE]` with a documented reason. These exempted scenarios are excluded from the coverage gate but still tracked.

**Gate logic:**
```
total_scenarios = all scenarios
automatable_scenarios = total - NOT_AUTOMATABLE count
IF uncovered_automatable_scenarios > 0:
  code-reviewer verdict = "Changes Requested"
  adversarial-reviewer adds V8 finding (High severity)
IF NOT_AUTOMATABLE count > 0:
  adversarial-reviewer adds V8 finding (Medium severity, informational)
```

**Scenario document addition:**
```markdown
### SCENARIO-005: System Handles Peak Load
**Acceptance Criteria:** AC-05
**Priority:** P2
**Automation Status:** [NOT-AUTOMATABLE: Requires load testing infrastructure not available in CI]

**Given** the system is under peak load (1000 concurrent users)
**When** a new user attempts to log in
**Then** the login completes within 3 seconds
```

**Strengths:**
- 100% coverage for automatable scenarios (no gaps)
- Explicit exemption mechanism with documented reasons
- Adversarial reviewer still flags exemptions (transparency)
- Handles real-world constraints gracefully

**Weaknesses:**
- Exemption mechanism could be abused (mitigated by adversarial review flagging)
- Slightly more complex gate logic

**Best For:** Real-world projects with mixed scenario types

#### Option C: Configurable Threshold (Default 100%, Override Per-Feature)

**Description:** Default threshold is 100%, but the coordinator can override to a lower percentage per feature. Threshold is stored in workflow tracking JSON.

**Gate logic:**
```
coverage_threshold = workflow_json.bddCoverageThreshold || 1.0
actual_coverage = covered_scenarios / total_scenarios
IF actual_coverage < coverage_threshold:
  block progress
```

**Strengths:**
- Maximum flexibility
- Can adapt to different project types

**Weaknesses:**
- Flexibility undermines the core value proposition (deterministic verification)
- Configuration adds complexity to workflow JSON and coordinator
- Lower thresholds defeat the purpose of BDD integration

**Best For:** Large organizations with varying BDD maturity

### Comparison Matrix: Gate Threshold

| Criteria | Weight | Option A (100%) | Option B (100% + Exemption) | Option C (Configurable) |
|----------|--------|-----------------|---------------------------|----------------------|
| Modularity | 0.10 | 4 | 4 | 3 |
| Coupling/Cohesion | 0.10 | 5 | 4 | 3 |
| Scalability | 0.10 | 3 | 4 | 5 |
| Performance | 0.10 | 5 | 5 | 4 |
| Security | 0.10 | 5 | 5 | 3 |
| Implementation Complexity | 0.08 | 5 | 4 | 3 |
| Risk | 0.08 | 3 | 4 | 3 |
| Time-to-Value | 0.07 | 5 | 4 | 3 |
| Maintainability | 0.04 | 5 | 4 | 3 |
| Testability | 0.03 | 5 | 4 | 3 |
| Observability | 0.05 | 4 | 5 | 4 |
| Reliability | 0.05 | 5 | 5 | 3 |
| Cost | 0.05 | 5 | 4 | 3 |
| Supportability | 0.03 | 4 | 4 | 3 |
| Reversibility | 0.02 | 4 | 4 | 4 |
| **Weighted Total** | | **4.42** | **4.32** | **3.36** |

**Recommendation:** Option A - 100% Coverage (All Scenarios Must Have Passing Tests)

**Rationale:** The user explicitly requested a "hard gate" and the core value proposition is *deterministic* verification. Adding exemption mechanisms (Option B) or configurable thresholds (Option C) dilutes this value. If a scenario truly can't be automated, the bdd-scenario-writer should not generate it in the first place - non-functional requirements that can't be expressed as Given/When/Then should be noted as constraints, not scenarios (per research report Guideline 5). The BDD agent is already instructed to flag ambiguous/non-testable criteria rather than forcing them into scenarios.

**Please Select:** Option A, B, or C

---

### Decision 3: Adversarial Reviewer V8 Vector Scope

**Context:** The adversarial reviewer needs behavior gap detection. How should V8 be integrated?

#### Option A: V8 Under Skeptic Lens Only

**Description:** Add V8 as a new attack vector under the Skeptic lens (which already owns V1-V6). V8 checks for behavior gaps: code paths without scenarios, and scenarios without tests.

**V8 checks:**
- Are all user-facing behaviors in the implementation covered by at least one BDD scenario?
- Are there code paths with business logic that have no corresponding scenario?
- Does the scenario coverage report show 100% coverage?

**Strengths:**
- Simplest integration - V8 joins V1-V6 under Skeptic
- Follows existing vector assignment pattern
- Single lens responsibility

**Weaknesses:**
- Skeptic lens already has 6 vectors, adding a 7th increases load
- Behavior gap detection is arguably architectural (scope vs. correctness)

#### Option B: V8 Shared Between Skeptic and Architect Lenses

**Description:** V8 is assigned to both Skeptic (primary: are scenarios tested?) and Architect (secondary: are scenarios complete relative to the architecture?).

**Skeptic V8 checks:**
- Does every scenario in `01.1-behavior-scenarios.md` have a corresponding passing test?
- Are scenario coverage report results consistent with test execution results?

**Architect V8 checks:**
- Are there architectural components with user-facing behavior but no corresponding scenarios?
- Do the scenarios cover the key architectural boundaries (API endpoints, service interfaces)?

**Strengths:**
- Dual-lens coverage catches both test gaps AND specification gaps
- Architect lens naturally fits "completeness of specification" concern
- Follows existing pattern of shared vectors (V1, V3, V5, V7 already have dual assignments)

**Weaknesses:**
- More complex to implement (V8 in two lens sections)
- Potential for conflicting findings between lenses

#### Option C: V8 Under Skeptic Only + Separate D9 Document-Level Check

**Description:** V8 under Skeptic checks test-to-scenario coverage. Additionally, add a new document-level pre-check (D9) that validates the scenario document itself before the lens reviews begin.

**D9 (document check):**
- Does `01.1-behavior-scenarios.md` exist?
- Does it have a traceability matrix?
- Are all ACs from `01-requirements.md` represented in the matrix?

**V8 (Skeptic):**
- Does the scenario coverage report show 100% coverage?
- Are scenario-to-test references valid?

**Strengths:**
- Separates document validation from implementation review
- D9 catches missing scenario document early

**Weaknesses:**
- D9 is a new concept not in the existing adversarial-reviewer pattern
- Over-engineering for what V8 alone can handle

### Comparison Matrix: V8 Scope

| Criteria | Weight | Option A (Skeptic) | Option B (Skeptic+Architect) | Option C (Skeptic+D9) |
|----------|--------|-------------------|---------------------------|---------------------|
| Modularity | 0.10 | 4 | 4 | 3 |
| Coupling/Cohesion | 0.10 | 5 | 4 | 3 |
| Scalability | 0.10 | 3 | 4 | 4 |
| Performance | 0.10 | 5 | 4 | 4 |
| Security | 0.10 | 3 | 4 | 3 |
| Implementation Complexity | 0.08 | 5 | 4 | 3 |
| Risk | 0.08 | 4 | 3 | 3 |
| Time-to-Value | 0.07 | 5 | 4 | 3 |
| Maintainability | 0.04 | 4 | 4 | 3 |
| Testability | 0.03 | 4 | 4 | 4 |
| Observability | 0.05 | 3 | 5 | 4 |
| Reliability | 0.05 | 4 | 5 | 4 |
| Cost | 0.05 | 5 | 4 | 3 |
| Supportability | 0.03 | 4 | 4 | 3 |
| Reversibility | 0.02 | 5 | 4 | 3 |
| **Weighted Total** | | **4.18** | **4.06** | **3.36** |

**Recommendation:** Option A - V8 Under Skeptic Lens Only

**Rationale:** Keeping V8 under Skeptic follows the simplest path and avoids adding complexity to the Architect lens. The Skeptic lens is the natural home for "is this behavior verified?" checks, which is fundamentally a correctness concern. The Architect lens can naturally observe behavioral completeness through its existing V1 (False Assumptions) without a formal V8 assignment. Adding V8 to a second lens creates coordination overhead with minimal additional value.

**Please Select:** Option A, B, or C

---

## 3. Component Design

### 3.1 New Agent: `bdd-scenario-writer`

**File:** `agents/bdd-scenario-writer.md`

**Pattern:** Follows existing agent markdown structure (YAML frontmatter + role + workflow + output template + quality gates)

```markdown
---
name: bdd-scenario-writer
description: Write BDD behavior scenarios in Gherkin-like markdown from requirements acceptance criteria. Produces traceable Given/When/Then scenarios mapped to acceptance criteria with quality validation.
---

[Role Statement]
You are a BDD Scenario Writer Agent specialized in transforming acceptance criteria
into structured behavior specifications using Given/When/Then format.

## Core Principles
1. Declarative style: describe WHAT behavior is expected, not HOW (no UI interactions)
2. One behavior per scenario: each scenario tests exactly one distinct behavior
3. Business language: use domain terminology, no technical jargon
4. Traceability: every scenario maps to at least one acceptance criterion
5. Scenario cadence: 3-5 scenarios per feature area (diminishing returns beyond 5)

## Required Inputs
- `requirements`: Path to 01-requirements.md (REQUIRED)
- `spec_directory`: Specification directory path
- `feature_name`: Name of the feature

## Scenario Writing Workflow

### Step 1 -- Parse Requirements
- Read ALL acceptance criteria from 01-requirements.md
- Extract AC-IDs and their descriptions
- Cross-reference "Job to Be Done" and "Stakeholders" sections
- Flag ambiguous criteria as [AMBIGUOUS: needs clarification]
- Note non-functional criteria as constraints (not scenarios)

### Step 2 -- Generate Scenarios (Chain-of-Thought)
For each acceptance criterion:
1. Write the golden scenario (happy path - core promise)
2. Write the primary alternative (most likely variation)
3. Write the primary failure (most likely error case)
4. Stop. Only add more if a distinct business behavior remains uncovered.

Reasoning process for each scenario:
- What is the precondition? (Given)
- What single action triggers the behavior? (When)
- What verifiable outcome results? (Then)

### Step 3 -- Validate Quality
Self-validate every scenario against Q1-Q10 checklist.
Self-validate the document against D1-D8 checklist.
Remove or rewrite any scenario that fails validation.

### Step 4 -- Build Traceability Matrix
Create AC-to-Scenario mapping table.
Verify 100% AC coverage (every AC has at least one scenario).

## Banned Words in Scenarios
click, navigate, type, enter, button, field, page, URL, endpoint,
database, API, HTTP, JSON, SQL, CSS, selector, element, component,
scroll, hover, tap, swipe, drag, drop, submit, form

## Few-Shot Examples
[2-3 exemplar scenarios embedded in the agent prompt for consistency]

## Output Template
[01.1-behavior-scenarios.md format - see Section 3.3]

## Quality Gates (Per-Scenario: Q1-Q10)
- [ ] Q1: Single Behavior (one When/Then pair)
- [ ] Q2: Declarative Style (WHAT not HOW)
- [ ] Q3: Business Language (domain terms, no jargon)
- [ ] Q4: Meaningful Title (behavior summarized clearly)
- [ ] Q5: Independence (self-contained, no cross-scenario deps)
- [ ] Q6: Concise Steps (3-5 steps total)
- [ ] Q7: Concrete Examples (specific but abstracted values)
- [ ] Q8: AC Traceability (maps to AC-ID)
- [ ] Q9: No Implementation Leakage (no technical details)
- [ ] Q10: Testable Outcome (Then is verifiable in code)

## Quality Gates (Per-Document: D1-D8)
- [ ] D1: AC Coverage (every AC has at least one scenario)
- [ ] D2: No Scenario Explosion (3-8 per major feature area)
- [ ] D3: Traceability Matrix (complete AC-to-Scenario table)
- [ ] D4: Unique IDs (every scenario has SCENARIO-XXX)
- [ ] D5: Priority Assignment (P0/P1/P2 per scenario)
- [ ] D6: Happy Path First (first scenario per area is success path)
- [ ] D7: Error Cases Included (at least one error scenario per area)
- [ ] D8: No Duplicate Behaviors (no two scenarios test same thing)
```

### 3.2 Scenario ID Format

```
SCENARIO-001, SCENARIO-002, ..., SCENARIO-NNN
```

- Sequential, zero-padded to 3 digits
- Unique within a single `01.1-behavior-scenarios.md` document
- Referenced in test code as: `// SCENARIO-001` or `describe('SCENARIO-001: ...')`

### 3.3 Output Document Format: `01.1-behavior-scenarios.md`

```markdown
# Behavior Scenarios: [Feature Name]

**Date:** [timestamp]
**Author:** super-dev:bdd-scenario-writer
**Source:** ./01-requirements.md
**Total Scenarios:** [count]

## Feature: [Feature Name]

### SCENARIO-001: [Meaningful Behavior Title]
**Acceptance Criteria:** AC-01 from requirements
**Priority:** P0

**Given** [precondition in business language]
**When** [single action/event in business language]
**Then** [verifiable outcome in business language]

### SCENARIO-002: [Meaningful Behavior Title]
**Acceptance Criteria:** AC-01 from requirements
**Priority:** P1

**Given** [precondition]
**When** [action]
**Then** [outcome]
**And** [additional outcome if needed]

### SCENARIO-003: [Meaningful Behavior Title]
**Acceptance Criteria:** AC-02 from requirements
**Priority:** P0

**Given** [precondition]
**When** [action]
**Then** [outcome]

## Scenario-Acceptance Criteria Traceability Matrix

| Acceptance Criterion | Scenario IDs | Coverage |
|---------------------|-------------|----------|
| AC-01: [description] | SCENARIO-001, SCENARIO-002 | Covered |
| AC-02: [description] | SCENARIO-003 | Covered |
| AC-03: [description] | SCENARIO-004, SCENARIO-005 | Covered |

## Coverage Summary

- **Total Acceptance Criteria:** [X]
- **Covered by Scenarios:** [Y]
- **Uncovered:** [Z] (should be 0)
- **Total Scenarios:** [N]
- **Scenarios per AC (avg):** [N/X]

## Quality Validation

### Per-Scenario Checks
| Scenario | Q1 | Q2 | Q3 | Q4 | Q5 | Q6 | Q7 | Q8 | Q9 | Q10 | Pass |
|----------|----|----|----|----|----|----|----|----|----|----|------|
| SCENARIO-001 | Y | Y | Y | Y | Y | Y | Y | Y | Y | Y | Y |
| SCENARIO-002 | Y | Y | Y | Y | Y | Y | Y | Y | Y | Y | Y |

### Per-Document Checks
- [x] D1: All AC covered
- [x] D2: Scenario count within limits
- [x] D3: Traceability matrix complete
- [x] D4: All IDs unique
- [x] D5: Priorities assigned
- [x] D6: Happy paths first
- [x] D7: Error cases included
- [x] D8: No duplicates
```

### 3.4 Modified Components

#### 3.4.1 Coordinator (`agents/coordinator.md`)

**Changes:**

1. **Phase Flow** (after line 98): Insert Phase 2.5 line
2. **Delegate Mode Table** (after line 77): Add row for Phase 2.5
3. **Skip Conditions** (after line 150): Add `Phase 2.5 | Never skip -- BDD scenarios mandatory`
4. **Team Creation** (line 161-176): Add `super-dev:bdd-scenario-writer`
5. **Teammate Roles** (line 178-196): Add `Planning | bdd-scenario-writer | Write BDD scenarios`
6. **Spawn Table** (line 198-212): Add `2.5 | bdd-scenario-writer`
7. **Termination Table** (line 286-299): Add `2.5 | bdd-scenario-writer | 01.1-behavior-scenarios.md complete`
8. **Quality Gates** (line 304-316): Modify `-> Phase 3` gate to require `01.1-behavior-scenarios.md` exists
9. **Iteration Rule** (line 128-141): Add `ScenarioCoverageMet` to loop exit criteria
10. **Final Verification** (line 347-354): Add `01.1-behavior-scenarios.md` to documents checklist

**Phase 2.5 Spawn Pattern:**
```
"Spawn a bdd-scenario-writer teammate with this context:
- Task: Generate BDD behavior scenarios from acceptance criteria
- Requirements: specification/[spec-index]-[spec-name]/01-requirements.md
- Spec directory: specification/[spec-index]-[spec-name]
- Feature name: [feature name]

Your role is to produce 01.1-behavior-scenarios.md with Given/When/Then scenarios
mapped to every acceptance criterion. No Scenario Outlines. Validate against Q1-Q10 and D1-D8."
```

#### 3.4.2 SKILL.md (`skills/super-dev/SKILL.md`)

**Changes:**

1. **Workflow Phase Checklist** (after line 128): Insert `- [ ] Phase 2.5: BDD Scenario Writing`
2. **Phase Enforcement Table** (after line 322): Insert row `| 2.5 | Use Task tool -> super-dev:bdd-scenario-writer | bdd-scenario-writer |`
3. **Teammate Roles Table** (after line 591): Add `| **Planning** | bdd-scenario-writer | Write BDD behavior scenarios from AC | super-dev:bdd-scenario-writer |`
4. **Team Creation Command** (line 569-584): Add `- super-dev:bdd-scenario-writer`
5. **When to Spawn Table** (after line 633): Add `| 2.5 | bdd-scenario-writer |`
6. **Phase 9 Section** (line 510-516): Add scenario coverage to Combined Pass Criteria
7. **Success Criteria** (line 104-108): Add `BDD scenario coverage: 100% of scenarios have passing tests`

#### 3.4.3 QA Agent (`agents/qa-agent.md`)

**Changes:**

1. **Core Principles** (after line 29): Add principle 6: `BDD-aligned: derive test plan from Gherkin scenarios in 01.1-behavior-scenarios.md`
2. **Execution Responsibilities** (after line 36): Add `Parse BDD scenarios from 01.1-behavior-scenarios.md and map each to test cases`
3. **Test Plan Structure** (after line 93): Add `BDD Scenario Mapping` section to test plan template

**New section in Test Plan:**
```markdown
## BDD Scenario Coverage

### Scenario-Test Mapping
| Scenario ID | Title | AC Ref | Test File | Test Name | Status |
|-------------|-------|--------|-----------|-----------|--------|
| SCENARIO-001 | [title] | AC-01 | [file] | [test name] | PASS/FAIL |

### Coverage Summary
- Total Scenarios: [N]
- Covered (with passing test): [M]
- Uncovered: [N-M]
- Coverage: [M/N * 100]%
```

4. **Quality Gates** (after line 840): Add `- [ ] All BDD scenarios from 01.1-behavior-scenarios.md have corresponding test implementations`

#### 3.4.4 Code Reviewer (`agents/code-reviewer.md`)

**Changes:**

1. **Review Workflow Step 6** (after line 206): Add BDD Scenario Coverage Validation

**New sub-step 6.1:**
```
6.1) BDD Scenario Coverage Validation
- Read 01.1-behavior-scenarios.md (if exists)
- Read qa-agent's Scenario Coverage Report
- For each SCENARIO-XXX:
  - Verify at least one test references it
  - Verify that test passes
- If any scenario lacks a passing test:
  - Emit finding (High severity, Correctness dimension)
  - Verdict: "Changes Requested"
```

2. **Output Template** (after line 274): Add BDD Scenario Coverage section

**New section in output:**
```markdown
## BDD Scenario Coverage

| Scenario ID | Title | Test Reference | Status |
|-------------|-------|---------------|--------|
| SCENARIO-001 | [title] | [test file:line] | Covered/Missing |

**Coverage:** [M/N] scenarios covered
**Gate:** PASS / FAIL
```

3. **Verdict Logic** (line 228-233): Add condition: `If scenario coverage < 100% -> Changes Requested`

#### 3.4.5 Adversarial Reviewer (`agents/adversarial-reviewer.md`)

**Changes:**

1. **Skeptic Lens** (after line 60): Add V8 sub-check

**V8: Behavior Coverage Gaps**
```
- [ ] V8 Behavior Coverage: Are all user-facing behaviors covered by BDD scenarios?
  - Read 01.1-behavior-scenarios.md
  - Cross-reference with implementation: are there code paths with business logic
    that have no corresponding scenario?
  - Check scenario coverage report: does it show 100% coverage?
  - Are there acceptance criteria from 01-requirements.md without scenarios?
```

2. **Vector Coverage Table** (line 238-248): Add V8 row

```markdown
| V8: Behavior Coverage | Skeptic | 0 | -- |
```

3. **Vector-to-Lens mapping** (line 98-101): Update to include V8

```
- **Skeptic** is primary for V1-V6, V8
```

#### 3.4.6 Spec Writer (`agents/spec-writer.md`)

**Changes:**

1. **Input Context** (after line 24): Add `bdd_scenarios` input

```markdown
- `bdd_scenarios`: BDD behavior scenarios from super-dev:bdd-scenario-writer
  (required for features; contains Given/When/Then scenarios mapped to AC)
```

2. **Testing Strategy Section** (section 5, around line 247): Add BDD Scenario References

**New sub-section 5.4:**
```markdown
### 5.4 BDD Scenario References

Tests MUST reference BDD scenario IDs from `01.1-behavior-scenarios.md`:

| Scenario ID | Title | Test Type | Test Location |
|-------------|-------|-----------|---------------|
| SCENARIO-001 | [title] | Unit/Integration/E2E | [planned test file] |

**Convention:** Test names or comments MUST include SCENARIO-XXX ID.
```

3. **Quality Standards** (after line 551): Add `- [ ] BDD scenarios cross-referenced in testing strategy (Section 5.4)`

#### 3.4.7 Testing Rules (`rules/testing.md`)

**Addition at end of file:**

```markdown
## BDD (Behavior-Driven Development)

MANDATORY for all features developed through super-dev workflow:

1. BDD scenarios written BEFORE implementation (Phase 2.5)
2. All scenarios stored in `01.1-behavior-scenarios.md` in spec directory
3. Format: Given/When/Then (Gherkin-like markdown, NOT .feature files)
4. No Scenario Outlines in v1 -- individual scenarios only
5. Every scenario MUST have a unique SCENARIO-XXX ID
6. Every acceptance criterion MUST have at least one scenario
7. Every scenario MUST have at least one corresponding test
8. Phase 9 gate: 100% scenario coverage required (hard gate)
9. BDD augments TDD -- does NOT replace unit/integration/E2E testing

Agent Support:
- **bdd-scenario-writer** -- Generates scenarios from acceptance criteria (Phase 2.5)
- **qa-agent** -- Maps scenarios to tests, produces coverage report (Phase 8)
- **code-reviewer** -- Validates scenario coverage gate (Phase 9)
- **adversarial-reviewer** -- V8 behavior gap detection (Phase 9)
```

### 3.5 Workflow Tracking JSON Update

Add Phase 2.5 to the phases array in the workflow tracking JSON:

```json
{
  "phases": [
    { "id": 0, "name": "Apply Dev Rules", "status": "complete" },
    { "id": 1, "name": "Specification Setup", "status": "complete" },
    { "id": 2, "name": "Requirements Clarification", "status": "complete" },
    { "id": 2.5, "name": "BDD Scenario Writing", "status": "pending" },
    { "id": 3, "name": "Research", "status": "pending" },
    ...
  ]
}
```

---

## 4. File Modification Plan (Ordered)

Implementation should proceed in this order to minimize conflicts and ensure each change builds on the previous one:

### Phase 1: Foundation (New Files)

| Order | File | Action | Description |
|-------|------|--------|-------------|
| 1 | `agents/bdd-scenario-writer.md` | **CREATE** | New BDD agent definition (full spec from Section 3.1) |
| 2 | `templates/reference/bdd-patterns.md` | **CREATE** | BDD reference template with Gherkin syntax, examples, banned words |

### Phase 2: Core Workflow Integration

| Order | File | Action | Sections Changed |
|-------|------|--------|-----------------|
| 3 | `rules/testing.md` | **MODIFY** | Append BDD section at end of file |
| 4 | `skills/super-dev/SKILL.md` | **MODIFY** | Phase checklist, enforcement table, team roles, spawn table, Phase 9 pass criteria, success criteria, team creation |
| 5 | `agents/coordinator.md` | **MODIFY** | Phase flow, delegate table, skip conditions, team creation, teammate roles, spawn table, termination table, quality gates, iteration rule, final verification |

### Phase 3: Downstream Consumer Updates

| Order | File | Action | Sections Changed |
|-------|------|--------|-----------------|
| 6 | `agents/spec-writer.md` | **MODIFY** | Input context, testing strategy section, quality standards |
| 7 | `agents/qa-agent.md` | **MODIFY** | Core principles, execution responsibilities, test plan structure, quality gates |

### Phase 4: Review Gate Updates

| Order | File | Action | Sections Changed |
|-------|------|--------|-----------------|
| 8 | `agents/code-reviewer.md` | **MODIFY** | Review workflow step 6, output template, verdict logic |
| 9 | `agents/adversarial-reviewer.md` | **MODIFY** | Skeptic lens V8, vector coverage table, vector-to-lens mapping |

### Summary

| Category | Count | Files |
|----------|-------|-------|
| **New Files** | 2 | `agents/bdd-scenario-writer.md`, `templates/reference/bdd-patterns.md` |
| **Modified Files** | 7 | `rules/testing.md`, `skills/super-dev/SKILL.md`, `agents/coordinator.md`, `agents/spec-writer.md`, `agents/qa-agent.md`, `agents/code-reviewer.md`, `agents/adversarial-reviewer.md` |
| **Total** | 9 | |

---

## 5. ADR-001: BDD Integration Approach

### Status
Proposed

### Context and Problem Statement
The super-dev plugin's Phase 9 quality gate relies on subjective reviewer judgment to verify acceptance criteria are met. There is no structural link between requirements (Phase 2) and tests (Phase 8), creating a gap where criteria can be marked "met" without executable proof.

### Decision Drivers
- Need deterministic (not subjective) acceptance criteria verification
- Must fit existing 14-phase workflow without disruption
- Must be framework/language agnostic (plugin is tool-agnostic)
- Must augment, not replace, existing TDD workflow

### Considered Options
1. Minimal: BDD within existing requirements-clarifier (no new phase)
2. New bdd-scenario-writer agent + mandatory Phase 2.5
3. Comprehensive: Full BDD lifecycle (agent + skill + command + rules)

### Decision Outcome
Chosen option: **Option 2 - New bdd-scenario-writer agent + mandatory Phase 2.5**, because it provides clean separation of concerns (dedicated agent), follows existing one-phase-one-agent patterns, and delivers the core value (traceable behavior specs) without over-engineering the workflow.

**User decisions (final):**
- Phase 2.5 is MANDATORY for all features
- Hard gate: 100% scenario coverage blocks progress in Phase 9
- Separate file: `01.1-behavior-scenarios.md`
- No Scenario Outlines in v1
- BDD augments TDD
- Markdown-based Gherkin-like syntax (no .feature files, no Cucumber/SpecFlow)

### Consequences
- Good: Deterministic scenario-to-test verification replaces subjective reviewer judgment
- Good: Living documentation in specification format (Given/When/Then readable by all)
- Good: Minimal disruption to existing phases (only Phase 2.5 added, Phase 9 gate enhanced)
- Bad: Adds one sequential step to workflow (mitigated: BDD agent is fast, < 2 min overhead)
- Bad: One more agent to maintain (mitigated: follows existing patterns exactly)

### Reversibility Plan
- **Trigger:** If BDD integration proves too slow or doesn't add value after 5+ features
- **Rollback:** Remove Phase 2.5 from coordinator, remove V8 from adversarial reviewer, remove scenario coverage gate from code-reviewer. bdd-scenario-writer agent file can be deleted.
- **Cost:** Low - all changes are additive (new file + insertions). Removal is straightforward.

---

## 6. ADR-002: Markdown-Based Gherkin-Like Syntax

### Status
Proposed

### Context and Problem Statement
BDD scenarios need a format that is both human-readable and machine-parseable by AI agents, without requiring external BDD framework dependencies.

### Decision Drivers
- Plugin must remain language/framework agnostic
- AI agents must be able to generate and parse the format
- Non-technical stakeholders must be able to read scenarios
- No additional runtime dependencies

### Considered Options
1. Pure Gherkin .feature files (Cucumber/SpecFlow)
2. Markdown-based Gherkin-like syntax
3. Structured YAML/JSON scenario definitions
4. Specification by Example tables
5. Free-form natural language

### Decision Outcome
Chosen option: **Option 2 - Markdown-based Gherkin-like syntax**, because it preserves the communication value of Given/When/Then while avoiding framework lock-in. AI agents generate high-quality markdown BDD scenarios from detailed requirements (arXiv study confirms Claude rated highest by human experts).

### Consequences
- Good: Framework-independent, works with any tech stack
- Good: Human-readable AND AI-parseable
- Good: No additional dependencies
- Good: Proven viable (Nordic Semiconductor bdd-markdown-js)
- Bad: No automatic step-definition binding (mitigated: qa-agent verifies mapping)
- Bad: No built-in lint/validation (mitigated: Q1-Q10, D1-D8 quality gates in agent)

### Reversibility Plan
- **Trigger:** If structured parsing proves insufficient for automated verification
- **Rollback:** Could upgrade to YAML/JSON structured format while preserving scenario content
- **Cost:** Medium - requires updating bdd-scenario-writer output format and qa-agent parser

---

## 7. Validation Checklist

### Architecture Completeness
- [x] All functional requirements addressed (FR-1 through FR-6)
- [x] All non-functional requirements considered (minimal disruption, < 2 min overhead, naming conventions, agent pattern consistency)
- [x] Module boundaries align with domain concepts (BDD writing vs testing vs reviewing)
- [x] Dependencies form directed acyclic graph (Phase 2 -> 2.5 -> 6/8 -> 9)
- [x] Each module has single, clear purpose

### Quality Principles
- [x] SOLID principles followed (single responsibility per agent, open for extension)
- [x] DRY: No duplicated responsibilities (bdd-scenario-writer writes, qa-agent tests, reviewers verify)
- [x] YAGNI: No speculative architecture (no BDD skill, no BDD command, no scenario-driven dev in v1)
- [x] Loose coupling: Agents communicate via files, not direct dependencies
- [x] High cohesion: Each agent handles one phase's work completely

### Implementation Readiness
- [x] Interfaces defined for all modules (scenario document format, coverage report format)
- [x] Error handling strategy complete (ambiguous AC flagged, non-testable noted as constraints)
- [x] Security considerations addressed (no credentials in scenarios - banned by agent instructions)
- [x] Performance path defined (< 2 min overhead for BDD agent)
- [x] Existing patterns respected (agent markdown format, phase numbering, file naming)

### Reuse Gate
- No external open-source components needed (markdown-based, no framework)
- Reuses existing: agent pattern, phase numbering pattern, spec directory convention, quality gate pattern

### Glue Code Gate
- `bdd-scenario-writer.md`: Glue between requirements doc and scenario doc (adapter: AC -> Given/When/Then)
- `qa-agent` changes: Glue between scenario doc and test code (adapter: SCENARIO-ID -> test reference)
- `code-reviewer` changes: Glue between coverage report and verdict (adapter: coverage % -> pass/fail)

### Interface-First Gate
- Scenario document interface: `01.1-behavior-scenarios.md` format defined in Section 3.3
- Scenario Coverage Report interface: Table format defined in Section 3.4.3
- SCENARIO-ID convention: `SCENARIO-XXX` format defined in Section 3.2
- AC-to-Scenario mapping: Traceability matrix format defined in Section 3.3
