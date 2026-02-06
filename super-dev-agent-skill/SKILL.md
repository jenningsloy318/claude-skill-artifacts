---
name: super-dev
description: Coordinator-driven development workflow with parallel agent execution for implementing features, fixing bugs, and refactoring code. Activates a team-based development system with specialized agents for requirements clarification, research, debugging, code assessment, architecture design, UI/UX design, specification writing, implementation, QA testing, code review, and documentation. Use when implementing new features, fixing bugs, optimizing performance, refactoring code, or conducting comprehensive development tasks.
license: MIT
metadata:
  author: Jennings Liu
  version: "2.1.0"
  homepage: https://github.com/jenningsloy318/super-skill-claude-artifacts
  repository: https://github.com/jenningsloy318/super-skill-claude-artifacts
  keywords:
    - development
    - workflow
    - debugging
    - implementation
    - refactoring
    - specification
    - coordinator
    - parallel
    - agent-teams
---

# Super Dev Workflow - Agent Teams Edition

A team-based development system where the Coordinator acts as Team Lead, orchestrating specialized teammate agents who work independently with their own context windows, communicate directly, and share a task list for self-coordination.

## When to Use

Activate super-dev for:
- Bug fixes, build warnings/errors
- New features, improvements
- Performance optimization
- Deprecation resolution
- Refactoring
- Complex development tasks requiring multiple specialists

## Quick Start

To start a development task:

```
I'm using super-dev to implement: [describe your task]
```

The Coordinator will automatically orchestrate all workflow phases.

## Workflow Phases

```
- [ ] Phase 0:  Apply Dev Rules
- [ ] Phase 1:  Specification Setup (worktree + team creation)
- [ ] Phase 2:  Requirements Clarification
- [ ] Phase 3:  Research (options presentation)
- [ ] Phase 4:  Debug Analysis (bugs only)
- [ ] Phase 5:  Code Assessment
- [ ] Phase 5.3: Architecture Design (complex features)
- [ ] Phase 5.5: UI/UX Design (UI features)
- [ ] Phase 6:  Specification Writing
- [ ] Phase 7:  Specification Review
- [ ] Phase 8:  Execution & QA (PARALLEL agents)
- [ ] Phase 9:  Code Review
- [ ] Phase 10: Documentation Update
- [ ] Phase 11: Cleanup
- [ ] Phase 12: Commit & Merge to Main
- [ ] Phase 13: Final Verification & Team Cleanup
```

**Iteration Rule:** Loop Phase 8/9 until Critical=0, High=0, Medium=0, all acceptance criteria met.

## Available Agents

### Core Workflow Agents

These agents are spawned by the Coordinator during the workflow:

| Agent | Phase | Purpose | Spawn Command |
|-------|-------|---------|---------------|
| `requirements-clarifier` | 2 | Gather and document complete requirements | Spawn agent: requirements-clarifier |
| `research-agent` | 3 | Research best practices and present options | Spawn agent: research-agent |
| `debug-analyzer` | 4 | Root cause analysis for bugs | Spawn agent: debug-analyzer |
| `code-assessor` | 5 | Evaluate existing codebase patterns | Spawn agent: code-assessor |
| `architecture-agent` | 5.3 | Design architecture and create ADRs | Spawn agent: architecture-agent |
| `ui-ux-designer` | 5.5 | Create UI/UX design specifications | Spawn agent: ui-ux-designer |
| `spec-writer` | 6 | Write technical specifications and plans | Spawn agent: spec-writer |
| `dev-executor` | 8 | Implement code changes | Spawn agent: dev-executor |
| `qa-agent` | 8, 9.5 | Plan and run tests | Spawn agent: qa-agent |
| `code-reviewer` | 9 | Specification-aware code review | Spawn agent: code-reviewer |
| `docs-executor` | 10 | Update documentation | Spawn agent: docs-executor |

### Developer Specialist Agents

| Agent | Purpose | Spawn Command |
|-------|---------|---------------|
| `rust-developer` | Rust systems programming | Spawn agent: rust-developer |
| `golang-developer` | Go backend development | Spawn agent: golang-developer |
| `frontend-developer` | React/Next.js/TypeScript development | Spawn agent: frontend-developer |
| `backend-developer` | Node.js/Python backend development | Spawn agent: backend-developer |
| `android-developer` | Kotlin/Jetpack Compose development | Spawn agent: android-developer |
| `ios-developer` | Swift/SwiftUI development | Spawn agent: ios-developer |
| `macos-app-developer` | Swift/SwiftUI/AppKit development | Spawn agent: macos-app-developer |
| `windows-app-developer` | C#/.NET/WinUI development | Spawn agent: windows-app-developer |

