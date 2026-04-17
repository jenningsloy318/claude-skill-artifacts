<meta>
  <name>super-dev</name>
  <type>skill</type>
  <description>Multi-step development orchestrator for implementing features, fixing bugs, refactoring, optimizing performance, and resolving deprecations</description>
  <author>Jennings Liu</author>
  <version>2.7.0</version>
  <license>MIT</license>
</meta>

<purpose>Orchestrate specialized agent teammates through research, architecture, coding, QA, code review, and documentation phases. Use for any multi-step development task requiring planning, implementation, testing, and review.</purpose>

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
  <phase n="7" name="Specification Review">Spawn spec-reviewer + doc-validator (parallel). Gate: gate-spec-review.sh. If issues found, loop to Phase 6.</phase>
  <phase n="8" name="Implementation">Domain-Aware Agent Routing: spawn specialist(s) + qa-agent (parallel). Gate: gate-build.sh.</phase>
  <phase n="9" name="Code Review + Adversarial Review">Spawn code-reviewer + adversarial-reviewer + 2x doc-validator (4 parallel). Gate: gate-review.sh. Loop Phase 8/9 until approved. Max 3 iterations.</phase>
  <phase n="10" name="Documentation Update">Spawn docs-executor. Gate: gate-docs-drift.sh. MANDATORY — do not skip.</phase>
  <phase n="10.5" name="Handoff Writing">Spawn handoff-writer. MANDATORY — do not skip.</phase>
  <phase n="11" name="Team Cleanup">Verify all teammates terminated, worktree preserved.</phase>
  <phase n="11.5" name="User Confirmation">Present summary to user for confirmation before merge.</phase>
  <phase n="12" name="Commit and Merge">Git operations: commit spec directory + code, merge to main.</phase>
  <phase n="13" name="Final Verification">Verify completion, worktree preserved for reference.</phase>

  <constraint>**MANDATORY Phase 9 → 12 Transition**: Execute in strict order: Phase 10 → gate-docs-drift.sh → Phase 10.5 → Phase 11 → Phase 11.5 → Phase 12. Jumping Phase 9 → Phase 12 is a CRITICAL violation.</constraint>
</workflow>

<process name="First-Run Configuration">
  <step n="1" name="Detect">Derive project key: `PROJECT_NAME="$(basename "$(git rev-parse --show-toplevel)")"`. Check `${CLAUDE_PLUGIN_DATA}/projects/${PROJECT_NAME}/config.json`.</step>
  <step n="2" name="Auto-detect">Language (package.json→Node, Cargo.toml→Rust, go.mod→Go, pyproject.toml→Python). Framework (next.config.*→Next.js, vite.config.*→Vite). Package manager (bun.lockb, pnpm-lock.yaml, yarn.lock). Test runner (jest.config.*, vitest.config.*, playwright.config.*).</step>
  <step n="3" name="Confirm and Write">Ask user to confirm detected values. Write config to `${CLAUDE_PLUGIN_DATA}/projects/${PROJECT_NAME}/config.json` (include `project.path` for collision detection). On subsequent runs, read config silently.</step>
</process>

<process name="Verification Gates">
  Gate scripts in `${CLAUDE_PLUGIN_ROOT}/scripts/gates/` exit 0 (PASS) or 1 (FAIL). Gates are NON-NEGOTIABLE — if a gate fails, loop back and fix.

  <step n="1" name="Gate Map">
    | After Phase | Gate Script | Run By | Checks |
    |---|---|---|---|
    | 2 → 2.5 | `gate-requirements.sh` | doc-validator | Acceptance criteria, NFRs, summary |
    | 2.5 → 3 | `gate-bdd.sh` | doc-validator | SCENARIO-IDs, Given/When/Then, AC traceability |
    | 6 → 7 | `gate-spec-trace.sh` | doc-validator | Spec refs BDD scenarios, testing strategy |
    | 7 → 8 | `gate-spec-review.sh` | doc-validator | Review verdict, 8 dimensions, grounding |
    | 8 → 9 | `gate-build.sh` | team-lead | Build succeeds, tests pass, type checks |
    | 9 → 10 | `gate-review.sh` | doc-validator | Code review approved, adversarial PASS |
    | 10 → 10.5 | `gate-docs-drift.sh` | team-lead | Docs exist, no excessive TODOs |
  </step>
  <step n="2" name="Execution">`bash ${CLAUDE_PLUGIN_ROOT}/scripts/gates/&lt;gate-name&gt;.sh &lt;spec-dir&gt;`</step>
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

<topic name="Teammate Termination Rules">
  Terminate teammates immediately after their work completes. Verify output, then shut down. Do NOT keep idle teammates running.

  **Exception**: In Phase 8 (specialists + qa-agent) and Phase 9 (code-reviewer + adversarial-reviewer + doc-validators), wait for ALL parallel agents to complete before terminating any.
