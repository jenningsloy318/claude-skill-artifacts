# Technical Specification: BDD Integration into Super-Dev Workflow

**Date:** 2026-03-15
**Author:** super-dev:spec-writer
**Status:** Draft

## 1. Overview

### 1.1 Summary

Integrate Behavior-Driven Development (BDD) into the super-dev plugin workflow by adding a new `bdd-scenario-writer` agent and a mandatory Phase 2.5 that transforms acceptance criteria from `01-requirements.md` into structured Given/When/Then behavior scenarios. These scenarios create a traceable chain from requirements through implementation to verification, replacing the current subjective Phase 9 acceptance-criteria check with a deterministic, binary pass/fail gate based on scenario coverage.

### 1.2 Goals

- Bridge the gap between prose acceptance criteria (Phase 2) and automated tests (Phase 8) with traceable behavior specifications
- Replace subjective "acceptance criteria met" check in Phase 9 with deterministic scenario coverage verification
- Produce living documentation in Given/When/Then format readable by all stakeholders
- Maintain backward compatibility with existing TDD workflow (BDD augments, does not replace)

### 1.3 Non-Goals

- No `.feature` files or Cucumber/SpecFlow/Behave runtime dependencies
- No Scenario Outlines (parameterized scenarios) in v1 -- individual scenarios only
- No scenario-driven development (dev-executor guided by scenarios) -- future enhancement
- No BDD skill or BDD command -- this is a workflow integration, not a standalone tool
- No changes to Phases 0, 1, 3-5, 10-13 unless strictly required by BDD integration

---

## 2. Background

### 2.1 Context

> From Research Report: BDD originated as a communication practice (Dan North, 2006), not a testing framework. LLMs can effectively generate BDD scenarios from detailed requirements -- Claude rated highest by human experts in a 2026 arXiv study. Markdown-based Gherkin-like syntax is the recommended approach for framework-free, tool-agnostic workflows.

> From Research Report: Declarative over imperative is the single most important Gherkin writing rule. Scenario cadence follows diminishing returns -- 3-5 scenarios per feature area captures bulk of business value.

### 2.2 Current State

> From Assessment: All agents follow strict markdown patterns (YAML frontmatter + role + workflow + output template + quality gates). The coordinator defines phases 0-13 with explicit skip conditions and quality gates. TDD workflow exists but has NO BDD layer. Nine files need modification; two new files need creation.

### 2.3 Problem Statement

> From Requirements: Acceptance criteria in `01-requirements.md` are written in free-form markdown with no direct connection to test code in Phase 8. Phase 9 verification is subjective -- a reviewer must manually map criteria to test results. The Phase 8/9 iteration loop can produce false positives: criteria marked "met" without corresponding executable proof.

---

## 3. Component Specifications

### 3.1 New Agent: `bdd-scenario-writer` (`agents/bdd-scenario-writer.md`)

The complete agent definition below is ready to be saved directly as `agents/bdd-scenario-writer.md`:

````markdown
---
name: bdd-scenario-writer
description: Write BDD behavior scenarios in Gherkin-like markdown from requirements acceptance criteria. Produces traceable Given/When/Then scenarios mapped to acceptance criteria with quality validation.
---

You are a BDD Scenario Writer Agent specialized in transforming acceptance criteria into structured behavior specifications using Given/When/Then format in markdown.

## Core Principles

1. **Declarative style**: Describe WHAT behavior is expected, not HOW (no UI interactions, no button clicks)
2. **One behavior per scenario**: Each scenario tests exactly one distinct behavior (one When/Then pair)
3. **Business language**: Use domain terminology stakeholders understand -- no technical jargon
4. **Traceability**: Every scenario maps to at least one acceptance criterion via AC-ID reference
5. **Scenario cadence**: 3-5 scenarios per feature area; diminishing returns beyond 5

## Required Inputs

- `requirements`: Path to `01-requirements.md` (REQUIRED)
- `spec_directory`: Specification directory path
- `feature_name`: Name of the feature

## Scenario Writing Workflow

### Step 1 -- Parse Requirements

1. Read ALL acceptance criteria from `01-requirements.md`
2. Extract AC-IDs and their descriptions into a working list
3. Cross-reference the "Job to Be Done" and "Stakeholders" sections for context
4. Flag ambiguous criteria as `[AMBIGUOUS: needs clarification]`
5. Note non-functional criteria (performance, security) as constraints -- do NOT force into Given/When/Then

### Step 2 -- Generate Scenarios (Chain-of-Thought)

For each acceptance criterion, reason through:
1. **Golden scenario** (happy path -- the core promise of this criterion)
2. **Primary alternative** (most likely variation from the happy path)
3. **Primary failure** (most likely error case)
4. **Stop.** Only add more if a distinct business behavior remains uncovered.

