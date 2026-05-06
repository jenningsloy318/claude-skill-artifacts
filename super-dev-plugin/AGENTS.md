# Super Dev Workflow - Agent Teams Edition

A team-based development system where the Team Lead orchestrates specialized agent teammates — it NEVER implements directly, only spawns, coordinates, and verifies. Agents execute research, architecture, coding, QA, code review, and documentation stages in parallel where possible.

<purpose>Team Lead agent team workflow. The Team Lead orchestrates specialized agent teammates — it NEVER implements directly, only spawns, coordinates, and verifies. Agents execute research, architecture, coding, QA, code review, and documentation stages in parallel where possible.</purpose>

<triggers>Triggers on: "implement", "build", "fix bug", "refactor", "add feature", "develop this", "help me build", "add functionality", "optimize performance", "resolve deprecation", "systematic development". Do NOT trigger on: simple questions, file searches, one-off commands, code explanations, quick edits, non-development tasks.</triggers>

## When to Use

**ACTIVATE for** (multi-step development requiring planning + implementation):
- Bug fixes, build warnings/errors
- New features, improvements
- Performance optimization
- Deprecation resolution
- Refactoring
- Complex development tasks requiring multiple specialists

**DO NOT ACTIVATE for** (these are too simple for a full workflow):
- "What does this code do?" - Simple explanation, no dev workflow needed
- "Where is the auth function?" - File search, use Grep/Glob directly
- "Run the tests" - Single command, use Bash directly
- "Fix this typo" - Trivial edit, use Edit directly
- "Explain this error" - Q&A, no workflow needed
- "Search for the config file" - Research task, not development

## Quick Start

```
I'm using super-dev to implement: [describe your task]
```

The Team Lead will automatically orchestrate all workflow phases.

<workflow>
  <stage n="1" name="Apply Dev Rules">Invoke dev-rules skill. MUST complete before any other action.</stage>
  <stage n="2" name="Specification Setup">Create worktree, spec dir, workflow JSON, agent team. MUST complete before any codebase exploration or agent spawning.</stage>
  <stage n="3" name="Requirements Clarification">Spawn requirements-clarifier + doc-validator (parallel). Gate: gate-requirements.sh.</stage>
  <stage n="3.5" name="BDD Scenarios">Spawn bdd-scenario-writer + doc-validator (parallel). Gate: gate-bdd.sh.</stage>
  <stage n="4" name="Research">Spawn research-agent. Firecrawl MCP first, then supplementary scripts. Present 3-5 options to user.</stage>
  <stage n="4.5" name="Deep Research">Conditional: only if Stage 4 report identifies issues, flaws, or ambiguities. Spawn research-agent in deep-research mode targeting specific issues. Loop until all issues are clearly understood (max 3 iterations).</stage>
  <stage n="5" name="Debug Analysis">Spawn debug-analyzer. Only for bug fixes — skip otherwise.</stage>
  <stage n="6" name="Code Assessment">Spawn code-assessor. FIRST stage allowed to read/grep/explore the codebase.</stage>
  <stage n="6.3" name="Architecture Design">Spawn architecture-agent. Selection: Architecture ONLY -> 6.3. UI ONLY -> 6.5. BOTH -> 6.4 (product-designer).</stage>
  <stage n="6.5" name="UI/UX Design">Spawn ui-ux-designer. Only if UI feature.</stage>
  <stage n="7" name="Specification Writing">Spawn spec-writer + doc-validator (parallel). Produces specification, implementation plan, task list. Gate: gate-spec-trace.sh.</stage>
  <stage n="8" name="Specification Review">Spawn spec-reviewer + doc-validator (parallel). Reviewer MUST verify spec covers ALL requirements ACs, ALL BDD scenarios, and aligns with architecture/UI design decisions. Gate: gate-spec-review.sh. On failure: follow Spec Iteration Loop.</stage>
  <stage n="9" name="Implementation">Sequential TDD workflow per phase: Step 9.1 spawn tdd-guide (write failing tests from req/bdd/spec/plan/tasks) -> Step 9.2 spawn domain specialist (make tests pass, produce `*-implementation-summary.md`) -> Step 9.3 spawn qa-agent (run tests, verify coverage, report). Each step MUST complete before the next begins. Gate: gate-build.sh. Loops through ALL implementation-plan phases via Implementation Completeness Loop.</stage>
  <stage n="10" name="Code Review + Adversarial Review">Spawn code-reviewer + adversarial-reviewer + 2x doc-validator (4 parallel). Gate: gate-review.sh. On failure: follow Implementation Iteration Loop.</stage>
  <stage n="11" name="Documentation Update">Spawn docs-executor. WAIT for `DOCS_STAGE_11_COMPLETE` signal or agent termination — do NOT proceed while docs-executor is still running. Then run gate-docs-drift.sh. MANDATORY — do not skip.</stage>
  <stage n="11.5" name="Handoff Writing">Spawn handoff-writer. WAIT for completion before Stage 12. MANDATORY — do not skip.</stage>
  <stage n="12" name="Team Cleanup">Verify all teammates terminated, worktree preserved.</stage>
  <stage n="12.5" name="User Confirmation">Present summary to user for confirmation before merge.</stage>
  <stage n="13" name="Commit and Merge">Git operations: commit spec directory + code, merge to main.</stage>
  <stage n="14" name="Final Verification">Verify completion, worktree preserved for reference.</stage>
