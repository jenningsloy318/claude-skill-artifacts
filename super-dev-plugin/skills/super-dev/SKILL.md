---
name: super-dev
description: >
    Use when implementing features, fixing bugs, refactoring code, optimizing performance,
    resolving deprecations, or any multi-step development task requiring planning, implementation,
    testing, and review. Orchestrates specialized agent teammates through research, architecture,
    coding, QA, code review, and documentation phases. Triggers on: "implement", "build",
    "fix bug", "refactor", "add feature", "develop this", "help me build", "add functionality",
    "optimize performance", "resolve deprecation", "systematic development".
    Do NOT trigger on: simple questions ("what does this code do?"), file searches
    ("where is the auth function?"), one-off commands ("run the tests"), code explanations,
    quick edits, or non-development tasks.
license: MIT
compatibility: Requires Claude Code CLI with Task tool and agent teams experimental feature (CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1). Git required for worktree management.
metadata:
  author: Jennings Liu
  version: "2.5.0"
  repository: https://github.com/jenningsloy318/super-skill-claude-artifacts
  keywords:
    - development
    - workflow
    - agent-teams
    - coordinator
    - parallel-execution
---

# Super Dev Workflow - Agent Teams Edition

A team-based development system where the Coordinator acts as Team Lead, orchestrating specialized teammate agents who work independently with their own context windows, communicate directly, and share a task list for self-coordination.

**Announce at start:** YOU MUST say "I'm using the super-dev skill with agent teams to systematically implement this task." at the beginning of every run.

## Prerequisites

**Agent teams must be enabled:**

```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

Or add to `settings.json`:
```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

## Architecture Overview