### Utility Agents

| Agent | Purpose | Spawn Command |
|-------|---------|---------------|
| `planner` | Implementation planning | Spawn agent: planner |
| `tdd-guide` | Test-driven development workflow | Spawn agent: tdd-guide |
| `security-reviewer` | Security analysis and review | Spawn agent: security-reviewer |
| `build-error-resolver` | Fix build and type errors | Spawn agent: build-error-resolver |
| `refactor-cleaner` | Dead code cleanup | Spawn agent: refactor-cleaner |
| `doc-updater` | Documentation updates | Spawn agent: doc-updater |
| `e2e-runner` | Playwright E2E testing | Spawn agent: e2e-runner |
| `search-agent` | Multi-source search | Spawn agent: search-agent |

## Direct Commands

You can also invoke specific capabilities directly:

```
# Planning
/plan - Create implementation plan with planner agent

# Testing
/tdd - Test-driven development workflow
/e2e - Generate and run E2E tests
/test-coverage - Check test coverage

# Code Quality
/code-review - Specification-aware code review
/security-review - Security analysis
/build-fix - Fix build and type errors
/refactor-clean - Remove dead code

# Documentation
/update-docs - Update documentation
/update-codemaps - Update code maps

# Research
/research - Multi-source research
/learn - Extract patterns from sessions
```

## Architecture Overview

```
                    ┌─────────────────┐
                    │   Coordinator   │ ◄── Team Lead (Orchestration)
                    │   (Team Lead)   │     Spawns teammates
                    └────────┬────────┘     Manages shared task list
                             │              Coordinates via messaging
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│   Planning    │   │   Analysis    │   │  Execution    │
│   Teammates   │   │   Teammates   │   │  Teammates    │
│ - Research    │   │ - Debug       │   │ - Dev         │
│ - Requirements│   │ - Assessment  │   │ - QA          │
│ - Architecture│   │ - Code Review │   │ - Docs        │
│ - UI/UX       │   │               │   │               │
└───────────────┘   └───────────────┘   └───────────────┘
        Own context         Own context         Own context
        Direct msg          Direct msg          Direct msg
```

## Phase-by-Phase Execution

### Phase 0: Apply Dev Rules

**Establish coding standards and guidelines at the start of any development task:**

## Time MCP Rules (MUST follow)
- In every prompt, add the current date and time as extra context

## Git Rules (MUST follow)
- Never create GitHub Actions when creating new projects or updating code
- If GitHub Actions already exist, don't add to git cache, don't commit, don't push
- When committing, only commit files you edited - ignore files not created/edited by you in this session
- Don't use `git add -A` - use `git add file1 file2` (only files you edited/created/deleted)
- Before committing, **ALWAYS** generate proper commit messages

## Rust Project Rules (MUST follow)

### Workspace Structure
- **Always use Rust workspace** with multiple crates for any Rust project
- Never create single-crate Rust projects
- Workspace structure:
  ```
  project/
  ├── Cargo.toml          # Workspace manifest
  ├── Cargo.lock          # Lockfile (committed)
  ├── crates/
  │   ├── crate-a/       # Main application
  │   │   └── Cargo.toml
  │   ├── crate-b/       # Library
  │   │   └── Cargo.toml
  │   └── crate-c/       # Binary
  │       └── Cargo.toml
  └── ...
  ```

### Crate Organization
- **Library crates** in `crates/[name]/` with `Cargo.toml`
- **Binary crates** in `crates/[name]/` with `Cargo.toml` and `src/main.rs`
- Use `members` in workspace `Cargo.toml` to include all crates
- Share dependencies in workspace `Cargo.toml` when appropriate

### Key Principles
- Each crate should have a single, clear responsibility
- Use workspace `Cargo.toml` for shared configuration
- Keep `Cargo.lock` committed for binaries
- Use `cargo check --workspace` for validation
- Use `cargo test --workspace` for testing

## Development Philosophy

### Core Principles
- **First Principles Analysis**: For complex features and bug fixes, break down to fundamental truths and build up from there
- **Incremental Development**: Small commits, each must compile and pass tests
- **Learn from Existing Code**: Research and plan before implementing
- **Pragmatic over Dogmatic**: Adapt to project's actual situation
- **Clear Intent over Clever Code**: Choose simple, clear solutions
- Avoid over-engineering - keep code simple, easy to understand, practical
- Watch cyclomatic complexity - maximize code reuse
- Focus on modular design - use design patterns where appropriate
- Minimize changes - avoid modifying code in other modules