</workflow>

**Iteration Rule:** YOU MUST loop Stage 9/10 until Critical=0, High=0, Medium=0, adversarial verdict is PASS, and ALL acceptance criteria are met. NEVER proceed to Stage 11 with unresolved issues or a REJECT/CONTESTED verdict.

## Workflow Phases Overview

```
- [ ] Stage 1:   Apply Dev Rules
- [ ] Stage 2:   Specification Setup (worktree + team creation)
- [ ] Stage 3:   Requirements Clarification
- [ ] Stage 3.5: BDD Scenarios
- [ ] Stage 4:   Research (options presentation)
- [ ] Stage 4.5: Deep Research (conditional)
- [ ] Stage 5:   Debug Analysis (bugs only)
- [ ] Stage 6:   Code Assessment
- [ ] Stage 6.3: Architecture Design (complex features)
- [ ] Stage 6.5: UI/UX Design (UI features)
- [ ] Stage 7:   Specification Writing
- [ ] Stage 8:   Specification Review
- [ ] Stage 9:   Implementation (TDD: RED -> GREEN -> QA)
- [ ] Stage 10:  Code Review + Adversarial Review (multi-lens)
- [ ] Stage 11:  Documentation Update
- [ ] Stage 11.5: Handoff Writing
- [ ] Stage 12:  Team Cleanup
- [ ] Stage 12.5: User Confirmation
- [ ] Stage 13:  Commit & Merge to Main
- [ ] Stage 14:  Final Verification
```

