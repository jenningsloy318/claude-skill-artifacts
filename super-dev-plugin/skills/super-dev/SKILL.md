---
name: super-dev
description: Agent Team-driven development workflow. Team Lead Coordinator orchestrates specialized teammates who work independently with their own context windows and can message each other directly.
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
- [ ] Phase 5.3: Architecture Design (complex features)
- [ ] Phase 5.5: UI/UX Design (UI features)
- [ ] Phase 6:  Specification Writing
- [ ] Phase 7:  Specification Review
- [ ] Phase 8:  Execution & QA (PARALLEL teammates)
- [ ] Phase 9:  Code Review
- [ ] Phase 10: Documentation Update
- [ ] Phase 11: Cleanup
- [ ] Phase 12: Commit & Merge to Main
- [ ] Phase 13: Final Verification & Team Cleanup
```

**Iteration Rule:** Loop Phase 8/9 until Critical=0, High=0, Medium=0, all acceptance criteria met.

## Entry Point: Team Lead Coordinator

**ROLE:** Current session becomes Team Lead

**To start:**
```
"I'm using super-dev with agent teams. Create an agent team with the Coordinator as Team Lead to implement: [task]"
```

## Team Lead Responsibilities (Delegate Mode)

**CRITICAL:** Team Lead operates in orchestration-only mode.

✅ **CAN:**
- Create agent team
- Spawn teammates with roles
- Create tasks in shared list
- Message teammates
- Monitor task status
- Synthesize findings
- Coordinate phases
- Commit and merge
- Clean up team

❌ **CANNOT:**
- Edit files directly
- Run commands directly
- Perform research directly
- Skip teammate communication
- Take over teammate tasks

## Teammate Roles

| Phase | Teammate | Role |
|-------|----------|------|
| 2 | requirements-clarifier | Gather requirements, output requirements.md |
| 3 | research-agent | Research best practices, present 3-5 options |
| 4 | debug-analyzer | Root cause analysis (bugs only) |
| 5 | code-assessor | Assess architecture, style, frameworks |
| 5.3 | architecture-agent | Design architecture, present 3-5 options |
| 5.5 | ui-ux-designer | Create UI/UX design, present 3-5 options |
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
Phases 3, 5.3, 5.5 require presenting 3-5 options to user for selection.

### Branch Name Rule
Git branch name MUST match worktree name: `[spec-index]-[spec-name]`

## Best Practices

1. **Give teammates context** - Include task details in spawn prompts
2. **Size tasks appropriately** - Self-contained units with clear deliverables
3. **Wait for teammates** - Team Lead should NOT implement directly
4. **Avoid file conflicts** - Each teammate owns different files
5. **Monitor and steer** - Check progress, redirect as needed
6. **Encourage communication** - Teammates should message each other

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
