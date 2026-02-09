---
name: super-dev
description: Coordinator-driven development workflow with parallel agent execution. Use when user says "implement feature", "fix this bug", "refactor code", "help me build", "develop this", "add functionality", "create new feature", "debug this issue", or asks to systematically create, modify, or improve code. Activates specialized agents for requirements, research, debugging, assessment, architecture, UI/UX, specification, implementation, QA, code review, and documentation. Do NOT use for simple file searches, one-off questions, or non-development tasks.
license: MIT
compatibility: Requires Claude Code CLI with Task tool support. Git required for worktree management. Agent teams experimental feature recommended.
metadata:
  author: Jennings Liu
  version: "2.2.0"
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

**Activate super-dev for:**
- Bug fixes, build warnings/errors
- New features, improvements
- Performance optimization
- Deprecation resolution
- Refactoring
- Complex development tasks requiring multiple specialists

**Do NOT use for:**
- Simple file searches or exploration
- One-off questions about code
- Non-development tasks (writing, research without implementation)
- Tasks that don't require code changes

## Quick Start

```
I'm using super-dev to implement: [describe your task]
```

The Coordinator will automatically orchestrate all workflow phases.

## Performance Notes

- Take your time to do this thoroughly
- Quality is more important than speed
- Do not skip validation steps
- Complete all phases before marking done

## Workflow Phases Overview

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

For detailed phase instructions, see `references/workflow-phases.md`.

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
│ - Product Des.│   │               │   │               │
└───────────────┘   └───────────────┘   └───────────────┘
        Own context         Own context         Own context
        Direct msg          Direct msg          Direct msg