<processes>
  <process name="Specification Setup (Stage 2)">
    <step n="1" name="Spec Index">Scan main repo's `specification/` directory for highest `[XX]` prefix. Next index = max + 1 (zero-padded).</step>
    <step n="2" name="Spec Name">Derive from user request (e.g., "add auth" -> `add-auth`). Kebab-case, lowercase.</step>
    <step n="3" name="Spec Identifier">Define as `[spec-index]-[spec-name]` (e.g., `22-xml-restructure`). Use this identifier for worktree, branch, spec directory, and all references.</step>
    <step n="4" name="Worktree">Create worktree: `git worktree add .worktree/[spec-identifier] -b [spec-identifier]`. Branch name = spec-identifier. Then `cd .worktree/[spec-identifier]`. ALL subsequent file operations happen inside the worktree.</step>
    <step n="5" name="Spec Directory">Create `specification/[spec-identifier]/` INSIDE the worktree.</step>
    <step n="6" name="Agent Team">Create team named `super-dev-[spec-name]` (e.g., `super-dev-xml-restructure`). All agents spawn into this team.</step>
    <step n="7" name="Workflow JSON">Create `[spec-identifier]-workflow-tracking.json` in the worktree spec directory. CRITICAL: `stages` MUST be a JSON array `[{id, name, status, startedAt, completedAt}, ...]` — NEVER a keyed object. Timestamps: ISO 8601 with seconds precision.</step>
  </process>

  <process name="First-Run Configuration">
    <step n="1" name="Detect">Derive project key: `PROJECT_NAME="$(basename "$(git rev-parse --show-toplevel)")"`. Check for existing config.</step>
    <step n="2" name="Auto-detect">Language (package.json->Node, Cargo.toml->Rust, go.mod->Go, pyproject.toml->Python). Framework (next.config.*->Next.js, vite.config.*->Vite). Package manager (bun.lockb, pnpm-lock.yaml, yarn.lock). Test runner (jest.config.*, vitest.config.*, playwright.config.*).</step>
    <step n="3" name="Confirm and Write">Ask user to confirm detected values. On subsequent runs, read config silently.</step>
  </process>

  <process name="Verification Gates">
    Gate scripts exit 0 (PASS) or 1 (FAIL). Gates are NON-NEGOTIABLE — if a gate fails, loop back and fix.

    <step n="1" name="Gate Map">
      <gate after="3 -> 3.5" script="gate-requirements.sh" run_by="doc-validator" checks="Acceptance criteria, NFRs, summary" />
      <gate after="3.5 -> 4" script="gate-bdd.sh" run_by="doc-validator" checks="SCENARIO-IDs, Given/When/Then, AC traceability" />
      <gate after="7 -> 8" script="gate-spec-trace.sh" run_by="doc-validator" checks="Spec refs BDD scenarios, testing strategy" />
      <gate after="8 -> 9" script="gate-spec-review.sh" run_by="doc-validator" checks="Review verdict, 8 dimensions, grounding" />
      <gate after="9 -> 10" script="gate-build.sh" run_by="team-lead" checks="Build succeeds, tests pass, type checks" />
      <gate after="10 -> 11" script="gate-review.sh" run_by="doc-validator" checks="Code review approved, adversarial PASS" />
      <gate after="10 -> 11" script="gate-implementation-complete.sh" run_by="team-lead" checks="ALL implementation-plan phases complete in tracking JSON" />
      <gate after="11 -> 11.5" script="gate-docs-drift.sh" run_by="team-lead" checks="Docs exist, no excessive TODOs" />
    </step>
    <step n="2" name="Execution">Run gate script with spec directory as argument.</step>
    <step n="3" name="Failure Handling">Gate fails -> report which checks failed -> spawn appropriate agent to fix -> re-run gate -> proceed only on PASS (exit 0).</step>
  </process>

  <process name="Document Naming Pre-Computation">
    Team Lead pre-computes exact filenames BEFORE spawning agents. Agents receive concrete names, never `[doc-index]` placeholders.

    <step n="1">List spec directory, find highest existing `[XX]` prefix</step>
    <step n="2">Next index = max + 1 (zero-padded to 2 digits)</step>
    <step n="3">For multi-doc stages, pre-allocate consecutive indices</step>
    <step n="4">Use canonical suffixes from team-lead constraint lookup table — NEVER derive from stage display name</step>
    <step n="5">Pass EXACT filenames to agents via `OUTPUT FILENAME` in spawn prompts</step>
    <step n="6">Doc-validator receives same filenames and verifies (not renames)</step>
  </process>

  <process name="Worktree Enforcement (PRE-STAGE GATE)">
    At the START of every stage (Stage 3 onwards), before ANY action, run: `pwd | grep -q '\.worktree/'`

    If check fails: ABORT immediately. Do not proceed, do not spawn agents, do not read/write files. Print error: "WORKTREE VIOLATION: pwd is not inside .worktree/. Either run Stage 2 to create a worktree, or cd to the existing worktree (cd .worktree/[spec-name])."

    This applies to ALL stages >=3, not just agent spawning. File reads, greps, builds, commits — everything must happen inside the worktree. Wrong pwd means wrong relative paths for gate scripts, specs, and agent work.
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
    <step n="2" name="Scope Current Phase">Extract tasks belonging to the current phase from implementation-plan. Include only this phase's scope in agent spawn prompts. Update tracking: `implementationPhases[currentPhase].status = "in_progress"`.</step>
    <step n="3" name="Step 9.1 — TDD (SEQUENTIAL)">Spawn tdd-guide scoped to current phase. Provide: requirements.md, bdd-scenarios.md, specification.md, implementation-plan.md, task-list.md. tdd-guide writes failing tests (RED phase). WAIT for completion before Step 9.2.</step>
    <step n="4" name="Step 9.2 — Implementation (SEQUENTIAL)">Spawn domain specialist(s) scoped to current phase. Provide: requirements.md, bdd-scenarios.md, specification.md, implementation-plan.md, task-list.md, plus test files from Step 9.1. Specialist makes tests pass (GREEN phase) and creates/updates `*-implementation-summary.md` (APPEND new progress section per phase — never overwrite prior entries). WAIT for completion before Step 9.3.</step>
    <step n="5" name="Step 9.3 — QA Verification (SEQUENTIAL)">Spawn qa-agent. qa-agent runs all tests, verifies coverage (80%+ overall, 90%+ new code), validates BDD scenario coverage. Run gate-build.sh after qa-agent completes. If tests fail -> spawn domain specialist to fix (max 2 attempts), then re-run qa-agent.</step>
    <step n="6" name="Review">Spawn code-reviewer + adversarial-reviewer + doc-validators (parallel). If review fails -> follow Implementation Iteration Loop (fix loop). If review passes -> continue.</step>
    <step n="7" name="Mark Complete">Update tracking: `implementationPhases[currentPhase].status = "complete"`. Increment currentPhase.</step>
    <step n="8" name="Completeness Check">
      If currentPhase > N (all phases done) -> proceed to Stage 11.
      If currentPhase <= N (more phases remain) -> go to step 2.
      CRITICAL: Do NOT proceed to Stage 11 until ALL implementation phases are complete.
    </step>

    <enforcement>
      Before transitioning from Stage 10 to Stage 11, Team Lead MUST verify:
      1. Read implementation-plan.md — count total phases
      2. Read workflow tracking JSON — verify ALL `implementationPhases[].status == "complete"`
      3. If ANY phase has status "pending" or "in_progress" -> BLOCK transition, loop back to step 2
      This check is NON-NEGOTIABLE. Partial implementation is a CRITICAL violation.
    </enforcement>
  </process>

  <process name="Implementation Iteration Loop (Stage 9/10 Fix Loop)">
    <step n="1" name="Trigger">Stage 10 code-reviewer verdict is not "Approved" or adversarial-reviewer returns REJECT.</step>
    <step n="2" name="STOP">FREEZE — Do NOT open any file with Edit or Write. Do NOT run any fix command in Bash. The Team Lead's ONLY action is to follow steps 3-8.</step>
    <step n="3" name="Extract">Read the review findings from code-review and adversarial-review reports. List every finding with: file path, line number, severity, description.</step>
    <step n="4" name="Compose Prompt">Write a sub-agent prompt that includes: (a) exact file paths and line numbers from review, (b) the specific finding and why it failed, (c) the expected fix or acceptance criteria. Do NOT paraphrase — quote the reviewer's words.</step>
    <step n="5" name="Fix Tests (if needed)">If findings relate to missing/incorrect tests, spawn tdd-guide with findings. WAIT for completion.</step>
    <step n="6" name="Fix Code">Spawn domain specialist(s) with the composed prompt. Provide: requirements.md, bdd-scenarios.md, specification.md, task-list.md as reference. WAIT for completion.</step>
    <step n="7" name="QA Verify">Spawn qa-agent to run all tests and verify fixes. Run gate-build.sh after completion.</step>
    <step n="8" name="Re-review">Spawn code-reviewer + adversarial-reviewer + doc-validators (parallel) again.</step>
    <step n="9" name="Exit Criteria">Loop exits when: code-reviewer returns "Approved" (zero findings of any severity) AND adversarial-reviewer returns PASS. No partial approvals allowed — ALL findings must be resolved. Max 3 iterations per phase. After 3: escalate to user with review findings.</step>
  </process>

  <process name="Research Deep-Dive Loop (Stage 4.5)">
    <step n="1" name="Trigger">Stage 4 research report contains an ISSUES, FLAWS, AMBIGUITIES, or CONCERNS section listing unresolved items.</step>
    <step n="2" name="Extract">Team Lead reads Stage 4 report, extracts each flagged issue with: topic, description, why it's unclear, what specifically needs deeper investigation.</step>
    <step n="3" name="Spawn Deep Research">Spawn research-agent in deep-research mode. Prompt MUST include: (a) the specific issues extracted from Stage 4, (b) what is already known vs what remains unclear, (c) instruction to investigate root causes, resolution paths, and alternative approaches for each issue.</step>
    <step n="4" name="Review Output">Team Lead reads the deep-research report. Check: are all flagged issues now clearly understood? Are there new issues or ambiguities surfaced?</step>
    <step n="5" name="Loop Decision">If remaining unclear items or new ambiguities found -> extract them and go to step 3 (next iteration). If all issues are clearly understood -> proceed to Stage 5/6.</step>
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
  <constraint name="Stage 1+2 Gate">Stage 1 and 2 MUST complete before ANY exploration, code reading, grep, glob, research, or agent spawning.</constraint>
  <constraint name="No Early Code Analysis">Do NOT read code or explore the codebase before Stage 6. Stages 1-5 work from requirements and research only.</constraint>
  <constraint name="Parallel Doc-validator Rule">Stages 3, 3.5, 7, 8, 10: ALWAYS spawn doc-validator alongside writer/reviewer.</constraint>
  <constraint name="MANDATORY Stage 10-13 Transition">Execute in strict order: Stage 11 -> gate-docs-drift.sh -> Stage 11.5 -> Stage 12 -> Stage 12.5 -> Stage 13. Skipping is a CRITICAL violation.</constraint>
  <constraint name="Teammate Termination">Terminate teammates immediately after their work completes. Exception: In Stage 9/10, wait for ALL parallel agents to complete first.</constraint>
