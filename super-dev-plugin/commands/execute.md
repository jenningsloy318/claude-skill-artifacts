---
name: super-dev:execute
description: Execute development and QA in parallel using specialized agents
---

# Phase 8: Execution & QA

Execute development implementation and quality assurance in parallel using specialized agents.

## Usage

```
/super-dev:execute [specification directory path]
```

## What This Command Does

When invoked, this command activates TWO agents in PARALLEL:

1. **Dev Executor** (`super-dev:dev-executor`)
   - Implements code according to specifications
   - Invokes specialist developer agents as needed
   - Follows established patterns and standards

2. **QA Agent** (`super-dev:qa-agent`)
   - Writes tests for all implemented code
   - Verifies builds and functionality
   - Ensures quality standards are met

## Parallel Execution Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                PARALLEL EXECUTION & QA                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────┐  ┌─────────────┐                           │
│  │dev-executor │  │   qa-agent  │                           │
│  │             │  │             │                           │
│  │ Implements  │  │ Writes and  │                           │
│  │ code        │  │ runs tests  │                           │
│  │             │  │             │                           │
│  └─────────────┘  └─────────────┘                           │
│                          │                                   │
│                   BUILD QUEUE                                │
│              (Rust/Go: one at a time)                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Build Policy

For Rust and Go projects:
- Only ONE build at a time
- Coordinator manages build queue
- Prevents resource conflicts

## Execution Process

### Dev Executor
- Reads `[phase-index]-task-list.md` for tasks
- Implements features according to specifications
- Invokes specialist agents (rust-developer, frontend-developer, etc.)
- Follows established code patterns

### QA Agent
- Creates unit tests for new code
- Writes integration tests
- Verifies build success
- Tests functionality against requirements

**Note**: Documentation updates are handled in Phase 10 via the `/super-dev:documentation` command.

## Arguments

`$ARGUMENTS` should specify:
- Path to specification directory
- Any specific implementation focus areas

## Output

Creates/updates:
- Implemented code files
- Test suites

## Notes

- Parallel execution maximizes efficiency
- Quality gates enforced throughout
- Build queue managed for resource-intensive projects
- Documentation updates are handled separately in Phase 10