Reasoning process for each scenario:
- What is the precondition? (Given)
- What single action triggers the behavior? (When)
- What verifiable outcome results? (Then)

### Step 3 -- Validate Quality

Self-validate every scenario against the Per-Scenario Quality Checklist (Q1-Q10).
Self-validate the complete document against the Per-Document Quality Checklist (D1-D8).
Remove or rewrite any scenario that fails validation.

### Step 4 -- Build Traceability Matrix

1. Create AC-to-Scenario mapping table
2. Verify 100% AC coverage (every AC has at least one scenario)
3. If any AC is uncovered, generate additional scenarios or flag as `[AMBIGUOUS]`

## Banned Words in Scenarios

These words indicate imperative/implementation-coupled scenarios. NEVER use them:

click, navigate, type, enter, button, field, page, URL, endpoint, database, API, HTTP, JSON, SQL, CSS, selector, element, component, scroll, hover, tap, swipe, drag, drop, submit, form, redirect, render, mount, DOM, query, request, response

## Few-Shot Examples

### Example 1: Good Scenario (Declarative, Business Language)

```
### SCENARIO-001: Registered user accesses account with valid credentials
**Acceptance Criteria:** AC-01 from requirements
**Priority:** P0

**Given** a registered user with an active account
**When** the user authenticates with valid credentials
**Then** the user gains access to their personalized dashboard
```

### Example 2: Good Scenario (Error Case)

```
### SCENARIO-002: Authentication fails with incorrect password
**Acceptance Criteria:** AC-01 from requirements
**Priority:** P1

**Given** a registered user with an active account
**When** the user authenticates with an incorrect password
**Then** the system denies access
**And** a descriptive error message is displayed
```

### Example 3: Bad Scenario (Imperative -- DO NOT WRITE LIKE THIS)

```
### BAD: User clicks login button
**Given** the user is on the login page
**When** the user types "admin@example.com" in the email field
**And** the user types "password123" in the password field
**And** the user clicks the "Login" button
**Then** the page redirects to /dashboard
```

This is BAD because: imperative style (click, type, field), implementation details (email value, URL path), multiple When steps, UI-coupled.

## Output Template

The output file is `01.1-behavior-scenarios.md` in the spec directory:

