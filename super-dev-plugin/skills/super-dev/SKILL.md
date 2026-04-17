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
  **Phase 0**: Apply dev rules (dev-rules skill). **Phase 1**: Specification setup (worktree, spec dir, workflow JSON, team creation). **Phase 2**: Requirements clarification (requirements-clarifier + doc-validator). **Phase 2.5**: BDD scenarios (bdd-scenario-writer + doc-validator, user confirmation required). **Phase 3**: Research (research-agent with Firecrawl MCP first). **Phase 4**: Debug analysis (debug-analyzer, if bug fix). **Phase 5**: Code assessment (code-assessor). **Phase 5.3**: Architecture design (architecture-agent or product-designer). **Phase 5.5**: UI/UX design (ui-ux-designer, if UI feature). **Phase 6**: Specification writing (spec-writer + doc-validator). **Phase 7**: Specification review (spec-reviewer + doc-validator). **Phase 8**: Implementation (domain specialists + qa-agent, parallel). **Phase 9**: Code review + adversarial review (parallel with doc-validator). **Phase 10**: Documentation update (docs-executor). **Phase 10.5**: Handoff writing (handoff-writer). **Phase 11**: Team cleanup. **Phase 12**: Commit and merge. **Phase 13**: Complete.

  **Phase 5.3/5.4/5.5 Selection**: Architecture ONLY → 5.3 (architecture-agent). UI ONLY → 5.5 (ui-ux-designer). BOTH → 5.4 (product-designer).

  **Iteration Rule**: Loop Phase 8/9 until code-reviewer approves, adversarial review PASS, BDD coverage 100%. Max 3 iterations.

  **MANDATORY Phase 9 → 12 Transition**: After Phase 9 passes, execute in strict order: Phase 10 (docs-executor) → gate-docs-drift.sh → Phase 10.5 (handoff-writer) → Phase 11 (cleanup) → Phase 11.5 (user confirmation) → Phase 12 (commit). Jumping Phase 9 → Phase 12 is a CRITICAL violation.
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
  <constraint>**No early code analysis**: Do not analyze codebase before Phase 5 (Code Assessment)</constraint>
  <constraint>All spec artifacts use pre-computed filenames from Team Lead</constraint>
  <constraint>Gate scripts must pass between phases</constraint>
</constraints>

<references>
  <ref>Plugin root: `${CLAUDE_PLUGIN_ROOT}` — agents, commands, rules, contexts, skills, templates, scripts</ref>
  <ref>Plugin data: `${CLAUDE_PLUGIN_DATA}` — global stats, learned patterns, autoresearch results</ref>
  <ref>Compatibility: Requires Claude Code CLI with Task tool and agent teams (CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1). Git required for worktree management.</ref>
</references>