### New Requirements Process
1. **Don't rush to code**: When user proposes new requirements, discuss the solution first
2. **Use ASCII diagrams**: When necessary, draw comparison diagrams for multiple solutions, let user choose
3. **Confirm before developing**: Only start development after user explicitly confirms the solution

### Implementation Process
1. **Understand existing patterns**: Study 3 similar features/components in the codebase
2. **Identify common patterns**: Find project conventions and patterns
3. **Follow existing standards**: Use same libraries/tools, follow existing test patterns
4. **Implement in phases**: Break complex work into 3-5 phases

### Quality Standards
- Every commit must compile successfully
- Pass all existing tests
- Include tests for new functionality
- Follow project formatting/linting rules

### Decision Framework Priority
1. **Testability** - Is it easy to test?
2. **Readability** - Will it be understandable in 6 months?
3. **Consistency** - Does it match project patterns?
4. **Simplicity** - Is it the simplest viable solution?
5. **Reversibility** - How hard to modify later?

### Error Handling & When Stuck
- Stop after maximum 3 attempts
- Record failure reasons and specific error messages
- Research 2-3 alternative implementation approaches
- Question basic assumptions: Is it over-abstracted? Can it be decomposed?

### Phase 1: Specification Setup

**Executed by:** Coordinator (Team Lead)

1. **Define Spec Directory Name**: `[spec-index]-[spec-name]` (e.g., `01-user-auth`)
2. **Create Git Worktree**: `git worktree add .worktree/[spec-index]-[spec-name] -b [spec-index]-[spec-name]`
3. **Create Spec Directory**: `mkdir -p specification/[spec-index]-[spec-name]/`
4. **Initialize Workflow Tracking JSON**: Create workflow tracking file
5. **Setup Complete**: Verify all artifacts exist

**Branch Name Rule:** Git branch name MUST match worktree name.

### Phase 2: Requirements Clarification

**Agent:** `requirements-clarifier`

```
Task: Gather and document complete requirements for [feature/bug]
Output: specification/[spec-index]-[spec-name]/[doc-index]-requirements.md
```

#### Requirements Clarifier Methodology

The Requirements Clarifier uses structured questioning techniques to ensure all aspects of a task are understood:

##### Process

**Step 1: Initial Analysis**

Analyze the task description and identify:
- What is being requested?
- What problem is being solved?
- Who are the stakeholders?
- What are the constraints?

**Step 2: Structured Questioning Techniques**

**Design Thinking Questions:**
- What is the user trying to achieve?
- What are their pain points?
- What does success look like?

**5 Whys Analysis:**
- Why is this feature needed?
- Why does that problem exist?
- Continue until root cause is identified

**Jobs-to-be-Done (JTBD):**
- What "job" is the user hiring this feature to do?
- What are the functional, emotional, and social dimensions?

**Step 3: Define Acceptance Criteria**

Create clear, testable acceptance criteria:

**Good Criteria:**
- "User can log in with email and password"
- "Login completes within 2 seconds"
- "Error message displays for invalid credentials"

**Poor Criteria:**
- "Login works well"
- "Fast login"

**Step 4: Identify Downstream Needs**

Consider what other work may be triggered:
- Database schema changes?
- API modifications?
- Frontend updates?
- Documentation updates?
- Testing requirements?

**Step 5: Define Quality Gates**

Define measurable quality gates:
- Test coverage thresholds
- Performance benchmarks
- Security requirements
- Accessibility standards

### Phase 3: Research

**Agent:** `research-agent`

```
Task: Research best practices for [feature/technology]
Output: specification/[spec-index]-[spec-name]/[doc-index]-research-report.md with 3-5 options
```

**Coordinator presents options to user for selection.**

#### Research Methodology

##### Multi-Source Search

Conduct research across multiple sources:

1. **Official Documentation (Context7)**
   - API references
   - Configuration guides
   - Best practice documentation

2. **Code Examples (GitHub Search)**
   - Real-world implementations
   - Popular patterns
   - Common pitfalls

3. **Web Search (Exa/Perplexity)**
   - Latest best practices
   - Community discussions
   - Recent tutorials

4. **Repository Analysis (DeepWiki)**
   - How similar projects implement features
   - Architecture patterns
   - Design decisions

##### Query Expansion

For each research topic, expand queries:

**Base Query:** "React state management"