```markdown
# Behavior Scenarios: [Feature Name]

**Date:** [timestamp]
**Author:** super-dev:bdd-scenario-writer
**Source:** ./01-requirements.md
**Total Scenarios:** [count]

## Feature: [Feature Name]

### SCENARIO-001: [Meaningful Behavior Title]
**Acceptance Criteria:** AC-XX from requirements
**Priority:** P0/P1/P2

**Given** [precondition in business language]
**When** [single action/event in business language]
**Then** [verifiable outcome in business language]

### SCENARIO-002: [Meaningful Behavior Title]
**Acceptance Criteria:** AC-XX from requirements
**Priority:** P0/P1/P2

**Given** [precondition]
**When** [action]
**Then** [outcome]
**And** [additional outcome if needed]

[... more scenarios ...]

## Scenario-Acceptance Criteria Traceability Matrix

| Acceptance Criterion | Scenario IDs | Coverage |
|---------------------|-------------|----------|
| AC-01: [description] | SCENARIO-001, SCENARIO-002 | Covered |
| AC-02: [description] | SCENARIO-003 | Covered |

## Coverage Summary

- **Total Acceptance Criteria:** [X]
- **Covered by Scenarios:** [Y]
- **Uncovered:** [Z] (must be 0)
- **Total Scenarios:** [N]
- **Scenarios per AC (avg):** [N/X]

## Quality Validation

### Per-Scenario Checks
| Scenario | Q1 | Q2 | Q3 | Q4 | Q5 | Q6 | Q7 | Q8 | Q9 | Q10 | Pass |
|----------|----|----|----|----|----|----|----|----|----|----|------|
| SCENARIO-001 | Y | Y | Y | Y | Y | Y | Y | Y | Y | Y | Y |

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

## Quality Gates

### Per-Scenario Checks (Q1-Q10)

| # | Check | Pass Criteria |
|---|-------|--------------|
| Q1 | **Single Behavior** | Scenario tests exactly ONE distinct behavior (one When/Then pair) |
| Q2 | **Declarative Style** | Describes WHAT happens, not HOW (no UI interactions, no banned words) |
| Q3 | **Business Language** | Uses domain terminology stakeholders understand (no technical jargon) |
| Q4 | **Meaningful Title** | Title summarizes the behavior; someone unfamiliar can understand the scenario's purpose |
| Q5 | **Independence** | Self-contained; no dependency on other scenarios' execution or state |
| Q6 | **Concise Steps** | 3-5 steps total (Given + When + Then + And/But). If > 7, split or abstract |
| Q7 | **Concrete Examples** | Uses specific but abstracted values. "Given a user with an expired subscription" > "Given a user" |
| Q8 | **AC Traceability** | Maps to at least one AC from `01-requirements.md` with explicit AC-ID reference |
| Q9 | **No Implementation Leakage** | No database tables, API endpoints, HTTP codes, CSS selectors, file paths, component names |
| Q10 | **Testable Outcome** | The Then clause describes a verifiable outcome that can be asserted in code |

### Per-Document Checks (D1-D8)

| # | Check | Pass Criteria |
|---|-------|--------------|
| D1 | **AC Coverage** | Every AC from `01-requirements.md` has at least one corresponding scenario |
| D2 | **No Scenario Explosion** | Total scenarios per feature area is 3-8 |
| D3 | **Traceability Matrix** | Document includes complete AC-to-Scenario mapping table |
| D4 | **Unique IDs** | Every scenario has a unique SCENARIO-XXX identifier |
| D5 | **Priority Assignment** | Each scenario has P0/P1/P2 priority |
| D6 | **Happy Path First** | First scenario for each feature area is the primary success path |
| D7 | **Error Cases Included** | At least one error/failure scenario per major feature area |
| D8 | **No Duplicate Behaviors** | No two scenarios test the same behavior with trivially different inputs |
````

### 3.2 Coordinator Modifications (`agents/coordinator.md`)

#### 3.2.1 Phase Flow (after line 98, insert new line)

**Before:**
```
Phase 2:  Requirements Clarification → Spawn requirements-clarifier teammate
Phase 3:  Research                  → Spawn research-agent teammate
```

**After:**
```
Phase 2:  Requirements Clarification → Spawn requirements-clarifier teammate
Phase 2.5: BDD Scenario Writing      → Spawn bdd-scenario-writer teammate (MANDATORY)
Phase 3:  Research                  → Spawn research-agent teammate
```

#### 3.2.2 Delegate Mode Table (after line 77, insert new row)

**Add row after Phase 2 row:**
```
| 2.5 | Writing BDD scenarios | Spawn bdd-scenario-writer |
```

#### 3.2.3 Iteration Rule (line 130, modify)

**Before:**
```
**Loop until:** Critical=0, High=0, Medium=0, AcceptanceCriteriaMet, CodeReviewVerdict=Approved, AdversarialVerdict=PASS
```

**After:**
```
**Loop until:** Critical=0, High=0, Medium=0, AcceptanceCriteriaMet, ScenarioCoverageMet (100%), CodeReviewVerdict=Approved, AdversarialVerdict=PASS
```

#### 3.2.4 Skip Conditions (after line 150, insert new row)

**Add row:**
```
| Phase 2.5 | Never skip -- BDD scenarios are mandatory for all features |
```

#### 3.2.5 Team Creation Command (between lines 163-175, insert new member)

**Add after `super-dev:requirements-clarifier`:**
```
- super-dev:bdd-scenario-writer
```

#### 3.2.6 Teammate Roles Table (after line 183, insert new row)

**Add after `requirements-clarifier` row:**
```
| **Planning** | bdd-scenario-writer | Write BDD behavior scenarios from AC |
```

#### 3.2.7 Spawn Table (after line 201, insert new row)

**Add after Phase 2 row:**
```
| 2.5 | bdd-scenario-writer |
```

#### 3.2.8 Teammate Spawn Patterns (after line 224, insert Phase 2.5 pattern)

**Add new spawn pattern:**
```
**Phase 2.5 (BDD Scenarios):**
"Spawn a bdd-scenario-writer teammate with this context:
- Task: Generate BDD behavior scenarios from acceptance criteria
- Requirements: specification/[spec-index]-[spec-name]/01-requirements.md
- Spec directory: specification/[spec-index]-[spec-name]
- Feature name: [feature name]

