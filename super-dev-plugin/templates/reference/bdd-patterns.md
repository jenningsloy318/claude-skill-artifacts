<meta>
  <name>bdd-patterns</name>
  <type>template</type>
  <description>BDD scenario writing patterns, Gherkin-like syntax conventions, and quality checklists for behavior-driven development</description>
</meta>

<purpose>Reference for writing BDD behavior scenarios using Given/When/Then format in markdown, with scenario ID conventions, priority levels, traceability matrices, and per-scenario/per-document quality checklists.</purpose>

<syntax name="Gherkin-Like Syntax">
  BDD scenarios use Given/When/Then format in markdown (NOT .feature files). Each scenario follows this structure: `SCENARIO-XXX: [Meaningful Behavior Title]` with acceptance criteria reference (`AC-XX`), priority (`P0/P1/P2`), and Given/When/Then/And steps in business language.
</syntax>

<convention name="Scenario ID Convention">
  - Format: `SCENARIO-001`, `SCENARIO-002`, ..., `SCENARIO-NNN`
  - Sequential, zero-padded to 3 digits
  - Unique within a single `[doc-index]-behavior-scenarios.md`
  - Referenced in tests: `describe('SCENARIO-001: ...')` or `// SCENARIO-001`
</convention>

<reference name="Priority Levels">
  - P0: Core business behavior (happy path) — always test
  - P1: Important alternative/error path — always test
  - P2: Edge case or secondary behavior — always test (coverage gate is 100%)
</reference>

<principles>
  <principle name="Declarative style only">Describe WHAT behavior is expected, not HOW (e.g., "subscriber accesses exclusive content" not "user clicks Upgrade button")</principle>
  <principle name="One behavior per scenario">Each scenario tests exactly one Given/When/Then pair</principle>
  <principle name="Business language">Use domain terminology; never use banned implementation words</principle>
  <principle name="Scenario cadence">3-5 per feature area; stop at 8</principle>
</principles>

<constraints>
  <constraint name="Banned words">in scenarios: click, navigate, type, enter, button, field, page, URL, endpoint, database, API, HTTP, JSON, SQL, CSS, selector, element, component, scroll, hover, tap, swipe, drag, drop, submit, form, redirect, render, mount, DOM, query, request, response</constraint>
</constraints>

<reference name="Traceability Matrix">
  Every behavior-scenarios document MUST include a traceability matrix mapping each Acceptance Criterion to its covering Scenario IDs. Zero uncovered items allowed.
</reference>

<reference name="Test Reference Patterns">
  BDD scenarios are referenced in tests using language-specific conventions: JavaScript/TypeScript uses `describe('SCENARIO-XXX: ...')`, Python uses `def test_scenario_xxx_...()`, Rust uses `fn scenario_xxx_...()`, Go uses `func TestScenarioXxx_...(t *testing.T)`.
</reference>

<checklist>
  <check name="Per-Scenario (Q1-Q10)">Q1 Single behavior, Q2 Declarative style, Q3 Business language, Q4 Meaningful title, Q5 Independent, Q6 Concise (3-5 steps), Q7 Concrete examples, Q8 AC traceability, Q9 No implementation leakage, Q10 Testable outcome</check>
  <check name="Per-Document (D1-D8)">D1 All AC covered, D2 No scenario explosion (3-8 per area), D3 Traceability matrix complete, D4 Unique IDs, D5 Priorities assigned, D6 Happy path first, D7 Error cases included, D8 No duplicate behaviors</check>
</checklist>