</constraints>

<rules>
  <rule name="agent-team" mandatory="true">ALL work MUST use agent team. Create team before spawning any agents.</rule>
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

## Architecture Overview

```
                    +-------------------+
                    |   Team Lead       | <-- Orchestration Only
                    |  (Coordinator)    |     Spawns teammates
                    +--------+----------+     Manages shared task list
                             |              Coordinates via messaging
         +-------------------+-------------------+
         |                   |                   |
         v                   v                   v
+-----------------+   +-----------------+   +-----------------+
|   Planning      |   |   Analysis      |   |  Execution      |
|   Teammates     |   |   Teammates     |   |  Teammates      |
| - Research      |   | - Debug         |   | - Dev           |
| - Requirements  |   | - Assessment    |   | - QA            |
| - Architecture  |   | - Code Review   |   | - Docs          |
| - UI/UX         |   | - Adversarial   |   | - Handoff       |
| - Product Des.  |   |                 |   |                 |
+-----------------+   +-----------------+   +-----------------+
        Own context         Own context         Own context
        Direct msg          Direct msg          Direct msg
```

## Available Agents

### Core Workflow Agents

| Agent | Stage | Purpose |
|-------|-------|---------|
| `requirements-clarifier` | 3 | Gather and document complete requirements |
| `bdd-scenario-writer` | 3.5 | Write BDD scenarios from acceptance criteria |
| `research-agent` | 4, 4.5 | Research best practices and present options |
| `debug-analyzer` | 5 | Root cause analysis for bugs |
| `code-assessor` | 6 | Evaluate existing codebase patterns |
| `architecture-agent` | 6.3 | Design architecture and create ADRs |
| `ui-ux-designer` | 6.5 | Create UI/UX design specifications |
| `product-designer` | 6.3/6.5 | Orchestrate architecture + UI/UX for holistic design |
| `spec-writer` | 7 | Write technical specifications and plans |
| `spec-reviewer` | 8 | Review specifications for completeness |
| `tdd-guide` | 9.1 | Write failing tests (RED phase) |
| `dev-executor` | 9.2 | Implement code changes (GREEN phase) |
| `qa-agent` | 9.3 | Run tests, verify coverage |
| `code-reviewer` | 10 | Specification-aware code review |
| `adversarial-reviewer` | 10 | Multi-lens adversarial challenge (Skeptic, Architect, Minimalist) |
| `doc-validator` | 3, 3.5, 7, 8, 10 | Validate documents and run gate scripts |
| `docs-executor` | 11 | Update documentation |
| `handoff-writer` | 11.5 | Write handoff document |