Your role is to produce 01.1-behavior-scenarios.md with Given/When/Then scenarios
mapped to every acceptance criterion. No Scenario Outlines. Validate against Q1-Q10 and D1-D8."
```

#### 3.2.9 Per-Phase Termination Table (after line 288, insert new row)

**Add after Phase 2 row:**
```
| 2.5 | bdd-scenario-writer | 01.1-behavior-scenarios.md complete |
```

#### 3.2.10 Quality Gates (modify line 307)

**Before:**
```
| → Phase 3 | 01-requirements.md exists |
```

**After:**
```
| → Phase 3 | 01-requirements.md exists AND 01.1-behavior-scenarios.md exists |
```

#### 3.2.11 Final Verification Checklist (modify line 348)

**Before:**
```
- Documents: requirements.md, research-report.md, assessment.md, specification.md, implementation-plan.md, task-list.md (all complete), implementation-summary.md
```

**After:**
```
- Documents: requirements.md, behavior-scenarios.md, research-report.md, assessment.md, specification.md, implementation-plan.md, task-list.md (all complete), implementation-summary.md
```

### 3.3 QA Agent Modifications (`agents/qa-agent.md`)

#### 3.3.1 Core Principles (after line 29, append new principle)

**Add as principle 6:**
```
6. BDD-aligned: derive test plan from Gherkin scenarios in `01.1-behavior-scenarios.md`, mapping each scenario to at least one test case with SCENARIO-ID references
```

#### 3.3.2 Execution Responsibilities (after line 36, insert)

**Add new bullet:**
```
- Parse BDD scenarios from `01.1-behavior-scenarios.md` and map each SCENARIO-XXX to test cases
```

#### 3.3.3 Test Plan Structure (after line 93, before the `---` separator, insert new section)

**Add new section to the Test Plan markdown template:**

```markdown
## BDD Scenario Coverage

### Scenario-Test Mapping
| Scenario ID | Title | AC Ref | Test File | Test Name | Status |
|-------------|-------|--------|-----------|-----------|--------|
| SCENARIO-001 | [title] | AC-01 | [file path] | [test function/describe name] | PASS/FAIL |
| SCENARIO-002 | [title] | AC-02 | [file path] | [test function/describe name] | PASS/FAIL |

### Coverage Summary
- **Total Scenarios:** [N]
- **Covered (with passing test):** [M]
- **Uncovered:** [N-M] (must be 0 for Phase 9 gate)
- **Coverage:** [M/N * 100]%
```

#### 3.3.4 Quality Gates (after line 840, append)

**Add new gate:**
```
- [ ] All BDD scenarios from `01.1-behavior-scenarios.md` have corresponding test implementations with SCENARIO-ID references
- [ ] BDD Scenario Coverage Report section included in QA output
```

### 3.4 Code Reviewer Modifications (`agents/code-reviewer.md`)

#### 3.4.1 Review Workflow -- New Sub-step 6.1 (after line 206, insert)

**Add new sub-step after step 6 "Validate Against Spec":**

```markdown
6.1) BDD Scenario Coverage Validation
- Read `01.1-behavior-scenarios.md` from the spec directory (if it exists)
- Read the qa-agent's BDD Scenario Coverage Report from QA output
- For each SCENARIO-XXX in the scenario document:
  - Verify at least one test references the SCENARIO-ID (in test name or comment)
  - Verify that test passes (status = PASS in coverage report)
- If ANY scenario lacks a corresponding passing test:
  - Emit finding: High severity, Correctness dimension
  - Include the missing SCENARIO-IDs in finding evidence
  - Verdict: "Changes Requested" (scenario coverage gap blocks approval)
```

#### 3.4.2 Output Template -- New Section (after line 278, insert before Findings section)

**Add new section after "Non-Goals Check":**

```markdown
## BDD Scenario Coverage

| Scenario ID | Title | Test Reference | Status |
|-------------|-------|---------------|--------|
| SCENARIO-001 | [title] | [test file:line or test name] | Covered / Missing |

**Coverage:** [M/N] scenarios covered
**Gate:** PASS / FAIL
```

#### 3.4.3 Verdict Logic (modify line 230)

**Before:**
```
Else if High > 3 or AC not met → Changes Requested
```

**After:**
```
Else if High > 3 or AC not met or scenario coverage < 100% → Changes Requested
```

### 3.5 Adversarial Reviewer Modifications (`agents/adversarial-reviewer.md`)

#### 3.5.1 Skeptic Lens -- V8 Attack Vector (after line 60, insert)

**Add after V6 Grounding Audit:**

```markdown
- [ ] **V8 Behavior Coverage:** Are all user-facing behaviors covered by BDD scenarios?
  - Read `01.1-behavior-scenarios.md` from the spec directory
  - Cross-reference with implementation: are there code paths with business logic that have no corresponding scenario?
  - Check the qa-agent's scenario coverage report: does it show 100% coverage?
  - Are there acceptance criteria from `01-requirements.md` that lack corresponding scenarios in the traceability matrix?
  - If any gaps found: emit finding with High severity
```

#### 3.5.2 D9 Document-Level Pre-Check (after line 105, before Step 3)

**Add new pre-check step (runs before lens reviews):**

```markdown
### Step 2.1 -- Document-Level Pre-Check (D9)

Before applying lens reviews, validate that required BDD artifacts exist:

- [ ] **D9 BDD Document Validation:**
  - Does `01.1-behavior-scenarios.md` exist in the spec directory?
  - Does it contain a Traceability Matrix section?
  - Are all ACs from `01-requirements.md` represented in the traceability matrix?
  - If any check fails: emit finding with High severity (Skeptic/D9)

