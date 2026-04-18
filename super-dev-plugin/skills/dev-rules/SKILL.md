---
name: dev-rules
description: Core development rules and philosophy for coding standards, git practices, and quality guidelines
---

<purpose>Define coding standards and practices that MUST be followed for all development work. Establish session continuity, git safety, documentation discipline, and development philosophy at the start of any task.</purpose>

<triggers>Triggers on any implementation, fix, or refactoring task</triggers>

<activation>Announce: "I'm applying the dev-rules skill to ensure we follow project standards and best practices."</activation>

<process name="Session Continuity">
  At session start, scan `specification/` directories (highest index first) for `[doc-index]-handoff.md`. If found, present prior context: what was done, key decisions, unfinished items, risks, recommended first steps. This informs requirements awareness, code assessment, and avoids redundant work.
</process>

<process name="Figma MCP Integration">
  1) `get_design_context` first (if truncated, `get_metadata` then re-fetch specific nodes). 2) `get_screenshot` for visual reference. 3) Only then download assets and implement. 4) Translate into project conventions — reuse existing tokens/components. 5) Validate 1:1 visual parity.
</process>

<constraints>
  <constraint name="MCP Scripts">Use wrapper scripts via Bash (Exa, DeepWiki, Context7, GitHub) per `${CLAUDE_PLUGIN_ROOT}/scripts/README.md`. Exception: `mcp__time-mcp__current_time` allowed directly.</constraint>
  <constraint name="Time MCP">Always add current date/time as context</constraint>
  <constraint name="ast-grep">Prefer AST-based pattern matching for structural code searches</constraint>
  <constraint name="Git Rules">Never create GitHub Actions. Don't `git add -A` — selective staging only. Only commit files you edited. Always generate proper commit messages.</constraint>
  <constraint name="Git Worktree (CRITICAL MANDATORY)">ALL development MUST be in a worktree. Verify with `test -f .git`. If not in worktree, create: `git worktree add .worktree/[spec-index]-[spec-name]`. Branch name MUST match worktree name.</constraint>
  <constraint name="Git Safety">Stash before major operations. Commit after every completed task (small, atomic). Verify `git status` clean between phases. Clean working tree at end of session.</constraint>
  <constraint name="Documentation Updates">Commit docs WITH code. Mark tasks complete immediately. Update implementation summary after each milestone. Update spec when code deviates (same commit).</constraint>
</constraints>

<principles>
  <principle name="First Principles Analysis">For complex features and bugs, break down to fundamental truths</principle>
  <principle name="Incremental Development">Small commits, each must compile and pass tests</principle>
  <principle name="Learn from Existing Code">Study 3 similar features before implementing</principle>
  <principle name="Pragmatic over Dogmatic">Adapt to project's actual situation</principle>
  <principle name="Clear Intent over Clever Code">Simple, clear solutions</principle>
  <principle name="Decision Priority">Testability → Readability → Consistency → Simplicity → Reversibility</principle>
  <principle name="Error Handling">Stop after 3 attempts. Record failures. Research 2-3 alternatives. Question assumptions.</principle>
</principles>

<gotchas>
  <gotcha>Running `git add -A` — stages everything including untracked files and build artifacts</gotcha>
  <gotcha>Forgetting git stash before major operations — context compaction can lose uncommitted work</gotcha>
  <gotcha>Working in main repo instead of worktree — breaks branch isolation</gotcha>
  <gotcha>Not checking for existing specs — duplicate specs fragment documentation</gotcha>
  <gotcha>Skipping doc updates when committing — code and docs must go together</gotcha>
  <gotcha>Ignoring the 3-attempt limit — infinite retry loops waste tokens</gotcha>
  <gotcha>Creating GitHub Actions accidentally</gotcha>
</gotchas>