**Expanded Queries:**
- "React state management 2024 best practices"
- "React Zustand vs Redux vs Context"
- "React state management performance comparison"
- "React server state vs client state"

##### Option Presentation Format

Present 3-5 options with consistent format:

```markdown
## Option N: [Name]

### Overview
Brief description of the approach.

### Pros
- Advantage 1
- Advantage 2

### Cons
- Disadvantage 1
- Disadvantage 2

### Trade-offs
- Trade-off 1
- Trade-off 2

### When to Choose
- Criteria for selecting this option

### Implementation Complexity
- Low / Medium / High

### Example
```code
// Example implementation
```

### References
- [Source 1](url)
- [Source 2](url)
```

Include a comparison matrix:

| Criteria | Option 1 | Option 2 | Option 3 |
|----------|----------|----------|----------|
| Performance | High | Medium | High |
| Complexity | Low | Medium | High |
| Learning Curve | Low | Medium | High |
| Community | Large | Medium | Small |
| Maintenance | Easy | Medium | Hard |

### Phase 4: Debug Analysis (Bugs Only)

**Agent:** `debug-analyzer`

```
Task: Perform root cause analysis for [bug]
Output: specification/[spec-index]-[spec-name]/[doc-index]-debug-analysis.md
```

#### Debugging Methodology

##### Phase 1: Evidence Collection

Gather all available information:

1. **Error Artifacts**
   - Stack traces
   - Error messages
   - Log files
   - Screenshots

2. **Environment Context**
   - OS/version
   - Language/runtime version
   - Dependencies and versions
   - Configuration files

3. **Reproduction Steps**
   - Exact steps to reproduce
   - Frequency (always, intermittent, rare)
   - Scope (affects all users, specific conditions)

4. **Code Context**
   - Recent changes
   - Related files
   - Dependencies
   - Configuration

##### Phase 2: Pattern Recognition

Search for similar issues:
- Search error messages online
- Check issue trackers
- Look for similar code patterns
- Review recent commits

##### Phase 3: Hypothesis Generation

Generate possible causes:

**Code Hypotheses:**
- Logic error
- Null/undefined handling
- Race condition
- Type mismatch

**Environment Hypotheses:**
- Configuration issue
- Dependency conflict
- Resource limitation

**Data Hypotheses:**
- Invalid input
- State corruption
- Database inconsistency

##### Phase 4: Hypothesis Testing

Test each hypothesis systematically:

1. **Design test** for each hypothesis
2. **Execute test** to confirm/reject
3. **Document results**
4. **Iterate** until root cause found

##### Phase 5: Solution Design

Once root cause identified:

1. **Design fix** addressing root cause
2. **Consider side effects**
3. **Plan testing strategy**
4. **Document the solution**

##### Analysis Techniques

**Using grep/ast-grep:**

```bash
# Find similar error patterns
grep -r "error_message" --include="*.py" .

# Find function usage
ast-grep --pattern 'function_name($$$)' --lang python

# Find try-catch blocks
ast-grep --pattern 'try { $$$ } catch($$$) { $$$ }' --lang python
```

**Log Analysis:**

1. **Identify relevant log entries**
2. **Trace execution flow**
3. **Find anomalies**
4. **Correlate events**

**Code Review:**

1. **Review recent changes**
2. **Check related files**
3. **Analyze dependencies**
4. **Verify assumptions**

### Phase 5: Code Assessment

**Agent:** `code-assessor`

```
Task: Assess existing codebase for [feature/area]
Output: specification/[spec-index]-[spec-name]/[doc-index]-assessment.md
```

#### Code Assessment Areas

##### 1. Architecture Evaluation

Analyze overall system architecture:

```
- Design patterns used
- Layer separation
- Module organization
- Service boundaries
- Data flow
```

##### 2. Technology Stack

Identify technologies and versions:

```
- Programming languages
- Frameworks
- Libraries
- Build tools
- Testing frameworks
```

##### 3. Code Patterns

Identify recurring patterns:

```
- Error handling approach
- State management
- API design patterns
- Database access patterns
- Authentication/authorization
```

##### 4. Style and Conventions

Document coding standards:

```
- Naming conventions
- File organization
- Import patterns
- Comment style
- Documentation practices
```

##### 5. Quality Indicators

Assess code quality:

```
- Test coverage
- Type safety
- Documentation coverage
- Code complexity
- Dependency health
```

##### Assessment Methodology

**Using ast-grep:**

