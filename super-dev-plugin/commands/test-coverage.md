---
name: test-coverage
description: Analyze test coverage and generate missing tests to reach 80%+ coverage
---

<purpose>Run tests with coverage, analyze the report, identify files below 80% threshold, and generate unit/integration/E2E tests for under-covered code paths.</purpose>

<process>
  <step n="1" name="Run Coverage">Run tests with coverage: `npm test --coverage` or `pnpm test --coverage`</step>
  <step n="2" name="Analyze">Analyze coverage report (coverage/coverage-summary.json). Identify files below 80%.</step>
  <step n="3" name="Generate Tests">For each under-covered file: analyze untested code paths, generate unit/integration/E2E tests.</step>
  <step n="4" name="Verify">Verify new tests pass. Show before/after coverage metrics. Ensure 80%+ overall.</step>
</process>

<constraints>
  <constraint>Focus on: happy path scenarios, error handling, edge cases (null, undefined, empty), boundary conditions</constraint>
</constraints>
