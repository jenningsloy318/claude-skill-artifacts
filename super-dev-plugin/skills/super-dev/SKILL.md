---
name: super-dev
description: Multi-step development orchestrator for implementing features, fixing bugs, refactoring, optimizing performance, and resolving deprecations
author: Jennings Liu
version: 2.7.0
license: MIT
---

<purpose>Team Lead agent team workflow. The Team Lead orchestrates specialized agent teammates — it NEVER implements directly, only spawns, coordinates, and verifies. Agents execute research, architecture, coding, QA, code review, and documentation phases in parallel where possible.</purpose>

<triggers>Triggers on: "implement", "build", "fix bug", "refactor", "add feature", "develop this", "help me build", "add functionality", "optimize performance", "resolve deprecation", "systematic development". Do NOT trigger on: simple questions, file searches, one-off commands, code explanations, quick edits, non-development tasks.</triggers>

<workflow>
  <phase n="0" name="Apply Dev Rules">Invoke dev-rules skill. MUST complete before any other action.</phase>
  <phase n="1" name="Specification Setup">Create worktree, spec dir, workflow JSON, agent team. MUST complete before any codebase exploration or agent spawning.</phase>
  <phase n="2" name="Requirements Clarification">Spawn requirements-clarifier + doc-validator (parallel). Gate: gate-requirements.sh.</phase>
  <phase n="2.5" name="BDD Scenarios">Spawn bdd-scenario-writer + doc-validator (parallel). User confirmation required. Gate: gate-bdd.sh.</phase>
  <phase n="3" name="Research">Spawn research-agent. Firecrawl MCP first, then supplementary scripts. Present 3-5 options to user.</phase>
  <phase n="4" name="Debug Analysis">Spawn debug-analyzer. Only for bug fixes — skip otherwise.</phase>
  <phase n="5" name="Code Assessment">Spawn code-assessor. FIRST phase allowed to read/grep/explore the codebase.</phase>
  <phase n="5.3" name="Architecture Design">Spawn architecture-agent. Selection: Architecture ONLY → 5.3. UI ONLY → 5.5. BOTH → 5.4 (product-designer).</phase>
  <phase n="5.5" name="UI/UX Design">Spawn ui-ux-designer. Only if UI feature.</phase>
  <phase n="6" name="Specification Writing">Spawn spec-writer + doc-validator (parallel). Produces specification, implementation plan, task list. Gate: gate-spec-trace.sh.</phase>
  <phase n="7" name="Specification Review">Spawn spec-reviewer + doc-validator (parallel). Gate: gate-spec-review.sh. If issues found, Loop Phase 6/7 until approved. Max 3 iterations</phase>
  <phase n="8" name="Implementation">Domain-Aware Agent Routing: spawn specialist(s) + qa-agent (parallel). Gate: gate-build.sh.</phase>
  <phase n="9" name="Code Review + Adversarial Review">Spawn code-reviewer + adversarial-reviewer + 2x doc-validator (4 parallel). Gate: gate-review.sh. Loop Phase 8/9 until approved. Max 3 iterations.</phase>
  <phase n="10" name="Documentation Update">Spawn docs-executor. Gate: gate-docs-drift.sh. MANDATORY — do not skip.</phase>
  <phase n="10.5" name="Handoff Writing">Spawn handoff-writer. MANDATORY — do not skip.</phase>
  <phase n="11" name="Team Cleanup">Verify all teammates terminated, worktree preserved.</phase>
  <phase n="11.5" name="User Confirmation">Present summary to user for confirmation before merge.</phase>
  <phase n="12" name="Commit and Merge">Git operations: commit spec directory + code, merge to main.</phase>
  <phase n="13" name="Final Verification">Verify completion, worktree preserved for reference.</phase>
</workflow>

