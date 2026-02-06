---
description: Assess codebase architecture and patterns
agent: code-assessor
---

Assess existing codebase:

1. Analyze architecture and patterns
2. Document technology stack
3. Identify code conventions
4. Evaluate quality metrics

Assessment areas:
- Architecture patterns
- Technology stack
- Code patterns and conventions
- Quality indicators (coverage, complexity)
- Dependencies health

Use ast-grep for structural analysis:
!`ast-grep --version 2>/dev/null || echo "ast-grep not installed"`

Configuration analysis:
!`ls -la package.json tsconfig.json Cargo.toml go.mod requirements.txt 2>/dev/null | head -5`

Output: Create assessment report in specification/[index]-assessment.md

Include:
- Architecture overview
- Technology stack
- Code patterns catalog
- Style conventions
- Quality metrics
- Implementation recommendations