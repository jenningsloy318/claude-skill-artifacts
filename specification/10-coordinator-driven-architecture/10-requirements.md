# Requirements: Coordinator-Driven Architecture Redesign

**Date:** 2025-11-27
**Author:** User
**Status:** Confirmed

## 1. Overview

Complete architectural redesign of the dev-workflow plugin to implement a dedicated Coordinator Agent that orchestrates all development phases using a subagent-driven methodology.

## 2. Core Requirements

### 2.1 Coordinator Agent (HIGH PRIORITY)

Create a dedicated Coordinator Agent that:
- Maintains central role in orchestrating ALL phases
- Assigns tasks to specialized sub-agents
- Monitors and oversees all sub-agent work
- Ensures no tasks are missed, postponed, or skipped
- Tracks entire process through task list completion

### 2.2 Plugin Renaming

- Rename plugin and skill from "dev-workflow" to a new name
- Suggested options: "super-development", "orchestrated-dev", "coordinator-workflow"
- Update all references throughout the plugin

### 2.3 Subagent-Driven Methodology

The workflow will be redesigned so that:
- Coordinator is the single entry point
- All work is delegated to specialized sub-agents
- Coordinator never performs implementation directly
- Sub-agents report back to Coordinator

## 3. Phase-Specific Requirements

### 3.1 Task Assignment (All Phases)

In each phase, the Coordinator:
- Identifies the correct sub-agent for the required work
- Assigns the task with appropriate context
- Monitors task completion
- Validates output before proceeding

### 3.2 Monitoring & Oversight (All Phases)

The Coordinator:
- Monitors sub-agent work in real-time
- Ensures all tasks are completed
- Prevents unauthorized pauses/stops
- Enforces no missing tasks policy

### 3.3 Research Phase

The Coordinator ensures:
- Search Sub-Agent always accesses latest information
- Time MCP is added to context for current date/time
- Data collected from ALL places on the internet
- Including all public articles and documentation
- No outdated information is used

### 3.4 Assessment/Debug Analysis Phase

The Coordinator instructs sub-agent to:
- Use `grep` skill for code searching
- Use `ast-grep` skill for structural code analysis
- Ensure ALL relevant files are covered
- No files are missed in the analysis

### 3.5 Execution Phase (CRITICAL)

The Coordinator initiates THREE sub-agents to work in PARALLEL (not sequential):

| Sub-Agent | Responsibility |
|-----------|----------------|
| **Development Agent** | Implements code changes |
| **QA Testing Agent** | Writes and runs tests |
| **Documentation Agent** | Updates implementation summary, spec/plan changes |

**Parallel Execution Rules:**
- All three agents work simultaneously
- Coordinator tracks entire process
- Goes through task list systematically
- Ensures ALL items completed without postponement or skipping

**Completion Protocol:**
- Once a task is done, ensure ALL changes (code + docs) are stashed/committed
- Upon task completion, immediately assign next task
- Continue until entire list is finished

**Build Policy (Rust/Go):**
- Only ONE build allowed at a time
- Regardless of build type (release, debug, development)
- Coordinator enforces build serialization

### 3.6 Final Phase

The Coordinator verifies:
- All documents correctly created
- All documents committed/pushed
- No missing code or files
- New design patterns reflected in spec/plan/task list
- Implementation summary is complete
- All code and documents committed and pushed

## 4. Non-Functional Requirements

### 4.1 Consistency
- Single source of truth for workflow orchestration
- Clear delegation patterns
- Predictable behavior

### 4.2 Observability
- Clear logging of Coordinator decisions
- Task assignment tracking
- Progress visibility

### 4.3 Reliability
- No work lost between phases
- Checkpoint/commit enforcement
- Recovery from failures

## 5. Acceptance Criteria

- [ ] Dedicated Coordinator Agent created and functional
- [ ] All phases orchestrated through Coordinator
- [ ] Research phase uses time MCP and comprehensive search
- [ ] Assessment phase uses grep/ast-grep skills
- [ ] Execution phase runs 3 parallel sub-agents
- [ ] Build policy enforced for Rust/Go
- [ ] Final phase verification complete
- [ ] Plugin renamed with all references updated
- [ ] All existing functionality preserved
- [ ] Documentation complete and accurate

## 6. Out of Scope

- Changes to external MCP servers
- New Claude Code capabilities
- Changes to other plugins
