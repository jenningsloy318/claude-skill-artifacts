# Requirements: BDD Integration into Super-Dev Process

**Date:** 2026-03-15
**Type:** Feature (Plugin Enhancement)
**Priority:** High

## Executive Summary

The super-dev plugin currently follows a TDD-centric testing approach where acceptance criteria in requirements documents (Phase 2) are disconnected from the automated tests written in Phase 8. BDD integration bridges this gap by introducing behavior specifications in Given/When/Then format that serve as both human-readable acceptance criteria AND executable test scaffolds, creating a traceable chain from requirements through implementation to verification.

## The Real Need (Root Cause Analysis)

### Surface Request

Integrate BDD (Behavior-Driven Development) into the super-dev plugin workflow so that feature behavior is described in natural language scenarios that directly map to automated tests.

### 5 Whys Analysis

1. **Why BDD?** The acceptance criteria in `01-requirements.md` are written in free-form markdown and have no direct connection to the test code written in Phase 8.
2. **Why is disconnection a problem?** When Phase 9 (code review + adversarial review) checks if "all acceptance criteria are met," this verification is manual — a reviewer must read the criteria and mentally map them to test results, which is error-prone.
3. **Why does this matter for the workflow?** The Phase 8/9 iteration loop (which repeats until Critical=0, High=0, Medium=0, and acceptance criteria met) can produce false positives: criteria marked "met" without corresponding executable proof.
4. **Why can't TDD alone solve this?** TDD tests are code-level (unit/integration/E2E) and use technical naming (`userLogin_should_returnToken_when_credentialsValid`). They verify implementation correctness but don't express business-level behavior in a way that maps 1:1 to acceptance criteria.
5. **Why does this root cause matter?** Without executable acceptance criteria, the quality gate between Phase 9 and Phase 10 lacks deterministic verification — the workflow's reliability depends on reviewer judgment rather than provable test coverage of stated requirements.

### Job to Be Done

**When** developing features through the super-dev workflow,
**I want to** have acceptance criteria automatically verified as executable behavior specifications,
**So I can** confidently know that every stated requirement has a corresponding passing test, and the Phase 8/9 loop terminates only when ALL behaviors are provably verified.

**Job Type:**
- Functional: Bridge requirements (Phase 2) to tests (Phase 8) with traceable behavior specs
- Emotional: Confidence that "acceptance criteria met" means provably verified, not assumed
- Social: Produce living documentation that any stakeholder can read and understand

## Workflow Context

### Current State

```
Phase 2: Requirements Clarifier                Phase 8: QA Agent
┌───────────────────────────┐                  ┌────────────────────────────┐
│ 01-requirements.md        │                  │ Tests written in code      │
│                           │   NO DIRECT      │                            │
│ ## Acceptance Criteria    │◄──CONNECTION──►   │ describe('Feature', () =>  │
│ - [ ] User can login      │                  │   it('should login', ...)  │
│ - [ ] Error shown on fail │                  │ })                         │
└───────────────────────────┘                  └────────────────────────────┘
                                                         │
                                                         ▼
                                               Phase 9: Code Reviewer
                                               ┌────────────────────────────┐
                                               │ Manual check:              │
                                               │ "Are acceptance criteria   │
                                               │  covered by tests?"        │
                                               │ (subjective judgment)      │
                                               └────────────────────────────┘
```

### Pain Points

1. **Acceptance criteria are prose, tests are code** — no structural link between them
2. **Phase 9 verification is subjective** — reviewer must manually map criteria to test results
3. **No living documentation** — requirements docs become stale after implementation
4. **Phase 8/9 loop false positives** — criteria can be marked "met" without executable proof
5. **TDD tests lack business context** — test names like `should_returnToken_when_credentialsValid` don't map to user stories
6. **No behavior-level regression** — if a behavior breaks, the test failure message is technical, not requirement-oriented

### Proposed Workflow with BDD