**D9 is a pre-gate:** If the scenario document is missing or incomplete, this finding is emitted before any V1-V8 analysis begins.
```

#### 3.5.3 Vector-to-Lens Mapping (modify line 99)

**Before:**
```
- **Skeptic** is primary for V1-V6
```

**After:**
```
- **Skeptic** is primary for V1-V6, V8
```

#### 3.5.4 Vector Coverage Table (after line 247, insert new row)

**Add after V7 row:**
```
| V8: Behavior Coverage | Skeptic | 0 | -- |
```

#### 3.5.5 Output Template -- Change Scope Section (modify line 199)

**Before:**
```
| Attack vectors applied | V1-V6 [+ V7] |
```

**After:**
```
| Attack vectors applied | V1-V6, V8 [+ V7] |
```

### 3.6 Spec Writer Modifications (`agents/spec-writer.md`)

#### 3.6.1 Input Context (after line 24, insert)

**Add new input after `debug_analysis`:**
```
- `bdd_scenarios`: BDD behavior scenarios from super-dev:bdd-scenario-writer (required for features; contains Given/When/Then scenarios mapped to acceptance criteria)
```

#### 3.6.2 Testing Strategy Section (add new sub-section 5.4 in specification template)

**Add to the specification template's Testing Strategy section:**

```markdown
### 5.4 BDD Scenario References

Tests MUST reference BDD scenario IDs from `01.1-behavior-scenarios.md`:

| Scenario ID | Title | Test Type | Test Location |
|-------------|-------|-----------|---------------|
| SCENARIO-001 | [title] | Unit/Integration/E2E | [planned test file] |

**Convention:** Test names or comments MUST include the SCENARIO-XXX ID.
Examples:
- `describe('SCENARIO-001: Registered user accesses account', ...)`
- `// SCENARIO-001` comment above test function
- `test_scenario_001_registered_user_access()` function name
```

#### 3.6.3 Quality Standards (append to existing quality standards checklist)

**Add:**
```
- [ ] BDD scenarios cross-referenced in testing strategy (Section 5.4)
```

### 3.7 SKILL.md Modifications (`skills/super-dev/SKILL.md`)

#### 3.7.1 Success Criteria -- Outcome Section (after line 108, insert)

**Add new bullet:**
```
- BDD scenario coverage: 100% of scenarios have corresponding passing tests
```

#### 3.7.2 Workflow Phase Checklist (after line 128, insert)

**Add after `Phase 2: Requirements Clarification`:**
```
- [ ] Phase 2.5: BDD Scenario Writing (MANDATORY)
```

#### 3.7.3 Iteration Rule (modify line 150)

**Before:**
```
**Iteration Rule:** YOU MUST loop Phase 8/9 until Critical=0, High=0, Medium=0, code review verdict is Approved, adversarial verdict is PASS, and ALL acceptance criteria are met. NEVER proceed to Phase 10 with unresolved issues or a REJECT/CONTESTED verdict.
```

**After:**
```
**Iteration Rule:** YOU MUST loop Phase 8/9 until Critical=0, High=0, Medium=0, code review verdict is Approved, adversarial verdict is PASS, ALL acceptance criteria are met, AND BDD scenario coverage is 100%. NEVER proceed to Phase 10 with unresolved issues, a REJECT/CONTESTED verdict, or uncovered scenarios.
```

#### 3.7.4 Teammate Roles Table (after line 236, insert new row)

**Add after `requirements-clarifier` row:**
```
| 2.5 | bdd-scenario-writer | Write BDD behavior scenarios from acceptance criteria | `super-dev:bdd-scenario-writer` |
```

#### 3.7.5 Phase Enforcement Table (after line 322, insert new row)

**Add after Phase 2 row:**
```
| 2.5 | Use Task tool → `super-dev:bdd-scenario-writer` | bdd-scenario-writer |
```

#### 3.7.6 Combined Phase 9 Pass Criteria (modify line 512-516)

**Before:**
```
**BOTH must pass to proceed to Phase 10 (Documentation):**
- Code Review verdict = Approved (or Approved with Comments)
- Adversarial Review verdict = PASS

**If either fails:** Loop back to Phase 8 with combined findings from both reviews as input.
```

**After:**
```
**ALL must pass to proceed to Phase 10 (Documentation):**
- Code Review verdict = Approved (or Approved with Comments)
- Adversarial Review verdict = PASS
- BDD Scenario Coverage = 100% (all scenarios have corresponding passing tests)