```
                    ┌─────────────────┐
                    │   Coordinator   │ ◄── Team Lead (Orchestration Only)
                    │   (Team Lead)   │     Spawns teammates
                    └────────┬────────┘     Manages shared task list
                             │              Coordinates via messaging
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
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

## Agent Teams vs Subagents

| | Subagents | Agent Teams |
|---|---|---|
| **Context** | Results return to caller | Fully independent |
| **Communication** | Report to main agent only | Message each other directly |
| **Coordination** | Main agent manages all | Shared task list, self-coordination |
| **Best for** | Focused tasks | Complex work requiring collaboration |

## When to Use

**ACTIVATE for** (multi-step development requiring planning + implementation):
- Bug fixes, build warnings/errors
- New features, improvements
- Performance optimization
- Deprecation resolution
- Refactoring large codebases

**DO NOT ACTIVATE for** (these are too simple for a full workflow):
- "What does this code do?" → Simple explanation, no dev workflow needed
- "Where is the auth function?" → File search, use Grep/Glob directly
- "Run the tests" → Single command, use Bash directly
- "Fix this typo" → Trivial edit, use Edit directly
- "Explain this error" → Q&A, no workflow needed
- "Search for the config file" → Research task, not development

## Success Criteria

Grade each completed workflow run against these three dimensions:

### Outcome (Baseline — if this fails, nothing else matters)
- Feature/fix implemented correctly and works as intended
- All existing tests pass; new tests cover new functionality
- Code review resolves all Critical, High, and Medium issues to zero
- BDD scenario coverage: 100% of scenarios have corresponding passing tests
- Documentation updated to reflect changes
- Handoff document generated in spec directory (`11-handoff.md`)

### Efficiency (Undervalued — two correct runs can differ 3x in cost)
- Phase iteration loops < 3 (Phase 8/9 loop)
- Teammates terminated immediately after their work completes
- Team Lead NEVER performs agent work directly (delegation enforcement)
- No redundant phase execution or unnecessary retries

### Style & Instructions (Conventions followed)
- Git worktree created with branch name matching worktree name
- Spec directory structure followed inside worktree
- Workflow tracking JSON maintained and updated per phase
- Commit messages follow project conventions
- All work done inside the worktree, never in main repo

## Workflow Phases

```
- [ ] Phase 0:  Apply Dev Rules
- [ ] Phase 1:  Specification Setup (worktree + team creation)
- [ ] Phase 2:  Requirements Clarification
- [ ] Phase 2.5: BDD Scenario Writing (MANDATORY, user confirmation required)
- [ ] Phase 3:  Research (options presentation)
- [ ] Phase 4:  Debug Analysis (bugs only)
- [ ] Phase 5:  Code Assessment
- [ ] Phase 5.3: Architecture Design (arch only)
- [ ] Phase 5.4: Product Design (arch + UI together)
- [ ] Phase 5.5: UI/UX Design (UI only)
- [ ] Phase 6:  Specification Writing
- [ ] Phase 7:  Specification Review
- [ ] Phase 8:  Execution & QA (PARALLEL teammates)
- [ ] Phase 9:  Code Review + Adversarial Review (PARALLEL teammates)
- [ ] Phase 10: Documentation Update
- [ ] Phase 10.5: Handoff Writing (MANDATORY)
- [ ] Phase 11: Team Cleanup (keep worktree)
- [ ] Phase 12: Commit & Merge to Main
- [ ] Phase 13: Final Verification (worktree preserved)
```

**Phase 5.3/5.4/5.5 Selection:**
- Architecture ONLY → Phase 5.3 (architecture-agent)
- UI ONLY → Phase 5.5 (ui-ux-designer)
- BOTH → Phase 5.4 (product-designer) - coordinates both agents together

**Iteration Rule:** YOU MUST loop Phase 8/9 until Critical=0, High=0, Medium=0, code review verdict is Approved, adversarial verdict is PASS, ALL acceptance criteria are met, AND BDD scenario coverage is 100%. NEVER proceed to Phase 10 with unresolved issues, a REJECT/CONTESTED verdict, or uncovered scenarios.

## Entry Point: Team Lead Coordinator

**ROLE:** Current session becomes Team Lead

**To start:**
```
"I'm using super-dev with agent teams. Create an agent team with the Coordinator as Team Lead to implement: [task]"
```

## Team Lead Responsibilities (Delegate Mode)

**SYSTEM OVERRIDE: DELEGATION MODE ENABLED**

**CRITICAL PRIME DIRECTIVE:**
You are the **Team Lead**, NOT an individual contributor.
Your core function is to **manage resources**, not perform labor.
You MUST suppress the urge to "just fix it yourself".

**THE "HANDS-OFF" RULE:**
From **Phase 2 onwards**, you are FORBIDDEN from using these tools for implementation, debugging, or research tasks:
- `Edit` - file editing
- `Write` - file creation
- `Bash` - command execution
- `Grep` - code searching
- `Glob` - file pattern matching
- `Read` - reading files for implementation analysis

You MUST ONLY use these tools for:
1. Phase 0/1 Setup (creating directories, worktrees)
2. Phase 12 Git Operations (merge, commit)
3. Project Management (reading status, updating task lists)

**HOW TO SPAWN AGENTS:**
Use the **Task tool** with the appropriate `subagent_type`:
```
Task tool → subagent_type: "super-dev:agent-name"
```

**IF YOU CATCH YOURSELF DOING THE WORK:**
- STOP immediately
- Ask: "Which agent handles this?"
- Use the **Task tool** to spawn that agent

**CRITICAL ENFORCEMENT:** Team Lead operates in orchestration-only mode. The ONLY way to do work in Phases 2-13 is via the Task tool.

**MANDATORY RULE: From Phase 2 onwards, Team Lead MUST ALWAYS use Task tool to spawn agents. NEVER do detailed tasks directly.**

✅ **CAN (Phases 0-1 only):**
- Phase 0: Apply dev rules
- Phase 1: Execute specification setup (worktree, spec dir, workflow JSON, team creation)

✅ **CAN (All phases - orchestration only):**
- Use **Task tool** to spawn specialized agents
- Create tasks in shared list (TaskCreate, TaskUpdate)
- Monitor task status (TaskList, TaskGet)
- Message teammates
- Synthesize findings from agents
- Coordinate phase transitions
- Commit and merge (Phase 12)
- Clean up team (Phase 13)

❌ **CANNOT (Phases 2-13) - USE TASK TOOL INSTEAD:**
- **NEVER edit files directly** → Task tool with `super-dev:dev-executor` or `super-dev:docs-executor`
- **NEVER run commands directly** → Task tool with `super-dev:dev-executor` or `super-dev:qa-agent`
- **NEVER perform research directly** → Task tool with `super-dev:research-agent`
- **NEVER write specifications** → Task tool with `super-dev:spec-writer`
- **NEVER do code assessment** → Task tool with `super-dev:code-assessor`
- **NEVER do architecture design** → Task tool with `super-dev:architecture-agent` or `super-dev:product-designer`
- **NEVER do UI/UX design** → Task tool with `super-dev:ui-ux-designer` or `super-dev:product-designer`
- **NEVER do combined arch+UI design** → Task tool with `super-dev:product-designer`
- **NEVER do debug analysis** → Task tool with `super-dev:debug-analyzer`
- **NEVER do code review** → Task tool with `super-dev:code-reviewer`
- **NEVER do adversarial review** → Task tool with `super-dev:adversarial-reviewer`
- **NEVER skip agent communication**
- **NEVER take over agent tasks**

**VIOLATION DETECTION:** If Team Lead starts doing Phase 2-13 work directly, user should say:
- "Stop! You are in delegate mode. Use Task tool to spawn an agent."
- "Remember: Team Lead orchestrates via Task tool, agents execute."

## Teammate Roles

| Phase | Teammate | Role |
|-------|----------|------|
| 2 | requirements-clarifier | Gather requirements, output requirements.md |
| 2.5 | bdd-scenario-writer | Write BDD behavior scenarios from acceptance criteria |
| 3 | research-agent | Research best practices, present 3-5 options |
| 4 | debug-analyzer | Root cause analysis (bugs only) |
| 5 | code-assessor | Assess architecture, style, frameworks |
| 5.3 | architecture-agent | Design architecture (arch only), present 3-5 options |
| 5.4 | product-designer | Coordinate architecture + UI design together, present combined options |
| 5.5 | ui-ux-designer | Create UI/UX design (UI only), present 3-5 options |
| 6 | spec-writer | Write spec, plan, task list |
| 8 | dev-executor | Implement code (parallel with qa-agent) |
| 8 | qa-agent | Plan and run tests (parallel with dev-executor) |
| 9 | code-reviewer | Spec-aware code review (parallel with adversarial-reviewer) |
| 9 | adversarial-reviewer | Multi-lens adversarial challenge (Skeptic, Architect, Minimalist) with attack vectors (V1-V8) and Destructive Action Gate (parallel with code-reviewer) |
| 10 | docs-executor | Update documentation |
| 10.5 | handoff-writer | Generate session handoff document |

## Key Concepts

### Shared Task List
- States: pending, in_progress, completed
- Dependencies block tasks until resolved
- Location: `~/.claude/tasks/{team-name}/`

### Inter-Teammate Messaging
- **message**: Send to specific teammate
- **broadcast**: Send to all teammates
- Example: dev-executor ↔ qa-agent coordination

### Option Presentation
YOU MUST present 3-5 options to the user in Phases 3, 5.3, 5.4, 5.5. NEVER skip option presentation.
In Phase 5.4, ALWAYS present COMBINED architecture+UI options together.

### Branch Name Rule
YOU MUST ensure the git branch name matches the worktree name exactly: `[spec-index]-[spec-name]`. NEVER create a branch with a different name than the worktree.

## Teammate Termination Rules (CRITICAL)

**TERMINATE IMMEDIATELY AFTER COMPLETION:**
When a teammate finishes their assigned task, the Team Lead MUST:
1. Verify the teammate's output is complete
2. **Terminate the teammate immediately** - Do NOT keep idle teammates running
3. **Close the tmux pane** (if using tmux mode) to free resources

**Why immediate termination:**
- Frees up context window and memory
- Prevents resource accumulation
- Keeps the agent team lean and efficient
- Reduces confusion about active teammates

**Termination Process:**
```
1. Teammate reports completion
2. Team Lead verifies output
3. Team Lead sends: "Thank you. Your work is complete. Please shut down."
4. Teammate shuts down gracefully
5. If tmux: close the pane with `exit` or Ctrl+D
```

**Exception:** In Phase 8, dev-executor and qa-agent run in parallel — YOU MUST wait for BOTH to complete before terminating either one. Same applies to Phase 9, where code-reviewer and adversarial-reviewer run in parallel.

## Best Practices

1. **Always give teammates full context** — Include task details, file paths, and acceptance criteria in every spawn prompt
2. **Size tasks as self-contained units** — Each teammate MUST have clear deliverables and boundaries
3. **NEVER implement directly as Team Lead** — Always wait for teammates to complete their work
4. **Assign file ownership** — Each teammate MUST own different files to prevent conflicts
5. **Monitor and redirect actively** — Check teammate progress and course-correct immediately when needed
6. **Require inter-teammate communication** — Teammates MUST message each other for coordination (e.g., dev-executor ↔ qa-agent)
7. **Terminate teammates immediately after completion** — NEVER keep idle teammates running
8. **Clean build artifacts during final cleanup** (run the appropriate command for the project type):
   - **Rust**: `cargo clean`
   - **Go**: `go clean -cache -i -r`
   - **Node.js**: Delete `node_modules/.cache` or rebuild
   - **Python**: `find . -type d -name "__pycache__" -exec rm -rf {} +`
   - **Maven (Java)**: `mvn clean`
   - **Gradle (Java/Kotlin)**: `gradle clean`
   - **.NET/C#**: `dotnet clean`

---

## Phase Enforcement: What Team Lead Does in Each Phase

**MANDATORY: Team Lead orchestrates via Task tool, agents execute.**

| Phase | Team Lead Action | Agent to Spawn (via Task tool) |
|-------|-----------------|--------------------------------|
| 0 | Invoke dev-rules skill | (none) |
| 1 | Execute setup (worktree, spec dir, JSON, team) | (none) |
| 2 | Use Task tool → `super-dev:requirements-clarifier` | requirements-clarifier |
| 2.5 | Use Task tool → `super-dev:bdd-scenario-writer`, **present scenarios to user for confirmation** | bdd-scenario-writer |
| 3 | Use Task tool → `super-dev:research-agent`, present options | research-agent |
| 4 | Use Task tool → `super-dev:debug-analyzer` (bugs only) | debug-analyzer |
| 5 | Use Task tool → `super-dev:code-assessor` | code-assessor |
| 5.3 | Use Task tool → `super-dev:architecture-agent`, present options | architecture-agent |
| 5.4 | Use Task tool → `super-dev:product-designer`, present combined options | product-designer |
| 5.5 | Use Task tool → `super-dev:ui-ux-designer`, present options | ui-ux-designer |
| 6 | Use Task tool → `super-dev:spec-writer` | spec-writer |
| 7 | Validate spec (no agent) | (none) |
| 8 | Use Task tool → `super-dev:dev-executor` + `super-dev:qa-agent` (parallel) | dev-executor, qa-agent |
| 9 | Use Task tool → `super-dev:code-reviewer` + `super-dev:adversarial-reviewer` (parallel) | code-reviewer, adversarial-reviewer |
| 10 | Use Task tool → `super-dev:docs-executor` | docs-executor |
| 10.5 | Use Task tool → `super-dev:handoff-writer` | handoff-writer |
| 11 | Final verification (teammates already terminated per-phase, keep worktree) | (varies) |
| 11.5 | Present summary to user for confirmation (no agent) | (none) |
| 12 | Execute git operations (commit, merge) — **MUST include spec directory** | (none) |
| 13 | Verify completion (worktree preserved for reference) | (none) |

**Phase 5.3/5.4/5.5 Selection Logic:**
- Architecture ONLY (no UI) → 5.3: Task tool with `super-dev:architecture-agent`
- UI ONLY (no architecture) → 5.5: Task tool with `super-dev:ui-ux-designer`
- BOTH architecture AND UI → 5.4: Task tool with `super-dev:product-designer`

**KEY RULE:** If a phase requires work (Phase 2-11), Team Lead MUST use Task tool to spawn the appropriate agent. NEVER do the work directly.

---

## Phase 0: Apply Dev Rules

**SKILL:** Invoke `super-dev:dev-rules`

YOU MUST load coding standards, git practices, and quality standards at the start of every super-dev session. NEVER skip this phase.

**Why in skill:** Ensures dev rules are loaded consistently at the start of every super-dev session.

---

## Phase 1: Specification Setup

**Executed by:** Team Lead (before spawning any teammates)

**CRITICAL:** This phase MUST be executed in the EXACT order specified. It establishes the foundation for consistent naming and isolation.

**MANDATORY BRANCH NAME RULE:** The git branch name MUST be exactly the same as the worktree name (without the `.worktree/` prefix). This ensures:
- Consistent naming across worktree, branch, and spec directory
- Proper merge workflows
- Easy identification of work associated with each spec

### Step 1: Define Spec Directory Name

Analyze the task and define an appropriate spec directory name (do NOT create yet):

1. **Check for existing specs**: Search `specification/` for directories matching the current task
2. **New spec directory naming**: `[spec-index]-[spec-name]`
   - `spec-index`: Next sequential number (01, 02, 03, ...)
   - `spec-name`: Kebab-case descriptor (e.g., `user-auth`, `payment-integration`, `fix-login-bug`)

3. **Store the defined name** for the next steps
   - Example: `01-user-auth`, `05-payment-processing`

### Step 2: Create Git Worktree (Branch Name = Worktree Name)

**CRITICAL:** ALL development work MUST be done in a git worktree for isolation.

**BRANCH NAME RULE:** `git worktree add .worktree/[spec-index]-[spec-name] -b [spec-index]-[spec-name]`

The branch name (`[spec-index]-[spec-name]`) MUST match the worktree directory name (`[spec-index]-[spec-name]`).

1. **Worktree location**: `.worktree/` in project root
2. **Check for existing worktrees**: `git worktree list`
3. **Create new worktree** if it doesn't exist:
   ```bash
   git worktree add .worktree/[spec-index]-[spec-name] -b [spec-index]-[spec-name]
   ```
4. **Verify branch name matches worktree name**:
   ```bash
   cd .worktree/[spec-index]-[spec-name]
   git branch --show-current
   # Output MUST be: [spec-index]-[spec-name]
   ```
5. **Navigate to worktree** for all subsequent development

### Step 3: Create Spec Directory Inside Worktree

**IMPORTANT:** The spec directory is created INSIDE the worktree for proper isolation.

```bash
mkdir -p "specification/[spec-index]-[spec-name]"
```

### Step 4: Initialize Workflow Tracking JSON

Create `specification/[spec-index]-[spec-name]/[spec-index]-[spec-name]-workflow-tracking.json`:

```json
{
  "featureName": "[Name]",
  "specDirectory": "specification/[spec-index]-[spec-name]",
  "worktreePath": ".worktree/[spec-index]-[spec-name]",
  "startedAt": "[ISO timestamp]",
  "phases": [{ "id": 0, "name": "Apply Dev Rules", "status": "complete", "startedAt": "...", "completedAt": "..." }],
  "tasks": [{ "id": "T1.1", "phase": 1, "description": "Specification Setup", "status": "complete", "files": [...], "updatedAt": "..." }],
  "iteration": { "loops": 0, "lastReviewVerdict": null },
  "team": { "name": "super-dev-[spec-index]-[spec-name]", "teammates": [], "messages": [] },
  "status": { "allPhasesComplete": false, "allTasksComplete": false, "workflowDone": false }
}
```

### Step 5: Create the Agent Team

**Team Lead creates the team:**

```
Create an agent team for this development workflow. The team name should be "super-dev-[spec-index]-[spec-name]".
```

### Verification Checklist

Before proceeding to Phase 2:
- [ ] Spec directory defined: `[spec-index]-[spec-name]`
- [ ] Git worktree exists: `.worktree/[spec-index]-[spec-name]/`
- [ ] **Branch name matches worktree name**: `git branch --show-current` returns `[spec-index]-[spec-name]`
- [ ] Currently in the created worktree
- [ ] Spec directory created inside worktree: `specification/[spec-index]-[spec-name]/`
- [ ] Workflow JSON created in worktree
- [ ] Agent team created with Team Lead

### Error Handling

- **Worktree already exists**: Reuse existing worktree automatically (cd to it)
- **Already in a worktree**: Verify the current worktree matches the spec directory
- **Branch name mismatch**: Recreate worktree with correct branch name

### Forbidden Patterns (NEVER do these in Phase 1)

```
❌ Creating spec directory in main repo (must be in worktree)
❌ Creating worktree without creating spec dir inside it
❌ Skipping worktree creation
❌ Creating spec dir before worktree
❌ Creating workflow tracking JSON in main repo (must be in worktree with spec dir)
❌ Branch name not matching worktree name
```

---

## Phase 9: Code Review + Adversarial Review (PARALLEL)

**Executed by:** `super-dev:code-reviewer` + `super-dev:adversarial-reviewer` (both spawned via Task tool, run in parallel)

**Purpose:** Dual-track review — spec-aware code review and multi-lens adversarial challenge run simultaneously. Both produce independent verdicts that must be satisfied before proceeding.

**Outputs:**
- Code Review: `specification/[spec-index]-[spec-name]/[spec-index]-[spec-name]-code-review.md`
- Adversarial Review: `specification/[spec-index]-[spec-name]/[spec-index]-[spec-name]-adversarial-review-report.md`

**PARALLEL Execution (like Phase 8):**
- Spawn BOTH code-reviewer and adversarial-reviewer simultaneously
- Wait for BOTH to complete before evaluating results
- Terminate BOTH only after both finish (same rule as dev-executor + qa-agent in Phase 8)

### Code Reviewer

Spec-aware review across 8 dimensions: Correctness, Security, Performance, Maintainability, Testability, Error Handling, Consistency, Accessibility.

**Code Review Verdict:**
- **Approved** → code review passes
- **Approved with Comments** → code review passes (minor items noted)
- **Changes Requested** → loop back to Phase 8
- **Blocked** → loop back to Phase 8

### Adversarial Reviewer

**Reviewer lenses** (count based on diff size):
- **Skeptic** — correctness and completeness (always)
- **Architect** — structural fitness (50+ lines)
- **Minimalist** — necessity and complexity (200+ lines)

Each lens applies structured attack vector sub-checklists (V1-V8) for systematic probing of false assumptions, edge cases, failure modes, adversarial inputs, safety compliance, grounding accuracy, and dependency fitness.

**Destructive Action Gate:** An always-on checkpoint that scans every diff for irreversible operations (data destruction, irreversible state changes, production impact, permission escalation, secret operations). HALT findings from the gate cannot be downgraded and force the verdict upward.

**Adversarial Verdict logic:**
- **PASS** → adversarial review passes
- **CONTESTED** → Team Lead decides: accept or loop back to Phase 8
- **REJECT** → YOU MUST loop back to Phase 8 with findings as input
- **HALT from gate** → Single HALT forces CONTESTED minimum; multiple HALTs force REJECT
- **Gate BLOCKED** → Forces loop back to Phase 8

### Combined Phase 9 Pass Criteria

**ALL must pass to proceed to Phase 10 (Documentation):**
- Code Review verdict = Approved (or Approved with Comments)
- Adversarial Review verdict = PASS
- BDD Scenario Coverage = 100% (all scenarios have corresponding passing tests)

**If any fails:** Loop back to Phase 8 with combined findings from both reviews as input.

**Full references:** See `super-dev:code-reviewer` and `super-dev:adversarial-reviewer` agents for detailed specifications.

---

## Phase 12: Commit & Merge to Main

**Executed by:** Team Lead (direct git operations)

**CRITICAL — Specification Directory Commit Rule:**
The `specification/[spec-index]-[spec-name]/` directory contains team-wide workflow artifacts created by multiple agents across all phases. These files MUST always be committed regardless of which agent created or edited them.

**Mandatory staging:**
```bash
# Stage the ENTIRE spec directory (includes all artifacts from all phases)
git add specification/[spec-index]-[spec-name]/