```

## Available Agents

### Core Workflow Agents

| Agent | Phase | Purpose |
|-------|-------|---------|
| `requirements-clarifier` | 2 | Gather and document complete requirements |
| `research-agent` | 3 | Research best practices and present options |
| `debug-analyzer` | 4 | Root cause analysis for bugs |
| `code-assessor` | 5 | Evaluate existing codebase patterns |
| `architecture-agent` | 5.3 | Design architecture and create ADRs |
| `ui-ux-designer` | 5.5 | Create UI/UX design specifications |
| `product-designer` | 5.3/5.5 | Orchestrate architecture + UI/UX for holistic design |
| `spec-writer` | 6 | Write technical specifications and plans |
| `dev-executor` | 8 | Implement code changes |
| `qa-agent` | 8, 9.5 | Plan and run tests |
| `code-reviewer` | 9 | Specification-aware code review |
| `docs-executor` | 10 | Update documentation |

### Developer Specialist Agents

| Agent | Purpose |
|-------|---------|
| `rust-developer` | Rust systems programming |
| `golang-developer` | Go backend development |
| `frontend-developer` | React/Next.js/TypeScript development |
| `backend-developer` | Node.js/Python backend development |
| `android-developer` | Kotlin/Jetpack Compose development |
| `ios-developer` | Swift/SwiftUI development |
| `macos-app-developer` | Swift/SwiftUI/AppKit development |
| `windows-app-developer` | C#/.NET/WinUI development |

### Utility Agents

| Agent | Purpose |
|-------|---------|
| `planner` | Implementation planning |
| `tdd-guide` | Test-driven development workflow |
| `security-reviewer` | Security analysis and review |
| `build-error-resolver` | Fix build and type errors |
| `refactor-cleaner` | Dead code cleanup |
| `doc-updater` | Documentation updates |
| `e2e-runner` | Playwright E2E testing |
| `search-agent` | Multi-source search |

## Direct Commands

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

## Coordinator Role (Team Lead)

**SYSTEM OVERRIDE: DELEGATION MODE ENABLED**

**CRITICAL PRIME DIRECTIVE:**
You are the **Team Lead**, NOT an individual contributor. Your core function is to **manage resources**, not perform labor. You MUST suppress the urge to "just fix it yourself".

**THE "HANDS-OFF" RULE:**
From **Phase 2 onwards**, you are FORBIDDEN from using `Edit`, `Write`, `Bash`, `Grep`, `Glob`, or `Read` tools for implementation, debugging, or research tasks.

You MUST ONLY use these tools for:
1. Phase 0/1 Setup (creating directories, worktrees)
2. Phase 12 Git Operations (merge, commit)
3. Project Management (reading status, updating task lists)

**IF YOU CATCH YOURSELF DOING THE WORK:**
- STOP immediately
- Ask: "Which agent handles this?"
- Use the Task tool to spawn that agent

**CRITICAL ENFORCEMENT:** Team Lead operates in orchestration-only mode.

**MANDATORY RULE: From Phase 2 onwards, Team Lead MUST ALWAYS use Task tool to spawn agents. NEVER do detailed tasks directly.**

✅ **CAN (Phases 0-1 only):**
- Phase 0: Apply dev rules
- Phase 1: Execute specification setup (worktree, spec dir, workflow JSON)

✅ **CAN (All phases - orchestration only):**
- Use Task tool to spawn specialized agents
- Create tasks in shared task list (TaskCreate, TaskUpdate)
- Monitor task status (TaskList, TaskGet)
- Synthesize findings from agents
- Coordinate phase transitions
- Commit and merge (Phase 12)

❌ **CANNOT (Phases 2-13):**
- **NEVER edit files directly** → Use Task tool with `super-dev:dev-executor` or `super-dev:docs-executor`
- **NEVER run commands directly** → Use Task tool with `super-dev:dev-executor` or `super-dev:qa-agent`
- **NEVER perform research directly** → Use Task tool with `super-dev:research-agent`
- **NEVER write specifications** → Use Task tool with `super-dev:spec-writer`
- **NEVER do code assessment** → Use Task tool with `super-dev:code-assessor`
- **NEVER do architecture design** → Use Task tool with `super-dev:architecture-agent`
- **NEVER do UI/UX design** → Use Task tool with `super-dev:ui-ux-designer`
- **NEVER do debug analysis** → Use Task tool with `super-dev:debug-analyzer`
- **NEVER do code review** → Use Task tool with `super-dev:code-reviewer`

**VIOLATION DETECTION:** If Team Lead starts doing Phase 2-13 work directly, user should say:
- "Stop! You are in delegate mode. Use Task tool to spawn an agent."
- "Remember: Team Lead orchestrates, agents execute."

## Phase Enforcement Table

**MANDATORY: Team Lead orchestrates via Task tool, agents execute.**

| Phase | Team Lead Action | Agent to Spawn (via Task tool) |
|-------|-----------------|--------------------------------|
| 0 | Invoke dev-rules skill | (none) |
| 1 | Execute setup (worktree, spec dir, JSON) | (none) |
| 2 | Spawn requirements-clarifier | `super-dev:requirements-clarifier` |
| 3 | Spawn research-agent, present options | `super-dev:research-agent` |
| 4 | Spawn debug-analyzer (bugs only) | `super-dev:debug-analyzer` |
| 5 | Spawn code-assessor | `super-dev:code-assessor` |
| 5.3 | Spawn architecture-agent | `super-dev:architecture-agent` |
| 5.5 | Spawn ui-ux-designer | `super-dev:ui-ux-designer` |
| 6 | Spawn spec-writer | `super-dev:spec-writer` |
| 7 | Validate spec (no agent) | (none) |
| 8 | Spawn dev-executor + qa-agent (parallel) | `super-dev:dev-executor`, `super-dev:qa-agent` |
| 9 | Spawn code-reviewer | `super-dev:code-reviewer` |
| 10 | Spawn docs-executor | `super-dev:docs-executor` |
| 11 | Coordinate cleanup | (varies) |
| 12 | Execute git operations (commit, merge) | (none) |
| 13 | Verify completion | (none) |

**KEY RULE:** If a phase requires work (Phase 2-10), Team Lead MUST use Task tool to spawn the appropriate agent. NEVER do the work directly.

For detailed coordinator methodology, see `references/coordinator-methodology.md`.

## Key Concepts

### Shared Task List
- States: pending, in_progress, completed
- Dependencies block tasks until resolved

### Option Presentation
Phases 3, 5.3, 5.5 require presenting 3-5 options to user for selection.

### Branch Name Rule
Git branch name MUST match worktree name: `[spec-index]-[spec-name]`

## Output Documents

All documents created in `specification/[index]-[name]/`:

| Document | Purpose |
|----------|---------|
| `[index]-requirements.md` | Clarified requirements |
| `[index]-research-report.md` | Research findings |
| `[index]-debug-analysis.md` | Debug analysis (bugs only) |
| `[index]-assessment.md` | Code assessment |
| `[index]-architecture.md` | Architecture design |
| `[index]-design-spec.md` | UI/UX design |
| `[index]-product-design-summary.md` | Architecture+UI cross-reference |
| `[index]-specification.md` | Technical specification |
| `[index]-implementation-plan.md` | Implementation plan |
| `[index]-task-list.md` | Detailed task list |
| `[index]-implementation-summary.md` | Final summary |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Agents not responding | Check agent team status, verify connections |
| Too many permission prompts | Pre-approve in permission settings |
| Agents stopping on errors | Check output, give additional instructions |
| Lead shuts down too early | Say "Keep going" or "Wait for agents" |
| File conflicts | Ensure each agent owns different files |

## Reference Documentation

See `references/` directory for detailed documentation:
- `workflow-phases.md` - Detailed phase-by-phase execution guide
- `coordinator-methodology.md` - Coordinator role and agent methodologies
- `architecture-patterns.md` - Software architecture patterns, SOLID principles, ADRs
- `backend-patterns.md` - API, database, caching patterns
- `coding-standards.md` - Language best practices and coding standards
- `debugging-patterns.md` - Systematic debugging methodology and root cause analysis
- `frontend-patterns.md` - React, Next.js patterns and best practices
- `research-methodology.md` - Multi-source research and option presentation
- `specification-templates.md` - Technical specification templates
- `testing-patterns.md` - Unit, integration, and E2E testing strategies
- `ui-ux-patterns.md` - UI/UX design patterns and accessibility guidelines

## Additional Resources

- **Dev Rules**: Load `super-dev/dev-rules` for coding standards
- **TDD Workflow**: Load `super-dev/tdd-guide` for test-driven development
- **Security Review**: Load `super-dev/security-reviewer` for security analysis