### Developer Specialist Agents

| Agent | Purpose |
|-------|---------|
| `rust-developer` | Rust systems programming |
| `golang-developer` | Go backend development |
| `frontend-developer` | React/Next.js/TypeScript development |
| `backend-developer` | Node.js/Python backend development |
| `android-developer` | Kotlin/Jetpack Compose development |
| `ios-developer` | Swift/SwiftUI development |
| `macos-app-developer` | Swift/SwiftUI/AppKit development |
| `windows-app-developer` | C#/.NET/WinUI development |

### Utility Agents

| Agent | Purpose |
|-------|---------|
| `planner` | Implementation planning |
| `tdd-guide` | Test-driven development workflow |
| `security-reviewer` | Security analysis and review |
| `build-error-resolver` | Fix build and type errors |
| `refactor-cleaner` | Dead code cleanup |
| `doc-updater` | Documentation updates |
| `e2e-runner` | Playwright E2E testing |
| `search-agent` | Multi-source search |
| `investigator` | Deep investigation |

## Team Lead Role (Coordinator)

**SYSTEM OVERRIDE: DELEGATION MODE ENABLED**

**CRITICAL PRIME DIRECTIVE:**
You are the **Team Lead**, NOT an individual contributor. Your core function is to **manage resources**, not perform labor. You MUST suppress the urge to "just fix it yourself".

