<meta>
  <name>tdd-workflow</name>
  <type>skill</type>
  <description>Test-driven development workflow enforcing tests FIRST with 80%+ coverage</description>
</meta>

<purpose>Enforce test-driven development methodology for writing new features, fixing bugs, or refactoring code. Scaffold interfaces, generate tests FIRST, then implement minimal code to pass. Ensure 80%+ coverage including unit, integration, and E2E tests.</purpose>

<triggers>Triggers on: feature implementation, bug fixes, refactoring, "write tests first", "TDD"</triggers>

<workflow>
  1. **Scaffold Interface**: Define the public API (function signatures, types, interfaces) before any implementation.
  2. **Write Tests (RED)**: Write failing tests that describe expected behavior. Cover: happy paths, error paths, edge cases (null, empty, boundaries), integration points.
  3. **Run Tests — Verify FAIL**: Execute test suite to confirm tests fail as expected.
  4. **Implement (GREEN)**: Write minimum code to make tests pass. No extra logic beyond what tests require.
  5. **Run Tests — Verify PASS**: Execute test suite to confirm all tests pass.
  6. **Refactor (IMPROVE)**: Remove duplication, improve naming, optimize. Re-run tests to verify no regressions.
  7. **Check Coverage**: Run coverage report. Verify 80%+ across branches, functions, lines, statements. Write additional tests if below threshold.
</workflow>

<constraints>
  <constraint>**Tests BEFORE code** — no code without tests. This is not optional.</constraint>
  <constraint>**All public functions**: Must have unit tests</constraint>
  <constraint>**All API endpoints**: Must have integration tests</constraint>
  <constraint>**Critical user flows**: Must have E2E tests</constraint>
  <constraint>**Edge cases**: null, empty, invalid types, boundaries, errors, race conditions, large data, special characters</constraint>
  <constraint>**Tests must be independent** — no shared state between tests</constraint>
  <constraint>**Coverage must be 80%+** (branches, functions, lines, statements)</constraint>
  <constraint>**Mock external dependencies** — Supabase, Redis, OpenAI, network calls</constraint>
</constraints>

<anti-patterns>
  <anti-pattern>Testing implementation details (internal state) instead of user-visible behavior</anti-pattern>
  <anti-pattern>Tests depending on execution order or shared state</anti-pattern>
  <anti-pattern>Missing edge case tests (only testing happy path)</anti-pattern>
  <anti-pattern>Writing implementation before tests</anti-pattern>
</anti-patterns>