**If any fails:** Loop back to Phase 8 with combined findings from both reviews as input.
```

#### 3.7.7 Team Creation Command (after line 571, insert)

**Add after `super-dev:requirements-clarifier`:**
```
- super-dev:bdd-scenario-writer
```

#### 3.7.8 Teammate Roles by Category Table (after line 591, insert)

**Add after `requirements-clarifier` row:**
```
| **Planning** | bdd-scenario-writer | Write BDD behavior scenarios from AC | `super-dev:bdd-scenario-writer` |
```

#### 3.7.9 Team Creation at Phase 1 (after line 616, insert)

**Add after `super-dev:requirements-clarifier` in the numbered list:**
```
3. super-dev:bdd-scenario-writer
```

(And renumber subsequent teammates 4-15.)

#### 3.7.10 When to Spawn Each Teammate Table (after line 635, insert)

**Add after Phase 2 row:**
```
| 2.5 | bdd-scenario-writer |
```

### 3.8 Testing Rules Modifications (`rules/testing.md`)

#### 3.8.1 Append BDD Section (after line 31, at end of file)

**Add:**

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
8. Phase 9 gate: 100% scenario coverage required (hard gate, blocks Phase 10)
9. BDD augments TDD -- does NOT replace unit/integration/E2E testing

Agent Support:
- **bdd-scenario-writer** -- Generates scenarios from acceptance criteria (Phase 2.5)
- **qa-agent** -- Maps scenarios to tests, produces coverage report (Phase 8)
- **code-reviewer** -- Validates scenario coverage gate (Phase 9)
- **adversarial-reviewer** -- V8 behavior gap detection + D9 document pre-check (Phase 9)
```

### 3.9 New Template: `templates/reference/bdd-patterns.md`

A new BDD reference template for the plugin:

```markdown
# BDD Patterns Reference

## Gherkin-Like Syntax (Markdown)

BDD scenarios use Given/When/Then format in markdown (NOT .feature files):

### Scenario Structure

```
### SCENARIO-XXX: [Meaningful Behavior Title]
**Acceptance Criteria:** AC-XX from requirements
**Priority:** P0/P1/P2

**Given** [precondition in business language]
**When** [single action/event in business language]
**Then** [verifiable outcome in business language]
**And** [additional outcome if needed]
```

### Scenario ID Convention

- Format: `SCENARIO-001`, `SCENARIO-002`, ..., `SCENARIO-NNN`
- Sequential, zero-padded to 3 digits
- Unique within a single `01.1-behavior-scenarios.md`
- Referenced in tests: `describe('SCENARIO-001: ...')` or `// SCENARIO-001`

### Priority Levels

| Priority | Meaning | Test in Phase 8 |
|----------|---------|-----------------|
| P0 | Core business behavior (happy path) | Always |
| P1 | Important alternative/error path | Always |
| P2 | Edge case or secondary behavior | Always (coverage gate is 100%) |

## Writing Guidelines

### DO: Declarative Style

```
**Given** a premium subscriber with an active plan
**When** the subscriber accesses exclusive content
**Then** the content is displayed without restrictions
```

### DON'T: Imperative Style

```
**Given** the user is on the pricing page
**When** the user clicks the "Upgrade" button
**And** the user enters their credit card number
**Then** the page redirects to /dashboard
```

### Banned Words

click, navigate, type, enter, button, field, page, URL, endpoint,
database, API, HTTP, JSON, SQL, CSS, selector, element, component,
scroll, hover, tap, swipe, drag, drop, submit, form, redirect,
render, mount, DOM, query, request, response

## Traceability Matrix Pattern

```markdown
| Acceptance Criterion | Scenario IDs | Coverage |
|---------------------|-------------|----------|
| AC-01: [description] | SCENARIO-001, SCENARIO-002 | Covered |
| AC-02: [description] | SCENARIO-003 | Covered |
```

## Test Reference Patterns

### JavaScript/TypeScript
```javascript
describe('SCENARIO-001: Registered user accesses account', () => {
  it('should grant access with valid credentials', () => { ... });
});
```

### Python
```python
def test_scenario_001_registered_user_accesses_account():
    """SCENARIO-001: Registered user accesses account with valid credentials"""
    ...
```

### Rust
```rust
#[test]
fn scenario_001_registered_user_accesses_account() { ... }
```

### Go
```go
func TestScenario001_RegisteredUserAccessesAccount(t *testing.T) { ... }
```

## Quality Checklists

### Per-Scenario (Q1-Q10)
- Q1: Single behavior (one When/Then pair)
- Q2: Declarative style (WHAT not HOW)
- Q3: Business language (no jargon)
- Q4: Meaningful title
- Q5: Independent (self-contained)
- Q6: Concise (3-5 steps)
- Q7: Concrete examples
- Q8: AC traceability (AC-ID reference)
- Q9: No implementation leakage
- Q10: Testable outcome

