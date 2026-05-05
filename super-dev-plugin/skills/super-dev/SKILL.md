---
name: super-dev
description: Multi-step development orchestrator for implementing features, fixing bugs, refactoring, optimizing performance, and resolving deprecations
author: Jennings Liu
version: 2.7.0
license: MIT
---

<purpose>Team Lead agent team workflow. The Team Lead orchestrates specialized agent teammates — it NEVER implements directly, only spawns, coordinates, and verifies. Agents execute research, architecture, coding, QA, code review, and documentation stages in parallel where possible.</purpose>

<triggers>Triggers on: "implement", "build", "fix bug", "refactor", "add feature", "develop this", "help me build", "add functionality", "optimize performance", "resolve deprecation", "systematic development". Do NOT trigger on: simple questions, file searches, one-off commands, code explanations, quick edits, non-development tasks.</triggers>

<workflow>
  <stage n="1" name="Apply Dev Rules">Invoke dev-rules skill. MUST complete before any other action.</stage>
  <stage n="2" name="Specification Setup">Create worktree, spec dir, workflow JSON, agent team. MUST complete before any codebase exploration or agent spawning.</stage>
  <stage n="3" name="Requirements Clarification">Spawn requirements-clarifier + doc-validator (parallel). Gate: gate-requirements.sh.</stage>
  <stage n="3.5" name="BDD Scenarios">Spawn bdd-scenario-writer + doc-validator (parallel). Gate: gate-bdd.sh.</stage>
  <stage n="4" name="Research">Spawn research-agent. Firecrawl MCP first, then supplementary scripts. Present 3-5 options to user.</stage>
  <stage n="4.5" name="Deep Research">Conditional: only if Stage 4 report identifies issues, flaws, or ambiguities. Spawn research-agent in deep-research mode targeting specific issues. Loop until all issues are clearly understood (max 3 iterations).</stage>
  <stage n="5" name="Debug Analysis">Spawn debug-analyzer. Only for bug fixes — skip otherwise.</stage>
  <stage n="6" name="Code Assessment">Spawn code-assessor. FIRST stage allowed to read/grep/explore the codebase.</stage>
  <stage n="6.3" name="Architecture Design">Spawn architecture-agent. Selection: Architecture ONLY → 6.3. UI ONLY → 6.5. BOTH → 6.4 (product-designer).</stage>
  <stage n="6.5" name="UI/UX Design">Spawn ui-ux-designer. Only if UI feature.</stage>
  <stage n="7" name="Specification Writing">Spawn spec-writer + doc-validator (parallel). Produces specification, implementation plan, task list. Gate: gate-spec-trace.sh.</stage>
  <stage n="8" name="Specification Review">Spawn spec-reviewer + doc-validator (parallel). Reviewer MUST verify spec covers ALL requirements ACs, ALL BDD scenarios, and aligns with architecture/UI design decisions. Gate: gate-spec-review.sh. On failure: follow Spec Iteration Loop.</stage>
  <stage n="9" name="Implementation">Domain-Aware Agent Routing: spawn specialist(s) + qa-agent (parallel). Specialist MUST produce `*-implementation-summary.md` documenting changes, decisions, and challenges. Gate: gate-build.sh. Loops through ALL implementation-plan phases via Implementation Completeness Loop.</stage>
  <stage n="10" name="Code Review + Adversarial Review">Spawn code-reviewer + adversarial-reviewer + 2x doc-validator (4 parallel). Gate: gate-review.sh. On failure: follow Implementation Iteration Loop.</stage>
  <stage n="11" name="Documentation Update">Spawn docs-executor. Gate: gate-docs-drift.sh. MANDATORY — do not skip.</stage>
  <stage n="11.5" name="Handoff Writing">Spawn handoff-writer. MANDATORY — do not skip.</stage>
  <stage n="12" name="Team Cleanup">Verify all teammates terminated, worktree preserved.</stage>
  <stage n="12.5" name="User Confirmation">Present summary to user for confirmation before merge.</stage>
  <stage n="13" name="Commit and Merge">Git operations: commit spec directory + code, merge to main.</stage>
  <stage n="14" name="Final Verification">Verify completion, worktree preserved for reference.</stage>
</workflow>

