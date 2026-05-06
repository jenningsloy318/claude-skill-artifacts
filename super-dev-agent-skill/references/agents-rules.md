---
name: agents
description: Agent orchestration rules for usage, parallel execution, and termination
---

<purpose>Define rules for agent usage, parallel task execution, immediate termination after completion, and multi-perspective analysis.</purpose>

<reference name="Available Agents">
  Located in `${CLAUDE_PLUGIN_ROOT}/agents/`:
  Writers: requirements-clarifier, bdd-scenario-writer, spec-writer, handoff-writer.
  Reviewers: spec-reviewer, code-reviewer, adversarial-reviewer.
  Researchers: research-agent, search-agent, investigator.
  Assessors: code-assessor, debug-analyzer.
  Designers: architecture-agent, ui-ux-designer, product-designer.
  Implementers: dev-executor, frontend-developer, backend-developer, rust-developer, golang-developer, ios-developer, android-developer, macos-app-developer, windows-app-developer, build-error-resolver, refactor-cleaner.
  QA: qa-agent, e2e-runner, tdd-guide.
  Docs: docs-executor, doc-updater, doc-validator.
</reference>

<directives>
  <directive severity="high" name="Immediate agent usage">No user prompt needed: Complex features → planner, Code written/modified → code-reviewer, Bug fix or new feature → tdd-guide, Architectural decision → architecture-agent</directive>
  <directive severity="high" name="Parallel Task execution">ALWAYS use parallel execution for independent operations. Never run sequentially when tasks are independent.</directive>
  <directive severity="high" name="Sequential TDD workflow">Stage 9 is strictly sequential: tdd-guide (9.1) → domain specialist (9.2) → qa-agent (9.3). Each step MUST complete before the next begins.</directive>
  <directive severity="critical" name="TERMINATE IMMEDIATELY AFTER COMPLETION">Verify output is complete, terminate the agent. Prevents resource accumulation. Exception: parallel agents in Stage 10 (code-reviewer + adversarial-reviewer) — wait for ALL to complete before terminating.</directive>
  <directive severity="medium" name="Multi-perspective analysis">For complex problems: use split role sub-agents (factual reviewer, senior engineer, security expert, consistency reviewer, redundancy checker)</directive>
</directives>