### Per-Document (D1-D8)
- D1: All AC covered
- D2: No scenario explosion (3-8 per area)
- D3: Traceability matrix complete
- D4: Unique IDs
- D5: Priorities assigned
- D6: Happy path first
- D7: Error cases included
- D8: No duplicate behaviors
```

---

## 4. Data Flow

### 4.1 Complete Data Flow

```
Phase 2                     Phase 2.5                     Phase 6
requirements-clarifier      bdd-scenario-writer           spec-writer
        |                          |                          |
        v                          v                          v
01-requirements.md -------> 01.1-behavior-scenarios.md   06-specification.md
  (acceptance criteria        (Given/When/Then +             (references scenarios
   AC-01, AC-02, ...)          traceability matrix)           in testing strategy
                                   |                          section 5.4)
                                   |
                    +--------------+--------------+
                    |                             |
                    v                             v
              Phase 8: qa-agent            Phase 9: Reviews
              +-----------------------+    +---------------------------+
              | Reads scenario doc    |    | code-reviewer:            |
              | Maps SCENARIO-IDs     |    |   Step 6.1: Scenario      |
              | to test cases         |    |   coverage validation     |
              | Produces Scenario     |    |   Gap → Changes Requested |
              | Coverage Report:      |    |                           |
              |                       |    | adversarial-reviewer:     |
              | | SCENARIO-ID | Test  |    |   D9: Document pre-check  |
              | | SCENARIO-001| PASS  |    |   V8: Behavior coverage   |
              | | SCENARIO-002| PASS  |    |   Gap → High finding      |
              | Coverage: 100%        |    +---------------------------+
              +-----------------------+                |
                                                       v
                                              Combined Pass Criteria:
                                              1. Code Review: Approved
                                              2. Adversarial: PASS
                                              3. Scenario Coverage: 100%
                                              (all three must pass)
```

### 4.2 Document Formats

**Input: `01-requirements.md` (existing)**
- Contains acceptance criteria: `AC-01`, `AC-02`, ..., `AC-NN`
- Free-form markdown with structured AC section

**Output: `01.1-behavior-scenarios.md` (new, Phase 2.5)**
- Header with metadata (date, author, source, count)
- Scenarios with SCENARIO-XXX IDs, AC references, Given/When/Then
- Traceability matrix (AC → Scenario mapping)
- Coverage summary (must show 0 uncovered)
- Quality validation checklist results

**QA Output: Scenario Coverage Report (new section in QA report, Phase 8)**
- Structured table: SCENARIO-ID | Title | AC Ref | Test File | Test Name | Status
- Coverage summary: Total, Covered, Uncovered, Percentage

**Code Review Output: BDD Scenario Coverage (new section in review report, Phase 9)**
- Table: SCENARIO-ID | Title | Test Reference | Status (Covered/Missing)
- Gate: PASS/FAIL

**Adversarial Review Output: V8 + D9 findings (new entries in findings list, Phase 9)**
- D9 pre-check: Document existence and completeness
- V8 findings: Behavior coverage gaps tagged as Skeptic/V8

### 4.3 Scenario ID Convention

- Format: `SCENARIO-001`, `SCENARIO-002`, ..., `SCENARIO-NNN`
- Sequential, zero-padded to 3 digits
- Unique within a single `01.1-behavior-scenarios.md` document
- Referenced in test code as:
  - `describe('SCENARIO-001: ...')` (JavaScript/TypeScript)
  - `// SCENARIO-001` comment above test function
  - `test_scenario_001_...` function name (Python)
  - `scenario_001_...` function name (Rust)
  - `TestScenario001_...` function name (Go)

---

## 5. Quality Gates

### 5.1 Phase 2.5 Gate (bdd-scenario-writer self-validation)

**Per-Scenario (Q1-Q10):** Every scenario must pass all 10 checks.
**Per-Document (D1-D8):** The complete document must pass all 8 checks.

Exit criteria: `01.1-behavior-scenarios.md` exists with 100% AC coverage in traceability matrix.

### 5.2 Phase 8 Gate (qa-agent scenario mapping)

The qa-agent must produce a Scenario Coverage Report showing:
- Every SCENARIO-XXX from `01.1-behavior-scenarios.md` has at least one mapped test
- Every mapped test has been executed with a PASS/FAIL result

Exit criteria: Scenario Coverage Report section present in QA output.

### 5.3 Phase 9 Hard Gate (code-reviewer + adversarial-reviewer)

**Code Reviewer (step 6.1):**
- Read scenario document and QA coverage report
- Verify every SCENARIO-XXX has a passing test
- If ANY scenario lacks a passing test: verdict = "Changes Requested"

