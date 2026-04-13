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
  version: "2.7.0"
  repository: https://github.com/jenningsloy318/super-skill-claude-artifacts
  keywords:
    - development
    - workflow
    - agent-teams
    - team-lead
    - parallel-execution
---

# Super Dev Workflow - Agent Teams Edition

A team-based development system where the Team Lead orchestrates specialized teammate agents who work independently with their own context windows, communicate directly, and share a task list for self-coordination.

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

## First-Run Configuration

On the first invocation of super-dev, check for a project configuration file:

### Project Data Directory

Each project gets its own data directory under `${CLAUDE_PLUGIN_DATA}/projects/`, keyed by the git repository basename:

```bash
# Derive project key from git root directory name
PROJECT_NAME="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")"
PROJECT_DATA="${CLAUDE_PLUGIN_DATA}/projects/${PROJECT_NAME}"
PROJECT_CONFIG="${PROJECT_DATA}/config.json"
```

**Directory structure:**
```
${CLAUDE_PLUGIN_DATA}/
├── global/
│   └── stats.json               # Cross-project usage statistics
└── projects/
    ├── my-rust-app/              # Per-project data (basename of git root)
    │   ├── config.json           # Project config (contains full path for verification)
    │   ├── session-history.log   # Project session log
    │   └── patterns.json         # Project-specific patterns
    └── my-react-app/
        ├── config.json
        ├── session-history.log
        └── patterns.json
```

**Path verification:** Every config.json stores the full project path in `project.path`. On load, verify the stored path matches the current working directory's git root. If mismatched (name collision), append a short hash suffix to create a new directory.

### Detection

```bash
# Check for existing project config
if [ ! -f "$PROJECT_CONFIG" ]; then
  echo "First-run detected for project '${PROJECT_NAME}' - configuration needed"
fi
```

### Setup Flow

If `${PROJECT_CONFIG}` does not exist:

1. **Announce**: "This is the first run of super-dev for project '${PROJECT_NAME}'. Let me set up your project configuration."
2. **Create project directory**: `mkdir -p "${PROJECT_DATA}"`
3. **Auto-detect** what you can from the project:
   - Language: Check for `package.json` (Node), `Cargo.toml` (Rust), `go.mod` (Go), `pyproject.toml` (Python), etc.
   - Framework: Check for `next.config.*` (Next.js), `vite.config.*` (Vite), `angular.json` (Angular), etc.
   - Package manager: Check for `bun.lockb`, `pnpm-lock.yaml`, `yarn.lock`, `package-lock.json`
   - Test runner: Check for `jest.config.*`, `vitest.config.*`, `playwright.config.*`, `.pytest.ini`
4. **Ask user to confirm** detected values and fill in missing ones using AskUserQuestion
5. **Write config** to `${PROJECT_CONFIG}` (include `project.path` with the full git root path)
6. **Continue** with the normal workflow

### Subsequent Runs

On subsequent runs, read `${PROJECT_CONFIG}` silently and apply preferences. Do NOT ask again unless the user runs `/super-dev configure`.

### Config Reference

See `${CLAUDE_PLUGIN_ROOT}/templates/config-template.json` for the full schema.

## Architecture Overview