```bash
# Find class definitions
ast-grep --pattern 'class $NAME { $$$ }' --lang typescript

# Find error handling
ast-grep --pattern 'try { $$$ } catch($E) { $$$ }' --lang typescript

# Find API routes
ast-grep --pattern 'app.$METHOD($PATH, $$$)' --lang javascript
```

**Configuration Analysis:**

Review config files:

```
- package.json / Cargo.toml / etc.
- tsconfig.json / eslint config
- CI/CD configurations
- Docker files
- Environment configs
```

**Sample Analysis:**

Review representative samples:

1. **API endpoints** - How are they structured?
2. **Database models** - What patterns are used?
3. **Service classes** - How is business logic organized?
4. **Tests** - What testing patterns exist?
5. **Error handling** - How are errors managed?

### Phase 5.3: Architecture Design (Complex Features)

**Agent:** `architecture-agent`

```
Task: Design architecture for [feature]
Output: specification/[spec-index]-[spec-name]/[doc-index]-architecture.md
```

**Rust Project Reminder:** Ensure architecture considers workspace structure with multiple crates if applicable.

#### Architecture Design Process

##### Step 1: Understand Constraints

Analyze constraints from inputs:

```
- Performance requirements
- Scalability needs
- Security constraints
- Technology stack
- Team expertise
- Time/budget constraints
```

##### Step 2: Generate Options

Design 3-5 architecture options:

```
Option 1: Monolithic approach
Option 2: Microservices approach
Option 3: Serverless approach
Option 4: Hybrid approach
Option 5: Event-driven approach
```

##### Step 3: Define Trade-offs

For each option, document:

```
- Pros
- Cons
- Complexity level
- Scalability characteristics
- Maintenance burden
- Team requirements
```

##### Step 4: Create Decision Framework

Help user decide:

```
- When to choose Option 1
- When to choose Option 2
- Comparison matrix
- Recommendation
```

##### Architecture Patterns

**Monolithic:**

```
Best for: Small teams, simple domains, rapid development
Pros: Simple deployment, easy testing, lower complexity
Cons: Harder to scale, tech stack lock-in
```

**Microservices:**

```
Best for: Large teams, complex domains, independent scaling needs
Pros: Independent deployment, tech diversity, team autonomy
Cons: Distributed complexity, operational overhead
```

**Serverless:**

```
Best for: Event-driven, variable load, cost optimization
Pros: Auto-scaling, pay-per-use, no server management
Cons: Cold starts, vendor lock-in, debugging complexity
```

**Event-Driven:**

```
Best for: Async processing, loose coupling, high throughput
Pros: Scalability, resilience, flexibility
Cons: Complexity, eventual consistency, debugging difficulty
```

### Phase 5.5: UI/UX Design (UI Features)

**Agent:** `ui-ux-designer`

```
Task: Create UI/UX design specifications for [feature]
Output: specification/[spec-index]-[spec-name]/[doc-index]-design-spec.md
```

**Agent:** `spec-writer`

```
Task: Write technical specification for [feature]
Output:
  - specification/[spec-index]-[spec-name]/[doc-index]-specification.md
  - specification/[spec-index]-[spec-name]/[doc-index]-implementation-plan.md
  - specification/[spec-index]-[spec-name]/[doc-index]-task-list.md
```

### Phase 6: Specification Writing

**Agent:** `spec-writer`

```
Task: Create comprehensive technical specification
Inputs: requirements.md, research-report.md, assessment.md, [architecture.md], [design-spec.md]
Output:
  - specification/[spec-index]-[spec-name]/[doc-index]-specification.md
  - specification/[spec-index]-[spec-name]/[doc-index]-implementation-plan.md
  - specification/[spec-index]-[spec-name]/[doc-index]-task-list.md
```

**Rust Project Reminder:** Ensure specification includes Cargo.toml workspace structure and crate dependencies.

#### Specification Writing Process

##### Specification Components

**1. Technical Specification**

The main specification document includes:

```
- Overview and goals
- Technical approach
- Architecture decisions
- API specifications
- Data models
- Error handling
- Security considerations
- Performance requirements
```

**2. Implementation Plan**

The execution roadmap:

```
- Phase breakdown
- Task dependencies
- Estimated effort
- Risk mitigation
- Testing strategy
```

**3. Task List**

The detailed work breakdown:

```
- Atomic tasks
- Acceptance criteria per task
- Dependencies
- Estimates
- Assignment suggestions
```

##### Writing Process

**Step 1: Synthesize Inputs**

