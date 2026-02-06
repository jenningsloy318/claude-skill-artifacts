---
description: Update project documentation
agent: docs-executor
---

Update project documentation:

1. Update README with new features/changes
2. Update CHANGELOG with recent changes
3. Add/update code comments
4. Update API documentation

Documentation to update:
- README.md - Features, usage, installation
- CHANGELOG.md - Recent changes
- API.md - API documentation
- Code comments and docstrings
- Configuration docs

Recent changes to document:
!`git log --oneline -10`

Files modified:
!`git diff --name-only HEAD~5..HEAD`

Ensure:
- Documentation is accurate
- Examples are correct
- Links work
- Follows project conventions