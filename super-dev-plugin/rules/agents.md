# Agent Orchestration

## Available Agents

Located in `~/.claude/agents/`:

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| planner | Implementation planning | Complex features, refactoring |
| architect | System design | Architectural decisions |
| tdd-guide | Test-driven development | New features, bug fixes |
| code-reviewer | Code review | After writing code |
| security-reviewer | Security analysis | Before commits |
| build-error-resolver | Fix build errors | When build fails |
| e2e-runner | E2E testing | Critical user flows |
| refactor-cleaner | Dead code cleanup | Code maintenance |
| doc-updater | Documentation | Updating docs |

## Immediate Agent Usage

No user prompt needed:
1. Complex feature requests - Use **planner** agent
2. Code just written/modified - Use **code-reviewer** agent
3. Bug fix or new feature - Use **tdd-guide** agent
4. Architectural decision - Use **architect** agent

## Parallel Task Execution

ALWAYS use parallel Task execution for independent operations:

```markdown
# GOOD: Parallel execution
Launch 3 agents in parallel:
1. Agent 1: Security analysis of auth.ts
2. Agent 2: Performance review of cache system
3. Agent 3: Type checking of utils.ts

# BAD: Sequential when unnecessary
First agent 1, then agent 2, then agent 3
```

## Agent Termination Rules (CRITICAL)

**TERMINATE IMMEDIATELY AFTER COMPLETION:**

When an agent/subagent/teammate finishes their assigned task:
1. Verify the agent's output is complete
2. **Terminate the agent immediately** - Do NOT keep idle agents running
3. **Close the tmux pane** (if using tmux mode) to free resources

**Why immediate termination:**
- Frees up context window and memory
- Prevents resource accumulation
- Keeps the system lean and efficient
- Reduces confusion about active agents

**Termination Process:**
```
1. Agent reports completion
2. Verify output is complete
3. Send: "Thank you. Your work is complete. Please shut down."
4. Agent shuts down gracefully
5. If tmux: close the pane with `exit` or Ctrl+D
```

**Exception:** Parallel agents (e.g., dev-executor + qa-agent) - Wait for ALL to complete before terminating.

## Multi-Perspective Analysis

For complex problems, use split role sub-agents:
- Factual reviewer
- Senior engineer
- Security expert
- Consistency reviewer
- Redundancy checker