```
                    ┌─────────────────┐
                    │   Team Lead    │ ◄── Team Lead (Orchestration Only)
                    │                │     Spawns teammates
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
- Handoff document generated in spec directory (`[XX]-handoff.md`)

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
- [ ] Phase 2:  Requirements Clarification (requirements-clarifier + doc-validator PARALLEL)
- [ ] GATE:     Requirements Completeness (gate-requirements.sh — run by doc-validator)
- [ ] Phase 2.5: BDD Scenario Writing (bdd-scenario-writer + doc-validator PARALLEL, user confirmation required)
- [ ] GATE:     BDD Scenario Quality (gate-bdd.sh — run by doc-validator)
- [ ] Phase 3:  Research (deep online research for latest patterns based on requirements + BDD, options presentation)
- [ ] Phase 4:  Debug Analysis (bugs only)
- [ ] Phase 5:  Code Assessment
- [ ] Phase 5.3: Architecture Design (arch only)
- [ ] Phase 5.4: Product Design (arch + UI together)
- [ ] Phase 5.5: UI/UX Design (UI only)
- [ ] Phase 6:  Specification Writing (spec-writer writes 3 files SEQUENTIALLY: specification → implementation-plan → task-list, doc-validator PARALLEL)
- [ ] GATE:     Spec-to-BDD Traceability (gate-spec-trace.sh — run by doc-validator)
- [ ] Phase 7:  Specification Review
- [ ] Phase 8:  Implementation (Domain-Aware Agent Routing + qa-agent PARALLEL)
- [ ] GATE:     Build & Test Pass (gate-build.sh — run by team-lead)
- [ ] Phase 9:  Code Review + Adversarial Review (code-reviewer + adversarial-reviewer + 2x doc-validator, 4 agents PARALLEL)
- [ ] GATE:     Review Verdicts (gate-review.sh — run by doc-validator)
- [ ] Phase 10: Documentation Update
- [ ] GATE:     Documentation-Code Drift (gate-docs-drift.sh — run by team-lead)
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

**MANDATORY Phase 9 → 12 Transition Sequence (NEVER skip or reorder):**
After Phase 9 passes, you MUST execute these phases in strict order. Do NOT jump to Phase 12.
1. Phase 9 gate validation already completed by doc-validator (gate-review.sh PASSED during Phase 9)
2. **Phase 10:** Spawn `super-dev:docs-executor` → Wait for completion → Terminate
3. **Run gate-docs-drift.sh** → Must PASS (exit 0)
4. **Phase 10.5:** Spawn `super-dev:handoff-writer` → Wait for completion → Terminate
5. **Phase 11:** Verify all teammates terminated, worktree preserved
6. **Phase 11.5:** Present summary to user for confirmation
7. **ONLY THEN** proceed to Phase 12 (commit & merge)

**VIOLATION:** Jumping from Phase 9 directly to Phase 12 is a CRITICAL workflow violation.

## Verification Gates (MANDATORY)

Gates are **programmatic quality checks** that run between phases to catch problems early. Each gate is a script in `scripts/gates/` that exits 0 (PASS) or 1 (FAIL).

**CRITICAL:** Gates are NON-NEGOTIABLE. If a gate fails, the Team Lead MUST NOT proceed to the next phase. Instead, loop back to the failing phase and fix the issue.

### Gate Execution

```bash
# Run any gate script
bash ${CLAUDE_PLUGIN_ROOT}/scripts/gates/<gate-name>.sh <spec-dir>
```

### Gate Map

| After Phase | Gate Script | Run By | What It Checks |
|-------------|-------------|--------|----------------|
| Phase 2 → 2.5 | `gate-requirements.sh` | doc-validator | Requirements have acceptance criteria, NFRs, summary, sufficient detail |
| Phase 2.5 → 3 | `gate-bdd.sh` | doc-validator | BDD scenarios have SCENARIO-IDs, Given/When/Then, AC traceability |
| Phase 6 → 7 | `gate-spec-trace.sh` | doc-validator | Spec references BDD scenarios, has testing strategy, has task list |
| Phase 8 → 9 | `gate-build.sh` | team-lead | Build succeeds, tests pass, type checks pass |
| Phase 9 → 10 | `gate-review.sh` | doc-validator | Code review approved, adversarial review PASS, no critical issues |
| Phase 10 → 10.5 | `gate-docs-drift.sh` | team-lead | Documentation exists, no excessive TODOs left in code |

### Gate Failure Handling

1. Gate fails → Team Lead reports which gate and which checks failed
2. Team Lead spawns the appropriate agent to fix the failing phase
3. After fix, re-run the gate
4. Only proceed when gate returns PASS (exit 0)

**Gotcha:** Do NOT skip gates to "save time." Gates prevent compound errors that cost 10x more to fix in later phases.

## Entry Point: Team Lead

**ROLE:** Current session becomes Team Lead

**To start:**
```
"I'm using super-dev with agent teams. Create an agent team with the Team Lead to implement: [task]"
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
| 2 | requirements-clarifier + doc-validator | **Product Thinker (YC Partner Mode):** MUST invoke `clarify` skill first, then challenge framing with 6 forcing questions, gather requirements. **Validator runs in parallel** |
| 2.5 | bdd-scenario-writer + doc-validator | Write BDD behavior scenarios from acceptance criteria. **Validator runs in parallel** |
| 3 | research-agent | **Research Scout (Intelligence Analyst):** Deep online research (Exa, DeepWiki, Context7, GitHub) for latest industry patterns and best practices based on requirements + BDD. NOT codebase search. Present 3-5 options with freshness scoring |
| 4 | debug-analyzer | Root cause analysis (bugs only) |
| 5 | code-assessor | Assess architecture, style, frameworks |
| 5.3 | architecture-agent | **Eng Manager (Architecture Lock-Down):** Design architecture with readiness dashboard, present 3-5 options |
| 5.4 | product-designer | Coordinate architecture + UI design together, present combined options |
| 5.5 | ui-ux-designer | Create UI/UX design (UI only), present 3-5 options |
| 6 | spec-writer + doc-validator | Write 3 files SEQUENTIALLY: specification → implementation-plan → task-list. Each builds on the previous. **Validator runs in parallel** |
| 8 | dev-executor (fallback) OR specialist developer agent(s) | Implement code — Team Lead routes to best-fit specialist (parallel with qa-agent). See **Domain-Aware Agent Routing** |
| 8 | qa-agent | **QA Lead (Break It Before Users Do):** Plan tests, run tests + browser smoke tests (parallel with specialist(s)) |
| 9 | code-reviewer + doc-validator | **Staff Engineer (Production Bug Hunter):** Spec-aware review focused on production-risk bugs. **Validator runs in parallel** (parallel with adversarial-reviewer) |
| 9 | adversarial-reviewer + doc-validator | **Red Team (Three Critical Lenses):** Multi-lens adversarial challenge (Skeptic, Architect, Minimalist) with attack vectors (V1-V8) and Destructive Action Gate. **Validator runs in parallel** (parallel with code-reviewer) |
| 10 | docs-executor | Update documentation |
| 10.5 | handoff-writer | Generate session handoff document |
| Any | investigator | **Detective (Root-Cause Investigator):** Bounded 4-phase investigation for mid-execution unknowns (spawned by any agent) |

