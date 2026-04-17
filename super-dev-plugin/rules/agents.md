<meta>
  <name>agents</name>
  <type>rule</type>
  <description>Agent orchestration rules for usage, parallel execution, and termination</description>
</meta>

<purpose>Define rules for agent usage, parallel task execution, immediate termination after completion, and multi-perspective analysis.</purpose>

<topic name="Available Agents">
  Located in `${CLAUDE_PLUGIN_ROOT}/agents/`: planner (implementation planning), architect (system design), tdd-guide (test-driven development), code-reviewer (code review), security-reviewer (security analysis), build-error-resolver (build errors), e2e-runner (E2E testing), refactor-cleaner (dead code cleanup), doc-updater (documentation).
</topic>

<directives>
  <directive severity="high" name="Immediate agent usage">No user prompt needed: Complex features → planner, Code written/modified → code-reviewer, Bug fix or new feature → tdd-guide, Architectural decision → architect</directive>
  <directive severity="high" name="Parallel Task execution">ALWAYS use parallel execution for independent operations. Never run sequentially when tasks are independent.</directive>
  <directive severity="critical" name="TERMINATE IMMEDIATELY AFTER COMPLETION">Verify output is complete, terminate the agent, close tmux pane if applicable. Prevents resource accumulation. Exception: parallel agents (e.g., dev-executor + qa-agent) — wait for ALL to complete before terminating.</directive>
  <directive severity="medium" name="Multi-perspective analysis">For complex problems: use split role sub-agents (factual reviewer, senior engineer, security expert, consistency reviewer, redundancy checker)</directive>
</directives>