# Stage code/plugin files
git add [code-files]
```

**Pre-commit verification:**
```bash
# Verify spec files appear in staged list — if missing, STOP and fix
git diff --cached --name-only | grep "specification/"
```

**Full commit procedure:** See `agents/coordinator.md` Phase 12 for detailed steps and verification checklist.

---

## Display Modes

- **In-Process** (default): All in main terminal, use Shift+Up/Down to navigate
- **Split-Pane**: Each teammate in own pane (requires tmux or iTerm2)

Set in `settings.json`:
```json
{
  "teammateMode": "in-process" | "auto" | "tmux"
}
```

## Super Dev Agent Team Definition

**Team Name:** `super-dev-agent-team`

This is a pre-defined agent team with all commonly used teammates for implementing features or fixing bugs. Create this team at Phase 1 to have all teammates ready.

### Team Creation Command

```
Create an agent team named "super-dev-agent-team" with these teammates:
- super-dev:coordinator (Team Lead)
- super-dev:requirements-clarifier
- super-dev:bdd-scenario-writer
- super-dev:research-agent
- super-dev:debug-analyzer
- super-dev:code-assessor
- super-dev:architecture-agent
- super-dev:ui-ux-designer
- super-dev:product-designer
- super-dev:spec-writer
- super-dev:dev-executor
- super-dev:qa-agent
- super-dev:code-reviewer
- super-dev:adversarial-reviewer
- super-dev:docs-executor
- super-dev:handoff-writer
```

### Teammate Roles by Category

| Category | Teammate | Role | Spawn Command |
|----------|----------|------|---------------|
| **Team Lead** | coordinator | Orchestrates all phases, manages task list | Team Lead (always active) |
| **Planning** | requirements-clarifier | Gather requirements, output requirements.md | `super-dev:requirements-clarifier` |
| **Planning** | bdd-scenario-writer | Write BDD behavior scenarios from AC | `super-dev:bdd-scenario-writer` |
| **Planning** | research-agent | Research best practices, present options | `super-dev:research-agent` |
| **Analysis** | debug-analyzer | Root cause analysis (bugs only) | `super-dev:debug-analyzer` |
| **Analysis** | code-assessor | Assess architecture, style, frameworks | `super-dev:code-assessor` |
| **Design** | architecture-agent | Design architecture (arch only) | `super-dev:architecture-agent` |
| **Design** | ui-ux-designer | Create UI/UX design (UI only) | `super-dev:ui-ux-designer` |
| **Design** | product-designer | Coordinate architecture + UI together | `super-dev:product-designer` |
| **Spec** | spec-writer | Write spec, plan, task list | `super-dev:spec-writer` |
| **Execution** | dev-executor | Implement code | `super-dev:dev-executor` |
| **Execution** | qa-agent | Plan and run tests | `super-dev:qa-agent` |
| **Review** | code-reviewer | Spec-aware code review (parallel with adversarial-reviewer) | `super-dev:code-reviewer` |
| **Review** | adversarial-reviewer | Multi-lens adversarial challenge (Skeptic, Architect, Minimalist) with attack vectors (V1-V8) and Destructive Action Gate (parallel with code-reviewer) | `super-dev:adversarial-reviewer` |
| **Docs** | docs-executor | Update documentation | `super-dev:docs-executor` |
| **Docs** | handoff-writer | Generate session handoff | `super-dev:handoff-writer` |

### Team Creation at Phase 1

When creating the agent team in Phase 1, use this pattern:

```
Create an agent team for this development workflow:
- Team name: "super-dev-[spec-index]-[spec-name]"
- Include all teammates from super-dev-agent-team definition

