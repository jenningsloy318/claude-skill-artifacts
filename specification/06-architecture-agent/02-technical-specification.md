# Technical Specification: Architecture Agent

**Date:** 2025-11-23
**Version:** 1.0.0
**Status:** Draft

## 1. Overview

### 1.1 Summary
Create an architecture agent for the dev-workflow plugin that designs software architecture, creates ADRs, and produces implementation-ready architecture documentation.

### 1.2 Goals
- Design clean, modular software architecture
- Document architectural decisions using MADR format
- Evaluate technology options objectively
- Create implementation-ready architecture docs
- Integrate seamlessly with dev-workflow phases

### 1.3 Non-Goals
- Implementation of the architecture (handled by execution-coordinator)
- Detailed UI/UX design (handled by ui-ux-designer)
- Code assessment (handled by code-assessor)

## 2. Background

### 2.1 Context
> From Research Report: Architecture agents on GitHub follow multi-phase methodologies with ADRs, module decomposition, and validation checklists.

### 2.2 Current State
> From Assessment: The dev-workflow plugin currently lacks an architecture phase, jumping from code assessment directly to UI/UX design or specification writing.

### 2.3 Problem Statement
Complex features need architectural planning before specification writing to ensure:
- Clean module boundaries
- Technology decisions are documented
- Dependencies are understood
- Scalability is considered

## 3. Technical Design

### 3.1 Agent Structure

```
architecture-agent.md
├── Frontmatter (name, description, model)
├── Philosophy (YAGNI, SOLID, etc.)
├── Core Capabilities
├── Input Context
├── 7-Phase Methodology
│   ├── Phase 1: Context Gathering
│   ├── Phase 2: Requirements Analysis
│   ├── Phase 3: Module Decomposition
│   ├── Phase 4: Technology Evaluation
│   ├── Phase 5: Interface Design
│   ├── Phase 6: Documentation
│   └── Phase 7: Validation
├── ADR Template (MADR 3.0.0)
├── Output Format
├── Quality Standards
└── Anti-Hallucination Measures
```

### 3.2 Integration with Dev-Workflow

```
Phase 4: Code Assessment
         ↓
Phase 4.5: Architecture Design  ← NEW
         ↓
Phase 5: Specification Writing
```

### 3.3 Phase Methodology

#### Phase 1: Context Gathering
- Load requirements document
- Load code assessment
- Identify existing patterns in codebase
- Determine project constraints

#### Phase 2: Requirements Analysis
- Extract functional requirements
- Identify non-functional requirements (performance, security, scalability)
- List system constraints
- Define architectural drivers

#### Phase 3: Module Decomposition
- Identify bounded contexts
- Define module boundaries
- Assign responsibilities to modules
- Map dependencies between modules
- Create module diagram

#### Phase 4: Technology Evaluation (if needed)
- Research technology options
- Create evaluation matrix
- Compare options objectively
- Select recommended technologies
- Document decision as ADR

#### Phase 5: Interface Design
- Define public interfaces for each module
- Specify API contracts
- Define data models
- Document error handling

#### Phase 6: Documentation
- Create architecture overview document
- Write ADRs for major decisions
- Create module specifications
- Document deployment considerations

#### Phase 7: Validation
- Verify all requirements addressed
- Check SOLID principles compliance
- Validate module boundaries
- Ensure scalability path
- Review security considerations

### 3.4 ADR Template (MADR 3.0.0)

```markdown
# ADR-XXXX: [Title]

## Status
[Proposed | Accepted | Deprecated | Superseded]

## Context and Problem Statement
[Issue motivating this decision]

## Decision Drivers
- [Driver 1]
- [Driver 2]

## Considered Options
1. [Option 1]
2. [Option 2]

## Decision Outcome
Chosen option: "[option]", because [justification]

### Consequences
- Good: [positive]
- Bad: [negative]

## Pros and Cons of the Options

### [Option 1]
- Good, because [argument]
- Bad, because [argument]

## Evaluation Matrix (if applicable)
| Criteria | Weight | Option 1 | Option 2 |
|----------|--------|----------|----------|
| [Criterion] | [1-5] | [score] | [score] |
```

### 3.5 Output Documents

#### Primary Output: `[index]-architecture.md`
```markdown
# Architecture: [Feature Name]

## Overview
[High-level description]

## Module Architecture
[ASCII diagram]

## Module Specifications
### Module 1: [Name]
- Purpose: [description]
- Responsibilities: [list]
- Dependencies: [list]
- Public Interface: [code]

## Data Flow
[Sequence diagram or flow description]

## Technology Stack
[Selected technologies with rationale]

## Security Considerations
[Security design]

## Performance Considerations
[Performance design]

## Deployment Considerations
[Deployment strategy]
```

#### Secondary Output: `[index]-adr-[topic].md` (one per major decision)

## 4. Quality Principles

### 4.1 SOLID Principles
- Single Responsibility: Each module has one reason to change
- Open/Closed: Open for extension, closed for modification
- Liskov Substitution: Subtypes must be substitutable
- Interface Segregation: Many specific interfaces over one general
- Dependency Inversion: Depend on abstractions, not concretions

### 4.2 Additional Principles
- DRY: Don't Repeat Yourself
- YAGNI: You Aren't Gonna Need It
- Separation of Concerns: Each module handles one concern
- Loose Coupling: Minimize dependencies between modules
- High Cohesion: Related functionality grouped together

### 4.3 Anti-Patterns to Avoid
- Big Ball of Mud: No clear structure
- God Module: One module doing everything
- Circular Dependencies: A depends on B depends on A
- Premature Optimization: Over-engineering for hypothetical scale
- Analysis Paralysis: Over-documenting instead of designing

## 5. Verification Checkpoints

### Phase 2 Verification
- [ ] All requirements extracted?
- [ ] Non-functional requirements identified?
- [ ] Constraints documented?

### Phase 3 Verification (YAGNI Check)
- [ ] Am I creating modules not in requirements?
- [ ] Can existing modules be reused?
- [ ] Is this the minimum architecture needed?
- [ ] Would a simpler design work?

### Phase 5 Verification
- [ ] All interfaces minimal and complete?
- [ ] Error handling defined for all interfaces?
- [ ] Data models match requirements?

### Phase 7 Verification (Final)
- [ ] All requirements addressed?
- [ ] Module boundaries align with domain?
- [ ] Dependencies form DAG (no cycles)?
- [ ] Each module has single purpose?
- [ ] Security considered?
- [ ] Scalability path defined?
- [ ] Existing patterns respected?

## 6. When to Skip Architecture Phase

Skip this phase for:
- Simple bug fixes
- Minor feature changes
- Cosmetic updates
- Configuration changes
- Documentation updates

Use this phase for:
- New features with multiple components
- Significant refactoring
- Technology stack changes
- Performance optimization requiring structural changes
- Security-related changes

## 7. Integration

### Inputs
- `requirements.md` from requirements-clarifier (required)
- `assessment.md` from code-assessor (required)

### Outputs
- `[index]-architecture.md` → used by spec-writer
- `[index]-adr-[topic].md` → stored in spec directory
