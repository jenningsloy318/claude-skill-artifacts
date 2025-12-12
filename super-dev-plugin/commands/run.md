---
name: super-dev:run
description: Execute the complete coordinator-driven development workflow for implementing features or fixing bugs
---

# Super Dev Workflow Command

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
11. **Phase 8: Execution & QA** - PARALLEL agents (dev + qa)
12. **Phase 9: Code Review** - Specification-aware code review
13. **Phase 10: Documentation Update** - Sequential docs update
14. **Phase 11: Cleanup** - Remove temp files
15. **Phase 12: Commit & Push** - Commit all changes
16. **Phase 13: Final Verification** - Coordinator verifies all complete

## Instructions

When this command is invoked:

1. **Invoke Coordinator**: Use `super-dev:coordinator` agent
2. **Apply dev rules**: Coordinator applies `super-dev:dev-rules` at Phase 0
3. **Coordinator orchestrates** all phases automatically
4. **Parallel execution** during Phase 8 (dev, qa agents)
5. **Sequential documentation** in Phase 10 (docs agent)
6. **Track progress** with TodoWrite tool

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
- Parallel execution (dev + qa) maximizes efficiency
- Build queue policy: For Rust/Go, only ONE build at a time
- All documents are created in `specification/[spec-index]-[spec-name]/` directory
- Final verification ensures no missing code or documents