## Key Concepts

### Shared Task List
- States: pending, in_progress, completed
- Dependencies block tasks until resolved
- Location: `~/.claude/tasks/{team-name}/`

### Direct Peer Communication

Parallel agents message each other **directly** via `SendMessage(to: "<peer-name>")` — NOT via Team Lead relay. Team Lead includes `Peer agents:` in spawn prompts and monitors only; intervenes only on `TEST_BLOCKED`, `DEP_BLOCKED`, or `VALIDATION BLOCKED`.

**Signals:**
- **dev ↔ qa-agent:** `BUILD_COMPLETE`, `DEV_COMPLETE`, `TEST_FAILED: [test] [error]`, `TEST_PASSED`, `CODERABBIT_ISSUE: [file:line] [desc]`
- **dev ↔ dev (multi-domain):** `BUILD_SLOT_REQUEST` / `BUILD_SLOT_RELEASED`, `INTERFACE_READY: [file]`, `DEP_BLOCKED: [what]`
- **reviewer ↔ reviewer:** `FINDING_SHARE: [severity] [file:line] [summary]`, `FINDING_ACK: [agree/disagree]`, `REVIEW_COMPLETE`
- **doc-validator ↔ writer:** `VALIDATION FAILED: ...` / `VALIDATED: PASS` / `FIXED: ready for re-check`

### Option Presentation
YOU MUST present 3-5 options to the user in Phases 3, 5.3, 5.4, 5.5. NEVER skip option presentation.
In Phase 5.4, ALWAYS present COMBINED architecture+UI options together.

### Branch Name Rule
YOU MUST ensure the git branch name matches the worktree name exactly: `[spec-index]-[spec-name]`. NEVER create a branch with a different name than the worktree.

### Document Naming: Team Lead Pre-Computation (MANDATORY)
All spec documents use `[XX]-[doc-type].md` naming with strictly incremental indices (no gaps). The **Team Lead** pre-computes exact filenames BEFORE spawning agents — agents receive concrete names like `03-research-report.md`, never `[doc-index]` placeholders.

**Algorithm (run at start of every doc-producing phase):**
1. `ls` the spec directory, find the highest existing `[XX]` prefix
2. Next index = max + 1 (zero-padded to 2 digits)
3. For multi-doc phases (e.g., Phase 6 produces 3 files), pre-allocate consecutive indices
4. Pass EXACT filenames to agents via `OUTPUT FILENAME` field in spawn prompts
5. Doc-validator receives the same exact filenames and verifies (not renames)

**Why:** Agents are unreliable at self-computing indices, and parallel agents (Phase 9) race for the same index. Pre-computation by Team Lead eliminates both problems.

### BDD Scenario Propagation Rule
`[XX]-behavior-scenarios.md` MUST be passed as input to ALL downstream phases after Phase 2.5:
- **Design phases (5.3, 5.4, 5.5):** BDD scenarios inform module boundaries, user flows, and interaction patterns
- **Spec writing (6):** BDD scenarios are cross-referenced in testing strategy
- **Execution (8):** specialist developer(s) reference SCENARIO-XXX IDs in code; qa-agent maps scenarios to tests
- **Review (9):** code-reviewer validates scenario coverage; adversarial-reviewer checks V8 behavior coverage

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

**Exception:** In Phase 8, all execution agents (specialist developer(s) + qa-agent) run in parallel — YOU MUST wait for ALL to complete before terminating any. Same applies to Phase 9, where code-reviewer and adversarial-reviewer run in parallel.

## Best Practices

1. **Always give teammates full context** — Include task details, file paths, and acceptance criteria in every spawn prompt
2. **Size tasks as self-contained units** — Each teammate MUST have clear deliverables and boundaries
3. **NEVER implement directly as Team Lead** — Always wait for teammates to complete their work
4. **Assign file ownership** — Each teammate MUST own different files to prevent conflicts
5. **Monitor and redirect actively** — Check teammate progress and course-correct immediately when needed
6. **Use direct peer communication** — Parallel teammates MUST message each other directly (see Direct Peer Communication signals), not via Team Lead relay
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

