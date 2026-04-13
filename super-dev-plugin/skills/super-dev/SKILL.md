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

**NO EARLY CODE ANALYSIS:** Do NOT read code, grep the codebase, or analyze files before Phase 2. Phase 0 loads dev rules, Phase 1 sets up worktree/spec.

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
- [ ] Phase 3:  Research (Firecrawl MCP first, MUST perform actual online searches based on requirements + BDD, options presentation)
- [ ] Phase 4:  Debug Analysis (bugs only)
- [ ] Phase 5:  Code Assessment
- [ ] Phase 5.3: Architecture Design (arch only)
- [ ] Phase 5.4: Product Design (arch + UI together)
- [ ] Phase 5.5: UI/UX Design (UI only)
- [ ] Phase 6:  Specification Writing (spec-writer writes 3 files SEQUENTIALLY: specification → implementation-plan → task-list, doc-validator PARALLEL)
- [ ] GATE:     Spec-to-BDD Traceability (gate-spec-trace.sh — run by doc-validator)
- [ ] Phase 7:  Specification Review (spec-reviewer + doc-validator PARALLEL)
- [ ] GATE:     Specification Review Quality (gate-spec-review.sh — run by doc-validator)
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
| Phase 7 → 8 | `gate-spec-review.sh` | doc-validator | Spec review verdict approved, all 8 dimensions covered, grounding verified |
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

**THE "HANDS-OFF" RULE:**
From **Phase 2 onwards**, you are FORBIDDEN from using these tools for implementation, debugging, or research:
- `Edit`, `Write`, `Bash`, `Grep`, `Glob`, `Read` (for implementation analysis)

Allowed uses: Phase 0/1 setup, Phase 12 git operations, reading status/task lists.

**HOW TO SPAWN AGENTS:** `Task tool → subagent_type: "super-dev:agent-name"`

❌ **NEVER in Phases 2-13** — use Task tool to spawn the appropriate agent instead:
- Edit/write files → `dev-executor` or `docs-executor`
- Run commands → `dev-executor` or `qa-agent`
- Research → `research-agent`
- Write specs → `spec-writer`
- Code assessment → `code-assessor`
- Architecture → `architecture-agent` or `product-designer`
- UI/UX → `ui-ux-designer` or `product-designer`
- Debug analysis → `debug-analyzer`
- Code/adversarial review → `code-reviewer` / `adversarial-reviewer`

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

## Teammate Termination Rules

Terminate teammates **immediately** after their work completes. Verify output, then shut down. Do NOT keep idle teammates running.

**Exception:** In Phase 8 (specialist(s) + qa-agent) and Phase 9 (code-reviewer + adversarial-reviewer), wait for ALL parallel agents to complete before terminating any.

## Best Practices

1. **Full context in spawn prompts** — task details, file paths, acceptance criteria, peer agents
2. **Self-contained tasks** — clear deliverables and file ownership boundaries
3. **Direct peer communication** — parallel teammates message each other directly (see signals above)
4. **Monitor and redirect** — check progress, course-correct immediately

---

## Phase Enforcement: What Team Lead Does in Each Phase

**MANDATORY: Team Lead orchestrates via Task tool, agents execute.**

**⚠️ PARALLEL DOC-VALIDATOR RULE (Phases 2, 2.5, 6, 7, 9): ALWAYS spawn `super-dev:doc-validator` alongside the writer/reviewer agent. Spawning only the writer without doc-validator is a VIOLATION. Both must be spawned in the SAME action.**

| Phase | Team Lead Action | Agent to Spawn (via Task tool) |
|-------|-----------------|--------------------------------|
| 0 | Invoke dev-rules skill | (none) |
| 1 | Execute setup (worktree, spec dir, JSON, team) | (none) |
| 2 | Use Task tool → `super-dev:requirements-clarifier` + `super-dev:doc-validator` (parallel) | requirements-clarifier, doc-validator |
| 2.5 | Use Task tool → `super-dev:bdd-scenario-writer` + `super-dev:doc-validator` (parallel), **present scenarios to user for confirmation** | bdd-scenario-writer, doc-validator |
| 3 | Use Task tool → `super-dev:research-agent` (with requirements + BDD as input), present options. Firecrawl MCP first, then supplementary scripts. NOT codebase search | research-agent |
| 4 | Use Task tool → `super-dev:debug-analyzer` (bugs only) | debug-analyzer |
| 5 | Use Task tool → `super-dev:code-assessor` | code-assessor |
| 5.3 | Use Task tool → `super-dev:architecture-agent`, present options (**include BDD scenarios**) | architecture-agent |
| 5.4 | Use Task tool → `super-dev:product-designer`, present combined options (**include BDD scenarios**) | product-designer |
| 5.5 | Use Task tool → `super-dev:ui-ux-designer`, present options (**include BDD scenarios**) | ui-ux-designer |
| 6 | Use Task tool → `super-dev:spec-writer` + `super-dev:doc-validator` (parallel) | spec-writer, doc-validator |
| 7 | Use Task tool → `super-dev:spec-reviewer` + `super-dev:doc-validator` (parallel) | spec-reviewer, doc-validator |
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

### Worktree Enforcement (MANDATORY — Phase 2+ runtime check)