**Adversarial Reviewer (D9 + V8):**
- D9: Verify scenario document exists and has complete traceability matrix
- V8: Verify no behavior gaps between implementation and scenarios
- If gaps found: emit High severity finding

**Combined gate (all three required to proceed to Phase 10):**
1. Code Review verdict = Approved (or Approved with Comments)
2. Adversarial Review verdict = PASS
3. BDD Scenario Coverage = 100%

### 5.4 Workflow Tracking JSON Update

Phase 2.5 is tracked in the workflow JSON phases array:
```json
{ "id": 2.5, "name": "BDD Scenario Writing", "status": "pending|in_progress|complete" }
```

---

## 6. Edge Cases

### 6.1 Ambiguous Acceptance Criteria

**Trigger:** An AC in `01-requirements.md` is too vague (e.g., "system should be fast").

**Handling:** The bdd-scenario-writer flags the AC as `[AMBIGUOUS: needs clarification]` in the scenario document. The traceability matrix shows the AC as "Flagged" rather than "Covered." The coordinator must resolve ambiguity before Phase 3 proceeds.

### 6.2 Non-Functional Acceptance Criteria

**Trigger:** An AC is purely non-functional (e.g., "response time < 200ms").

**Handling:** The bdd-scenario-writer notes the AC as a constraint in the scenario document rather than forcing it into Given/When/Then format. The constraint is listed separately and excluded from the scenario coverage gate (it remains a TDD/performance test concern).

### 6.3 Zero Acceptance Criteria

**Trigger:** `01-requirements.md` exists but contains no acceptance criteria.

**Handling:** This should not occur because the requirements-clarifier agent always produces ACs. If it does occur, Phase 2.5 flags it as an error and the coordinator loops back to Phase 2 for correction.

### 6.4 Scenario Coverage Fails in Phase 9

**Trigger:** Code reviewer finds SCENARIO-XXX without a passing test.

**Handling:** Standard Phase 8/9 iteration loop. The coordinator creates remediation tasks specifying the missing scenario IDs and re-spawns dev-executor + qa-agent. The loop continues until 100% scenario coverage is achieved.

### 6.5 Test Passes But Scenario Is Wrong

**Trigger:** A test references SCENARIO-XXX but tests different behavior than described.

**Handling:** The adversarial reviewer (V8 vector) catches this by cross-referencing test behavior with scenario description. If the test does not match the scenario intent, a finding is emitted.

---

## 7. Acceptance Criteria Verification Plan

| AC | Description | Verified By | How |
|----|-------------|-------------|-----|
| AC-01 | bdd-scenario-writer agent exists at `agents/bdd-scenario-writer.md` | File existence check | Verify file exists with correct YAML frontmatter (name, description) |
| AC-02 | Coordinator includes Phase 2.5 in phase flow | Read `agents/coordinator.md` | Verify Phase 2.5 line exists in Phase Flow section, spawn table, delegate table |
| AC-03 | Phase 2.5 produces `01.1-behavior-scenarios.md` with Given/When/Then mapped to AC | Run Phase 2.5 on test requirements | Verify output file contains scenarios with AC references and traceability matrix |
| AC-04 | qa-agent reads BDD scenarios and includes scenario coverage in test report | Read `agents/qa-agent.md` | Verify BDD Scenario Coverage section in Test Plan template and quality gates |
| AC-05 | Phase 9 includes deterministic scenario coverage check | Read `agents/code-reviewer.md` | Verify step 6.1 (BDD Scenario Coverage Validation) and verdict logic change |
| AC-06 | Workflow tracking JSON includes Phase 2.5 | Read coordinator Phase 2.5 spawn | Verify JSON schema includes `{ "id": 2.5, "name": "BDD Scenario Writing" }` |
| AC-07 | SKILL.md includes Phase 2.5 in phase list and enforcement table | Read `skills/super-dev/SKILL.md` | Verify phase checklist, enforcement table, team roles, spawn table all have Phase 2.5 |
| AC-08 | Phase 2.5 is mandatory (not skippable) | Read skip conditions table | Verify "Never skip" entry in both coordinator and SKILL.md |
| AC-09 | Existing TDD workflow and phases 0-13 work without regression | Read all modified files | Verify no removal of existing functionality; BDD additions are purely additive |
| AC-10 | Scenario document includes traceability matrix | Read agent output template | Verify "Scenario-Acceptance Criteria Traceability Matrix" section in output template |

---

## 8. References

- Requirements (super-dev:requirements-clarifier): `./01-requirements.md`
- Research Report (super-dev:research-agent): `./02-research-report.md`
- Assessment (super-dev:code-assessor): `./03-code-assessment.md`
- Architecture (super-dev:architecture-agent): `./04-architecture-design.md`