**⚠️ PARALLEL DOC-VALIDATOR RULE (Phases 2, 2.5, 6, 9): ALWAYS spawn `super-dev:doc-validator` alongside the writer agent. Spawning only the writer without doc-validator is a VIOLATION. Both must be spawned in the SAME action.**

| Phase | Team Lead Action | Agent to Spawn (via Task tool) |
|-------|-----------------|--------------------------------|
| 0 | Invoke dev-rules skill | (none) |
| 1 | Execute setup (worktree, spec dir, JSON, team) | (none) |
| 2 | Use Task tool → `super-dev:requirements-clarifier` + `super-dev:doc-validator` (parallel) | requirements-clarifier, doc-validator |
| 2.5 | Use Task tool → `super-dev:bdd-scenario-writer` + `super-dev:doc-validator` (parallel), **present scenarios to user for confirmation** | bdd-scenario-writer, doc-validator |
| 3 | Use Task tool → `super-dev:research-agent` (with requirements + BDD as input), present options. Deep online research, NOT codebase search | research-agent |
| 4 | Use Task tool → `super-dev:debug-analyzer` (bugs only) | debug-analyzer |
| 5 | Use Task tool → `super-dev:code-assessor` | code-assessor |
| 5.3 | Use Task tool → `super-dev:architecture-agent`, present options (**include BDD scenarios**) | architecture-agent |
| 5.4 | Use Task tool → `super-dev:product-designer`, present combined options (**include BDD scenarios**) | product-designer |
| 5.5 | Use Task tool → `super-dev:ui-ux-designer`, present options (**include BDD scenarios**) | ui-ux-designer |
| 6 | Use Task tool → `super-dev:spec-writer` + `super-dev:doc-validator` (parallel) | spec-writer, doc-validator |
| 7 | Validate spec (no agent) | (none) |
| 8 | Use Task tool → Domain-Aware Agent Routing: spawn best-fit specialist(s) (**include BDD scenarios**) + `super-dev:qa-agent` (parallel). See Phase 8 section | specialist developer(s) OR dev-executor (fallback), qa-agent |
| 9 | Use Task tool → `super-dev:code-reviewer` + `super-dev:doc-validator` + `super-dev:adversarial-reviewer` + `super-dev:doc-validator` (parallel, 4 agents) | code-reviewer, adversarial-reviewer, doc-validator x2 |
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
   - **If a matching spec with `[XX]-handoff.md` exists (continuation):**
     1. Read ONLY sections 2 (Progress), 4 (Unfinished Items), and 7 (Next Steps) from the handoff
     2. Do NOT read the full handoff — it's a map, not a novel
     3. Resume from the last incomplete phase per the Progress table
     4. Skip to the "Read These First" list (Section 6) if you need deeper context on specific files
     5. Re-use the existing worktree and spec directory — do NOT recreate
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

Create `specification/[spec-index]-[spec-name]/[spec-index]-[spec-name]-workflow-tracking.json`.

**Template:** See `${CLAUDE_PLUGIN_ROOT}/templates/reference/workflow-tracking-template.json` for the full schema and initial value.

### Step 5: Create or Reuse the Agent Team

**Team name is always `super-dev-[spec-name]`** — each spec gets its own dedicated team. Do NOT reuse teams from other specs.

**If the team already exists:** Reuse it. Do NOT create a new team.
**If the team does not exist:** Create it:

```
Create an agent team for this development workflow. The team name should be "super-dev-[spec-name]".
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

## Phase 8: Implementation (Domain-Aware Agent Routing)

**Executed by:** Best-fit specialist developer agent(s) + `super-dev:qa-agent` (spawned via Task tool, run in parallel)

**Purpose:** Implement code changes using domain-specialized agents instead of a generic dev-executor. Team Lead analyzes the task list, detects which domains are involved, and directly spawns the best-fit specialist agents. This eliminates the middleman layer and ensures each implementation agent has deep domain expertise.

### Domain Detection Algorithm (Team Lead runs BEFORE spawning)

```
1. Read task list from spec directory
2. For each task, identify target files and detect domain:

   File Pattern                          → Specialist Agent
   ─────────────────────────────────────────────────────────
   .rs / Cargo.toml                      → super-dev:rust-developer
   .go / go.mod                          → super-dev:golang-developer
   .tsx/.jsx/.css/.html / next.config.*  → super-dev:frontend-developer
     / vite.config.* / tailwind.config.*
   .py / .ts (API routes, services,      → super-dev:backend-developer
     middleware) / FastAPI / Express
   .swift + iOS target / ios/            → super-dev:ios-developer
   .kt / android/                        → super-dev:android-developer
   .xaml / .csproj / WinUI               → super-dev:windows-app-developer
   .swift + macOS target / macos/        → super-dev:macos-app-developer