<processes>
  <process name="Specification Setup (Stage 2)">
    <step n="1" name="Spec Index">Scan main repo's `specification/` directory for highest `[XX]` prefix. Next index = max + 1 (zero-padded).</step>
    <step n="2" name="Spec Name">Derive from user request (e.g., "add auth" → `add-auth`). Kebab-case, lowercase.</step>
    <step n="3" name="Spec Identifier">Define as `[spec-index]-[spec-name]` (e.g., `22-xml-restructure`). Use this identifier for worktree, branch, spec directory, and all references.</step>
    <step n="4" name="Worktree">Create worktree: `git worktree add .worktree/[spec-identifier] -b [spec-identifier]`. Branch name = spec-identifier. Then `cd .worktree/[spec-identifier]`. ALL subsequent file operations happen inside the worktree.</step>
    <step n="5" name="Spec Directory">Create `specification/[spec-identifier]/` INSIDE the worktree.</step>
    <step n="6" name="Agent Team">Create team named `super-dev-[spec-name]` (e.g., `super-dev-xml-restructure`). All agents spawn into this team.</step>
    <step n="7" name="Workflow JSON">Create `[spec-identifier]-workflow-tracking.json` in the worktree spec directory using template from `${CLAUDE_PLUGIN_ROOT}/templates/reference/workflow-tracking-template.json`. CRITICAL: `stages` MUST be a JSON array `[{id, name, status, startedAt, completedAt}, ...]` — NEVER a keyed object. Timestamps: ISO 8601 with seconds precision.</step>
  </process>

  <process name="First-Run Configuration">
    <step n="1" name="Detect">Derive project key: `PROJECT_NAME="$(basename "$(git rev-parse --show-toplevel)")"`. Check `${CLAUDE_PLUGIN_DATA}/projects/${PROJECT_NAME}/config.json`.</step>
    <step n="2" name="Auto-detect">Language (package.json→Node, Cargo.toml→Rust, go.mod→Go, pyproject.toml→Python). Framework (next.config.*→Next.js, vite.config.*→Vite). Package manager (bun.lockb, pnpm-lock.yaml, yarn.lock). Test runner (jest.config.*, vitest.config.*, playwright.config.*).</step>
    <step n="3" name="Confirm and Write">Ask user to confirm detected values. Write config to `${CLAUDE_PLUGIN_DATA}/projects/${PROJECT_NAME}/config.json` (include `project.path` for collision detection). On subsequent runs, read config silently.</step>
  </process>

  <process name="Verification Gates">
    Gate scripts in `${CLAUDE_PLUGIN_ROOT}/scripts/gates/` exit 0 (PASS) or 1 (FAIL). Gates are NON-NEGOTIABLE — if a gate fails, loop back and fix.

    <step n="1" name="Gate Map">
      <gate after="3 → 3.5" script="gate-requirements.sh" run_by="doc-validator" checks="Acceptance criteria, NFRs, summary" />
      <gate after="3.5 → 4" script="gate-bdd.sh" run_by="doc-validator" checks="SCENARIO-IDs, Given/When/Then, AC traceability" />
      <gate after="7 → 8" script="gate-spec-trace.sh" run_by="doc-validator" checks="Spec refs BDD scenarios, testing strategy" />
      <gate after="8 → 9" script="gate-spec-review.sh" run_by="doc-validator" checks="Review verdict, 8 dimensions, grounding" />
      <gate after="9 → 10" script="gate-build.sh" run_by="team-lead" checks="Build succeeds, tests pass, type checks" />
      <gate after="10 → 11" script="gate-review.sh" run_by="doc-validator" checks="Code review approved, adversarial PASS" />
      <gate after="10 → 11" script="gate-implementation-complete.sh" run_by="team-lead" checks="ALL implementation-plan phases complete in tracking JSON" />
      <gate after="11 → 11.5" script="gate-docs-drift.sh" run_by="team-lead" checks="Docs exist, no excessive TODOs" />
    </step>
    <step n="2" name="Execution">`bash ${CLAUDE_PLUGIN_ROOT}/scripts/gates/<gate-name>.sh <spec-dir>`</step>
    <step n="3" name="Failure Handling">Gate fails → report which checks failed → spawn appropriate agent to fix → re-run gate → proceed only on PASS (exit 0).</step>
  </process>

  <process name="Document Naming Pre-Computation">
    Team Lead pre-computes exact filenames BEFORE spawning agents. Agents receive concrete names (e.g., `03-research-report.md`), never `[doc-index]` placeholders.

    <step n="1">List spec directory, find highest existing `[XX]` prefix</step>
    <step n="2">Next index = max + 1 (zero-padded to 2 digits)</step>
    <step n="3">For multi-doc stages, pre-allocate consecutive indices</step>
    <step n="4">Pass EXACT filenames to agents via `OUTPUT FILENAME` in spawn prompts</step>
    <step n="5">Doc-validator receives same filenames and verifies (not renames)</step>
  </process>

  <process name="Worktree Enforcement (PRE-STAGE GATE)">
    At the START of every stage (Stage 3 onwards), before ANY action, run: `pwd | grep -q '\.worktree/'`

    If check fails: ABORT immediately. Do not proceed, do not spawn agents, do not read/write files. Print error: "WORKTREE VIOLATION: pwd is not inside .worktree/. Either run Stage 2 to create a worktree, or cd to the existing worktree (cd .worktree/[spec-name])."

    This applies to ALL stages ≥3, not just agent spawning. File reads, greps, builds, commits — everything must happen inside the worktree. Wrong pwd means wrong relative paths for gate scripts, specs, and agent work.
  </process>

  <process name="Domain-Aware Agent Routing">
    For Stage 9, spawn domain specialists directly instead of dev-executor:
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

  <process name="Spec Iteration Loop (Stage 7/8)">
    <step n="1" name="Trigger">Stage 8 spec-reviewer reports issues or gate-spec-review.sh fails.</step>
    <step n="2" name="STOP">FREEZE — Do NOT open any spec file with Edit or Write. The Team Lead's ONLY action is to follow steps 3-5.</step>
    <step n="3" name="Spawn Fix">Team Lead spawns spec-writer + doc-validator (parallel) with reviewer findings as input. Include exact quotes from the reviewer's findings in the prompt.</step>
    <step n="4" name="Re-review">After spec-writer completes, spawn spec-reviewer + doc-validator (parallel) again.</step>
    <step n="5" name="Exit Criteria">Loop exits when: spec-reviewer approves AND gate-spec-review.sh passes. Max 3 iterations. After 3: escalate to user with findings summary.</step>
  </process>

  <process name="Implementation Completeness Loop (Stage 9/10)">
    <purpose>Ensures ALL phases defined in the implementation-plan are implemented before proceeding to Stage 11. Even if the plan has only one phase, this loop verifies completion.</purpose>

    <step n="1" name="Initialize">At Stage 9 entry, Team Lead reads implementation-plan.md and task-list.md. Identify total number of implementation phases (N). Set currentPhase = 1. Update workflow tracking JSON: `implementationPhases[].status = "pending"` for all phases.</step>
    <step n="2" name="Scope Current Phase">Extract tasks belonging to the current phase from implementation-plan. Include only this phase's scope in the specialist spawn prompt. Update tracking: `implementationPhases[currentPhase].status = "in_progress"`.</step>
    <step n="3" name="Execute">Spawn domain specialist(s) + qa-agent (parallel) scoped to current phase tasks. Specialist MUST produce/update `*-implementation-summary.md` documenting changes, decisions, challenges. Run gate-build.sh after completion.</step>
    <step n="4" name="Review">Spawn code-reviewer + adversarial-reviewer + doc-validators (parallel). If review fails → follow Implementation Iteration Loop (fix loop). If review passes → continue.</step>
    <step n="5" name="Mark Complete">Update tracking: `implementationPhases[currentPhase].status = "complete"`. Increment currentPhase.</step>
    <step n="6" name="Completeness Check">
      If currentPhase > N (all phases done) → proceed to Stage 11.
      If currentPhase ≤ N (more phases remain) → go to step 2.
      CRITICAL: Do NOT proceed to Stage 11 until ALL implementation phases are complete.
    </step>

    <enforcement>
      Before transitioning from Stage 10 to Stage 11, Team Lead MUST verify:
      1. Read implementation-plan.md — count total phases
      2. Read workflow tracking JSON — verify ALL `implementationPhases[].status == "complete"`
      3. If ANY phase has status "pending" or "in_progress" → BLOCK transition, loop back to step 2
      This check is NON-NEGOTIABLE. Partial implementation is a CRITICAL violation.
    </enforcement>
  </process>

  <process name="Implementation Iteration Loop (Stage 9/10 Fix Loop)">
    <step n="1" name="Trigger">Stage 10 code-reviewer verdict is not "Approved" or adversarial-reviewer returns REJECT.</step>
    <step n="2" name="STOP">FREEZE — Do NOT open any file with Edit or Write. Do NOT run any fix command in Bash. The Team Lead's ONLY action is to follow steps 3-7.</step>
    <step n="3" name="Extract">Read the review findings from code-review and adversarial-review reports. List every finding with: file path, line number, severity, description.</step>
    <step n="4" name="Compose Prompt">Write a sub-agent prompt that includes: (a) exact file paths and line numbers from review, (b) the specific finding and why it failed, (c) the expected fix or acceptance criteria. Do NOT paraphrase — quote the reviewer's words.</step>
    <step n="5" name="Spawn Fix">Spawn domain specialist(s) + qa-agent (parallel) with the composed prompt. This is the ONLY way to fix code — Team Lead never edits directly.</step>
    <step n="6" name="Wait and Verify">Wait for all spawned agents to complete. Run gate-build.sh to verify build and tests pass.</step>
    <step n="7" name="Re-review">Spawn code-reviewer + adversarial-reviewer + doc-validators (parallel) again.</step>
    <step n="8" name="Exit Criteria">Loop exits when: code-reviewer returns "Approved" (zero findings of any severity) AND adversarial-reviewer returns PASS. No partial approvals allowed — ALL findings must be resolved. Max 3 iterations per phase. After 3: escalate to user with review findings.</step>
  </process>

  <process name="Research Deep-Dive Loop (Stage 4.5)">
    <step n="1" name="Trigger">Stage 4 research report contains an ISSUES, FLAWS, AMBIGUITIES, or CONCERNS section listing unresolved items.</step>
    <step n="2" name="Extract">Team Lead reads Stage 4 report, extracts each flagged issue with: topic, description, why it's unclear, what specifically needs deeper investigation.</step>
    <step n="3" name="Spawn Deep Research">Spawn research-agent in deep-research mode. Prompt MUST include: (a) the specific issues extracted from Stage 4, (b) what is already known vs what remains unclear, (c) instruction to investigate root causes, resolution paths, and alternative approaches for each issue.</step>
    <step n="4" name="Review Output">Team Lead reads the deep-research report. Check: are all flagged issues now clearly understood? Are there new issues or ambiguities surfaced?</step>
    <step n="5" name="Loop Decision">If remaining unclear items or new ambiguities found → extract them and go to step 3 (next iteration). If all issues are clearly understood → proceed to Stage 5/6.</step>
    <step n="6" name="Exit Criteria">Loop exits when: ALL issues have clear resolution paths with sufficient evidence. Max 3 iterations. After 3: present remaining ambiguities to user for decision.</step>
    <step n="7" name="Document Naming">Each iteration produces a separate document: `[XX]-deep-research-report-N.md` where N is the iteration number (1, 2, 3). Pre-compute filenames before spawning.</step>
  </process>