```
Phase 2: Requirements          Phase 2.5 (NEW): BDD Scenarios       Phase 8: QA Agent
┌──────────────────────┐      ┌────────────────────────────────┐    ┌──────────────────────┐
│ 01-requirements.md   │      │ 01.1-behavior-scenarios.md     │    │ Tests generated from  │
│                      │─────▶│                                │───▶│ behavior scenarios    │
│ ## Acceptance Criteria│      │ Feature: User Authentication   │    │                      │
│ - [ ] User can login │      │   Scenario: Successful Login   │    │ Given/When/Then maps │
│ - [ ] Error on fail  │      │     Given a registered user    │    │ to test steps        │
└──────────────────────┘      │     When they enter valid creds│    └──────────────────────┘
                              │     Then they see dashboard    │              │
                              │                                │              ▼
                              │   Scenario: Failed Login       │    Phase 9: Deterministic
                              │     Given a registered user    │    ┌──────────────────────┐
                              │     When they enter wrong pass │    │ Automated check:     │
                              │     Then error message shown   │    │ "All scenarios pass?" │
                              └────────────────────────────────┘    │ (provable, not guess) │
                                                                    └──────────────────────┘
```

### Stakeholders

- **super-dev Coordinator (Team Lead)**: Orchestrates phases, needs to know when BDD scenarios should be generated
- **requirements-clarifier agent**: Produces acceptance criteria that become BDD scenario seeds
- **qa-agent**: Needs to consume BDD scenarios as test plans and verify scenario coverage
- **code-reviewer**: Needs deterministic criteria-to-test mapping for Phase 9 verification
- **adversarial-reviewer**: Checks completeness — BDD scenarios make missing coverage more visible
- **spec-writer agent**: May reference BDD scenarios in the technical specification
- **dev-executor agent**: Implementation guided by behavior scenarios (outside-in development)

## Requirements

### Functional Requirements

#### FR-1: BDD Scenario Generation

A mechanism to transform acceptance criteria from `01-requirements.md` into structured Given/When/Then behavior scenarios (Gherkin-like format). The output is a markdown document (`01.1-behavior-scenarios.md`) stored in the spec directory.

#### FR-2: Scenario-to-Test Traceability

Each BDD scenario MUST have a unique identifier (e.g., `SCENARIO-001`) that maps to one or more test cases in Phase 8. The qa-agent MUST report scenario coverage (scenarios with passing tests vs. total scenarios).

#### FR-3: Phase Integration

BDD scenario generation integrates into the super-dev workflow at a defined point between requirements (Phase 2) and execution (Phase 8). The coordinator must know when and how to trigger BDD scenario work.

#### FR-4: Scenario Verification in Phase 9

Phase 9 (code review + adversarial review) gains a deterministic quality gate: "all BDD scenarios have at least one corresponding passing test." This replaces the current subjective "acceptance criteria met" check for behavioral requirements.

#### FR-5: Living Documentation Output

After Phase 8 completes, a behavior verification report is produced showing each scenario's pass/fail status, creating living documentation that stays in sync with the codebase.

#### FR-6: Backward Compatibility with TDD

BDD augments, not replaces, the existing TDD workflow. Unit tests, integration tests, and E2E tests continue as before. BDD scenarios add a business-behavior layer on top.

### Non-Functional Requirements

- **Minimal disruption**: No changes to Phase 0, 1, 3-5, 10-13 unless strictly necessary
- **Performance**: BDD scenario generation should not significantly increase total workflow time (target: < 2 min added overhead)
- **Consistency**: BDD artifacts follow the same spec directory naming conventions (`01.1-behavior-scenarios.md`, etc.)
- **Agent pattern consistency**: Any new agent or skill follows the same patterns as existing ones (agent markdown frontmatter, tool declarations, output format)

### Anticipated Downstream Needs

Based on workflow analysis:

1. **Scenario-driven development**: Dev-executor could use BDD scenarios to guide implementation order (outside-in), implementing from behavior scenarios inward — this is a future enhancement, not required for v1
2. **Scenario templates per domain**: Over time, common scenario patterns (auth flows, CRUD operations, API endpoints) could be templated — future enhancement
3. **Coverage gap detection**: Adversarial reviewer could check for acceptance criteria WITHOUT corresponding BDD scenarios — enhancement to adversarial reviewer
4. **Regression behavior reports**: Producing a behavior status dashboard for ongoing projects — future enhancement

