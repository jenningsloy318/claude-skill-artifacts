---
name: super-dev
description: Agent Team-driven development workflow. Team Lead Coordinator orchestrates specialized teammates who work independently with their own context windows and can message each other directly. Use when user says "implement feature", "fix bug", "refactor code", "help me build", "develop this", "add functionality", or asks for systematic multi-phase development. Do NOT use for simple file searches, one-off questions, or non-development tasks.
license: MIT
compatibility: Requires Claude Code CLI with Task tool and agent teams experimental feature (CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1). Git required for worktree management.
metadata:
  author: Jennings Liu
  version: "2.2.0"
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

**Announce at start:** "I'm using the super-dev skill with agent teams to systematically implement this task."

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

Activate for:
- Bug fixes, build warnings/errors
- New features, improvements
- Performance optimization
- Deprecation resolution
- Refactoring

## Workflow Phases

```
- [ ] Phase 0:  Apply Dev Rules
- [ ] Phase 1:  Specification Setup (worktree + team creation)
- [ ] Phase 2:  Requirements Clarification
- [ ] Phase 3:  Research (options presentation)
- [ ] Phase 4:  Debug Analysis (bugs only)
- [ ] Phase 5:  Code Assessment
- [ ] Phase 5.3: Architecture Design (arch only)
- [ ] Phase 5.4: Product Design (arch + UI together) ← NEW: replaces 5.3+5.5 when both needed
- [ ] Phase 5.5: UI/UX Design (UI only)
- [ ] Phase 6:  Specification Writing
- [ ] Phase 7:  Specification Review
- [ ] Phase 8:  Execution & QA (PARALLEL teammates)
- [ ] Phase 9:  Code Review
- [ ] Phase 10: Documentation Update
- [ ] Phase 11: Team Cleanup (keep worktree)
- [ ] Phase 12: Commit & Merge to Main
- [ ] Phase 13: Final Verification (worktree preserved)
```

**Phase 5.3/5.4/5.5 Selection:**
- Architecture ONLY → Phase 5.3 (architecture-agent)
- UI ONLY → Phase 5.5 (ui-ux-designer)
- BOTH → Phase 5.4 (product-designer) - coordinates both agents together

**Iteration Rule:** Loop Phase 8/9 until Critical=0, High=0, Medium=0, all acceptance criteria met.

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
- **NEVER skip agent communication**
- **NEVER take over agent tasks**

**VIOLATION DETECTION:** If Team Lead starts doing Phase 2-13 work directly, user should say:
- "Stop! You are in delegate mode. Use Task tool to spawn an agent."
- "Remember: Team Lead orchestrates via Task tool, agents execute."

## Teammate Roles

| Phase | Teammate | Role |
|-------|----------|------|
| 2 | requirements-clarifier | Gather requirements, output requirements.md |
| 3 | research-agent | Research best practices, present 3-5 options |
| 4 | debug-analyzer | Root cause analysis (bugs only) |
| 5 | code-assessor | Assess architecture, style, frameworks |
| 5.3 | architecture-agent | Design architecture (arch only), present 3-5 options |
| 5.4 | product-designer | Coordinate architecture + UI design together, present combined options |
| 5.5 | ui-ux-designer | Create UI/UX design (UI only), present 3-5 options |
| 6 | spec-writer | Write spec, plan, task list |
| 8 | dev-executor | Implement code (parallel with qa-agent) |
| 8 | qa-agent | Plan and run tests (parallel with dev-executor) |
| 9 | code-reviewer | Spec-aware code review |
| 10 | docs-executor | Update documentation |

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
Phases 3, 5.3, 5.4, 5.5 require presenting 3-5 options to user for selection.
Phase 5.4 (product-designer) presents COMBINED architecture+UI options.

### Branch Name Rule
Git branch name MUST match worktree name: `[spec-index]-[spec-name]`

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

**Exception:** Phase 8 (dev-executor + qa-agent) - These run in parallel and should both complete before termination.

## Best Practices

1. **Give teammates context** - Include task details in spawn prompts
2. **Size tasks appropriately** - Self-contained units with clear deliverables
3. **Wait for teammates** - Team Lead should NOT implement directly
4. **Avoid file conflicts** - Each teammate owns different files
5. **Monitor and steer** - Check progress, redirect as needed
6. **Encourage communication** - Teammates should message each other
7. **Terminate after completion** - Shut down teammates immediately after their work is done

---

## Phase Enforcement: What Team Lead Does in Each Phase

**MANDATORY: Team Lead orchestrates via Task tool, agents execute.**

| Phase | Team Lead Action | Agent to Spawn (via Task tool) |
|-------|-----------------|--------------------------------|
| 0 | Invoke dev-rules skill | (none) |
| 1 | Execute setup (worktree, spec dir, JSON, team) | (none) |
| 2 | Use Task tool → `super-dev:requirements-clarifier` | requirements-clarifier |
| 3 | Use Task tool → `super-dev:research-agent`, present options | research-agent |
| 4 | Use Task tool → `super-dev:debug-analyzer` (bugs only) | debug-analyzer |
| 5 | Use Task tool → `super-dev:code-assessor` | code-assessor |
| 5.3 | Use Task tool → `super-dev:architecture-agent`, present options | architecture-agent |
| 5.4 | Use Task tool → `super-dev:product-designer`, present combined options | product-designer |
| 5.5 | Use Task tool → `super-dev:ui-ux-designer`, present options | ui-ux-designer |
| 6 | Use Task tool → `super-dev:spec-writer` | spec-writer |
| 7 | Validate spec (no agent) | (none) |
| 8 | Use Task tool → `super-dev:dev-executor` + `super-dev:qa-agent` (parallel) | dev-executor, qa-agent |
| 9 | Use Task tool → `super-dev:code-reviewer` | code-reviewer |
| 10 | Use Task tool → `super-dev:docs-executor` | docs-executor |
| 11 | Final verification (teammates already terminated per-phase, keep worktree) | (varies) |
| 11.5 | Present summary to user for confirmation (no agent) | (none) |
| 12 | Execute git operations (commit, merge) | (none) |
| 13 | Verify completion (worktree preserved for reference) | (none) |

**Phase 5.3/5.4/5.5 Selection Logic:**
- Architecture ONLY (no UI) → 5.3: Task tool with `super-dev:architecture-agent`
- UI ONLY (no architecture) → 5.5: Task tool with `super-dev:ui-ux-designer`
- BOTH architecture AND UI → 5.4: Task tool with `super-dev:product-designer`

**KEY RULE:** If a phase requires work (Phase 2-10), Team Lead MUST use Task tool to spawn the appropriate agent. NEVER do the work directly.

---

## Phase 0: Apply Dev Rules

**SKILL:** Invoke `super-dev:dev-rules`

Establishes coding standards, git practices, and quality standards for the development session.

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

## Display Modes

- **In-Process** (default): All in main terminal, use Shift+Up/Down to navigate
- **Split-Pane**: Each teammate in own pane (requires tmux or iTerm2)

Set in `settings.json`:
```json
{
  "teammateMode": "in-process" | "auto" | "tmux"
}
```

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