</topic>

<topic name="Success Criteria">
  **Outcome (baseline)**: Feature/fix works correctly. All tests pass with new coverage. Code review resolves all Critical/High/Medium to zero. BDD scenario coverage 100%. Documentation updated. Handoff document generated.

  **Efficiency**: Phase iteration loops less than 3. Teammates terminated immediately after completion. Team Lead never performs agent work directly.

  **Style and Instructions**: Git worktree with matching branch name. Spec directory structure followed. Workflow tracking JSON maintained. Commit messages follow conventions. All work inside worktree.
</topic>

<topic name="Phase Enforcement Table">
  | Phase | Team Lead Action | Agent(s) to Spawn |
  |---|---|---|
  | 0 | Invoke dev-rules skill | (none) |
  | 1 | Setup: worktree, spec dir, JSON, team | (none) |
  | 2 | Task tool | requirements-clarifier + doc-validator (parallel) |
  | 2.5 | Task tool, present to user | bdd-scenario-writer + doc-validator (parallel) |
  | 3 | Task tool, present options | research-agent |
  | 4 | Task tool (bugs only) | debug-analyzer |
  | 5 | Task tool | code-assessor |
  | 5.3/5.4/5.5 | Task tool, present options | architecture-agent / product-designer / ui-ux-designer |
  | 6 | Task tool | spec-writer + doc-validator (parallel) |
  | 7 | Task tool | spec-reviewer + doc-validator (parallel) |
  | 8 | Domain-Aware Routing | specialist(s) + qa-agent (parallel) |
  | 9 | Task tool | code-reviewer + adversarial-reviewer + 2x doc-validator (4 parallel) |
  | 10 | Task tool | docs-executor |
  | 10.5 | Task tool | handoff-writer |
  | 11 | Verify all terminated, worktree preserved | (varies) |
  | 12 | Git operations (commit, merge) — include spec directory | (none) |
  | 13 | Verify completion, worktree preserved | (none) |

  **Parallel doc-validator rule (Phases 2, 2.5, 6, 7, 9)**: ALWAYS spawn doc-validator alongside writer/reviewer. Both in same action. Spawning only writer is a VIOLATION.

  **KEY RULE**: If a phase requires work (2-11), Team Lead MUST spawn agents via Task tool. NEVER do work directly.
</topic>

<topic name="Key Capabilities">
  **Domain-Aware Agent Routing**: For known domains, spawn specialists directly (Rust→rust-developer, Go→golang-developer, Frontend→frontend-developer, etc.) bypassing dev-executor.

  **Worktree Enforcement**: ALL development in git worktrees. Auto-create `.worktree/[spec-index]-[spec-name]`.

  **Phase 7 Spawn**: Specification review runs spec-reviewer + doc-validator in parallel.

  **Direct Peer Communication**: Agents in same phase communicate directly (FINDING_SHARE, FINDING_ACK, REVIEW_COMPLETE, VALIDATION FAILED/PASS).

  **Firecrawl MCP First**: Research phase MUST run Firecrawl MCP before any other search tool.

  **BDD Integration**: Scenarios written before implementation (Phase 2.5). 100% scenario coverage required at Phase 9 gate.
</topic>

<constraints>
  <constraint>**DELEGATION MODE**: Team Lead spawns teammates for ALL work. Never implements directly.</constraint>
  <constraint>**Sequential phases**: Each phase depends on previous phase completing successfully</constraint>
  <constraint>**Iteration Rule**: Phase 8/9 loop until code-reviewer approves. Max 3 iterations.</constraint>
  <constraint>**Version bump**: Every modification to super-dev-plugin files requires patch version bump in plugin.json and marketplace.json</constraint>
  <constraint>**Phase 0+1 gate**: Phase 0 (dev rules) and Phase 1 (worktree, spec dir, team) MUST complete before ANY exploration, code reading, grep, glob, research, or agent spawning. No codebase interaction until the worktree and spec directory exist.</constraint>
  <constraint>**No early code analysis**: Do NOT read code, grep, glob, or explore the codebase before Phase 5 (Code Assessment). Phases 0-4 work from requirements, BDD scenarios, and research only — not from reading source files. The code-assessor agent in Phase 5 is the FIRST agent allowed to examine the codebase.</constraint>
  <constraint>All spec artifacts use pre-computed filenames from Team Lead</constraint>
  <constraint>Gate scripts must pass between phases</constraint>
</constraints>

<references>
  <ref>Plugin root: `${CLAUDE_PLUGIN_ROOT}` — agents, commands, rules, contexts, skills, templates, scripts</ref>
  <ref>Plugin data: `${CLAUDE_PLUGIN_DATA}` — global stats, learned patterns, autoresearch results</ref>
  <ref>Compatibility: Requires Claude Code CLI with Task tool and agent teams (CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1). Git required for worktree management.</ref>
</references>
