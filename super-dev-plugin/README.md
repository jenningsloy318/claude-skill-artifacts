# Super Dev Plugin

A comprehensive team-lead-driven development workflow plugin for Claude Code with parallel agent execution for implementing features, fixing bugs, and refactoring code.

Enhanced with best practices from [everything-claude-code](https://github.com/affaan-m/everything-claude-code)

v2.3.52 — Stage-Based Workflow with Implementation Completeness:
- Terminology Clarity: Workflow steps renamed from "Phase" to "Stage" (Stage 1–14). "Phase" now exclusively refers to implementation-plan phases (Phase 1, 2, 3…)
- Implementation Completeness Loop: Stage 9/10 now iterates through ALL implementation-plan phases before proceeding to Stage 11
- Continuous Verification Gates: Programmatic quality checks between every stage handoff (6 gate scripts in `scripts/gates/`)
- Real Browser Testing: QA agent now runs browser smoke tests using chrome-devtools MCP for web apps
- Autoresearch Skill: Auto-improve agent prompts using Karpathy's iterative test-measure-improve method
- Investigation Protocol: New `investigator` agent for bounded mid-execution research when agents hit unknowns (inspired by gstack's `/investigate`)
- 10 Automated Hooks: Hook-level enforcement for safety, formatting, linting, testing, stage gates, and checkpoints (inspired by @zodchiii's 8 hooks principle)

*Inspired by: gstack (Garry Tan), Boris's Claude Code workflow, agentic engineering best practices 2026, @zodchiii's Claude Code hooks, and Anthropic's official skill design lessons.*

## Overview

This plugin provides a systematic development workflow orchestrated by a Coordinator Agent that:

- Assigns tasks to specialized sub-agents
- Monitors execution - no unauthorized stops
- Enforces quality gates at each stage
- Manages build queue (Rust/Go serialization)
- Ensures parallel execution during implementation (dev + qa + docs)

## Usage

### Main Entry Point

Directly invoke the `super-dev` skill:

```
Invoke the super-dev skill and describe your task
```

The Coordinator Agent will orchestrate all 14 stages automatically.

### Examples

```
"Fix the login button not responding on mobile"
"Implement user profile page with avatar upload"
"Refactor the authentication module for better testability"
"Improve API response time for product listing"
```

### Additional Commands

```
/plan - Implementation planning with planner agent
/tdd - Test-driven development workflow
/e2e - E2E test generation
/code-review - Quality and security review
/build-fix - Fix build errors
/refactor-clean - Dead code removal
/learn - Extract patterns mid-session
/test-coverage - Check test coverage
/update-docs - Update documentation
/update-codemaps - Update code maps
/autoresearch - Auto-improve agent prompts (Karpathy method)
```

## Architecture

```
                    ┌─────────────────┐
                    │   super-dev     │
                    │     Skill       │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   Coordinator   │ ◄── Central Authority
                    │     Agent       │
                    └────────┬────────┘
                             │
    ┌────────────────────────┼────────────────────────┐
    │                        │                        │
    ▼                        ▼                        ▼
┌─────────┐            ┌─────────┐            ┌─────────┐
│Planning │            │Analysis │            │Execution│
│ Agents  │            │ Agents  │            │ Agents  │
└─────────┘            └─────────┘            └─────────┘
```

## Plugin Structure

All instruction files (agents, commands, rules, contexts, skills, reference docs) use a unified XML-tagged format with a three-tier tag schema (`<meta>`, semantic content blocks, type-specific tags). README files and JSON/shell files remain in their original formats.

```
super-dev-plugin/
├── agents/                    # Specialized agents (30 total, XML-tagged)
│   ├── team-lead.md              # Central Team Lead Agent (super-dev unique)
│   ├── dev-executor.md             # Development Executor
│   ├── qa-executor.md              # QA Executor
│   ├── docs-executor.md            # Documentation Executor
│   ├── architecture-agent.md       # Architecture Design (super-dev unique)
│   ├── ui-ux-designer.md           # UI/UX Design (super-dev unique)
│   ├── spec-writer.md              # Specification Writer (super-dev unique)
│   ├── research-agent.md           # Research Agent (super-dev unique)
│   ├── code-reviewer.md            # Specification-Aware Review (super-dev unique)
│   ├── debug-analyzer.md           # Debug Analysis
│   ├── code-assessor.md            # Code Assessment
│   ├── requirements-clarifier.md   # Requirements Clarification
│   ├── search-agent.md             # Multi-Source Search
│   ├── qa-agent.md                 # QA Testing
│   ├── adversarial-reviewer.md      # Multi-lens Adversarial Review
│   ├── bdd-scenario-writer.md       # BDD Scenario Generation (Stage 3.5)
│   ├── investigator.md              # Mid-Execution Investigation (any stage, on-demand)
│   │
│   # Additional agents:
│   ├── build-error-resolver.md     # Build Error Resolution
│   ├── doc-updater.md              # Documentation Updates
│   ├── e2e-runner.md               # E2E Testing
│   ├── planner.md                  # Implementation Planning
│   ├── refactor-cleaner.md         # Dead Code Cleanup
│   ├── security-reviewer.md        # Security Analysis
│   ├── tdd-guide.md                # Test-Driven Development
│   │
│   # Developer Specialists:
│   ├── rust-developer.md
│   ├── golang-developer.md
│   ├── frontend-developer.md
│   ├── backend-developer.md
│   ├── android-developer.md
│   ├── ios-developer.md
│   ├── macos-app-developer.md
│   └── windows-app-developer.md
│
├── commands/                   # Slash commands (17 total, XML-tagged)
│   # super-dev commands:
│   ├── architecture-design.md
│   ├── code-assessment.md
│   ├── code-review.md
│   ├── debug-analysis.md
│   ├── documentation.md
│   ├── execute.md
│   ├── research.md
│   └── ui-ux-design.md
│   # Additional commands:
│   ├── build-fix.md
│   ├── e2e.md
│   ├── learn.md
│   ├── plan.md
│   ├── refactor-clean.md
│   ├── tdd.md
│   ├── test-coverage.md
│   ├── update-codemaps.md
│   └── update-docs.md
│
├── skills/                     # Skills (6 items, XML-tagged)
│   # super-dev skills:
│   ├── super-dev/                 # Main orchestrator skill
│   └── dev-rules/                 # Core development rules and philosophy
│   # Additional skills:
│   ├── tdd-workflow/              # Test-Driven Development methodology
│   ├── security-review/           # Security checklist
│   ├── continuous-learning/       # Auto-extract patterns from sessions
│   └── strategic-compact/         # Manual compaction suggestions
│
├── templates/                  # Reference materials and examples
│   └── reference/                # Reference documentation
│       ├── architecture-patterns.md  # Software architecture patterns, SOLID, ADRs
│       ├── ui-ux-patterns.md         # UI/UX design patterns, wireframes, accessibility
│       ├── debugging-patterns.md     # Systematic debugging methodology, root cause analysis
│       ├── research-methodology.md   # Multi-source research, option presentation, synthesis
│       ├── testing-patterns.md       # CLI, Desktop UI, Web testing strategies
│       ├── backend-patterns.md       # API, database, caching patterns
│       ├── frontend-patterns.md      # React, Next.js patterns
│       ├── coding-standards.md       # Language best practices
│       ├── bdd-patterns.md            # BDD scenario writing patterns and reference
│       ├── *-template.md              # XML-tagged document templates (14 files)
│       └── project-guidelines-example.md
│
├── rules/                      # Always-follow guidelines (7 files, XML-tagged)
│   ├── agents.md                 # When to delegate to subagents
│   ├── coding-style.md           # Immutability, file organization
│   ├── git-workflow.md           # Commit format, PR process
│   ├── patterns.md               # Common code patterns
│   ├── performance.md            # Model selection, context management
│   ├── security.md               # Mandatory security checks
│   └── testing.md                # TDD, coverage requirements
│
├── contexts/                   # Dynamic system prompt injection (XML-tagged)
│   ├── dev.md                    # Development mode context
│   ├── review.md                 # Code review mode context
│   └── research.md               # Research/exploration mode context
│
├── hooks/                     # Automated hooks (10 total)
│   ├── hooks.json                  # Hook configuration (PreToolUse/PostToolUse/Stop)
│   ├── block-dangerous.sh          # Block destructive Bash commands
│   ├── protect-files.sh            # Block edits to sensitive files
│   ├── log-commands.sh             # Audit trail of all commands
│   ├── require-tests-pr.sh         # Gate: tests must pass before PR
│   ├── stage-gate.sh               # Gate: validate stage artifacts before agent spawn
│   ├── stage-manifest.json         # Stage → required artifacts mapping
│   ├── auto-format.sh              # Auto-detect and run formatter
│   ├── auto-lint.sh                # Auto-detect and run linter
│   ├── run-tests.sh                # Run tests after edit (opt-in)
│   └── auto-checkpoint.sh          # Git checkpoint on stop
│
├── plugins/                    # Plugin ecosystem documentation
│   └── README.md                # Plugins and marketplaces guide
│
├── examples/                   # Example configurations
│   ├── CLAUDE.md                # Example project-level config
│   ├── user-CLAUDE.md           # Example user-level config
│   └── statusline.json          # Example statusline config
│
└── scripts/                    # Utility scripts
    └── (existing scripts)
```

## Workflow Stages

| Stage | Name | Agent/Skill | Description |
|-------|------|-------------|-------------|
| 1 | Apply Dev Rules | `super-dev:dev-rules` skill | Establish coding standards |
| 2 | Specification Setup | Coordinator | Create worktree, spec dir, team |
| 3 | Requirements Clarification | `super-dev:requirements-clarifier` | Gather complete requirements |
| 3.5 | BDD Scenario Writing | `super-dev:bdd-scenario-writer` | Generate Given/When/Then scenarios (MANDATORY) |
| 4 | Research | `super-dev:research-agent` | Find best practices |
| 4.5 | Deep Research | `super-dev:research-agent` | Targeted investigation of flagged issues (conditional) |
| 5 | Debug Analysis | `super-dev:debug-analyzer` | Root cause analysis (grep/ast-grep) |
| 6 | Code Assessment | `super-dev:code-assessor` | Evaluate codebase (grep/ast-grep) |
| 6.3 | Architecture Design | `super-dev:architecture-agent` | For complex features (optional) |
| 6.5 | UI/UX Design | `super-dev:ui-ux-designer` | For features with UI (optional) |
| 7 | Specification Writing | `super-dev:spec-writer` | Create tech spec, plan, tasks |
| 8 | Specification Review | `super-dev:spec-reviewer` | Validate all documents |
| 9-10 | Implementation + Review | PARALLEL: specialists + qa + reviewers | Implement ALL plan phases with review loop |
| 11 | Documentation | `super-dev:docs-executor` | Update documentation |
| 11.5 | Handoff | `super-dev:handoff-writer` | Session handoff document |
| 12-13 | Cleanup & Commit | Coordinator | Terminate agents, commit, merge |
| 14 | Final Verification | Coordinator | Verify all complete |

## Key Features

### Super-Dev Unique Features

1. Coordinator Agent - Central orchestrator for all workflow stages
2. Git Worktree Requirement - MANDATORY isolation for development
3. Specification-Aware Code Review - Validates against technical specs
4. Parallel Execution - Specialists + QA run simultaneously
5. Build Queue Management - Rust/Go serialization for resource safety
6. Implementation Completeness Loop - ALL plan phases must be implemented before docs stage
7. BDD Integration - Mandatory Stage 3.5 for behavior scenario generation with 100% coverage gate
8. Investigation Protocol - Bounded mid-execution investigation when agents hit unknowns (auto-triggered by dev-executor, qa-agent, code-reviewer)

### Additional Integrated Features

1. TDD Workflow Skill - Comprehensive test-driven development methodology
2. Security Review Skill - Security checklist and validation
3. Rules System - Modular always-follow guidelines
4. Contexts - Dynamic system prompt injection (dev/review/research modes)
5. MCP Configurations - Pre-configured MCP server templates
6. Additional Agents - planner, tdd-guide, security-reviewer, refactor-cleaner, etc.
7. Additional Commands - /plan, /tdd, /e2e, /refactor-clean, etc.

## Hooks (10 Total)

Hooks are automatic actions that fire every time Claude edits a file, runs a command, or finishes a task. Unlike CLAUDE.md rules (~80% compliance), hooks provide 100% enforcement — they run in the background without Claude needing to remember.

### PreToolUse Hooks (block before action)

| # | Hook | Matcher | Purpose |
|---|------|---------|---------|
| 1 | `usage-tracker.sh` | `Skill\|Agent` | Track skill/agent invocations to usage log |
| 2 | `block-dangerous.sh` | `Bash` | Block `rm -rf`, `DROP TABLE`, `git push --force`, etc. (exit 2) |
| 3 | `protect-files.sh` | `Edit\|Write` | Block edits to `.env`, `.pem`, `secrets/`, `.git/` (exit 2) |
| 4 | `log-commands.sh` | `Bash` | Timestamped audit trail of every command |
| 5 | `require-tests-pr.sh` | `mcp__github__create_pull_request` | Hard gate: tests must pass before PR creation |
| 6 | `stage-gate.sh` | `Agent` | Validate previous stage artifacts before spawning next agent |

### PostToolUse Hooks (quality control after action)

| # | Hook | Matcher | Purpose |
|---|------|---------|---------|
| 7 | `auto-format.sh` | `Write\|Edit` | Auto-detect formatter (prettier/biome/black/ruff/gofmt/rustfmt) |
| 8 | `auto-lint.sh` | `Write\|Edit` | Auto-detect linter (eslint/biome/ruff/golangci-lint/clippy) |
| 9 | `run-tests.sh` | `Write\|Edit` | Run tests after edit (opt-in: `SUPER_DEV_TEST_ON_EDIT=1`) |

### Stop Hook (cleanup on session end)

| # | Hook | Matcher | Purpose |
|---|------|---------|---------|
| 10 | `auto-checkpoint.sh` | (all) | Create recoverable git checkpoint via `git stash create` |

### Stage Gate (Hook #6)

The stage-gate hook validates that prerequisite artifacts exist before spawning stage agents. It reads `stage-manifest.json` to map agent types to required files:

```
Stage 3.5  (BDD)        → requires [doc-index]-requirements.md
Stage 4    (Research)    → requires [doc-index]-requirements.md + [doc-index]-bdd-scenarios.md
Stage 6    (Assessment)  → requires [doc-index]-research-report.md
Stage 7    (Spec)        → requires [doc-index]-code-assessment.md
Stage 9    (Execution)   → requires [doc-index]-specification.md + [doc-index]-implementation-plan.md + [doc-index]-task-list.md
Stage 10   (Review)      → requires [doc-index]-specification.md
Stage 11   (Docs)        → requires [doc-index]-specification.md
Stage 11.5 (Handoff)     → requires [doc-index]-specification.md
```

The gate also validates required sections within files (e.g., requirements.md must contain "Acceptance Criteria").

### Configuration

Hooks are defined in `hooks/hooks.json` and activated automatically when the plugin is loaded. Environment variables:

- `SUPER_DEV_TEST_ON_EDIT=1` — Enable test-on-edit feedback loop (Hook #9)
- `SUPER_DEV_SPEC_DIR=/path` — Override spec directory detection for stage gates

## Agents

### Coordinator Agent (Central Authority)

The Coordinator Agent orchestrates ALL workflow stages:

- Task Assignment: Assigns correct sub-agent per stage
- Monitoring: Ensures no unauthorized stops or missing tasks
- Build Queue: Manages Rust/Go build serialization
- Quality Gates: Enforces checkpoints at stage boundaries
- Implementation Completeness: Verifies ALL plan phases are done before docs
- Final Verification: Verifies all artifacts complete

Invoke: `Task(subagent_type: "super-dev:team-lead")`

### Executor Agents (Parallel Execution)

During Stage 9-10, specialists + QA run in PARALLEL:

| Agent | Purpose | Invoke Via |
|-------|---------|------------|
| `dev-executor` | Implements code, invokes specialists | `super-dev:dev-executor` |
| `qa-agent` | Writes and runs tests | `super-dev:qa-agent` |
| `docs-executor` | Updates documentation | `super-dev:docs-executor` |

Build Policy (Rust/Go): Only ONE build at a time to prevent resource conflicts.

### Workflow Agents

| Agent | Purpose | Invoke Via |
|-------|---------|------------|
| `requirements-clarifier` | Gather requirements | `super-dev:requirements-clarifier` |
| `research-agent` | Research with Time MCP | `super-dev:research-agent` |
| `search-agent` | Multi-source search | `super-dev:search-agent` |
| `debug-analyzer` | Root cause analysis (grep/ast-grep) | `super-dev:debug-analyzer` |
| `code-assessor` | Assess codebase (grep/ast-grep) | `super-dev:code-assessor` |
| `code-reviewer` | Specification-aware code review | `super-dev:code-reviewer` |
| `architecture-agent` | Design architecture and create ADRs | `super-dev:architecture-agent` |
| `ui-ux-designer` | Create UI/UX design specifications | `super-dev:ui-ux-designer` |
| `spec-writer` | Write specifications | `super-dev:spec-writer` |
| `qa-agent` | Modality-specific QA testing | `super-dev:qa-agent` |
| `bdd-scenario-writer` | BDD scenario generation (Stage 3.5) | `super-dev:bdd-scenario-writer` |
| `investigator` | Mid-execution investigation (any stage, on-demand) | `super-dev:investigator` |
| `planner` | Implementation planning | `planner` |
| `tdd-guide` | Test-driven development | `tdd-guide` |
| `security-reviewer` | Security analysis | `security-reviewer` |
| `build-error-resolver` | Fix build errors | `build-error-resolver` |
| `refactor-cleaner` | Dead code cleanup | `refactor-cleaner` |
| `doc-updater` | Documentation sync | `doc-updater` |
| `e2e-runner` | Playwright E2E testing | `e2e-runner` |

## Skills

### super-dev

Main entry point skill that documents the workflow. The Coordinator Agent is invoked to orchestrate all stages.

### dev-rules

Core development rules and standards including:
- Git workflow rules (no GitHub Actions, selective commits)
- Git Worktree Requirement (CRITICAL - MANDATORY)
- Git Safety & Checkpoint Rules
- Development philosophy (incremental development, pragmatic approach)
- Quality standards (testability, readability, consistency)
- Decision framework priorities
- Figma MCP Integration Rules
- MCP Script Usage
- Time MCP Rules
- Codebase Search with ast-grep
- Documentation Update Rules

### tdd-workflow

Comprehensive test-driven development methodology with:
- Tests BEFORE code requirement
- 80%+ minimum coverage (unit + integration + E2E)
- Test patterns for Jest/Vitest, Playwright
- Mocking external services
- Coverage verification
- Best practices and common mistakes

### security-review

Security checklist and validation:
- No hardcoded secrets
- Input validation
- SQL injection prevention
- XSS/CSRF protection
- Authentication/authorization verification
- Rate limiting on endpoints
- Error message sanitization

## Reference Materials

The `templates/reference/` directory contains reference documentation (XML-tagged format):

### architecture-patterns

Software architecture patterns, SOLID principles, ADR templates.

### ui-ux-patterns

UI/UX design patterns, wireframes, accessibility guidelines.

### debugging-patterns

Systematic debugging methodology, root cause analysis, evidence collection, and hypothesis verification.

### research-methodology

Multi-source research, option presentation, Time MCP integration, and synthesis techniques.

### Document Templates (XML-tagged)

14 XML-tagged document templates in `templates/reference/*-template.md`. Each agent loads its template at runtime for consistent document formatting. Templates cover: requirements, bdd-scenarios, specification, implementation-plan, task-list, handoff, code-review, adversarial-review, implementation-summary, architecture, design-spec, product-design-summary, spec-review, qa-report.

### testing-patterns

CLI, Desktop UI, and Web testing strategies, coverage tracking, and quality gates.

### coding-standards

Language best practices reference.

### bdd-patterns

BDD scenario writing patterns, Gherkin-like syntax reference, banned words, test reference patterns per language, and quality checklists.

### backend-patterns

API, database, caching patterns.

### frontend-patterns

React, Next.js patterns.

### project-guidelines-example

Example project-specific skill template (based on Zenith production app).

## Rules

The `rules/` directory contains modular always-follow guidelines:

- agents.md - When to delegate to subagents
- coding-style.md - Immutability, file organization, error handling
- git-workflow.md - Commit format, PR process
- patterns.md - Common code patterns (API response format, custom hooks, repository pattern)
- performance.md - Model selection (Haiku/Sonnet/Opus), context window management
- security.md - Mandatory security checks
- testing.md - TDD, 80% coverage requirement

## Contexts

The `contexts/` directory provides dynamic system prompt injection:

- dev.md - Development mode (write code first, prefer working solutions)
- review.md - Code review mode (critical analysis, specification validation)
- research.md - Research mode (gather information, explore options)

## Output Documents

All documents are created in `specification/[index]-[name]/` directory:

1. `[index]-requirements.md` - Clarified requirements
2. `[index]-research-report.md` - Research findings with freshness scores
3. `[index]-debug-analysis.md` - Debug analysis (bugs only)
4. `[index]-code-assessment.md` - Code assessment with coverage
5. `[index]-architecture.md` - Architecture design (complex features)
6. `[index]-design-spec.md` - UI/UX design (UI features)
7. `[index]-specification.md` - Technical specification
8. `[index]-implementation-plan.md` - Implementation plan
9. `[index]-task-list.md` - Detailed task list
10. `[index]-implementation-summary.md` - Final summary

## License

MIT

## Credits

- super-dev-plugin - Coordinator-driven development workflow
- everything-claude-code - Additional agents, commands, skills, rules, and configurations
