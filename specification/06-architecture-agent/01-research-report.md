# Research Report: Architecture Agent

**Date:** 2025-11-23
**Version:** 1.0.0

## Executive Summary

This report synthesizes research findings from GitHub repositories and technical sources to identify best practices for implementing an architecture agent within the dev-workflow plugin.

## Research Sources

### GitHub Implementations Analyzed

| Repository | Agent Name | Model | Key Strengths |
|------------|-----------|-------|---------------|
| keithmackay/ccide | arch-design-agent | sonnet | Most comprehensive, ADRs with MADR 3.0.0, evaluation matrices |
| VishalJ99/claude-docker | system-architect | opus | Strong module decomposition, API contracts, implementation roadmaps |
| michaelkacher/claude-code-deno2-starter | architect-agent | default | Lightweight, focused on ADRs and complexity pushback |
| mikotoIO/mikoto | project-architect | default | Strategic analysis, project prioritization |

---

## Key Patterns Identified

### 1. Multi-Phase Methodology

All comprehensive architecture agents follow a phased approach:

**Common Phases:**
1. **Requirements Analysis** - Understand what needs to be built
2. **Architectural Decomposition** - Break down into modules/components
3. **Technology Evaluation** - Research and select tech stack
4. **Interface Design** - Define APIs and contracts
5. **Documentation** - Create architecture docs and ADRs
6. **Validation** - Verify completeness and correctness

### 2. Architecture Decision Records (ADRs)

**MADR 3.0.0 Format** (Most widely adopted):
```markdown
# ADR-XXXX: [Title - Concise Decision Statement]

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-YYYY]

## Context and Problem Statement
[What is the issue motivating this decision?]

## Decision Drivers
- [Driver 1]
- [Driver 2]

## Considered Options
1. [Option 1]
2. [Option 2]
3. [Option 3]

## Decision Outcome
Chosen option: "[option]", because [justification]

### Consequences
- Good: [positive consequences]
- Bad: [negative consequences]

## Pros and Cons of the Options

### [Option 1]
- Good, because [argument]
- Bad, because [argument]

### [Option 2]
...

## Evaluation Matrix (Optional)
| Criteria | Weight | Option 1 | Option 2 | Option 3 |
|----------|--------|----------|----------|----------|
| [Criterion] | [1-5] | [1-5] | [1-5] | [1-5] |
```

### 3. Module Architecture Diagrams

**ASCII/Mermaid Format:**
```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │  Component  │  │  Component  │  │  Component  │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
├─────────────────────────────────────────────────────────┤
│                    Business Logic Layer                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Service   │  │   Service   │  │   Service   │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
├─────────────────────────────────────────────────────────┤
│                    Data Access Layer                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ Repository  │  │ Repository  │  │  External   │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
```

### 4. Quality Principles

**SOLID Principles:**
- **S**ingle Responsibility - Each module has one reason to change
- **O**pen/Closed - Open for extension, closed for modification
- **L**iskov Substitution - Subtypes must be substitutable
- **I**nterface Segregation - Many specific interfaces over one general
- **D**ependency Inversion - Depend on abstractions, not concretions

**Additional Principles:**
- **DRY** - Don't Repeat Yourself
- **YAGNI** - You Aren't Gonna Need It
- **Separation of Concerns** - Each module handles one concern
- **Loose Coupling** - Minimize dependencies between modules
- **High Cohesion** - Related functionality grouped together

### 5. Technology Evaluation Matrices

**Evaluation Criteria:**
| Criteria | Description | Weight |
|----------|-------------|--------|
| Learning Curve | How quickly team can adopt | 1-5 |
| Community Support | Documentation, ecosystem | 1-5 |
| Performance | Speed, scalability | 1-5 |
| Maintainability | Long-term maintenance burden | 1-5 |
| Security | Security features, vulnerabilities | 1-5 |
| Cost | Licensing, infrastructure | 1-5 |
| Integration | How well it fits existing stack | 1-5 |

### 6. Validation Checklists

**Architecture Completeness:**
- [ ] All requirements addressed by architecture
- [ ] Module boundaries align with domain concepts
- [ ] Interfaces are minimal and complete
- [ ] Dependencies form directed acyclic graph (DAG)
- [ ] Each module has single, clear purpose
- [ ] Error handling strategy defined
- [ ] Security considerations addressed
- [ ] Performance requirements met
- [ ] Scalability path defined
- [ ] Testing strategy defined

---

## Best Implementation: keithmackay/ccide

The most comprehensive implementation with these standout features:

### Strengths:
1. **7-Phase Methodology** with clear deliverables per phase
2. **MADR 3.0.0 ADR format** for decision documentation
3. **Evaluation matrices** for objective technology selection
4. **Anti-patterns section** to avoid common mistakes
5. **Best practices** embedded in each phase
6. **Comprehensive validation checklist**
7. **Clear output structure** (docs/architecture.md, docs/ADR/, docs/plans/)

### Phase Structure:
1. Requirements Analysis
2. Page Structure & Information Architecture
3. Technology Stack Research
4. Architecture Design
5. Architecture Decision Records (ADRs)
6. Architecture Documentation
7. Validation & Handoff

---

## Synthesis: Our Architecture Agent

Based on research, our architecture agent should:

### Core Capabilities:
1. **Requirements Analysis** - Extract architectural requirements
2. **Module Decomposition** - Break down into clean modules
3. **Technology Evaluation** - Research and compare options
4. **Interface Design** - Define APIs and contracts
5. **ADR Creation** - Document decisions using MADR format
6. **Architecture Documentation** - Create comprehensive docs
7. **Validation** - Verify architecture completeness

### Key Differentiators:
1. **Integration with dev-workflow** - Fit between requirements and spec-writing
2. **YAGNI Focus** - Prevent over-architecture
3. **Verification Checkpoints** - Multiple validation gates
4. **Existing Pattern Detection** - Respect current codebase patterns

### Output Documents:
1. `[index]-architecture.md` - Architecture documentation
2. `[index]-adr-[decision].md` - Architecture Decision Records
3. `[index]-module-specs.md` - Module specifications (optional)

### Integration Point:
- **Phase 4.5** in dev-workflow (after Code Assessment, before UI/UX Design)
- Only for features requiring significant architectural decisions
- Skip for simple bug fixes or minor changes

---

## Recommendations

1. **Use MADR 3.0.0 format** for ADRs (industry standard)
2. **Include evaluation matrices** for technology decisions
3. **Embed SOLID/DRY/YAGNI** principles as verification checkpoints
4. **Create ASCII diagrams** for module architecture
5. **Add anti-patterns section** to prevent common mistakes
6. **Include validation checklist** for completeness
7. **Reference existing codebase patterns** from code-assessor output

## References

- keithmackay/ccide/agents/arch-design-agent.md
- VishalJ99/claude-docker/.claude/agents/system-architect.md
- michaelkacher/claude-code-deno2-starter/.claude/agents/architect-agent.md
- mikotoIO/mikoto/.claude/agents/project-architect.md
- MADR 3.0.0 - https://adr.github.io/madr/
