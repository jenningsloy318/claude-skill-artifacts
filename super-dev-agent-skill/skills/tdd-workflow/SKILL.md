---
name: tdd-workflow
description: Test-driven development workflow enforcing tests FIRST with 80%+ coverage
---

<purpose>Enforce test-driven development methodology for writing new features, fixing bugs, or refactoring code. Scaffold interfaces, generate tests FIRST, then implement minimal code to pass. Ensure 80%+ coverage including unit, integration, and E2E tests.</purpose>

<triggers>Triggers on: feature implementation, bug fixes, refactoring, "write tests first", "TDD"</triggers>

<workflow>
  <step n="1" name="Scaffold Interface">Define the public API (function signatures, types, interfaces) before any implementation.</step>
  <step n="2" name="Write Tests (RED)">Write failing tests that describe expected behavior. Cover: happy paths, error paths, edge cases (null, empty, boundaries), integration points.</step>
  <step n="3" name="Run Tests — Verify FAIL">Execute test suite to confirm tests fail as expected.</step>
  <step n="4" name="Implement (GREEN)">Write minimum code to make tests pass. No extra logic beyond what tests require.</step>
  <step n="5" name="Run Tests — Verify PASS">Execute test suite to confirm all tests pass.</step>
  <step n="6" name="Refactor (IMPROVE)">Remove duplication, improve naming, optimize. Re-run tests to verify no regressions.</step>
  <step n="7" name="Check Coverage">Run coverage report. Verify 80%+ across branches, functions, lines, statements. Write additional tests if below threshold.</step>
</workflow>

<constraints>
  <constraint name="Tests BEFORE code">No code without tests. This is not optional.</constraint>
  <constraint name="All public functions">Must have unit tests</constraint>
  <constraint name="All API endpoints">Must have integration tests</constraint>
  <constraint name="Critical user flows">Must have E2E tests</constraint>
  <constraint name="Edge cases">null, empty, invalid types, boundaries, errors, race conditions, large data, special characters</constraint>
  <constraint name="Tests must be independent">No shared state between tests</constraint>
  <constraint name="Coverage must be 80%+">Branches, functions, lines, statements</constraint>
  <constraint name="Mock external dependencies">Supabase, Redis, OpenAI, network calls</constraint>
</constraints>

<anti-patterns>
  <anti-pattern>Testing implementation details (internal state) instead of user-visible behavior</anti-pattern>
  <anti-pattern>Tests depending on execution order or shared state</anti-pattern>
  <anti-pattern>Missing edge case tests (only testing happy path)</anti-pattern>
  <anti-pattern>Writing implementation before tests</anti-pattern>
</anti-patterns>