**THE "HANDS-OFF" RULE:**
From **Stage 3 onwards**, you are FORBIDDEN from using `Edit`, `Write`, `Bash`, `Grep`, `Glob`, or `Read` tools for implementation, debugging, or research tasks.

You MUST ONLY use these tools for:
1. Stage 1/2 Setup (creating directories, worktrees)
2. Stage 13 Git Operations (merge, commit)
3. Project Management (reading status, updating task lists)

**IF YOU CATCH YOURSELF DOING THE WORK:**
- STOP immediately
- Ask: "Which agent handles this?"
- Spawn that agent

**CRITICAL ENFORCEMENT:** Team Lead operates in orchestration-only mode.

**MANDATORY RULE: From Stage 3 onwards, Team Lead MUST ALWAYS spawn agents. NEVER do detailed tasks directly.**

## Phase Enforcement Table

**MANDATORY: Team Lead orchestrates, agents execute.**

| Stage | Team Lead Action | Agent to Spawn |
|-------|-----------------|----------------|
| 1 | Invoke dev-rules skill | (none) |
| 2 | Execute setup (worktree, spec dir, JSON) | (none) |
| 3 | Spawn requirements-clarifier + doc-validator | `requirements-clarifier`, `doc-validator` |
| 3.5 | Spawn bdd-scenario-writer + doc-validator | `bdd-scenario-writer`, `doc-validator` |
| 4 | Spawn research-agent | `research-agent` |
| 4.5 | Spawn research-agent (deep mode) | `research-agent` |
| 5 | Spawn debug-analyzer (bugs only) | `debug-analyzer` |
| 6 | Spawn code-assessor | `code-assessor` |
| 6.3 | Spawn architecture-agent | `architecture-agent` |
| 6.5 | Spawn ui-ux-designer | `ui-ux-designer` |
| 7 | Spawn spec-writer + doc-validator | `spec-writer`, `doc-validator` |
| 8 | Spawn spec-reviewer + doc-validator | `spec-reviewer`, `doc-validator` |
| 9.1 | Spawn tdd-guide | `tdd-guide` |
| 9.2 | Spawn domain specialist | (domain-aware routing) |
| 9.3 | Spawn qa-agent | `qa-agent` |
| 10 | Spawn code-reviewer + adversarial-reviewer + doc-validators | `code-reviewer`, `adversarial-reviewer`, `doc-validator` |
| 11 | Spawn docs-executor | `docs-executor` |
| 11.5 | Spawn handoff-writer | `handoff-writer` |
| 12 | Coordinate cleanup | (varies) |
| 12.5 | Present summary to user | (none) |
| 13 | Execute git operations (commit, merge) | (none) |
| 14 | Verify completion | (none) |