</processes>

<criteria name="Success">
  <criterion name="Outcome">Feature/fix works correctly. All tests pass with new coverage. Code review resolves all Critical/High/Medium to zero. BDD scenario coverage 100%. Documentation updated. Handoff document generated.</criterion>
  <criterion name="Efficiency">Stage iteration loops less than 3. ALL implementation-plan phases completed. Teammates terminated immediately after completion. Team Lead never performs agent work directly.</criterion>
  <criterion name="Style">Git worktree with matching branch name. Spec directory structure followed. Workflow tracking JSON maintained. Commit messages follow conventions. All work inside worktree.</criterion>
</criteria>

<constraints>
  <constraint name="Worktree-Only Modifications">NEVER modify files in the main repo. ALL file operations MUST happen inside the worktree. Only exception: Stage 2 scanning main repo's specification/ for next index (read-only). Stage 13 merges to main.</constraint>
  <constraint name="Worktree Paths in Spawn Prompts">ALL paths passed to agents MUST be worktree-relative. Verify every path contains `.worktree/` before spawning. Wrong paths corrupt the main branch.</constraint>
  <constraint name="Delegation Mode">Team Lead spawns teammates for ALL work. Never implements directly. No exceptions for "small fixes" or "one-line changes".</constraint>
  <constraint name="Iteration Rules">Stage 7/8: follow Spec Iteration Loop. Stage 9/10: follow Implementation Completeness Loop + Implementation Iteration Loop. Both: max 3 iterations, spawn sub-agents for fixes, escalate after 3.</constraint>
  <constraint name="Implementation Completeness">Do NOT proceed from Stage 10 to Stage 11 until ALL phases in the implementation-plan are implemented and reviewed. Partial implementation is a CRITICAL violation.</constraint>
  <constraint name="Version Bump">Every modification to super-dev-plugin files requires patch version bump in plugin.json and marketplace.json.</constraint>
  <constraint name="Stage 1+2 Gate">Stage 1 and 2 MUST complete before ANY exploration, code reading, grep, glob, research, or agent spawning.</constraint>
  <constraint name="No Early Code Analysis">Do NOT read code or explore the codebase before Stage 6. Stages 1-5 work from requirements and research only.</constraint>
  <constraint name="Parallel Doc-validator Rule">Stages 3, 3.5, 7, 8, 10: ALWAYS spawn doc-validator alongside writer/reviewer.</constraint>
  <constraint name="MANDATORY Stage 10-13 Transition">Execute in strict order: Stage 11 → gate-docs-drift.sh → Stage 11.5 → Stage 12 → Stage 12.5 → Stage 13. Skipping is a CRITICAL violation.</constraint>
  <constraint name="Teammate Termination">Terminate teammates immediately after their work completes. Exception: In Stage 9/10, wait for ALL parallel agents to complete first.</constraint>
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