3. Group tasks by detected domain
4. Apply routing decision (see table below)
```

**Config Hint:** If `${PROJECT_CONFIG}` has a `language` or `framework` field, use it to pre-seed the domain detection instead of re-scanning files.

### Routing Decision Table

| Scenario | What to Spawn | Example |
|----------|---------------|---------|
| All tasks → single domain | 1 specialist agent directly | All `.rs` → `super-dev:rust-developer` |
| Tasks span 2+ domains | 1 specialist per domain group (PARALLEL) | `.rs` + `.tsx` → `rust-developer` + `frontend-developer` |
| Domain unclear / too mixed | `super-dev:dev-executor` (fallback) | Mixed scripts, config-only tasks |

### Specialist Spawn Prompt Template

Each specialist receives the same base context as the old dev-executor, plus domain-specific task assignment:

```
"Spawn a [specialist]-developer teammate with this context:
- Task: Implement [domain] code changes per task list
- Spec directory: specification/[spec-index]-[spec-name]
- Specification: specification/[spec-index]-[spec-name]/[exact-specification-filename]
- BDD Scenarios: specification/[spec-index]-[spec-name]/[exact-bdd-filename]
- Task list: specification/[spec-index]-[spec-name]/[exact-task-list-filename]
- Assigned tasks: [T1, T3, T5] ([domain]-domain tasks ONLY)
- File ownership: [list of files/dirs this specialist owns — do NOT touch files outside this list]
- OUTPUT FILENAME for implementation summary: [XX]-implementation-summary.md  ← (exact name, single-domain only)

Reference BDD SCENARIO-XXX IDs in code comments for business logic implementing specific behaviors.
Write your implementation summary to EXACTLY the filename given above.
Signal BUILD_COMPLETE after successful builds and DEV_COMPLETE after all assigned tasks done.
When encountering errors after 2 fix attempts, spawn super-dev:investigator for root-cause analysis."
```

### Multi-Domain Coordination Rules

When spawning multiple specialists:
1. **File ownership is MANDATORY** — Each specialist MUST own distinct files. No overlapping edits.
2. **Implementation summary consolidation** — Team Lead consolidates outputs from all specialists into a single `[XX]-implementation-summary.md` after all specialists complete.
3. **Build queue** — For Rust/Go, only ONE build at a time. Specialists message each other directly to coordinate build slots (see Direct Peer Communication signals).
4. **Termination** — Wait for ALL specialists + qa-agent to complete before terminating any.

### Fallback to dev-executor

Use `super-dev:dev-executor` when:
- Target files don't map to any known domain
- Tasks are too interleaved across domains to cleanly separate
- The project uses a language/framework not covered by any specialist

The dev-executor retains its internal specialist delegation table and will attempt its own domain detection.

---

## Phase 9: Code Review + Adversarial Review (PARALLEL)

**Executed by:** `super-dev:code-reviewer` + `super-dev:adversarial-reviewer` (both spawned via Task tool, run in parallel)

**Purpose:** Dual-track review — spec-aware code review and multi-lens adversarial challenge run simultaneously. Both produce independent verdicts that must be satisfied before proceeding. Reviewers share findings directly with each other (see Direct Peer Communication signals).

**Outputs:**
- Code Review: `specification/[spec-index]-[spec-name]/[XX]-code-review.md`
- Adversarial Review: `specification/[spec-index]-[spec-name]/[XX]-adversarial-review-report.md`

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

**After all pass:** Proceed to Phase 10 (Documentation Update). Do NOT skip to Phase 12.

**Full references:** See `super-dev:code-reviewer` and `super-dev:adversarial-reviewer` agents for detailed specifications.

---

## Investigation Protocol (Any Phase — On-Demand)

**Agent:** `super-dev:investigator` — can be spawned by any phase agent or Team Lead when unknowns arise mid-execution.

**Problem this solves:** During Phase 8 (Execution) or Phase 9 (Review), agents often discover unexpected behavior, missing dependencies, or opaque errors that simple retry loops cannot resolve. Instead of immediately escalating to the user, agents can spawn a bounded investigation.

### Auto-Trigger Conditions

Any phase agent SHOULD spawn the investigator when:

| Condition | Signal |
|-----------|--------|
| **Loop detection** | Same error 2x with different fix attempts |
| **Doc mismatch** | API/library behaves differently than docs |
| **Missing dependency** | Required config/package not in assessment |
| **Unknown pattern** | No codebase convention for needed approach |
| **Opaque failure** | Build/test error with no obvious cause |
| **Abnormal behavior** | Code compiles but produces wrong results |

### Four-Phase Protocol (Bounded: 120s, 5 tool calls)

```
GATHER (30s) → SEARCH (60s) → HYPOTHESIZE (30s) → RESOLVE
                                      |
                                      v (3 hypotheses failed)
                                   ESCALATE to Team Lead
