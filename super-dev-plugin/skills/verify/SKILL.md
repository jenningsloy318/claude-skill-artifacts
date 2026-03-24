---
name: verify
description: >
    Verify that implemented features work correctly by driving browser/UI testing with
    screenshots and programmatic assertions. Uses Playwright MCP when available, falls back
    to CLI-based verification. Triggers on: "verify this works", "check the output",
    "test the UI", "verify the feature", "screenshot test", "visual verification",
    "does it actually work". Do NOT trigger on: unit test writing (use tdd-workflow),
    code review (use code-review), standard test runs ("run the tests").
---

# Verification Skill

Drive interactive testing to verify that implemented features actually work. Takes screenshots, records evidence, and enforces programmatic assertions at each step.

**Announce at start:** "Running verification. I will test the feature interactively and capture evidence."

## When to Activate

- After implementation is complete and you want to verify it works
- When unit tests pass but you need to verify end-to-end behavior
- When you need visual evidence that a feature works correctly
- When testing user flows that span multiple steps
- After fixing a bug to confirm the fix

## When NOT to Activate

- Writing unit/integration tests (use `tdd-workflow`)
- Code quality review (use `code-review` or `adversarial-review`)
- Running existing test suites ("run the tests" → just use Bash)
- Performance benchmarking

## Tool Detection (MANDATORY first step)

Before starting verification, detect available tools:

### Playwright MCP (Primary -- preferred)

Check for Playwright MCP tools:
- `mcp__playwright__browser_navigate`
- `mcp__playwright__browser_snapshot`
- `mcp__playwright__browser_take_screenshot`
- `mcp__playwright__browser_click`
- `mcp__playwright__browser_fill_form`

If available: Use Playwright MCP for browser-based verification with screenshots.

### CLI Verification (Fallback)

If no browser tools are available, fall back to:
- Running the application and checking HTTP responses via `curl`
- Verifying CLI output matches expectations
- Checking file system state after operations
- Running health check endpoints

**Announce which mode is active:**
- Playwright detected: "Using Playwright MCP for browser-based verification with screenshots."
- CLI fallback: "No browser tools available. Using CLI-based verification."

## Verification Process

### Step 1: Define Verification Plan

Before testing, create a verification checklist from:
- Acceptance criteria (from requirements)
- BDD scenarios (from behavior-scenarios.md)
- Bug reproduction steps (if fixing a bug)

```markdown
## Verification Checklist
- [ ] Step 1: [Action] -> Expected: [Result]
- [ ] Step 2: [Action] -> Expected: [Result]
- [ ] Step 3: [Action] -> Expected: [Result]
```

### Step 2: Start the Application

```bash
# Start the dev server (detect from project)
# Node.js: npm run dev / yarn dev / pnpm dev
# Rust: cargo run
# Go: go run .
# Python: python -m uvicorn main:app
```

Wait for the application to be ready before proceeding.

### Step 3: Execute Verification (Playwright MCP mode)

For each checklist item:

1. **Navigate** to the relevant page:
   ```
   mcp__playwright__browser_navigate(url: "http://localhost:3000/path")
   ```

2. **Interact** with the UI:
   ```
   mcp__playwright__browser_click(element: "button", ref: "submit-btn")
   mcp__playwright__browser_fill_form(element: "input[name='email']", value: "test@example.com")
   ```

3. **Assert** the expected state:
   ```
   mcp__playwright__browser_snapshot()
   # Verify the snapshot contains expected elements
   ```

4. **Screenshot** as evidence:
   ```
   mcp__playwright__browser_take_screenshot()
   # Save screenshot for verification report
   ```

5. **Record result**: Pass or fail with evidence

### Step 3 (Alternative): Execute Verification (CLI mode)

For each checklist item:

1. **Make HTTP request**:
   ```bash
   curl -s http://localhost:3000/api/endpoint | jq .
   ```

2. **Assert response**:
   ```bash
   # Check status code
   STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/endpoint)
   [ "$STATUS" = "200" ] && echo "PASS" || echo "FAIL: Expected 200, got $STATUS"
   ```

3. **Check state**:
   ```bash
   # Verify file was created
   [ -f expected-output.json ] && echo "PASS" || echo "FAIL: File not created"
   ```

### Step 4: Generate Verification Report

Create a structured report with all evidence:

```markdown
# Verification Report: [Feature Name]

**Date:** [timestamp]
**Mode:** Playwright MCP / CLI
**Verdict:** PASS / PARTIAL / FAIL

## Environment
- Application: [URL or command]
- Browser: [if Playwright]
- OS: [platform]

## Results

### Check 1: [Description]
- **Action:** [what was done]
- **Expected:** [expected result]
- **Actual:** [actual result]
- **Status:** PASS / FAIL
- **Evidence:** [screenshot path or output]

### Check 2: [Description]
...

## Summary
- Total checks: [N]
- Passed: [N]
- Failed: [N]
- Pass rate: [N%]

## Screenshots
[List of screenshot paths with descriptions]

## Issues Found
[Any bugs or unexpected behavior discovered during verification]
```

### Step 5: Store Evidence

Save verification artifacts:
```bash
# Store in spec directory
mkdir -p specification/[spec-name]/verification/
# Screenshots saved here
# Report saved as [index]-verification-report.md
```

## Assertion Patterns

### DOM Assertions (Playwright MCP)

```
# Element exists
browser_snapshot -> check for element presence

# Text content
browser_snapshot -> verify text matches expected

# Element state (visible, disabled, etc.)
browser_snapshot -> check element attributes

# Navigation
browser_snapshot -> verify current URL matches expected
```

### HTTP Assertions (CLI)

```bash
# Status code check
[ "$(curl -s -o /dev/null -w '%{http_code}' $URL)" = "200" ]

# Response body check
curl -s $URL | jq -e '.success == true'

# Header check
curl -sI $URL | grep -q 'Content-Type: application/json'

# Response time check
TIME=$(curl -s -o /dev/null -w '%{time_total}' $URL)
[ "$(echo "$TIME < 2.0" | bc)" = "1" ]
```

### State Assertions

```bash
# File exists
[ -f path/to/expected/file ]

# File content matches
diff expected-output.txt actual-output.txt

# Database state (via CLI tools)
psql -c "SELECT COUNT(*) FROM users WHERE status = 'active'" | grep -q "expected_count"

# Process running
pgrep -f "process-name" > /dev/null
```

## Integration with super-dev Workflow

When used within the super-dev workflow:
- Run after Phase 8 (Execution & QA) for additional confidence
- Evidence feeds into Phase 9 (Code Review) -- reviewers can see screenshots
- Verification report stored in spec directory alongside other artifacts

When used standalone:
- Run anytime after implementation
- Generate report for stakeholder review
- Useful for demo preparation

## Gotchas

- **Dev server not started**: Always ensure the application is running before browser verification. Check for port availability.
- **Flaky selectors**: Use data-testid attributes or semantic selectors, not CSS classes that may change.
- **Timing issues**: Wait for page loads and animations to complete before asserting. Use Playwright's built-in waiting, not arbitrary timeouts.
- **Environment differences**: Verify against the same environment (dev server, not production) that the code was tested against.
- **Screenshot storage**: Screenshots can be large. Store in the spec directory but consider cleanup after verification is confirmed.
- **Auth barriers**: If the feature requires authentication, handle login as the first verification step before testing the actual feature.
