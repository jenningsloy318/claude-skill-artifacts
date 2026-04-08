---
name: dev-rules
description: Core development rules and philosophy. Use at the start of any development task to establish coding standards, git practices, and quality guidelines. Triggers on any implementation, fix, or refactoring task.
---

# Development Rules and Philosophy

These rules define coding standards and practices that MUST be followed for all development work.

## Session Continuity: Read Previous Handoff

At the start of every super-dev session, check for context from the previous completed spec.

### Handoff Discovery Process

1. **Scan spec directories**: List all directories in `specification/` and extract the numeric prefix (e.g., `20` from `20-bdd-integration`)
2. **Sort descending**: Order by numeric prefix, highest first
3. **Find the most recent handoff**: Starting from highest-index directory, check if `[doc-index]-handoff.md` exists
   - If found: Read the handoff file — proceed to step 4
   - If not found: Try the next-highest directory
   - If no handoff found in any directory: Skip silently — first run or all specs predate the handoff phase
4. **Present prior context**: Display a brief summary to the Team Lead:
   - What was done (section 2), key decisions (section 3), unfinished items (section 5), risks (section 7), recommended first steps

### Context Application

The handoff context informs:
- Phase 2 (Requirements): Awareness of prior decisions and constraints
- Phase 5 (Code Assessment): Knowledge of recently changed areas
- All phases: Avoidance of redundant work, awareness of known risks

## Figma MCP Integration Rules

When implementing designs from Figma:

1. Run `get_design_context` first → if truncated, use `get_metadata` then re-fetch specific nodes
2. Run `get_screenshot` for visual reference
3. Only then download assets and start implementation
4. Translate output into project conventions — reuse existing tokens, components, patterns
5. Validate 1:1 visual parity against Figma screenshot

## MCP Script Usage (MUST follow)

Use wrapper scripts via Bash instead of direct MCP tool calls. See `${CLAUDE_PLUGIN_ROOT}/scripts/README.md` for full command reference and examples.

**Available script groups:** Exa (web/code search), DeepWiki (repo docs), Context7 (library docs), GitHub (code/repo search)

**Exception:** `mcp__time-mcp__current_time` is allowed (no script available)

## Time MCP Rules (MUST follow)

- In every prompt, add the current date and time as extra context

## Codebase Search with ast-grep (MUST follow)

When searching the local codebase for structural code patterns (e.g., all `useState` hooks, deprecated API usage, refactoring patterns across files):
- **Prefer ast-grep** (AST-based pattern matching) using the **ast-grep skill**

## Git Rules (MUST follow)

- Never create GitHub Actions when creating new projects or updating code
- If GitHub Actions already exist, don't add to git cache, don't commit, don't push
- When committing, only commit files you edited - ignore files not created/edited by you in this session
- Don't use `git add -A` - use `git add file1 file2` (only files you edited/created/deleted)
- Before committing, **ALWAYS** generate proper commit messages

## Git Worktree Requirement (CRITICAL - MANDATORY)

**ALL development work MUST be done in a git worktree. This is NOT optional.**

Before ANY development work, verify you're in a worktree:
```bash
test -f .git && echo "In worktree" || test -d .git && echo "In main repo - MUST create worktree"
```

**If NOT in a worktree**, create one automatically (no confirmation required):
```bash
git worktree add .worktree/[spec-index]-[spec-name] -b [spec-index]-[spec-name]
cd .worktree/[spec-index]-[spec-name]
```

**Worktree naming**: `.worktree/[spec-index]-[spec-name]/` — branch name MUST match worktree name.

## Git Safety & Checkpoint Rules (CRITICAL)

1. **Stash before major operations**: `git stash push -m "checkpoint: [phase name]"` before new phases or risky changes
2. **Commit after every completed task**: Small, frequent, atomic commits — don't batch multiple tasks
3. **Verify before phase transitions**: `git status` must show no uncommitted changes between phases
4. **End-of-session cleanup**: All work committed or stashed — working tree clean

**Recovery**: `git stash list` → `git stash pop` | `git reflog` → `git checkout -- <file>`

## Documentation Update Rules (MUST follow)