<processes>
  <process name="Specification Setup (Phase 1)">
    <step n="1" name="Spec Index">Find highest `[XX]` prefix in `specification/` directory. Next index = max + 1 (zero-padded).</step>
    <step n="2" name="Spec Name">Derive from user request (e.g., "add auth" → `add-auth`). Kebab-case, lowercase.</step>
    <step n="3" name="Spec Directory">Create `specification/[spec-index]-[spec-name]/` (e.g., `specification/22-xml-restructure/`).</step>
    <step n="4" name="Worktree">Create `.worktree/[spec-index]-[spec-name]` with matching branch name `[spec-index]-[spec-name]`.</step>
    <step n="5" name="Agent Team">Create team named `super-dev-[spec-name]` (e.g., `super-dev-xml-restructure`). All agents spawn into this team.</step>
    <step n="6" name="Workflow JSON">Create `[spec-index]-[spec-name]-workflow-tracking.json` in spec directory. Track phases, iterations, timestamps.</step>
  </process>

  <process name="First-Run Configuration">
    <step n="1" name="Detect">Derive project key: `PROJECT_NAME="$(basename "$(git rev-parse --show-toplevel)")"`. Check `${CLAUDE_PLUGIN_DATA}/projects/${PROJECT_NAME}/config.json`.</step>
    <step n="2" name="Auto-detect">Language (package.json→Node, Cargo.toml→Rust, go.mod→Go, pyproject.toml→Python). Framework (next.config.*→Next.js, vite.config.*→Vite). Package manager (bun.lockb, pnpm-lock.yaml, yarn.lock). Test runner (jest.config.*, vitest.config.*, playwright.config.*).</step>
    <step n="3" name="Confirm and Write">Ask user to confirm detected values. Write config to `${CLAUDE_PLUGIN_DATA}/projects/${PROJECT_NAME}/config.json` (include `project.path` for collision detection). On subsequent runs, read config silently.</step>
  </process>

  <process name="Verification Gates">
    Gate scripts in `${CLAUDE_PLUGIN_ROOT}/scripts/gates/` exit 0 (PASS) or 1 (FAIL). Gates are NON-NEGOTIABLE — if a gate fails, loop back and fix.

    <step n="1" name="Gate Map">
      <gate after="2 → 2.5" script="gate-requirements.sh" run_by="doc-validator" checks="Acceptance criteria, NFRs, summary" />
      <gate after="2.5 → 3" script="gate-bdd.sh" run_by="doc-validator" checks="SCENARIO-IDs, Given/When/Then, AC traceability" />
      <gate after="6 → 7" script="gate-spec-trace.sh" run_by="doc-validator" checks="Spec refs BDD scenarios, testing strategy" />
      <gate after="7 → 8" script="gate-spec-review.sh" run_by="doc-validator" checks="Review verdict, 8 dimensions, grounding" />
      <gate after="8 → 9" script="gate-build.sh" run_by="team-lead" checks="Build succeeds, tests pass, type checks" />
      <gate after="9 → 10" script="gate-review.sh" run_by="doc-validator" checks="Code review approved, adversarial PASS" />
      <gate after="10 → 10.5" script="gate-docs-drift.sh" run_by="team-lead" checks="Docs exist, no excessive TODOs" />
    </step>
    <step n="2" name="Execution">`bash ${CLAUDE_PLUGIN_ROOT}/scripts/gates/<gate-name>.sh <spec-dir>`</step>
    <step n="3" name="Failure Handling">Gate fails → report which checks failed → spawn appropriate agent to fix → re-run gate → proceed only on PASS (exit 0).</step>
  </process>

  <process name="Document Naming Pre-Computation">
    Team Lead pre-computes exact filenames BEFORE spawning agents. Agents receive concrete names (e.g., `03-research-report.md`), never `[doc-index]` placeholders.

    <step n="1">List spec directory, find highest existing `[XX]` prefix</step>
    <step n="2">Next index = max + 1 (zero-padded to 2 digits)</step>
    <step n="3">For multi-doc phases, pre-allocate consecutive indices</step>
    <step n="4">Pass EXACT filenames to agents via `OUTPUT FILENAME` in spawn prompts</step>
    <step n="5">Doc-validator receives same filenames and verifies (not renames)</step>
  </process>

  <process name="Worktree Enforcement">
    Before spawning ANY agent in Phase 2+, Team Lead MUST verify `pwd` is inside `.worktree/`. If not, STOP immediately.

    Check: `pwd | grep -q '\.worktree/'` — if fails, all gate scripts and agent work will use wrong relative paths.
  </process>

  <process name="Domain-Aware Agent Routing">
    For Phase 8, spawn domain specialists directly instead of dev-executor:
    <route domain="Rust" agent="rust-developer" />
    <route domain="Go" agent="golang-developer" />
    <route domain="Frontend" agent="frontend-developer" />
    <route domain="Backend" agent="backend-developer" />
    <route domain="iOS" agent="ios-developer" />
    <route domain="Android" agent="android-developer" />
    <route domain="Windows" agent="windows-app-developer" />
    <route domain="macOS" agent="macos-app-developer" />
    <route domain="Unknown" agent="dev-executor" />
  </process>

  <process name="Phase Enforcement">
    <entry phase="0" action="Invoke dev-rules skill" agents="none" />
    <entry phase="1" action="Setup: worktree, spec dir, JSON, team" agents="none" />
    <entry phase="2" action="Task tool" agents="requirements-clarifier + doc-validator (parallel)" />
    <entry phase="2.5" action="Task tool, present to user" agents="bdd-scenario-writer + doc-validator (parallel)" />
    <entry phase="3" action="Task tool, present options" agents="research-agent" />
    <entry phase="4" action="Task tool (bugs only)" agents="debug-analyzer" />
    <entry phase="5" action="Task tool" agents="code-assessor" />
    <entry phase="5.3/5.4/5.5" action="Task tool, present options" agents="architecture-agent / product-designer / ui-ux-designer" />
    <entry phase="6" action="Task tool" agents="spec-writer + doc-validator (parallel)" />
    <entry phase="7" action="Task tool" agents="spec-reviewer + doc-validator (parallel)" />
    <entry phase="8" action="Domain-Aware Routing" agents="specialist(s) + qa-agent (parallel)" />
    <entry phase="9" action="Task tool" agents="code-reviewer + adversarial-reviewer + 2x doc-validator (4 parallel)" />
    <entry phase="10" action="Task tool" agents="docs-executor" />
    <entry phase="10.5" action="Task tool" agents="handoff-writer" />
    <entry phase="11" action="Verify all terminated, worktree preserved" agents="varies" />
    <entry phase="12" action="Git operations (commit, merge) — include spec directory" agents="none" />
    <entry phase="13" action="Verify completion, worktree preserved" agents="none" />
  </process>
