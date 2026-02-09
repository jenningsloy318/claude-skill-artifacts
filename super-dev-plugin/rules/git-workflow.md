# Git Workflow

## Commit Message Format

### Full Super-Dev Workflow (with spec/worktree)
When working within a specification workflow:
```
spec-[spec-index]-[spec-name] <type>: <description>

<optional body>
```

Example:
```
spec-01-user-auth feat: implement JWT token validation

- Add token validation middleware
- Create refresh token endpoint
- Add unit tests for auth flow
```

### Direct Changes (no spec workflow)
When making direct changes without a specification:
```
<type>: <description>

<optional body>
```

Example:
```
fix: resolve null pointer in login handler

- Add null check before accessing user object
- Update error message for clarity
```

### Types
feat, fix, refactor, docs, test, chore, perf, ci

Note: Attribution disabled globally via ~/.claude/settings.json.

## Pull Request Workflow

When creating PRs:
1. Analyze full commit history (not just latest commit)
2. Use `git diff [base-branch]...HEAD` to see all changes
3. Draft comprehensive PR summary
4. Include test plan with TODOs
5. Push with `-u` flag if new branch

## Feature Implementation Workflow

1. **Plan First**
   - Use **planner** agent to create implementation plan
   - Identify dependencies and risks
   - Break down into phases

2. **TDD Approach**
   - Use **tdd-guide** agent
   - Write tests first (RED)
   - Implement to pass tests (GREEN)
   - Refactor (IMPROVE)
   - Verify 80%+ coverage

3. **Code Review**
   - Use **code-reviewer** agent immediately after writing code
   - Address CRITICAL and HIGH issues
   - Fix MEDIUM issues when possible

4. **Commit & Push**
   - Detailed commit messages
   - Follow conventional commits format
