---
description: Remove dead code and refactor
agent: refactor-cleaner
---

Clean up dead code and refactor:

1. Identify unused code (functions, variables, imports)
2. Remove dead code safely
3. Consolidate duplicates
4. Simplify complex code

Tools used:
- knip (for JavaScript/TypeScript)
- depcheck
- ts-prune
- Manual code analysis

Operations:
- Remove unused imports
- Delete unused functions
- Remove unused variables
- Consolidate duplicate code
- Simplify complex expressions

Check output:
!`npx knip 2>/dev/null || echo "Knip not configured"`

Always verify after removal:
- Tests still pass
- Build still succeeds
- No runtime errors

For: $ARGUMENTS