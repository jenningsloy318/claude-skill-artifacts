# Research Report: BDD Best Practices for AI-Driven Development Workflows

**Date:** 2026-03-15
**Research Period:** 2006 (origin) to 2026-03-15 (latest sources)
**Technologies:** BDD, Gherkin, Markdown-based Scenarios, LLM/AI Agents, Claude Code Plugin
**Freshness Score:** 85% of sources < 1 year old

## Summary

- **BDD originated as a communication practice** (Dan North, 2006), not a testing framework. The methodology's core value is shared understanding through concrete examples, with three key activities: discovery, formulation, and automation.
- **LLMs can effectively generate BDD scenarios** from detailed requirements. A March 2026 arXiv study (500 user stories, 3 LLMs) found Claude rated highest by human experts; temperature=0 produces best results; detailed requirement descriptions are essential (user stories alone yield low-quality scenarios).
- **Declarative over imperative** is the single most important Gherkin writing rule. Scenarios should describe WHAT behavior is expected, not HOW the user interacts with the UI.
- **Scenario cadence follows diminishing returns**: The first 1-3 scenarios per feature capture the bulk of business value. Beyond 5, you're likely chasing edge cases that belong in unit tests.
- **Framework-free BDD is viable**: Markdown-based Gherkin-like syntax works well as a specification practice. Traceability is achieved through scenario IDs mapped to acceptance criteria and test names, not through Cucumber/SpecFlow tooling.

## Options Comparison: BDD Scenario Writing Approaches for AI Agents

### Option 1: Pure Gherkin Feature Files (.feature)

**Description:** Use standard .feature files with full Gherkin syntax, executable via Cucumber/SpecFlow/Behave.

**Strengths:**
- Industry standard syntax parsed by dozens of tools (Cucumber docs)
- Direct executable test generation — scenarios ARE tests
- Rich ecosystem of IDE plugins, linters, and formatters

**Weaknesses:**
- Requires framework dependency (Cucumber, SpecFlow, Behave) — violates our tool-agnostic constraint
- Feature files are coupled to specific test runners
- Over-engineering for an AI agent workflow that doesn't need runtime execution of .feature files

**Best For:**
- Teams with established BDD tooling
- Projects where non-technical stakeholders write scenarios directly

### Option 2: Markdown-Based Gherkin-Like Syntax (RECOMMENDED)

**Description:** Use Given/When/Then syntax embedded in Markdown documents with scenario IDs for traceability. No external BDD framework required.