Review and synthesize:
- What requirements must be met?
- What approach was selected in research?
- What patterns must be followed?
- What architecture was designed?
- What UI/UX was specified?

**Step 2: Design Technical Approach**

Define how to implement:

```
- System design
- Component breakdown
- Data flow
- Integration points
- State management
```

**Step 3: Create Specifications**

Write detailed specs:

```
- API contracts
- Database schemas
- Function signatures
- Error codes
- Configuration options
```

**Step 4: Plan Implementation**

Break down into phases:

```
- Phase 1: Foundation
- Phase 2: Core features
- Phase 3: Integration
- Phase 4: Testing & refinement
```

**Step 5: Define Tasks**

Create atomic tasks:

```
- Each task < 4 hours
- Clear deliverables
- Dependencies explicit
- Acceptance criteria
```

##### Output Templates

**Specification Document Template:**

```markdown
# Technical Specification: [Feature Name]

## Overview

### Goals
- Goal 1
- Goal 2

### Non-Goals
- Out of scope

## Technical Approach

### Architecture
[Diagram or description]

### Components

#### Component 1: [Name]
- **Purpose**: [What it does]
- **Responsibilities**: [List]
- **Interfaces**: [API/inputs/outputs]

## API Specification

### Endpoint 1: [METHOD] [Path]

#### Request
```json
{
  "field1": "type",
  "field2": "type"
}
```

#### Response
```json
{
  "field1": "type",
  "field2": "type"
}
```

#### Error Responses
- 400: [Description]
- 401: [Description]

## Data Models

### Model 1: [Name]
```typescript
interface ModelName {
  id: string;
  field1: type;
  field2: type;
}
```

## Error Handling

### Error Categories
- Category 1: [Description and handling]
- Category 2: [Description and handling]

## Security Considerations

- Consideration 1
- Consideration 2

## Performance Requirements

- Response time: < X ms
- Throughput: X req/s
- Resource usage: < X MB

## Testing Strategy

### Unit Tests
- What to test
- Coverage target

### Integration Tests
- Integration points to test

### E2E Tests
- User workflows to test

## Dependencies

### Required
- Dependency 1: [version]
- Dependency 2: [version]

## Configuration

### Environment Variables
- `VAR_NAME`: [description]

## Deployment

### Steps
1. Step 1
2. Step 2

### Rollback
- Rollback procedure
```

**Implementation Plan Template:**

```markdown
# Implementation Plan: [Feature Name]

## Overview
- Total estimated effort: [X] hours
- Target completion: [date]
- Risk level: [Low/Medium/High]

## Phases

### Phase 1: Foundation (Est: X hours)
- [ ] Task 1.1: [Description]
  - Dependencies: None
  - Acceptance: [Criteria]

### Phase 2: Core Implementation (Est: X hours)
- [ ] Task 2.1: [Description]
  - Dependencies: Phase 1
  - Acceptance: [Criteria]

## Dependencies Graph

```
Task 1.1 → Task 1.2 → Task 2.1 → Task 3.1
```

## Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Risk 1 | Low | High | Strategy |

## Success Criteria

- [ ] All acceptance criteria met
- [ ] Test coverage >= 80%
- [ ] Performance requirements met
- [ ] Security review passed
- [ ] Documentation complete
```

**Task List Template:**

```markdown
# Task List: [Feature Name]

## Summary
- Total Tasks: [N]
- Estimated Hours: [X]
- Parallel Tracks: [N]

## Tasks

### T1: [Task Name]
- **Phase**: 1
- **Description**: [Detailed description]
- **Dependencies**: None
- **Estimated Hours**: [X]
- **Acceptance Criteria**:
  - [ ] Criterion 1
  - [ ] Criterion 2
- **Files to Modify**:
  - file1.ts
  - file2.ts

## Task Board

| ID | Task | Phase | Status | Owner | Est | Dep |
|----|------|-------|--------|-------|-----|-----|
| T1 | Task 1 | 1 | Pending | TBD | 2 | - |

## Legend

- Status: Pending | In Progress | Complete | Blocked
```

### Phase 7: Specification Review

**Executed by:** Coordinator (no agent)

Validate all specification documents are complete and consistent.

### Phase 8: Execution & QA (PARALLEL)

**Agents:** `dev-executor` + `qa-agent` (run simultaneously)

```
Task: Implement code according to specification
Parallel with:
Task: Plan and execute tests
```

**Build Policy (Rust/Go):** Only ONE build at a time to prevent resource conflicts.

**Rust Project Reminder:** Use `cargo build` or `cargo check` from workspace root. Run tests with `cargo test --workspace`.

