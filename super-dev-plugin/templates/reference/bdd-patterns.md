# BDD Patterns Reference

## Gherkin-Like Syntax (Markdown)

BDD scenarios use Given/When/Then format in markdown (NOT .feature files):

### Scenario Structure

```
### SCENARIO-XXX: [Meaningful Behavior Title]
**Acceptance Criteria:** AC-XX from requirements
**Priority:** P0/P1/P2

**Given** [precondition in business language]
**When** [single action/event in business language]
**Then** [verifiable outcome in business language]
**And** [additional outcome if needed]
```

### Scenario ID Convention

- Format: `SCENARIO-001`, `SCENARIO-002`, ..., `SCENARIO-NNN`
- Sequential, zero-padded to 3 digits
- Unique within a single `01.1-behavior-scenarios.md`
- Referenced in tests: `describe('SCENARIO-001: ...')` or `// SCENARIO-001`

### Priority Levels

| Priority | Meaning | Test in Phase 8 |
|----------|---------|-----------------|
| P0 | Core business behavior (happy path) | Always |
| P1 | Important alternative/error path | Always |
| P2 | Edge case or secondary behavior | Always (coverage gate is 100%) |

## Writing Guidelines

### DO: Declarative Style

```
**Given** a premium subscriber with an active plan
**When** the subscriber accesses exclusive content
**Then** the content is displayed without restrictions
```

### DON'T: Imperative Style

```
**Given** the user is on the pricing page
**When** the user clicks the "Upgrade" button
**And** the user enters their credit card number
**Then** the page redirects to /dashboard
```

### Banned Words

click, navigate, type, enter, button, field, page, URL, endpoint,
database, API, HTTP, JSON, SQL, CSS, selector, element, component,
scroll, hover, tap, swipe, drag, drop, submit, form, redirect,
render, mount, DOM, query, request, response

## Traceability Matrix Pattern

```markdown
| Acceptance Criterion | Scenario IDs | Coverage |
|---------------------|-------------|----------|
| AC-01: [description] | SCENARIO-001, SCENARIO-002 | Covered |
| AC-02: [description] | SCENARIO-003 | Covered |
```

## Test Reference Patterns

### JavaScript/TypeScript
```javascript
describe('SCENARIO-001: Registered user accesses account', () => {
  it('should grant access with valid credentials', () => { ... });
});
```

### Python
```python
def test_scenario_001_registered_user_accesses_account():
    """SCENARIO-001: Registered user accesses account with valid credentials"""
    ...
```

### Rust
```rust
#[test]
fn scenario_001_registered_user_accesses_account() { ... }
```

### Go
```go
func TestScenario001_RegisteredUserAccessesAccount(t *testing.T) { ... }
```

## Quality Checklists

### Per-Scenario (Q1-Q10)
- Q1: Single behavior (one When/Then pair)
- Q2: Declarative style (WHAT not HOW)
- Q3: Business language (no jargon)
- Q4: Meaningful title
- Q5: Independent (self-contained)
- Q6: Concise (3-5 steps)
- Q7: Concrete examples
- Q8: AC traceability (AC-ID reference)
- Q9: No implementation leakage
- Q10: Testable outcome

### Per-Document (D1-D8)
- D1: All AC covered
- D2: No scenario explosion (3-8 per area)
- D3: Traceability matrix complete
- D4: Unique IDs
- D5: Priorities assigned
- D6: Happy path first
- D7: Error cases included
- D8: No duplicate behaviors