**CRITICAL:** Before spawning ANY agent in Phase 2+, Team Lead MUST verify `pwd` is inside `.worktree/`. If not, STOP the workflow immediately.

```bash
# Run this check before every phase (Phase 2+)
if ! pwd | grep -q '\.worktree/'; then
  echo "WORKFLOW STOPPED: Not inside a worktree. cd to .worktree/[spec-index]-[spec-name] first."
  exit 1
fi
```

**Why:** Gate scripts, spec files, and all agent work use relative paths. Running from main repo root causes gates to find wrong (or no) files, silently passing invalid specs.

---

## Phase 7: Specification Review (PARALLEL — spec-reviewer + doc-validator)

**Executed by:** `super-dev:spec-reviewer` + `super-dev:doc-validator` (spawned via Task tool, run in parallel)

**Purpose:** Deep content review of AI-generated specifications across 8 quality dimensions before implementation begins. Catches hallucinated references, missing edge cases, ambiguity, infeasibility, and broken traceability that format-only gates miss.

**Why a dedicated agent:** The spec-writer should NOT review its own output (Fagan inspection principle). doc-validator only checks format/structure via regex. The spec-reviewer checks *meaning* — verifying that referenced files exist, architecture is feasible, and acceptance criteria are testable.

**Steps:**
1. Pre-compute the next doc index: `[XX]-spec-review.md`
2. Spawn `super-dev:spec-reviewer` with:
   - All spec artifacts: specification, implementation plan, task list
   - Upstream artifacts: requirements, BDD scenarios
   - Context artifacts: code assessment, research report, architecture doc (if they exist)
   - OUTPUT FILENAME: `[XX]-spec-review.md`
3. Spawn `super-dev:doc-validator` in parallel with:
   - Expected filename: `[XX]-spec-review.md`
   - Gate profile: `gate-spec-review`
   - Writer agent: `spec-reviewer`
4. Wait for BOTH to complete
5. Check verdict:
   - **APPROVED** → proceed to Phase 8
   - **APPROVED WITH REVISIONS** → Team Lead reviews, may proceed or loop
   - **REVISIONS NEEDED** → loop back to Phase 6 (spec-writer fixes)
   - **REJECTED** → loop back to Phase 6 (major rewrite)
6. Terminate both agents after completion

**Output:** `specification/[spec-index]-[spec-name]/[XX]-spec-review.md`

**After Phase 7:** Proceed to Phase 8 (Implementation).

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

**Executed by:** `super-dev:code-reviewer` + `super-dev:adversarial-reviewer` + 2× `super-dev:doc-validator` (4 agents parallel)

**Outputs:** `[XX]-code-review.md` and `[XX]-adversarial-review-report.md`

**Verdicts:**
- **Code Review:** Approved / Approved with Comments → pass. Changes Requested / Blocked → loop to Phase 8.
- **Adversarial:** PASS → pass. CONTESTED → Team Lead decides. REJECT → loop to Phase 8. HALT from Destructive Action Gate → forces CONTESTED minimum (multiple HALTs → REJECT).

**Pass criteria (ALL required for Phase 10):**
- Code Review = Approved (or with Comments)
- Adversarial = PASS
- BDD Scenario Coverage = 100%

**If any fails:** Loop back to Phase 8 with combined findings. **After all pass:** Phase 10 (not Phase 12).

**Full references:** See `super-dev:code-reviewer` and `super-dev:adversarial-reviewer` agent files.

---

## Investigation Protocol (Any Phase — On-Demand)

**Agent:** `super-dev:investigator` — spawned by any agent or Team Lead when unknowns arise.

**Trigger:** Same error 2× with different fix attempts, opaque failures, doc mismatches, missing dependencies, abnormal behavior. Budget: 120s, 5 tool calls.

**Output:** `specification/[spec-index]-[spec-name]/[spec-index]-investigation-[seq].md`

**Iron Law:** No fix without root cause. See `super-dev:investigator` agent for full protocol.

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

Per-project state stored at `${PROJECT_DATA}` (derived from git root basename, see First-Run Configuration).

- **Phase 0:** Read `session-history.log` (last 3 sessions) and `patterns.json` for context.
- **Phase 12:** Append session record to `session-history.log`.
- **Phases 5/9:** Record discovered patterns to `patterns.json` (only patterns seen 2+ times).

See `${CLAUDE_PLUGIN_ROOT}/templates/reference/state-management.md` for full format.

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

**Team Name:** `super-dev-[spec-name]` — each spec gets its own dedicated team. Do NOT reuse teams from other specs.

### Team Creation at Phase 1

```
Create an agent team for this development workflow:
- Team name: "super-dev-[spec-name]"
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
19. super-dev:spec-reviewer
```

## Gotchas

- **Skipping Phase 7 spec review to save time**: The spec-reviewer catches hallucinated file references, infeasible architecture, and ambiguous ACs that will cause 5-10x more rework during Phase 8/9 loops. Never skip it.
- **Batching multiple tasks into one commit**: Each completed task should be committed individually — batching makes reverting impossible.
- **Agent prompts degrading without measurement**: Use `/super-dev:autoresearch` periodically on the agent that caused the most Phase 8/9 iteration loops.

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