## Proposed Solution Options

### Option 1: Minimal — BDD Scenario Document Only (No New Phase)

Add BDD scenario generation as a sub-task within Phase 2 (requirements-clarifier). The requirements-clarifier produces both `01-requirements.md` AND `01.1-behavior-scenarios.md`. The qa-agent in Phase 8 reads the scenarios to inform test planning.

**What changes:**
- requirements-clarifier agent: Extended to also produce BDD scenario document
- qa-agent: Enhanced to read BDD scenarios and map tests to scenario IDs
- Phase 9 quality gate: Add "scenario coverage" check

**Pros:**
- Minimal structural change — no new phases, agents, or skills
- Reuses existing requirements-clarifier context (it already has the acceptance criteria)
- Smallest implementation effort

**Cons:**
- Requirements-clarifier becomes overloaded (already has a large prompt)
- BDD scenario generation requires different expertise than requirements elicitation
- No separation of concerns — mixing requirement gathering with behavior specification

### Option 2: Recommended — New BDD Agent + Phase 2.5

Introduce a new `bdd-scenario-writer` agent and a new Phase 2.5 that runs after requirements (Phase 2) and before research (Phase 3). This agent consumes `01-requirements.md` and produces `01.1-behavior-scenarios.md`.

**What changes:**
- NEW agent: `agents/bdd-scenario-writer.md`
- Coordinator: Add Phase 2.5 to the workflow
- qa-agent: Enhanced to read BDD scenarios and report scenario coverage
- Phase 9 quality gate: Add deterministic scenario verification
- SKILL.md: Updated workflow phases list
- Workflow tracking JSON: Add Phase 2.5

**Pros:**
- Clean separation of concerns — dedicated agent for behavior specification
- Consistent with existing pattern (each phase has its own agent)
- BDD agent can be specialized with Gherkin expertise
- Easy to skip if project doesn't need BDD (like Phase 4 is skipped for non-bugs)

**Cons:**
- One more agent to maintain
- Adds a sequential step to the workflow (minor time cost)
- Requires coordinator update

### Option 3: Comprehensive — Full BDD Lifecycle (Agent + Skill + Phase + Review Gate)

Everything in Option 2, plus:
- NEW skill: `skills/bdd-workflow/SKILL.md` (like `tdd-workflow` but for BDD)
- NEW command: `commands/bdd.md` (like `commands/tdd.md`)
- Enhanced adversarial reviewer: New attack vector V8 (Behavior Coverage — checks for acceptance criteria without scenarios)
- Dev-executor enhancement: Outside-in development guided by scenarios
- New testing rule in `rules/testing.md`: BDD requirements

**What changes:**
- Everything in Option 2
- NEW skill: `skills/bdd-workflow/SKILL.md`
- NEW command: `commands/bdd.md`
- adversarial-reviewer: New V8 vector
- dev-executor: Scenario-aware implementation
- rules/testing.md: BDD requirements added

**Pros:**
- Full BDD lifecycle integrated
- Scenarios drive development AND testing
- Maximum traceability
- Most robust quality gate

**Cons:**
- Largest implementation effort
- May be over-engineered for initial release
- More files to maintain
- Risk of overcomplicating the already complex 14-phase workflow

## Impact Assessment

### Business Outcome

Increases confidence in the super-dev workflow's quality gates by making acceptance criteria verification deterministic rather than subjective. Reduces the probability of shipping features that technically pass tests but don't fully satisfy stated requirements.

### Success Metrics

- **Scenario coverage**: 100% of acceptance criteria in `01-requirements.md` have corresponding BDD scenarios
- **Test-scenario mapping**: 100% of BDD scenarios have at least one corresponding test in Phase 8
- **Phase 9 determinism**: Phase 9 can automatically verify scenario coverage without manual interpretation
- **No workflow regression**: Existing phases (0-13) continue to work for projects that don't use BDD