### Spec Directory Indexing

All work should have a spec directory under `specification/` using pattern `[index]-[feature-name]` with incremental indexing. Reuse existing specs when related to current task.

### Keep Spec Documents Current (MANDATORY)

Documents within each spec directory use dynamic naming (`[XX]-[doc-type].md`):

1. **Task List (`[doc-index]-task-list.md`)**: Mark tasks complete immediately, add discovered tasks, never leave stale
2. **Implementation Summary (`[doc-index]-implementation-summary.md`)**: Update after each milestone — files changed, decisions made, challenges, deviations
3. **Specification (`[doc-index]-specification.md`)**: Update when implementation differs, mark with `[UPDATED: YYYY-MM-DD]`

### Rules
- **Commit docs WITH code**: Never commit code without updating related docs
- **Atomic doc updates**: Each task completion = task list update
- **Spec sync**: If code deviates from spec, update spec in same commit

## Development Philosophy

### Core Principles
- **First Principles Analysis**: For complex features and bug fixes, break down to fundamental truths and build up
- **Incremental Development**: Small commits, each must compile and pass tests
- **Learn from Existing Code**: Research and plan before implementing
- **Pragmatic over Dogmatic**: Adapt to project's actual situation
- **Clear Intent over Clever Code**: Choose simple, clear solutions
- Avoid over-engineering - keep code simple, easy to understand, practical
- Watch cyclomatic complexity - maximize code reuse
- Focus on modular design - use design patterns where appropriate
- Minimize changes - avoid modifying code in other modules
- Versioned API with clear, predictable hierarchy

### New Requirements Process
1. **Don't rush to code**: When user proposes new requirements, discuss the solution first
2. **Use ASCII diagrams**: When necessary, draw comparison diagrams for multiple solutions, let user choose
3. **Confirm before developing**: Only start development after user explicitly confirms the solution

### Bug/Error Reporting Requirements (MANDATORY)

When a user reports a bug, **ALWAYS** ask for reproduction steps before attempting to fix:
1. Steps to reproduce (exact sequence)
2. Expected vs actual behavior (paste error message)
3. Environment details (if relevant)

**Skip only if**: error visible in provided stack trace, comprehensive context already given, or obvious code error pointed to directly.

### Implementation Process
1. **Understand existing patterns**: Study 3 similar features/components in the codebase
2. **Identify common patterns**: Find project conventions and patterns
3. **Follow existing standards**: Use same libraries/tools, follow existing test patterns
4. **Implement in phases**: Break complex work into 3-5 phases

### Quality Standards
- Every commit must compile successfully
- Pass all existing tests
- Include tests for new functionality
- Follow project formatting/linting rules

### Refactoring Process
1. First analyze project according to Clean Code principles
2. Create an incremental refactoring checklist, sorted by priority (high to low)
3. Execute one by one, update todo status after completing each item
4. Each step must be confirmed by user before proceeding

### Decision Framework Priority
1. **Testability** - Is it easy to test?
2. **Readability** - Will it be understandable in 6 months?
3. **Consistency** - Does it match project patterns?
4. **Simplicity** - Is it the simplest viable solution?
5. **Reversibility** - How hard to modify later?

### Error Handling & When Stuck
- Stop after maximum 3 attempts
- Record failure reasons and specific error messages
- Research 2-3 alternative implementation approaches
- Question basic assumptions: Is it over-abstracted? Can it be decomposed?

## Gotchas

- **Running `git add -A`**: Stages everything including untracked files and build artifacts. Always use selective staging.
- **Forgetting git stash before major operations**: Context compaction can lose uncommitted work.
- **Working in main repo instead of worktree**: Breaks branch isolation, can corrupt main branch.
- **Not checking for existing specs**: Duplicate specs fragment documentation.
- **Skipping doc updates when committing**: Code and docs must be committed together.
- **Ignoring the 3-attempt limit**: Infinite retry loops waste tokens and rarely succeed.
- **Creating GitHub Actions accidentally**: Never create/modify `.github/workflows/` files.

## Using This Skill

Announce at the start of any development task:
"I'm applying the dev-rules skill to ensure we follow project standards and best practices."
