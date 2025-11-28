---
name: super-dev:run
description: Execute the complete coordinator-driven development workflow for implementing features or fixing bugs
---

# Super Dev Workflow Command

## ⛔ FORBIDDEN - Direct MCP Tool Calls

**CRITICAL ENFORCEMENT:** When running this workflow, NEVER call MCP tools directly. Always use the wrapper scripts via Bash.

**NEVER use these direct MCP tool calls:**
- ❌ `mcp__exa__web_search_exa` - Use `python3 super-dev-plugin/scripts/exa/exa_search.py` instead
- ❌ `mcp__exa__get_code_context_exa` - Use `python3 super-dev-plugin/scripts/exa/exa_code.py` instead
- ❌ `mcp__deepwiki__read_wiki_structure` - Use `python3 super-dev-plugin/scripts/deepwiki/deepwiki_structure.py` instead
- ❌ `mcp__deepwiki__read_wiki_contents` - Use `python3 super-dev-plugin/scripts/deepwiki/deepwiki_contents.py` instead
- ❌ `mcp__deepwiki__ask_question` - Use `python3 super-dev-plugin/scripts/deepwiki/deepwiki_ask.py` instead
- ❌ `mcp__context7__resolve-library-id` - Use `python3 super-dev-plugin/scripts/context7/context7_resolve.py` instead
- ❌ `mcp__context7__get-library-docs` - Use `python3 super-dev-plugin/scripts/context7/context7_docs.py` instead
- ❌ `mcp__github__search_code` - Use `python3 super-dev-plugin/scripts/github/github_search_code.py` instead
- ❌ `mcp__github__search_repositories` - Use `python3 super-dev-plugin/scripts/github/github_search_repos.py` instead
- ❌ `mcp__github__get_file_contents` - Use `python3 super-dev-plugin/scripts/github/github_file_contents.py` instead

**EXCEPTION:** `mcp__time-mcp__current_time` is allowed (no script wrapper available)

---

This command orchestrates the complete coordinator-driven development workflow.

## Usage

```
/super-dev:run [description of task]
```

## What This Command Does

When invoked, this command activates the `super-dev:coordinator` agent which orchestrates all 12 phases:

1. **Phase 0: Apply Dev Rules** - Establish coding standards
2. **Phase 1: Specification Setup** - Find or create spec directory
3. **Phase 2: Requirements Clarification** - Gather complete requirements
4. **Phase 3: Research** - Find best practices with Time MCP
5. **Phase 4: Debug Analysis** - Root cause analysis (bugs only, uses grep/ast-grep)
6. **Phase 5: Code Assessment** - Evaluate existing codebase (uses grep/ast-grep)
7. **Phase 5.3: Architecture Design** - For complex features (optional)
8. **Phase 5.5: UI/UX Design** - For features with UI (optional)
9. **Phase 6: Specification Writing** - Create tech spec, plan, tasks
10. **Phase 7: Specification Review** - Validate all documents
11. **Phase 8-9: Execution** - PARALLEL agents (dev + qa + docs)
12. **Phase 9.5: Quality Assurance** - Modality-specific testing
13. **Phase 10-11: Cleanup & Commit** - Remove temp files, commit changes
14. **Phase 12: Final Verification** - Coordinator verifies all complete

## Instructions

When this command is invoked:

1. **Invoke Coordinator**: Use `super-dev:coordinator` agent
2. **Apply dev rules**: Coordinator applies `super-dev:dev-rules` at Phase 0
3. **Coordinator orchestrates** all phases automatically
4. **Parallel execution** during Phases 8-9 (dev, qa, docs agents)
5. **Track progress** with TodoWrite tool

## Arguments

`$ARGUMENTS` contains the user's description of what needs to be done:
- Bug description
- Feature request
- Refactoring goal
- Performance issue

## Example Invocations

```
/super-dev:run Fix the login button not responding on mobile
/super-dev:run Implement user profile page with avatar upload
/super-dev:run Refactor the authentication module for better testability
/super-dev:run Improve API response time for product listing
```

## Notes

- The Coordinator Agent is the central authority that orchestrates ALL phases
- Parallel execution (dev + qa + docs) maximizes efficiency
- Build queue policy: For Rust/Go, only ONE build at a time
- All documents are created in `specification/[index]-[name]/` directory
- Final verification ensures no missing code or documents
