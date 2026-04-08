# Testing Requirements

## Minimum Test Coverage: 80%

Test Types (ALL required):
1. **Unit Tests** - Individual functions, utilities, components
2. **Integration Tests** - API endpoints, database operations
3. **E2E Tests** - Critical user flows (Playwright)

## Test-Driven Development

MANDATORY workflow:
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)

## Troubleshooting Test Failures

1. Use **tdd-guide** agent
2. Check test isolation
3. Verify mocks are correct
4. Fix implementation, not tests (unless tests are wrong)

## Agent Support

- **tdd-guide** - Use PROACTIVELY for new features, enforces write-tests-first
- **e2e-runner** - Playwright E2E testing specialist

## BDD (Behavior-Driven Development)

MANDATORY for all features developed through super-dev workflow:

1. BDD scenarios written BEFORE implementation (Phase 2.5)
2. All scenarios stored in `*-behavior-scenarios.md` in spec directory
3. Format: Given/When/Then (Gherkin-like markdown, NOT .feature files)
4. No Scenario Outlines in v1 -- individual scenarios only
5. Every scenario MUST have a unique SCENARIO-XXX ID
6. Every acceptance criterion MUST have at least one scenario
7. Every scenario MUST have at least one corresponding test
8. Phase 9 gate: 100% scenario coverage required (hard gate, blocks Phase 10)
9. BDD augments TDD -- does NOT replace unit/integration/E2E testing

Agent Support:
- **bdd-scenario-writer** -- Generates scenarios from acceptance criteria (Phase 2.5)
- **qa-agent** -- Maps scenarios to tests, produces coverage report (Phase 8)
- **code-reviewer** -- Validates scenario coverage gate (Phase 9)
- **adversarial-reviewer** -- V8 behavior gap detection + D9 document pre-check (Phase 9)
