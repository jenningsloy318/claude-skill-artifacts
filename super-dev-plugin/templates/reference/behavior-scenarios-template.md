---
name: behavior-scenarios-template
description: XML-tagged template for BDD behavior scenarios in Gherkin-like markdown. Used by bdd-scenario-writer agent to produce traceable Given/When/Then scenarios mapped to acceptance criteria with quality validation.
doc-type: behavior-scenarios
gate-profile: gate-bdd.sh
---

```xml
<document type="behavior-scenarios">

  <metadata>
    <field name="title">Behavior Scenarios: [Feature Name]</field>
    <field name="date">[timestamp]</field>
    <field name="author">super-dev:bdd-scenario-writer</field>
    <field name="source">./[doc-index]-requirements.md</field>
    <field name="total-scenarios">[count]</field>
  </metadata>

  <section title="Feature: [Feature Name]">

    <scenario id="SCENARIO-001" title="[Meaningful Behavior Title]">
      <field name="acceptance-criteria">AC-XX from requirements</field>
      <field name="priority">P0 | P1 | P2</field>

      <paragraph>
        **Given** [precondition in business language]
        **When** [single action/event in business language]
        **Then** [verifiable outcome in business language]
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-002" title="[Meaningful Behavior Title]">
      <field name="acceptance-criteria">AC-XX from requirements</field>
      <field name="priority">P0 | P1 | P2</field>

      <paragraph>
        **Given** [precondition]
        **When** [action]
        **Then** [outcome]
        **And** [additional outcome if needed]
      </paragraph>
    </scenario>

    <!-- Repeat for each scenario. Follow the cadence:
         1. Golden scenario (happy path)
         2. Primary alternative (most likely variation)
         3. Primary failure (most likely error case)
         4. Stop unless a distinct business behavior remains uncovered.
         Target: 3-5 scenarios per feature area; max 8. -->

  </section>

  <section title="Scenario-Acceptance Criteria Traceability Matrix">
    <table>
      <row header="true">
        <cell>Acceptance Criterion</cell>
        <cell>Scenario IDs</cell>
        <cell>Coverage</cell>
      </row>
      <row>
        <cell>AC-01: [description]</cell>
        <cell>SCENARIO-001, SCENARIO-002</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-02: [description]</cell>
        <cell>SCENARIO-003</cell>
        <cell>Covered</cell>
      </row>
    </table>
    <rule>Every acceptance criterion from [doc-index]-requirements.md MUST appear in this matrix with at least one scenario. Zero uncovered items allowed.</rule>
  </section>

  <section title="Coverage Summary">
    <list type="unordered">
      <item>**Total Acceptance Criteria:** [X]</item>
      <item>**Covered by Scenarios:** [Y]</item>
      <item>**Uncovered:** [Z] (must be 0)</item>
      <item>**Total Scenarios:** [N]</item>
      <item>**Scenarios per AC (avg):** [N/X]</item>
    </list>
  </section>

  <section title="Quality Validation">

    <subsection title="Per-Scenario Checks">
      <table>
        <row header="true">
          <cell>Scenario</cell>
          <cell>Q1</cell>
          <cell>Q2</cell>
          <cell>Q3</cell>
          <cell>Q4</cell>
          <cell>Q5</cell>
          <cell>Q6</cell>
          <cell>Q7</cell>
          <cell>Q8</cell>
          <cell>Q9</cell>
          <cell>Q10</cell>
          <cell>Pass</cell>
        </row>
        <row>
          <cell>SCENARIO-001</cell>
          <cell>Y</cell>
          <cell>Y</cell>
          <cell>Y</cell>
          <cell>Y</cell>
          <cell>Y</cell>
          <cell>Y</cell>
          <cell>Y</cell>
          <cell>Y</cell>
          <cell>Y</cell>
          <cell>Y</cell>
          <cell>Y</cell>
        </row>
      </table>
      <paragraph>
        Q1: Single Behavior | Q2: Declarative Style | Q3: Business Language |
        Q4: Meaningful Title | Q5: Independence | Q6: Concise Steps |
        Q7: Concrete Examples | Q8: AC Traceability | Q9: No Implementation Leakage |
        Q10: Testable Outcome
      </paragraph>
    </subsection>

    <subsection title="Per-Document Checks">
      <checklist>
        <item status="pass">D1: All AC covered</item>
        <item status="pass">D2: Scenario count within limits (3-8 per area)</item>
        <item status="pass">D3: Traceability matrix complete</item>
        <item status="pass">D4: All IDs unique</item>
        <item status="pass">D5: Priorities assigned</item>
        <item status="pass">D6: Happy paths first</item>
        <item status="pass">D7: Error cases included</item>
        <item status="pass">D8: No duplicates</item>
      </checklist>
    </subsection>

  </section>

</document>
```

## Gate Compliance Notes

The rendered document MUST satisfy `gate-bdd.sh`:

| # | Gate Check | How This Template Satisfies It |
|---|-----------|-------------------------------|
| 1 | SCENARIO-IDs present | `<scenario id="SCENARIO-XXX">` renders `### SCENARIO-XXX:` headings |
| 2 | Given/When/Then at line start | `<paragraph>` blocks contain `**Given**`, `**When**`, `**Then**`, `**And**` at line start |
| 3 | AC references present | `<field name="acceptance-criteria">AC-XX</field>` renders AC-ID references |
| 4 | Scenario count >= AC count | Template cadence (3-5 per area) ensures sufficient scenarios |
| 5 | Minimum 300 characters | Full template expansion produces well above 300 characters |

## Scenario Writing Rules

- **Declarative style only**: Describe WHAT behavior is expected, not HOW
- **One behavior per scenario**: Each `<scenario>` tests exactly one Given/When/Then pair
- **Business language**: Use domain terminology; never use banned words (click, navigate, button, field, page, URL, endpoint, database, API, etc.)
- **Scenario cadence**: 3-5 per feature area; stop at 8