```

1. **GATHER** — Collect evidence: error messages, stack traces, git diff, environment versions
2. **SEARCH** — Search max 3 sources: project docs first, then library docs, then web
3. **HYPOTHESIZE** — Form testable hypothesis, verify with minimal validation (log/assert/run)
4. **RESOLVE** — Document root cause and fix instructions for the calling agent

### Output

Investigation report written to: `specification/[spec-index]-[spec-name]/[spec-index]-investigation-[seq].md`

### Integration Points

| Caller | When | What Happens After |
|--------|------|-------------------|
| **dev-executor** | Build error after 2 fix attempts | Applies investigation fix, rebuilds |
| **qa-agent** | Test failure after 2 retries, unclear cause | Adjusts test or reports code bug |
| **code-reviewer** | Suspicious pattern needs verification | Includes finding in review |
| **Team Lead** | Teammate reports BLOCKED, error unclear | Forwards findings to blocked teammate |

### Iron Law

**No fix without root cause investigation first.** The investigator never proposes a fix it cannot explain.

**Full reference:** See `super-dev:investigator` agent for detailed specification.

---

## Phase 10: Documentation Update (MANDATORY — do NOT skip)

**Executed by:** `super-dev:docs-executor` (spawned via Task tool)

**CRITICAL:** This phase MUST be executed after Phase 9 passes. NEVER jump from Phase 9 to Phase 12.

**Purpose:** Update all relevant documentation (README, API docs, inline docs) to reflect changes made during this workflow.

**Steps:**
1. Gate-review.sh already PASSED via doc-validator during Phase 9 — no need to re-run
2. Spawn `super-dev:docs-executor` with context:
   - Spec directory path
   - Specification document (e.g., `05-specification.md`)
   - Implementation summary (e.g., `08-implementation-summary.md`)
   - Code review results
3. Wait for docs-executor to complete
4. Verify documentation files are updated
5. Terminate docs-executor immediately after completion
6. Run `gate-docs-drift.sh` → Must PASS (exit 0)

**Output:** Updated documentation files in the project

**After Phase 10:** Proceed to Phase 10.5 (Handoff Writing). NEVER skip to Phase 12.

---

## Phase 10.5: Handoff Writing (MANDATORY — do NOT skip)

**Executed by:** `super-dev:handoff-writer` (spawned via Task tool)

**Purpose:** Generate a structured session handoff document for seamless AI agent continuity.

**Steps:**
1. Spawn `super-dev:handoff-writer` with context:
   - All spec artifacts in the spec directory
   - Workflow tracking JSON
   - Git diff: `git diff --stat main..HEAD`
   - Feature name
2. Wait for handoff-writer to complete `[XX]-handoff.md`
3. Verify `[XX]-handoff.md` exists in spec directory
4. Terminate handoff-writer immediately after completion

**Output:** `specification/[spec-index]-[spec-name]/[XX]-handoff.md`

**After Phase 10.5:** Proceed to Phase 11 (Team Cleanup). NEVER skip to Phase 12.

---

## Phase 11: Team Cleanup (MANDATORY — do NOT skip)

**Executed by:** Team Lead (direct verification)

**Purpose:** Final verification that all teammates are terminated and resources cleaned up, while preserving the worktree.

**Steps:**
1. Verify all teammates have been terminated (should already be done per-phase)
2. If any teammates still active, message them: "Please shut down gracefully"
3. Verify worktree is preserved at `.worktree/[spec-index]-[spec-name]/`
4. Update workflow tracking JSON: Phase 11 = complete

**After Phase 11:** Proceed to Phase 11.5 (present summary to user for confirmation), then Phase 12 (Commit & Merge).

---

## Phase 12: Commit & Merge to Main (ONLY after Phases 10-11 complete)

**Executed by:** Team Lead (direct git operations)

**PRE-CONDITION CHECK (MANDATORY — run before ANY Phase 12 work):**
Before starting Phase 12, verify ALL of these are true. If ANY check fails, STOP and go back to the missing phase.
1. **Phase 8 complete:** Build passes, tests pass, implementation done
2. **Phase 9 complete:** Code review = Approved, adversarial review = PASS
3. **Phase 10 complete:** Documentation updated, `gate-docs-drift.sh` passed
4. **Phase 10.5 complete:** `[XX]-handoff.md` exists in spec directory
5. **Phase 11 complete:** All teammates terminated, worktree preserved

**If any check fails:** Do NOT proceed. Go back to the earliest incomplete phase and complete it first.

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

**Full commit procedure:** See `agents/team-lead.md` Phase 12 for detailed steps and verification checklist.

---

## Session State Management

Super-dev maintains persistent state per project using `${PROJECT_DATA}` (see First-Run Configuration for path derivation).

### Phase 0 — Read History

At the start of every session (during Phase 0), read previous session data:

```bash
# Derive project data path
PROJECT_NAME="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")"
PROJECT_DATA="${CLAUDE_PLUGIN_DATA}/projects/${PROJECT_NAME}"

# Read last 3 sessions for context
if [ -f "${PROJECT_DATA}/session-history.log" ]; then
  tail -3 "${PROJECT_DATA}/session-history.log"