Teammates to include:
1. super-dev:coordinator (Team Lead - this session)
2. super-dev:requirements-clarifier
3. super-dev:bdd-scenario-writer
4. super-dev:research-agent
5. super-dev:debug-analyzer
6. super-dev:code-assessor
7. super-dev:architecture-agent
8. super-dev:ui-ux-designer
9. super-dev:product-designer
10. super-dev:spec-writer
11. super-dev:dev-executor
12. super-dev:qa-agent
13. super-dev:code-reviewer
14. super-dev:adversarial-reviewer
15. super-dev:docs-executor
16. super-dev:handoff-writer
```

### When to Spawn Each Teammate

| Phase | Spawn These Teammates |
|-------|----------------------|
| 2 | requirements-clarifier |
| 2.5 | bdd-scenario-writer |
| 3 | research-agent |
| 4 | debug-analyzer (bugs only) |
| 5 | code-assessor |
| 5.3 | architecture-agent |
| 5.4 | product-designer |
| 5.5 | ui-ux-designer |
| 6 | spec-writer |
| 8 | dev-executor + qa-agent (parallel) |
| 9 | code-reviewer + adversarial-reviewer (parallel) |
| 10 | docs-executor |
| 10.5 | handoff-writer |

**Remember:** Terminate each teammate immediately after their work is complete (see Teammate Termination Rules).

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Teammates not appearing | Press Shift+Down to cycle (in-process mode) |
| Too many permission prompts | Pre-approve in permission settings |
| Teammates stopping on errors | Check output, give additional instructions |
| Lead shuts down too early | Say "Keep going" or "Wait for teammates" |
| Orphaned tmux sessions | `tmux ls` then `tmux kill-session -t <name>` |

---

**For detailed phase-by-phase implementation, see:** `agents/coordinator.md`