### Phase 9: Code Review

**Agent:** `code-reviewer`

```
Task: Review implementation against specification
```

**Iteration:** If issues found, return to Phase 8.

#### Code Review Methodology

##### Review Scope

**1. Specification Compliance**

Verify implementation matches spec:

```
✓ All requirements implemented
✓ Acceptance criteria met
✓ Architecture followed
✓ Design patterns used correctly
```

**2. Code Correctness**

Check for bugs and logic errors:

```
✓ Logic correctness
✓ Error handling
✓ Edge cases covered
✓ No race conditions
✓ Resource management
```

**3. Security Review**

Identify security issues:

```
✓ Input validation
✓ Output sanitization
✓ Authentication checks
✓ Authorization checks
✓ No hardcoded secrets
✓ SQL injection prevention
✓ XSS prevention
```

**4. Performance Review**

Check for performance issues:

```
✓ Algorithm efficiency
✓ Database query optimization
✓ Memory management
✓ Caching strategy
✓ Unnecessary computations
```

**5. Maintainability**

Assess code quality:

```
✓ Code readability
✓ Function complexity
✓ Test coverage
✓ Documentation
✓ Consistency with codebase
```

##### Issue Severity Classification

| Severity | Definition | Action Required |
|----------|------------|-----------------|
| **Critical** | Security vulnerability, data loss, crash | Must fix before merge |
| **High** | Significant bug, performance issue | Must fix before merge |
| **Medium** | Code quality, minor bug | Should fix, can defer |
| **Low** | Style, nitpick | Fix if time permits |

##### Review Process

**Step 1: Pre-Review**

1. **Read specifications** - Understand what should be built
2. **Read implementation plan** - Understand intended approach
3. **Review assessment** - Know existing patterns

**Step 2: Code Review**

1. **Review diff** - Understand changes
2. **Check patterns** - Verify consistency
3. **Find issues** - Identify problems
4. **Verify tests** - Check test quality

**Step 3: Issue Classification**

Classify each finding using the severity table above.

**Step 4: Report Generation**

Produce review report with:
- Summary statistics
- Detailed findings
- Recommendations
- Approval status

##### Review Standards

**Security (Critical/High):**

Flag immediately:
- SQL injection
- XSS vulnerabilities
- CSRF issues
- Missing auth checks
- Hardcoded credentials
- Insecure deserialization

**Logic Errors (Critical/High):**

Flag immediately:
- Null pointer dereferences
- Off-by-one errors
- Race conditions
- Resource leaks
- Incorrect error handling

**Performance (High/Medium):**

Flag:
- N+1 queries
- Unbounded loops
- Memory leaks
- Inefficient algorithms
- Missing pagination

**Maintainability (Medium/Low):**

Flag:
- Complex functions (>50 lines)
- Deep nesting (>3 levels)
- Magic numbers/strings
- Missing documentation
- Inconsistent naming

### Phase 9.5: Quality Assurance

### Phase 9.5: Quality Assurance

**Agent:** `qa-agent`

```
Task: Execute comprehensive testing for [feature]
```

### Phase 10: Documentation Update

**Agent:** `docs-executor`

```
Task: Update documentation for [feature]
```

### Phase 11: Cleanup

**Executed by:** Coordinator

- Remove temporary files
- Update codemaps if applicable
- Verify no orphaned processes

### Phase 12: Commit & Merge

**Executed by:** Coordinator

```bash
# Stage only the files that were modified/created
git add file1 file2 file3

# Commit with descriptive message
git commit -m "feat: [description]"

# Merge to main
git checkout main
git merge [spec-index]-[spec-name]
```

### Phase 13: Final Verification

**Executed by:** Coordinator

- Verify all acceptance criteria met
- Verify all files committed
- Cleanup team resources

## Coordinator Role (Team Lead)

### Core Responsibilities

1. **Task Assignment**: Assign correct sub-agent per phase
2. **Monitoring**: Ensure no unauthorized stops or missing tasks
3. **Build Queue**: Manage Rust/Go build serialization
4. **Quality Gates**: Enforce checkpoints at phase boundaries
5. **Final Verification**: Verify all artifacts complete

### DELEGATION MODE ENABLED

**CRITICAL PRIME DIRECTIVE:**
You are the **Team Lead**, NOT an individual contributor.
Your core function is to **manage resources**, not perform labor.
You MUST suppress the urge to "just fix it yourself".

