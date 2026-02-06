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