### Behavior Change Expected

- Coordinator spawns BDD agent after requirements phase
- QA agent produces scenario coverage report alongside test results
- Code reviewer uses scenario coverage as a quality gate (pass/fail) instead of subjective assessment
- Requirements documents gain actionable, testable behavior specifications

## Technical Considerations

### Integration Points

| Component | Integration Type | Description |
|-----------|-----------------|-------------|
| `agents/coordinator.md` | Modify | Add Phase 2.5, update phase flow, update quality gates |
| `agents/requirements-clarifier.md` | Minor modify | Ensure acceptance criteria format is BDD-compatible |
| `agents/qa-agent.md` | Modify | Add scenario consumption, coverage tracking, scenario report |
| `agents/code-reviewer.md` | Minor modify | Add scenario coverage quality gate |
| `agents/bdd-scenario-writer.md` | New | BDD scenario generation agent |
| `skills/super-dev/SKILL.md` | Modify | Add Phase 2.5 to workflow phases list |
| `rules/testing.md` | Minor modify | Add BDD testing references |

### Technical Constraints

1. **No external dependencies**: BDD scenarios are markdown-based (Gherkin-like syntax), not requiring Cucumber/SpecFlow/etc. — the super-dev plugin is tool-agnostic
2. **Agent markdown pattern**: New agent must follow the existing frontmatter format (`name`, `description`, `tools`)
3. **Spec directory convention**: BDD scenario file follows the numbering convention (e.g., `01.1-behavior-scenarios.md`)
4. **Workflow tracking JSON**: Phase 2.5 must be tracked in the JSON schema
5. **Skip condition**: Phase 2.5 should be skippable (like Phase 4 for non-bugs) when BDD isn't needed (e.g., trivial fixes, documentation-only changes)

### Scenario Document Format (Proposed)

```markdown
# Behavior Scenarios: [Feature Name]

**Date:** [timestamp]
**Source:** ./01-requirements.md
**Total Scenarios:** [count]

## Feature: [Feature Name]

### SCENARIO-001: [Scenario Name]
**Acceptance Criteria:** AC-001 from requirements
**Priority:** P0/P1/P2

**Given** [initial context/precondition]
**When** [action/event]
**Then** [expected outcome]

**Examples:**
| Input | Expected |
|-------|----------|
| [value1] | [result1] |
| [value2] | [result2] |

### SCENARIO-002: [Scenario Name]
...

## Scenario-Acceptance Criteria Traceability Matrix

| Acceptance Criterion | Scenarios |
|---------------------|-----------|
| AC-001: User can login | SCENARIO-001, SCENARIO-002 |
| AC-002: Error on failure | SCENARIO-003 |

## Coverage Summary
- Acceptance Criteria: [X] total, [Y] covered by scenarios, [Z] uncovered
- Uncovered Criteria: [list any AC without scenarios]
```

## Assumptions

1. **BDD scenarios are markdown, not Gherkin DSL**: We use Gherkin-like syntax in markdown, not actual `.feature` files, because the super-dev plugin is language/framework-agnostic
2. **Scenario-to-test mapping is by ID, not file convention**: Tests reference scenario IDs in comments or test names (e.g., `// SCENARIO-001` or `describe('SCENARIO-001: Successful Login', ...)`)
3. **BDD is optional per project**: Some tasks (trivial fixes, doc updates) don't need BDD — the coordinator can skip Phase 2.5
4. **No Cucumber/SpecFlow runtime**: This is a specification practice, not a test framework change — existing test runners (Jest, Vitest, Playwright) are preserved
5. **Phase 2.5 runs sequentially after Phase 2**: It needs the requirements document as input, so it cannot be parallelized with Phase 2

## Open Questions