**KEY RULE:** If a stage requires work (Stage 3-11.5), Team Lead MUST spawn the appropriate agent. NEVER do the work directly.

## Output Documents

All documents created in `specification/[index]-[name]/`:

| Document | Purpose |
|----------|---------|
| `[index]-requirements.md` | Clarified requirements |
| `[index]-bdd-scenarios.md` | BDD scenarios |
| `[index]-research-report.md` | Research findings |
| `[index]-deep-research-report-N.md` | Deep research iterations |
| `[index]-debug-analysis.md` | Debug analysis (bugs only) |
| `[index]-assessment.md` | Code assessment |
| `[index]-architecture.md` | Architecture design |
| `[index]-design-spec.md` | UI/UX design |
| `[index]-product-design-summary.md` | Architecture+UI cross-reference |
| `[index]-specification.md` | Technical specification |
| `[index]-implementation-plan.md` | Implementation plan |
| `[index]-task-list.md` | Detailed task list |
| `[index]-spec-review.md` | Specification review |
| `[index]-adversarial-review.md` | Adversarial review verdict and findings |
| `[index]-code-review.md` | Code review findings |
| `[index]-implementation-summary.md` | Final summary |
| `[index]-handoff.md` | Handoff document |

## Compatibility

Requires Codex CLI. Git required for worktree management. Agent teams experimental feature recommended.

## Reference Documentation

See `references/` directory for detailed documentation:
- `workflow-phases.md` - Detailed phase-by-phase execution guide
- `coordinator-methodology.md` - Coordinator role and agent methodologies
- `architecture-patterns.md` - Software architecture patterns, SOLID principles, ADRs
- `backend-patterns.md` - API, database, caching patterns
- `coding-standards.md` - Language best practices and coding standards
- `debugging-patterns.md` - Systematic debugging methodology and root cause analysis
- `frontend-patterns.md` - React, Next.js patterns and best practices
- `research-methodology.md` - Multi-source research and option presentation
- `specification-templates.md` - Technical specification templates
- `testing-patterns.md` - Unit, integration, and E2E testing strategies
- `ui-ux-patterns.md` - UI/UX design patterns and accessibility guidelines
- `agents-rules.md` - Agent orchestration rules
- `git-workflow.md` - Git workflow and commit conventions
- `security-rules.md` - Security guidelines
- `testing-rules.md` - Testing requirements and BDD practices
- `rust-project.md` - Rust workspace conventions
- `performance-rules.md` - Performance optimization