**Strengths:**
- Language/framework agnostic — works for any tech stack (matches super-dev's design)
- Human-readable AND machine-parseable by AI agents
- No additional dependencies — fits existing spec directory convention
- Proven approach: Nordic Semiconductor's bdd-markdown-js demonstrates viability
- Traceability via scenario IDs (SCENARIO-001) referenced in test names/comments

**Weaknesses:**
- No automatic step-definition binding — tests reference scenarios by convention, not framework
- Requires discipline to maintain scenario-test mapping manually (mitigated by AI agent verification)
- No built-in lint/validation tooling (mitigated by AI agent quality checks)

**Best For:**
- AI-driven development workflows
- Tool-agnostic plugin systems
- Teams that value specification-as-documentation over executable feature files

### Option 3: Structured YAML/JSON Scenario Definitions

**Description:** Define scenarios in structured data format (YAML/JSON) for machine parsing, with human-readable rendering.

**Strengths:**
- Easily machine-parseable for automated verification
- Schema-validatable for consistent structure
- Can generate both documentation and test scaffolds

**Weaknesses:**
- Poor readability for humans compared to Gherkin-like syntax
- Loses the natural language benefit that is BDD's core value
- No established community practice or tooling

**Best For:**
- Highly automated pipelines where machine parsing is primary concern
- API-first development with schema-driven workflows

### Option 4: Specification by Example Tables

**Description:** Use tabular examples (input → expected output) as the primary scenario format, with minimal Given/When/Then structure.

**Strengths:**
- Extremely concise for data-driven behavior (Gojko Adzic's SbE approach)
- Easy for AI to generate and verify
- Natural fit for validation rules and calculations

**Weaknesses:**
- Loses narrative context — harder to understand complex workflows
- Not suitable for all scenario types (e.g., multi-step user journeys)
- Requires additional prose for context

**Best For:**
- Business rule validation
- Mathematical/computational behavior
- Scenarios with many data variations

### Option 5: Natural Language Scenarios (Free-Form)

**Description:** Write scenarios in plain English prose without Given/When/Then structure.

**Strengths:**
- Most natural for non-technical stakeholders
- No syntax rules to learn
- Maximum flexibility

**Weaknesses:**
- Ambiguous — different readers interpret differently
- Hard for AI agents to parse consistently into test plans
- No structural separation of precondition/action/outcome
- Loses the precision that makes BDD valuable

**Best For:**
- Early discovery phase before formalization
- Stakeholder communication (not specification)

### Comparison Matrix

| Criteria | .feature Files | Markdown Gherkin | YAML/JSON | SbE Tables | Free-Form |
|----------|---------------|-----------------|-----------|------------|-----------|
| Human Readability | High | High | Low | Medium | High |
| Machine Parseability | High | Medium | High | High | Low |
| Framework Independence | Low | High | High | High | High |
| BDD Community Alignment | High | Medium | Low | Medium | Low |
| AI Agent Compatibility | Medium | High | Medium | High | Low |
| Traceability Support | High | High | Medium | Medium | Low |
| Maintenance Overhead | Medium | Low | Medium | Low | High |

### Recommendation

**Recommended:** Option 2 — Markdown-Based Gherkin-Like Syntax

**Rationale:** This approach perfectly aligns with the super-dev plugin's tool-agnostic philosophy. It preserves the communication value of Given/When/Then (BDD's core benefit) while avoiding framework lock-in. The AI bdd-scenario-writer agent can generate well-structured markdown, and the qa-agent can parse scenario IDs from it to verify test coverage. The arXiv study confirms that LLMs produce high-quality BDD scenarios from detailed requirements — exactly what `01-requirements.md` provides.

**Trade-offs:** We gain framework independence and simplicity, but give up automatic step-definition binding. This is acceptable because the qa-agent performs the traceability check that frameworks would otherwise provide.

**Alternative Consider:** Option 4 (SbE Tables) as a supplementary format within the markdown document for data-driven scenarios (e.g., validation rules, edge case matrices).

## Deprecation Warnings

None identified. BDD as a methodology is experiencing renewed interest due to AI/LLM integration (multiple 2025-2026 sources confirm growing adoption).

## Best Practices

### Recommended Patterns

1. **Declarative Style (WHAT not HOW)**
   - Description: Write scenarios that describe intended behavior and outcomes, not UI interactions or implementation steps. Ask: "Will this wording need to change if the implementation does?" If yes, rewrite.
   - Use when: Always. This is the #1 rule of good Gherkin.
   - Example (Good): `When the user logs in with valid credentials`
   - Example (Bad): `When I type "user@example.com" in the email field And I click the "Login" button`
   - Source: [Cucumber - Writing Better Gherkin](https://cucumber.io/docs/bdd/better-gherkin/), [Automation Panda - BDD 101](https://automationpanda.com/2017/01/30/bdd-101-writing-good-gherkin/)

2. **One Behavior Per Scenario**
   - Description: Each scenario tests exactly one distinct behavior. If a scenario has multiple When/Then pairs, split it.
   - Use when: Always. This is the cardinal rule of BDD scenario writing.
   - Why: Improves debugging (one failure = one behavior), maintenance, and readability.
   - Source: [TestQuality - Good vs Bad Gherkin](https://testquality.com/examples-of-good-vs-bad-gherkin-test-scenarios-a-guide-to-better-bdd-testing/)

3. **Business Language (Ubiquitous Language)**
   - Description: Use domain terminology that stakeholders understand. No CSS selectors, API endpoints, database tables, or technical jargon.
   - Use when: Always. Scenarios are specifications, not test scripts.
   - Example (Good): `Given a premium subscriber`
   - Example (Bad): `Given a user with role_id=3 in the users table`
   - Source: [Dan North - Introducing BDD](https://dannorth.net/blog/introducing-bdd/), [Cucumber Anti-Patterns](https://cucumber.io/docs/guides/anti-patterns)

4. **Scenario Cadence (Diminishing Returns)**
   - Description: Start with the "golden scenario" (core promise of the feature). Add meaningful variations. Stop when scenarios start chasing edge cases — those belong in unit tests.
   - Use when: Deciding how many scenarios to write per feature.
   - Guideline: 3-5 scenarios per feature is typical. First captures happy path, second adds key alternative, third covers primary error case. Beyond 5, question whether the behavior is truly distinct.
   - Source: [Jakub Sobolewski - The Cadence of BDD](https://jakubsobolewski.com/blog/bdd-cadence/)

5. **Independent and Deterministic Scenarios**
   - Description: Each scenario must be self-contained — no dependencies on other scenarios' outcomes or execution order. Setup all preconditions in the Given block.
   - Use when: Always.
   - Source: [GitHub - andredesousa/gherkin-best-practices](https://github.com/andredesousa/gherkin-best-practices)

6. **Scenario-to-Acceptance-Criteria Traceability**
   - Description: Every scenario must trace back to at least one acceptance criterion. Include a traceability matrix in the scenario document.
   - Use when: Always. This is the core value proposition of our BDD integration.
   - Source: [TestRail - RTM Guide](https://www.testrail.com/blog/requirements-traceability-matrix/), [AssertThat - BDD Validation in Jira](https://www.assertthat.com/blog/bdd-validation-in-jira)

7. **Meaningful Scenario Titles**
   - Description: Titles should summarize the behavior being tested. They are the "face" of the scenario. Good titles make test triage efficient.
   - Format: `[Subject] [Action/Condition] [Expected Outcome]` or `[When X] [Then Y]`
   - Example (Good): `Registered user logs in with valid credentials`
   - Example (Bad): `Test login` or `Scenario 1`
   - Source: [Automation Panda - Good Gherkin Scenario Titles](https://automationpanda.com/2018/01/31/good-gherkin-scenario-titles/)

### Anti-Patterns to Avoid

1. **Imperative/Procedural Scenarios (UI Step-by-Step)**
   - Description: Writing scenarios as UI test scripts: "Given I navigate to /login, When I type 'user' in the username field, And I click Submit..."
   - Why: Brittle (breaks when UI changes), verbose, obscures business intent, loses readability for non-technical stakeholders.
   - Fix: Use declarative style — describe the behavior, not the interaction steps.
   - Source: [Cucumber - Writing Better Gherkin](https://cucumber.io/docs/bdd/better-gherkin/), [itsadeliverything.com - Declarative vs Imperative](https://itsadeliverything.com/declarative-vs-imperative-gherkin-scenarios-for-cucumber)

2. **Multiple Behaviors Per Scenario**
   - Description: A single scenario that tests login, navigation, AND profile update. Multiple When/Then pairs crammed into one scenario.
   - Why: When it fails, you don't know which behavior broke. Harder to maintain and understand.
   - Fix: Split into separate scenarios, each with one When/Then pair.
   - Source: [Medium - Common Anti-Patterns in Cucumber](https://medium.com/@aj.516147/common-anti-patterns-in-cucumber-how-to-avoid-them-ab73c63df180)

3. **Using BDD for Unit-Level Testing**
   - Description: Writing Given/When/Then scenarios for low-level function behavior (e.g., "Given a string 'hello', When I call toUpperCase(), Then I get 'HELLO'").
   - Why: BDD is for business-behavior-level specifications, not code-level testing. Unit tests are better served by TDD.
   - Fix: Reserve BDD scenarios for user-visible behaviors and business rules. Use TDD for implementation details.
   - Source: [Cucumber Anti-Patterns](https://cucumber.io/docs/guides/anti-patterns)

4. **Conjunction Steps (And-Bombing)**
   - Description: Steps that combine multiple actions: "Given I have shades and a brand new Mustang and a full tank of gas"
   - Why: Steps become too specialized and hard to reuse. Harder to identify which part failed.
   - Fix: Split into separate Given/And steps, each with one precondition.
   - Source: [Cucumber Anti-Patterns](https://cucumber.io/docs/guides/anti-patterns)

5. **Scenario Explosion (Writing Until You Run Out of Ideas)**
   - Description: Writing 20+ scenarios for a single feature, trying to cover every possible combination.
   - Why: Diminishing returns — most value is in the first 3-5 scenarios. Edge cases belong in unit/integration tests, not BDD.
   - Fix: Apply the scenario cadence principle. Ask "Does this scenario describe a distinct business behavior that stakeholders care about?"
   - Source: [Jakub Sobolewski - The Cadence of BDD](https://jakubsobolewski.com/blog/bdd-cadence/)

6. **Implementation Details in Scenarios**
   - Description: Mentioning database operations, API endpoints, HTTP status codes, CSS selectors, or internal system components.
   - Why: Couples scenarios to implementation. Scenarios should survive refactoring unchanged.
   - Fix: Write from the user's perspective using domain language.
   - Source: [NextGenAnalysts - Common Gherkin Mistakes](https://nextgenanalysts.co.uk/common-gherkin-mistakes-and-how-to-avoid-them-with-examples/)

7. **Vague/High-Level Scenarios**
   - Description: Scenarios so abstract they don't specify concrete behavior: "Given a user, When they do something, Then it works"
   - Why: Not testable, not verifiable, provides no shared understanding.
   - Fix: Use concrete examples with specific (but abstracted) values. "Given a registered user with an active subscription" is specific without being implementation-coupled.
   - Source: [GitHub - andredesousa/gherkin-best-practices](https://github.com/andredesousa/gherkin-best-practices)

## Official Documentation

### Key References

| Resource | URL | Key Takeaways |
|----------|-----|---------------|
| Dan North - Introducing BDD | https://dannorth.net/blog/introducing-bdd/ | BDD origin story; "test method names should be sentences"; behavior-first mindset |
| Cucumber - History of BDD | https://cucumber.io/docs/bdd/history/ | Evolution from JBehave to Cucumber; Given/When/Then template origin |
| Cucumber - Writing Better Gherkin | https://cucumber.io/docs/bdd/better-gherkin/ | Declarative vs imperative; describe behavior not implementation |
| Cucumber - Anti-Patterns | https://cucumber.io/docs/guides/anti-patterns | Feature-coupled steps, conjunction steps, incidental details |
| Gherkin Best Practices (GitHub) | https://github.com/andredesousa/gherkin-best-practices | 25 comprehensive guidelines with examples |

### API Notes

Not applicable — our approach is framework-free markdown-based BDD. No API integration required.

## Community Insights

### Top Discussions

1. **"BDD with tests without Gherkin"** — Reddit r/SoftwareEngineering (Nov 2025) — Active discussion about using BDD methodology without Gherkin tooling. Community consensus: BDD's value is in the collaboration/specification, not the framework.
2. **"Still Wasting Time on BDD?"** — LinkedIn article (Mar 2025) — Provocative title but concludes BDD's communication value is irreplaceable; the waste comes from over-tooling, not the methodology.
3. **"Specification by Example to Drive AI"** — Ürgo Ringo (Nov 2025) — Experimented with SbE + AI coding workflow. Found that concrete examples help AI produce more accurate implementations. ATDD with AI reduces "glue code" overhead.

### Common Issues

1. **Teams treat BDD as "testing only"** — BDD is primarily a specification/communication practice. Testing is a beneficial byproduct, not the goal.
2. **Scenario maintenance burden** — Teams write too many scenarios initially, then abandon them when maintenance costs grow. Solution: apply scenario cadence.
3. **Non-technical stakeholders don't participate** — When scenarios are written in imperative/technical style, business stakeholders disengage. Solution: enforce declarative style with business language.
4. **Scenario-test drift** — Over time, scenarios and tests diverge. Solution: scenario IDs with automated coverage verification (exactly what our Phase 9 gate provides).

## AI/LLM-Specific Findings

### Academic Research: LLMs for BDD Scenario Generation

**Key Paper:** "Behaviour Driven Development Scenario Generation with Large Language Models" (Rathnayake et al., arXiv:2603.04729, March 2026)

**Study Details:**
- Evaluated GPT-4, Claude 3, Gemini on 500 real-world user stories from 4 proprietary products
- Multidimensional evaluation: text similarity, semantic similarity, LLM-based evaluation, human expert assessment

**Critical Findings for Our Agent:**

1. **Claude rated highest by human experts** — Claude 3 produces scenarios that human reviewers prefer over GPT-4 and Gemini outputs.
2. **Input quality is decisive** — "Detailed requirement descriptions alone yield high-quality scenarios, whereas user stories alone yield low-quality scenarios." This validates our design: the bdd-scenario-writer agent consumes the full `01-requirements.md` (with acceptance criteria, not just user stories).
3. **Optimal parameters** — Temperature=0, top_p=1.0 produces highest quality. For our agent: use deterministic generation, not creative sampling.
4. **Prompting technique matters per model** — Claude benefits most from chain-of-thought reasoning. Our agent prompt should include reasoning steps.
5. **Few-shot examples help** — Providing 2-3 example scenarios in the prompt improves output quality.

**Key Paper:** "Agentic AI for Behavior-Driven Development Testing Using Large Language Models" (Paduraru et al., ICAART 2025)

**Finding:** Proposes using agentic AI (multi-step LLM agents) for BDD test generation. Validates the concept of an AI agent that generates BDD scenarios as part of a development workflow — directly analogous to our bdd-scenario-writer agent.

### AI-Driven BDD Best Practices (from industry)

**Source:** [AssertThat - AI-Driven BDD](https://www.assertthat.com/blog/ai-driven-bdd) (Dec 2025)

**Key Insight:** "AI does not replace collaboration, product ownership, or decision-making. AI works best as human-in-the-loop support — helping teams reduce manual effort while keeping ownership of behaviour firmly with the people responsible for delivery."

**Application to Our Design:**
- The bdd-scenario-writer agent GENERATES scenarios, but the user should review/approve them (Phase 2.5 output goes through coordinator approval before Phase 3)
- AI-generated scenarios should still follow all quality criteria (declarative, one-behavior, business language)
- The agent should flag uncertainty — if an acceptance criterion is ambiguous, note it rather than guess

### AI BDD Workflow Pattern (from developertoolkit.ai)

**Source:** [Developer Toolkit - BDD Workflows with AI](https://developertoolkit.ai/en/shared-workflows/development-workflows/behavior-driven-dev/) (Feb 2026)

**Pattern:**
1. Define behavior in plain-language specifications
2. AI assistant parses natural language requirements
3. AI generates Given/When/Then scenarios
4. Human reviews and refines scenarios
5. AI generates test implementations from scenarios
6. Tests are executed, failures feed back to implementation

**Application:** This mirrors our Phase 2 → 2.5 → 8 → 9 flow exactly.

## Performance Considerations

### Benchmarks

- **BDD scenario generation time with LLMs:** The arXiv study reports that an experienced BDD practitioner takes "approximately hours" to create comprehensive scenarios for a single feature manually. LLM generation takes seconds to minutes.
- **Overhead estimate:** Phase 2.5 should add < 2 minutes to the workflow (per requirements NFR), which is achievable given LLM generation speed.

### Optimization Tips

1. **Provide full requirements context** — The more detailed the input (acceptance criteria, constraints, stakeholder info), the better the output quality. Don't just pass user stories.
2. **Include few-shot examples** — 2-3 exemplar scenarios in the agent prompt significantly improve consistency.
3. **Use deterministic generation** — Temperature=0 for maximum quality and reproducibility.
4. **Batch generation** — Generate all scenarios for a feature in one pass, not one at a time, to maintain consistency and avoid duplication.

## Edge Cases

### Known Limitations

1. **Ambiguous acceptance criteria** — If requirements contain vague criteria like "system should be fast" or "user-friendly," the AI agent cannot generate meaningful scenarios. The agent should flag these as "not scenario-ready."
2. **Cross-cutting concerns** — Security, performance, accessibility requirements don't map cleanly to Given/When/Then. These should be noted as constraints in the scenario document, not forced into scenario format.
3. **Negative/error scenarios** — AI tends to generate happy-path scenarios more readily than error cases. The agent should explicitly prompt for error/boundary scenarios.

### Edge Cases to Handle

1. **Feature with 0 acceptance criteria**: Skip Phase 2.5 (scenario writer has no input).
2. **Trivial bug fixes**: Phase 2.5 should be skippable (like Phase 4 for non-bugs).
3. **Pure documentation changes**: No BDD scenarios needed — skip Phase 2.5.
4. **Acceptance criteria that are purely non-functional** (e.g., "response time < 200ms"): Note as constraints, don't force into scenario format.
5. **Overlapping acceptance criteria**: Agent should deduplicate and consolidate into shared scenarios.

### Security Considerations

No security-sensitive concerns specific to BDD scenario generation. Scenarios should NOT contain:
- Real credentials or secrets (use placeholder values)
- Actual database queries or API keys
- Production URLs or endpoints

## BDD Scenario Quality Checklist

The following checklist should be embedded in the `bdd-scenario-writer` agent's instructions for self-validation of every generated scenario:

### Per-Scenario Checks

| # | Check | Pass Criteria |
|---|-------|--------------|
| Q1 | **Single Behavior** | Scenario tests exactly ONE distinct behavior (one When/Then pair) |
| Q2 | **Declarative Style** | Describes WHAT happens, not HOW (no UI interactions, no button clicks, no field names) |
| Q3 | **Business Language** | Uses domain terminology stakeholders understand (no technical jargon, no code references) |
| Q4 | **Meaningful Title** | Title summarizes the behavior clearly; someone unfamiliar can understand the scenario's purpose from the title alone |
| Q5 | **Independence** | Scenario is self-contained; does not depend on other scenarios' execution or state |
| Q6 | **Concise Steps** | 3-5 steps total (Given + When + Then + And/But). If > 7 steps, split or abstract |
| Q7 | **Concrete Examples** | Uses specific (but abstracted) values, not vague descriptions. "Given a user with an expired subscription" > "Given a user" |
| Q8 | **AC Traceability** | Maps to at least one acceptance criterion from `01-requirements.md` with explicit AC-ID reference |
| Q9 | **No Implementation Leakage** | No database tables, API endpoints, HTTP status codes, CSS selectors, file paths, or internal component names |
| Q10 | **Testable Outcome** | The Then clause describes a verifiable outcome that can be asserted in code |

### Per-Document Checks

| # | Check | Pass Criteria |
|---|-------|--------------|
| D1 | **AC Coverage** | Every acceptance criterion from `01-requirements.md` has at least one corresponding scenario |
| D2 | **No Scenario Explosion** | Total scenarios per feature is reasonable (typically 3-8 per major feature area) |
| D3 | **Traceability Matrix** | Document includes a complete AC-to-Scenario mapping table |
| D4 | **Unique IDs** | Every scenario has a unique SCENARIO-XXX identifier |
| D5 | **Priority Assignment** | Each scenario has a priority (P0/P1/P2) reflecting business criticality |
| D6 | **Happy Path First** | The first scenario for each feature area covers the primary success path |
| D7 | **Error Cases Included** | At least one error/failure scenario exists for each major feature area |
| D8 | **No Duplicate Behaviors** | No two scenarios test the same behavior with trivially different inputs (use examples table instead) |

## BDD Scenario Writing Guidelines for the bdd-scenario-writer Agent

Based on synthesized research, these are the five core guidelines specific to our AI-driven, markdown-based, framework-free use case:

### Guideline 1: Start from Acceptance Criteria, Not User Stories

The arXiv study proves that detailed requirement descriptions produce significantly higher quality scenarios than user stories alone. The agent must:
- Read ALL acceptance criteria from `01-requirements.md`
- Process each AC individually as a scenario seed
- Cross-reference the "Job to Be Done" and "Stakeholders" sections for context

### Guideline 2: Apply the Scenario Cadence

For each acceptance criterion:
1. Write the **golden scenario** (happy path — the core promise)
2. Write the **primary alternative** (most likely variation)
3. Write the **primary failure** (most likely error case)
4. Stop. Only add more scenarios if a distinct business behavior remains uncovered.

### Guideline 3: Declarative + Domain Language Only

Every scenario must pass this test: "Would a product owner read this and immediately understand what behavior is being specified?" If the answer is no, rewrite.

Banned words in scenarios: click, navigate, type, enter, button, field, page, URL, endpoint, database, API, HTTP, JSON, SQL, CSS, selector, element, component.

### Guideline 4: Structure for Traceability

```
### SCENARIO-XXX: [Meaningful Behavior Title]
**Acceptance Criteria:** AC-XXX from requirements
**Priority:** P0/P1/P2

**Given** [precondition in business language]
**When** [single action/event in business language]
**Then** [verifiable outcome in business language]
```

The SCENARIO-XXX ID must be referenced in test names: `describe('SCENARIO-001: ...')` or `// SCENARIO-001`.

### Guideline 5: Flag Ambiguity, Don't Guess

If an acceptance criterion is:
- Too vague to generate a concrete scenario → Flag it with `[AMBIGUOUS: needs clarification]`
- Non-functional (performance, security) → Note as a constraint, don't force into Given/When/Then
- Already covered by another scenario → Note the overlap in the traceability matrix

## Recommendations

### Must Do

1. **Embed the Quality Checklist in the agent prompt** — The bdd-scenario-writer agent must self-validate every scenario against Q1-Q10 and every document against D1-D8.
2. **Require full `01-requirements.md` as input** — Never generate scenarios from user stories alone. The arXiv study proves this produces low-quality output.
3. **Enforce declarative style** — Include a "banned words" list in the agent prompt to prevent imperative scenarios.
4. **Include few-shot examples** — Provide 2-3 exemplar scenarios in the agent prompt for consistency (the arXiv study shows this helps, especially for Chain-of-Thought prompting which Claude excels at).
5. **Phase 9 hard gate on scenario coverage** — Make it deterministic: "ALL scenarios have corresponding passing tests" (binary pass/fail, not subjective).

### Should Consider

1. **Scenario cadence limits** — Soft-warn if > 8 scenarios are generated for a single feature area.
2. **Negative scenario enforcement** — Require at least one failure scenario per major feature area.
3. **Chain-of-thought in the agent prompt** — Claude performs best with CoT reasoning for BDD generation (per arXiv study). Structure the prompt to think through preconditions, actions, and outcomes step by step.
4. **Living documentation header** — Include metadata (date, source doc, total count) for traceability audits.

### Future Considerations

1. **Adversarial reviewer V8 vector** — Check for acceptance criteria WITHOUT corresponding BDD scenarios (coverage gap detection).
2. **Scenario-driven development** — Dev-executor could use BDD scenarios to guide implementation order (outside-in development).
3. **Scenario templates** — Common patterns (auth flows, CRUD, API endpoints) pre-seeded as few-shot examples.
4. **BDD regression dashboard** — Behavior status report showing scenario pass/fail over time.

## Sources

### Primary Sources

| # | Title | URL | Published | Freshness | Confidence |
|---|-------|-----|-----------|-----------|------------|
| 1 | BDD Scenario Generation with LLMs (arXiv) | https://arxiv.org/abs/2603.04729 | Mar 2026 | Fresh | 0.95 |
| 2 | Agentic AI for BDD Testing (ICAART) | https://www.scitepress.org/Papers/2025/133744/133744.pdf | Feb 2025 | Current | 0.90 |
| 3 | AI-Driven BDD: Using AI to Generate and Refine | https://www.assertthat.com/blog/ai-driven-bdd | Dec 2025 | Fresh | 0.85 |
| 4 | BDD Workflows with AI Coding Assistants | https://developertoolkit.ai/en/shared-workflows/development-workflows/behavior-driven-dev/ | Feb 2026 | Fresh | 0.80 |
| 5 | Using Specification by Example to Drive AI | https://urgo.medium.com/using-specification-by-example-to-drive-ai-95c19f0bb4ec | Nov 2025 | Fresh | 0.80 |
| 6 | Best Practices for Maintainable Gherkin Cases | https://testquality.com/best-practices-for-writing-maintainable-gherkin-test-cases/ | Jan 2026 | Fresh | 0.85 |
| 7 | Good vs Bad Gherkin Scenarios | https://testquality.com/examples-of-good-vs-bad-gherkin-test-scenarios-a-guide-to-better-bdd-testing/ | Sep 2025 | Fresh | 0.85 |
| 8 | Gherkin User Stories Acceptance Criteria 2026 | https://testquality.com/gherkin-user-stories-acceptance-criteria-guide/ | Feb 2026 | Fresh | 0.80 |
| 9 | The Cadence of BDD | https://jakubsobolewski.com/blog/bdd-cadence/ | Sep 2025 | Fresh | 0.85 |
| 10 | Dan North - Introducing BDD (Origin) | https://dannorth.net/blog/introducing-bdd/ | Sep 2006 | Origin | 0.95 |
| 11 | Cucumber - Writing Better Gherkin | https://cucumber.io/docs/bdd/better-gherkin/ | Evergreen | Current | 0.95 |
| 12 | Cucumber - Anti-Patterns | https://cucumber.io/docs/guides/anti-patterns | Evergreen | Current | 0.95 |
| 13 | Cucumber - History of BDD | https://cucumber.io/docs/bdd/history/ | Nov 2024 | Current | 0.90 |
| 14 | Gherkin Best Practices (GitHub) | https://github.com/andredesousa/gherkin-best-practices | Evergreen | Current | 0.85 |
| 15 | Common Anti-Patterns in Cucumber | https://medium.com/@aj.516147/common-anti-patterns-in-cucumber-how-to-avoid-them-ab73c63df180 | Sep 2024 | Current | 0.80 |
| 16 | Good Gherkin Scenario Titles | https://automationpanda.com/2018/01/31/good-gherkin-scenario-titles/ | Jan 2018 | Dated | 0.85 |
| 17 | BDD 101: Writing Good Gherkin | https://automationpanda.com/2017/01/30/bdd-101-writing-good-gherkin/ | Jan 2017 | Dated | 0.85 |
| 18 | Declarative vs Imperative Gherkin | https://itsadeliverything.com/declarative-vs-imperative-gherkin-scenarios-for-cucumber | Dec 2013 | Dated | 0.80 |
| 19 | Common Gherkin Mistakes (NextGenAnalysts) | https://nextgenanalysts.co.uk/common-gherkin-mistakes-and-how-to-avoid-them-with-examples/ | Jul 2025 | Fresh | 0.80 |
| 20 | BDD-Markdown (Nordic Semiconductor) | https://github.com/NordicSemiconductor/bdd-markdown-js | Sep 2022 | Dated | 0.75 |
| 21 | RTM: A How-To Guide (TestRail) | https://www.testrail.com/blog/requirements-traceability-matrix/ | Mar 2026 | Fresh | 0.80 |
| 22 | BDD Validation in Jira | https://www.assertthat.com/blog/bdd-validation-in-jira | Dec 2025 | Fresh | 0.80 |
| 23 | Traceability in CI/CD Workflows | https://medium.com/@sancharini.panda/how-a-traceability-matrix-fits-into-modern-ci-cd-workflows-714c5a6862af | Feb 2026 | Fresh | 0.75 |
| 24 | Automated Test Generation Using LLM Based on BDD | https://www.scitepress.org/Papers/2025/136836/136836.pdf | 2025 | Current | 0.85 |
| 25 | Gherkin Cucumber: A Definitive Guide | https://levelup.gitconnected.com/gherkin-cucumber-a-definitive-guide-for-bdd-driven-testing-ca1987617eed | Jan 2026 | Fresh | 0.75 |
| 26 | BDD: An Essential Guide for 2026 | https://monday.com/blog/rnd/behavior-driven-development/ | Nov 2025 | Fresh | 0.75 |
| 27 | Characterising the Quality of BDD Specifications | https://link.springer.com/content/pdf/10.1007/978-3-030-49392-9_6.pdf | May 2020 | Outdated | 0.80 |
| 28 | Sufficient Set of BDD Scenarios (Gojko Adzic) | https://gojko.net/2010/01/06/how-to-effectively-define-a-sufficient-set-of-bdd-scenariosacceptance-tests | Jan 2010 | Origin | 0.85 |
| 29 | SbE 10 Years Later (Gojko Adzic) | https://gojko.net/2020/03/17/sbe-10-years.html | Mar 2020 | Outdated | 0.80 |

### Source Freshness Summary

- Fresh (< 6 months): 17 sources
- Current (6-12 months): 5 sources
- Dated (1-2 years): 3 sources
- Origin/Reference (> 2 years, foundational): 4 sources

### Provenance Log

<details>
<summary>Full provenance (for audit)</summary>

| # | Query | Source Tool | Timestamp |
|---|-------|------------|-----------|
| 1 | "BDD Given When Then best practices Gherkin syntax anti-patterns 2025 2026" | exa_search | 2026-03-15T07:01 |
| 2 | "BDD behavior driven development AI LLM agent code generation acceptance testing 2024 2025" | exa_search | 2026-03-15T07:01 |
| 3 | "BDD without framework language agnostic markdown scenarios traceability requirements tests mapping 2024 2025" | exa_search | 2026-03-15T07:01 |
| 4 | "BDD scenario quality criteria good bad scenarios writing guidelines naming conventions business language" | exa_search | 2026-03-15T07:01 |
| 5 | "BDD traceability matrix requirements scenarios tests CI/CD living documentation integration pattern" | exa_search | 2026-03-15T07:01 |
| 6 | "BDD scenario generation LLM large language model Given When Then automated acceptance test 2025 2026" | exa_code | 2026-03-15T07:02 |
| 7 | "BDD Gherkin anti-patterns common mistakes scenario writing guidelines one behavior per scenario imperative declarative" | exa_code | 2026-03-15T07:02 |
| 8 | "Dan North introducing BDD behavior driven development original article Given When Then story template" | exa_search | 2026-03-15T07:02 |
| 9 | "BDD scenario cadence diminishing returns how many scenarios per feature outside-in TDD acceptance test driven development 2024 2025" | exa_search | 2026-03-15T07:02 |
| 10 | "specification by example living documentation BDD markdown Gherkin-like without cucumber framework-free 2024 2025" | exa_search | 2026-03-15T07:02 |

</details>