- [ ] **Q1**: Should the BDD scenario writer agent also produce scenario outlines for edge cases, or only for the acceptance criteria listed in requirements?
- [ ] **Q2**: Should Phase 2.5 be mandatory for all feature requests, or only when the user/coordinator decides BDD is needed?
- [ ] **Q3**: For the Phase 9 quality gate, should "scenario coverage" be a hard gate (blocks progress) or a soft gate (warning only)?
- [ ] **Q4**: Should the BDD scenario document be a separate file (`01.1-behavior-scenarios.md`) or a section within the requirements document?
- [ ] **Q5**: Should we support Scenario Outlines (parameterized scenarios with Examples tables) in v1, or keep it simple with individual scenarios?

## Acceptance Criteria

- [ ] **AC-01**: A new BDD scenario writer agent exists at `agents/bdd-scenario-writer.md` following existing agent markdown patterns
- [ ] **AC-02**: The coordinator workflow includes Phase 2.5 (BDD Scenario Generation) in the phase flow, triggered after Phase 2 completion
- [ ] **AC-03**: Phase 2.5 produces `01.1-behavior-scenarios.md` in the spec directory with Given/When/Then scenarios mapped to acceptance criteria
- [ ] **AC-04**: The qa-agent reads BDD scenarios from `01.1-behavior-scenarios.md` and includes scenario coverage in its test report
- [ ] **AC-05**: Phase 9 quality gate includes a deterministic check: "all BDD scenarios have corresponding passing tests"
- [ ] **AC-06**: The workflow tracking JSON schema is updated to include Phase 2.5
- [ ] **AC-07**: `skills/super-dev/SKILL.md` is updated to include Phase 2.5 in the workflow phases list and phase enforcement table
- [ ] **AC-08**: Phase 2.5 is skippable (like Phase 4) when BDD is not needed, with a documented skip condition
- [ ] **AC-09**: Existing TDD workflow and all other phases (0-13) continue to work without regression
- [ ] **AC-10**: The scenario document includes a traceability matrix mapping acceptance criteria to scenario IDs

## Recommendations

Based on the analysis, I recommend:

1. **Immediate (this spec)**: Implement **Option 2** — New BDD agent + Phase 2.5. This provides clean separation of concerns, follows existing patterns, and delivers the core value (traceable behavior specs) without overcomplicating the workflow.

2. **Next iteration**: Enhance the adversarial reviewer with a V8 "Behavior Coverage" vector that checks for acceptance criteria without corresponding BDD scenarios. This strengthens Phase 9 quality gates.

3. **Future roadmap**: Consider the comprehensive Option 3 additions (BDD skill, BDD command, scenario-driven development) once the core BDD integration proves valuable in practice.

## Dependencies Map

```
Phase 2 (requirements-clarifier)
    │
    │ produces 01-requirements.md with acceptance criteria
    │
    ▼
Phase 2.5 (NEW: bdd-scenario-writer)  ◄── Consumes AC from Phase 2
    │
    │ produces 01.1-behavior-scenarios.md with Given/When/Then
    │
    ├──────────────────────────────────────────┐
    ▼                                          ▼
Phase 6 (spec-writer)                    Phase 8 (qa-agent)
    │                                          │
    │ references scenarios                     │ maps tests to scenario IDs
    │ in testing strategy                      │ produces scenario coverage report
    │                                          │
    └──────────────────────────────────────────┘
                       │
                       ▼
              Phase 9 (code-reviewer + adversarial-reviewer)
                       │
                       │ deterministic scenario coverage gate
                       ▼
              Phase 10 (docs-executor)
```

## Components Affected Summary

| Component | Change Type | Effort |
|-----------|-------------|--------|
| `agents/bdd-scenario-writer.md` | **New file** | Medium |
| `agents/coordinator.md` | Modify (add Phase 2.5) | Small |
| `agents/qa-agent.md` | Modify (scenario consumption) | Medium |
| `agents/code-reviewer.md` | Minor modify (quality gate) | Small |
| `skills/super-dev/SKILL.md` | Modify (phase list, enforcement table) | Small |
| `rules/testing.md` | Minor modify (BDD reference) | Small |
| Workflow tracking JSON schema | Schema update (Phase 2.5) | Small |