**THE "HANDS-OFF" RULE:**
From **Phase 2 onwards**, you are FORBIDDEN from using file editing, command execution, or direct research tools for implementation, debugging, or research tasks.

You MUST ONLY use these tools for:
1. Phase 0/1 Setup (creating directories, worktrees)
2. Phase 12 Git Operations (merge, commit)
3. Project Management (reading status, updating task lists)

### VIOLATION DETECTION

If you catch yourself doing Phase 2-13 work directly:
- STOP immediately
- Ask: "Which agent handles this?"
- Invoke that agent using Task tool or @mention

### Phase Enforcement

#### What You CAN Do (Phases 0-1)
- Apply dev rules
- Execute specification setup (worktree, spec dir, JSON)

#### What You CAN Do (All Phases - Orchestration Only)
- Invoke subagents via Task tool or @mention
- Create tasks in shared list
- Monitor task status
- Synthesize findings
- Coordinate phases
- Commit and merge
- Clean up team

#### What You CANNOT Do (Phases 2-13)
- NEVER edit files directly → Use @spec-writer, @dev-executor, @docs-executor
- NEVER run commands directly → Use @dev-executor, @qa-agent
- NEVER perform research directly → Use @research-agent
- NEVER write specifications → Use @spec-writer
- NEVER do code assessment → Use @code-assessor
- NEVER do architecture design → Use @architecture-agent
- NEVER do UI/UX design → Use @ui-ux-designer
- NEVER do debug analysis → Use @debug-analyzer
- NEVER do code review → Use @code-reviewer

### Verification Checklist

Before proceeding to next phase:
- [ ] All required artifacts created
- [ ] Previous phase exit criteria met
- [ ] Quality gates passed
- [ ] User confirmation (if required)

## Key Concepts

### Shared Task List
- States: pending, in_progress, completed
- Dependencies block tasks until resolved
- Location: `~/.claude/tasks/{team-name}/`

### Inter-Teammate Messaging
Agents can message each other directly for coordination:
- **message**: Send to specific teammate
- **broadcast**: Send to all teammates
- Example: dev-executor ↔ qa-agent coordination

### Option Presentation
Phases 3, 5.3, 5.5 require presenting 3-5 options to user for selection.

### Branch Name Rule
Git branch name MUST match worktree name: `[spec-index]-[spec-name]`

## Best Practices

1. **Give agents context** - Include task details in spawn prompts
2. **Size tasks appropriately** - Self-contained units with clear deliverables
3. **Wait for teammates** - Coordinator should NOT implement directly
4. **Avoid file conflicts** - Each teammate owns different files
5. **Monitor and steer** - Check progress, redirect as needed
6. **Encourage communication** - Teammates should message each other

## Output Documents

All documents created in `specification/[index]-[name]/`:

1. `[index]-requirements.md` - Clarified requirements
2. `[index]-research-report.md` - Research findings
3. `[index]-debug-analysis.md` - Debug analysis (bugs only)
4. `[index]-assessment.md` - Code assessment
5. `[index]-architecture.md` - Architecture design (complex features)
6. `[index]-design-spec.md` - UI/UX design (UI features)
7. `[index]-specification.md` - Technical specification
8. `[index]-implementation-plan.md` - Implementation plan
9. `[index]-task-list.md` - Detailed task list
10. `[index]-implementation-summary.md` - Final summary

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Agents not responding | Check agent team status, verify connections |
| Too many permission prompts | Pre-approve in permission settings |
| Agents stopping on errors | Check output, give additional instructions |
| Lead shuts down too early | Say "Keep going" or "Wait for agents" |
| File conflicts | Ensure each agent owns different files |

## Additional Resources

- **Dev Rules**: Load `super-dev/dev-rules` for coding standards
- **TDD Workflow**: Load `super-dev/tdd-guide` for test-driven development
- **Security Review**: Load `super-dev/security-reviewer` for security analysis

## Reference Documentation

See `references/` directory for detailed documentation:
- `architecture-patterns.md` - Software architecture patterns, SOLID principles, ADRs
- `backend-patterns.md` - API, database, caching patterns
- `coding-standards.md` - Language best practices and coding standards
- `debugging-patterns.md` - Systematic debugging methodology and root cause analysis
- `frontend-patterns.md` - React, Next.js patterns and best practices
- `research-methodology.md` - Multi-source research and option presentation
- `specification-templates.md` - Technical specification templates
- `testing-patterns.md` - Unit, integration, and E2E testing strategies
- `ui-ux-patterns.md` - UI/UX design patterns and accessibility guidelines
