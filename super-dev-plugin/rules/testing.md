<meta>
  <name>testing</name>
  <type>rule</type>
  <description>Testing requirements including minimum coverage, TDD workflow, and BDD practices</description>
</meta>

<purpose>Enforce minimum 80% test coverage, test-driven development workflow, and behavior-driven development practices for all features.</purpose>

<directives>
  <directive severity="critical">**Minimum 80% test coverage** across all test types: unit (functions, utilities, components), integration (API endpoints, database operations), E2E (critical user flows via Playwright)</directive>
  <directive severity="critical">**TDD MANDATORY workflow**: Write test first (RED) → Run test, verify FAIL → Write minimal implementation (GREEN) → Run test, verify PASS → Refactor (IMPROVE) → Verify coverage 80%+</directive>
  <directive severity="critical">**BDD MANDATORY for all features** in super-dev workflow: Scenarios written BEFORE implementation (Phase 2.5), stored in `[doc-index]-behavior-scenarios.md`, Given/When/Then format with unique SCENARIO-XXX IDs, 100% scenario coverage required at Phase 9 gate</directive>
  <directive severity="high">Every acceptance criterion MUST have at least one BDD scenario</directive>
  <directive severity="high">Every BDD scenario MUST have at least one corresponding test</directive>
  <directive severity="medium">If test failures occur: use **tdd-guide** agent, check test isolation, verify mocks, fix implementation not tests (unless tests are wrong)</directive>
</directives>

<references>
  <ref>**bdd-scenario-writer**: Generates scenarios from acceptance criteria (Phase 2.5)</ref>
  <ref>**qa-agent**: Maps scenarios to tests, produces coverage report (Phase 8)</ref>
  <ref>**code-reviewer**: Validates scenario coverage gate (Phase 9)</ref>
  <ref>**adversarial-reviewer**: V8 behavior gap detection + D9 document pre-check (Phase 9)</ref>
</references>