</processes>

<criteria name="Success">
  <criterion name="Outcome">Feature/fix works correctly. All tests pass with new coverage. Code review resolves all Critical/High/Medium to zero. BDD scenario coverage 100%. Documentation updated. Handoff document generated.</criterion>
  <criterion name="Efficiency">Phase iteration loops less than 3. Teammates terminated immediately after completion. Team Lead never performs agent work directly.</criterion>
  <criterion name="Style">Git worktree with matching branch name. Spec directory structure followed. Workflow tracking JSON maintained. Commit messages follow conventions. All work inside worktree.</criterion>
</criteria>

<constraints>
  <constraint name="Delegation Mode">Team Lead spawns teammates for ALL work. Never implements directly.</constraint>
  <constraint name="Sequential Phases">Each phase depends on previous phase completing successfully.</constraint>
  <constraint name="Iteration Rule">Phase 8/9 loop until code-reviewer approves. Max 3 iterations.</constraint>
  <constraint name="Version Bump">Every modification to super-dev-plugin files requires patch version bump in plugin.json and marketplace.json.</constraint>
  <constraint name="Phase 0+1 Gate">Phase 0 (dev rules) and Phase 1 (worktree, spec dir, team) MUST complete before ANY exploration, code reading, grep, glob, research, or agent spawning. No codebase interaction until the worktree and spec directory exist.</constraint>
  <constraint name="No Early Code Analysis">Do NOT read code, grep, glob, or explore the codebase before Phase 5 (Code Assessment). Phases 0-4 work from requirements, BDD scenarios, and research only — not from reading source files. The code-assessor agent in Phase 5 is the FIRST agent allowed to examine the codebase.</constraint>
  <constraint name="Gate Scripts">Gate scripts must pass between phases.</constraint>
  <constraint name="Parallel Doc-validator Rule">Phases 2, 2.5, 6, 7, 9: ALWAYS spawn doc-validator alongside writer/reviewer. Both in same action. Spawning only writer is a VIOLATION.</constraint>
  <constraint name="Delegation Rule">If a phase requires work (2-11), Team Lead MUST spawn agents via Task tool. NEVER do work directly.</constraint>
  <constraint name="Direct Peer Communication">Agents in same phase communicate directly (FINDING_SHARE, FINDING_ACK, REVIEW_COMPLETE, VALIDATION FAILED/PASS).</constraint>
  <constraint name="MANDATORY Phase 9-12 Transition">Execute in strict order: Phase 10 → gate-docs-drift.sh → Phase 10.5 → Phase 11 → Phase 11.5 → Phase 12. Jumping Phase 9 → Phase 12 is a CRITICAL violation.</constraint>
  <constraint name="Teammate Termination">Terminate teammates immediately after their work completes. Verify output, then shut down. Do NOT keep idle teammates running. Exception: In Phase 8 (specialists + qa-agent) and Phase 9 (code-reviewer + adversarial-reviewer + doc-validators), wait for ALL parallel agents to complete before terminating any.</constraint>
</constraints>

<rules>
  <rule name="agent-team" mandatory="true">ALL work MUST use agent team. Create team via TeamCreate before spawning any agents.</rule>
  <rule name="team-lead-delegation" mandatory="true">Team Lead NEVER implements directly. Only assigns tasks, spawns agents, coordinates, and verifies output.</rule>
  <rule name="git-workflow" mandatory="true">Commit format, PR workflow, feature implementation workflow</rule>
  <rule name="coding-style" mandatory="true">Immutability, file organization, error handling, input validation</rule>
  <rule name="testing" mandatory="true">80% coverage, TDD workflow, BDD practices</rule>
  <rule name="security" mandatory="true">No hardcoded secrets, input validation, injection prevention</rule>
  <rule name="agents" mandatory="true">Agent usage, parallel execution, immediate termination</rule>
  <rule name="patterns" mandatory="false">API response format, custom hooks, repository pattern</rule>
  <rule name="performance" mandatory="false">Model selection, context management, build troubleshooting</rule>
  <rule name="rust-project" mandatory="false">Rust workspace structure, build commands, crate conventions (only for Rust projects)</rule>
</rules>

<references>
  <ref>Plugin root: `${CLAUDE_PLUGIN_ROOT}` — agents, commands, rules, contexts, skills, templates, scripts</ref>
  <ref>Plugin data: `${CLAUDE_PLUGIN_DATA}` — global stats, learned patterns, autoresearch results</ref>
  <ref>Compatibility: Requires Claude Code CLI with Task tool and agent teams (CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1). Git required for worktree management.</ref>
</references>