fi

# Read learned patterns
if [ -f "${PROJECT_DATA}/patterns.json" ]; then
  cat "${PROJECT_DATA}/patterns.json"
fi
```

Use this context to:
- Avoid repeating mistakes from previous sessions
- Apply learned patterns consistently
- Skip research for topics already investigated

### Phase 12 — Write History

After committing, append a session summary:

```bash
# Append session record (single JSON line)
echo '{"timestamp":"[ISO]","spec":"[spec-name]","task":"[description]","phases_completed":[...],"verdict":{"code_review":"[verdict]","adversarial":"[verdict]"},"files_changed":[count],"language":"[lang]","framework":"[fw]"}' >> "${PROJECT_DATA}/session-history.log"
```

### Pattern Learning

During Phases 5 and 9, record discovered patterns:

```bash
# Update patterns.json with new discoveries
# Only add patterns seen 2+ times (high confidence)
```

### State File Reference

See `${CLAUDE_PLUGIN_ROOT}/templates/reference/state-management.md` for full format documentation.

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

**Team Name:** `super-dev-[spec-name]`

This is a pre-defined agent team with all commonly used teammates for implementing features or fixing bugs. Create this team at Phase 1 using the spec name. Each spec gets its own dedicated team — do NOT reuse teams from other specs.

### Team Creation Command

```
Create an agent team named "super-dev-[spec-name]" with these teammates:
- super-dev:team-lead (Team Lead)
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
- super-dev:doc-validator
```

### Teammate Roles by Category

| Category | Teammate | Role | Spawn Command |
|----------|----------|------|---------------|
| **Team Lead** | team-lead | Orchestrates all phases, manages task list | Team Lead (always active) |
| **Planning** | requirements-clarifier | **Product Thinker (YC Partner Mode):** MUST invoke `clarify` skill first, then challenge framing with 6 forcing questions, gather requirements | `super-dev:requirements-clarifier` |
| **Planning** | bdd-scenario-writer | Write BDD behavior scenarios from AC | `super-dev:bdd-scenario-writer` |
| **Planning** | research-agent | **Research Scout (Intelligence Analyst):** Deep online research for latest patterns based on requirements + BDD | `super-dev:research-agent` |
| **Analysis** | debug-analyzer | Root cause analysis (bugs only) | `super-dev:debug-analyzer` |
| **Analysis** | code-assessor | Assess architecture, style, frameworks | `super-dev:code-assessor` |
| **Design** | architecture-agent | **Eng Manager (Architecture Lock-Down):** Design architecture with readiness dashboard | `super-dev:architecture-agent` |
| **Design** | ui-ux-designer | Create UI/UX design (UI only) | `super-dev:ui-ux-designer` |
| **Design** | product-designer | Coordinate architecture + UI together | `super-dev:product-designer` |
| **Spec** | spec-writer | Write spec, plan, task list | `super-dev:spec-writer` |
| **Execution** | dev-executor | Implement code | `super-dev:dev-executor` |
| **Execution** | qa-agent | **QA Lead (Break It Before Users Do):** Plan tests, run tests + browser smoke tests | `super-dev:qa-agent` |
| **Review** | code-reviewer | **Staff Engineer (Production Bug Hunter):** Spec-aware review focused on production-risk bugs | `super-dev:code-reviewer` |
| **Review** | adversarial-reviewer | **Red Team (Three Critical Lenses):** Multi-lens adversarial challenge with Destructive Action Gate | `super-dev:adversarial-reviewer` |
| **Docs** | docs-executor | Update documentation | `super-dev:docs-executor` |
| **Docs** | handoff-writer | Generate session handoff | `super-dev:handoff-writer` |
| **Support** | investigator | **Detective (Root-Cause Investigator):** Bounded 4-phase investigation for mid-execution unknowns | `super-dev:investigator` |
| **Support** | doc-validator | **Quality Gate Inspector:** Independent gate-criteria validation, runs parallel with writers | `super-dev:doc-validator` |

### Team Creation at Phase 1

When creating the agent team in Phase 1, use this pattern:

```
Create an agent team for this development workflow:
- Team name: "super-dev-[spec-name]"
- Each spec gets its own dedicated team — do NOT reuse teams from other specs
- Reuse existing team if already created from a previous invocation of the same spec

Teammates to include:
1. super-dev:team-lead (Team Lead - this session)
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
17. super-dev:investigator
18. super-dev:doc-validator
```

### When to Spawn Each Teammate

| Phase | Spawn These Teammates |
|-------|----------------------|
| 2 | requirements-clarifier + doc-validator (parallel) |
| 2.5 | bdd-scenario-writer + doc-validator (parallel) |
| 3 | research-agent |
| 4 | debug-analyzer (bugs only) |
| 5 | code-assessor |
| 5.3 | architecture-agent |
| 5.4 | product-designer |
| 5.5 | ui-ux-designer |
| 6 | spec-writer + doc-validator (parallel) |
| 8 | specialist developer(s) + qa-agent (parallel). See Domain-Aware Agent Routing |
| 9 | code-reviewer + doc-validator + adversarial-reviewer + doc-validator (parallel, 4 agents) |
| 10 | docs-executor |
| 10.5 | handoff-writer |
| Any (on-demand) | investigator (spawned by dev-executor, qa-agent, code-reviewer, or Team Lead when unknowns arise) |

**Remember:** Terminate each teammate immediately after their work is complete (see Teammate Termination Rules).

## Gotchas

- **Spawning generic dev-executor when domain is clear**: If the task list targets `.rs` files, spawn `rust-developer` directly — don't route through `dev-executor`. The domain detection algorithm (Phase 8) exists precisely for this. Only fall back to `dev-executor` when domains are genuinely unclear or too mixed to separate.
- **Overlapping file ownership in multi-domain Phase 8**: When spawning multiple specialists in parallel, each MUST own distinct files. If two specialists edit the same file, merge conflicts are guaranteed. Team Lead must assign clear file ownership boundaries in the spawn prompt.
- **Team Lead doing work directly instead of delegating**: The number one failure mode. The team-lead starts using Edit, Bash, or Grep to "just quickly fix something" instead of spawning an agent via Task tool. This violates the prime directive and defeats the entire team-based architecture.
- **Forgetting to terminate teammates after completion**: Idle teammates consume context window and memory. If teammates are not terminated immediately after their phase completes, resources accumulate and the session degrades or hits limits.
- **Branch name not matching worktree name**: The git branch created with `git worktree add` must exactly match the worktree directory name (e.g., `03-user-auth`). A mismatch causes merge failures and confuses the commit/merge workflow in Phase 12.
- **Skipping Phase 0 dev-rules loading**: Without loading dev-rules at session start, teammates operate without coding standards, git practices, or quality guidelines, leading to inconsistent output that fails review.
- **Not passing BDD scenarios to downstream phases**: `[XX]-behavior-scenarios.md` must be included as input to design (5.3/5.4/5.5), spec writing (6), execution (8), and review (9) phases. Omitting them creates coverage gaps where implemented behavior diverges from agreed scenarios.
- **Creating spec directory in main repo instead of worktree**: The spec directory must be created inside the worktree (`.worktree/[name]/specification/[name]/`), not in the main repository root. Creating it in the wrong location breaks isolation and causes files to appear in the wrong branch.
- **Batching multiple tasks into one commit instead of atomic commits**: Each completed task should be committed individually. Batching makes it impossible to revert a single change and violates the incremental development principle.
- **Not presenting options to user in Phases 3/5.3/5.4/5.5**: These phases require presenting 3-5 options for the user to choose from. Skipping option presentation and jumping straight to implementation removes the user from the decision loop.
- **Skipping verification gates between phases**: Gates are programmatic quality checks (scripts in `scripts/gates/`) that catch problems early. Skipping them to "save time" causes compound errors that cost 10x more to fix in later phases. Every gate must PASS (exit 0) before proceeding.
- **Agent prompts degrading over time without measurement**: Use `/super-dev:autoresearch` periodically to auto-improve agent prompts. Run it on the agent that caused the most Phase 8/9 iteration loops.
- **Retrying the same fix 3+ times instead of investigating**: When dev-executor or qa-agent hits the same error repeatedly with different fix attempts, they should spawn `super-dev:investigator` after 2 attempts instead of brute-forcing to 3. The investigation protocol exists precisely for this — blind retries waste tokens and delay resolution.
- **Investigation scope creep**: The investigator has strict budget limits (120s, 5 tool calls, 3 sources). If an investigation is unbounded, it bloats context and delays the calling agent. Always respect the budget constraints and escalate if inconclusive.
- **Jumping from Phase 9 to Phase 12, skipping Phases 10/10.5/11**: After Phase 9 reviews pass, the Phase 12 "Commit & Merge" section acts as a gravity well — its detail and finality cause the team-lead to skip documentation (Phase 10), handoff writing (Phase 10.5), and team cleanup (Phase 11). Always follow the mandatory transition sequence: Phase 9 → gate-review → Phase 10 → gate-docs-drift → Phase 10.5 → Phase 11 → Phase 12. Phase 12 has a pre-condition check that enforces this.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Teammates not appearing | Press Shift+Down to cycle (in-process mode) |
| Too many permission prompts | Pre-approve in permission settings |
| Teammates stopping on errors | Check output, give additional instructions |
| Lead shuts down too early | Say "Keep going" or "Wait for teammates" |
| Orphaned tmux sessions | `tmux ls` then `tmux kill-session -t <name>` |
| Config outdated | Run `/super-dev configure` to re-run setup |

---

**For detailed phase-by-phase implementation, see:** `agents/team-lead.md`
