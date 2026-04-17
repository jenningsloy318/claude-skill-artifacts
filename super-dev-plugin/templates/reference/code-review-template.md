---
name: code-review-template
description: Structured code review report template with severity-graded findings, specification validation, BDD scenario coverage, and deterministic verdict logic.
doc-type: code-review
gate-profile: code-review
---

<document type="code-review">

<metadata>
  <field name="title">Code Review: [Feature/Fix Name]</field>
  <field name="date">[timestamp]</field>
  <field name="reviewer">super-dev:code-reviewer</field>
  <field name="secondary-reviewer">code-review-expert (if available)</field>
  <field name="status">[Approved / Approved with Comments / Changes Requested / Blocked]</field>
  <field name="base-sha">[sha or N/A]</field>
  <field name="head-sha">[sha or N/A]</field>
</metadata>

<section title="Summary Statistics">
  <table>
    <row header="true">
      <cell>Severity</cell>
      <cell>Count</cell>
    </row>
    <row><cell>Critical</cell><cell>X</cell></row>
    <row><cell>High</cell><cell>X</cell></row>
    <row><cell>Medium</cell><cell>X</cell></row>
    <row><cell>Low</cell><cell>X</cell></row>
    <row><cell>Info</cell><cell>X</cell></row>
  </table>

  <table>
    <row header="true">
      <cell>Dimension</cell>
      <cell>Issues</cell>
    </row>
    <row><cell>Correctness</cell><cell>X</cell></row>
    <row><cell>Security</cell><cell>X</cell></row>
    <row><cell>Performance</cell><cell>X</cell></row>
    <row><cell>Maintainability</cell><cell>X</cell></row>
    <row><cell>Testability</cell><cell>X</cell></row>
    <row><cell>Error Handling</cell><cell>X</cell></row>
    <row><cell>Consistency</cell><cell>X</cell></row>
    <row><cell>Accessibility</cell><cell>X</cell></row>
  </table>
</section>

<section title="Specification Validation">
  <table>
    <row header="true">
      <cell>Criterion</cell>
      <cell>Status</cell>
      <cell>Evidence</cell>
    </row>
    <row>
      <cell>AC-1: [description]</cell>
      <cell>Met/Not Met/Partial</cell>
      <cell>[file:line]</cell>
    </row>
    <row>
      <cell>AC-2: [description]</cell>
      <cell>Met/Not Met/Partial</cell>
      <cell>[file:line]</cell>
    </row>
  </table>

  <subsection title="Non-Goals Check">
    <checklist>
      <item checked="true">NG-1: [non-goal] - Not implemented (correct)</item>
      <item checked="false">NG-2: [non-goal] - Implemented (issue - see F-XXX)</item>
    </checklist>
  </subsection>
</section>

<section title="BDD Scenario Coverage">
  <table>
    <row header="true">
      <cell>Scenario ID</cell>
      <cell>Title</cell>
      <cell>Test Reference</cell>
      <cell>Status</cell>
    </row>
    <row>
      <cell>SCENARIO-001</cell>
      <cell>[title]</cell>
      <cell>[test file:line or test name]</cell>
      <cell>Covered / Missing</cell>
    </row>
  </table>

  <paragraph label="Coverage">[M/N] scenarios covered</paragraph>
  <paragraph label="Gate">PASS / FAIL</paragraph>
</section>

<section title="Findings">
  <rule name="critical-text-guard">
    NEVER use `**Critical**` as bold text inside finding bodies. The gate regex `\*\*Critical\*\*` scans the ENTIRE file — any `**Critical**` text outside the summary table triggers CR3 FAIL. The `### Critical` section heading is safe (no bold markers). Use `label` attributes on `<paragraph>` tags for field labels (e.g., `<paragraph label="Issue">`).
  </rule>
  <subsection title="Critical">
    <finding id="F-001" dimension="[Dimension]" location="file:line">
      <paragraph label="Issue">[description]</paragraph>
      <paragraph label="Suggestion">[concrete fix]</paragraph>
      <paragraph label="Rationale">[why it matters]</paragraph>
    </finding>
  </subsection>

  <subsection title="High">
    <finding id="F-002" dimension="[Dimension]" location="file:line">
      <paragraph label="Issue">[description]</paragraph>
      <paragraph label="Suggestion">[fix]</paragraph>
      <paragraph label="Rationale">[why]</paragraph>
    </finding>
  </subsection>

  <subsection title="Medium">
    <finding id="F-XXX" dimension="[Dimension]" location="file:line">
      <paragraph label="Issue">[description]</paragraph>
      <paragraph label="Suggestion">[fix]</paragraph>
      <paragraph label="Rationale">[why]</paragraph>
    </finding>
  </subsection>

  <subsection title="Low">
    <finding id="F-XXX" dimension="[Dimension]" location="file:line">
      <paragraph label="Issue">[description]</paragraph>
      <paragraph label="Suggestion">[fix]</paragraph>
      <paragraph label="Rationale">[why]</paragraph>
    </finding>
  </subsection>

  <subsection title="Info">
    <finding id="F-XXX" dimension="[Dimension]" location="file:line">
      <paragraph label="Issue">[description]</paragraph>
      <paragraph label="Suggestion">[fix]</paragraph>
      <paragraph label="Rationale">[why]</paragraph>
    </finding>
  </subsection>
</section>

<section title="Strengths">
  <list type="unordered">
    <item>[Specific good patterns with file:line references]</item>
  </list>
</section>

<section title="Recommendations">
  <list type="unordered">
    <item>[Non-blocking improvements and future considerations]</item>
  </list>
</section>

<section title="Verdict">
  <field name="verdict">[Approved / Approved with Comments / Changes Requested / Blocked]</field>
  <paragraph label="Reasoning">[brief technical assessment]</paragraph>
  <paragraph label="Blocking Issues">[F-XXX IDs or "None"]</paragraph>
  <rule name="verdict-consistency">
    The verdict here MUST exactly match the `status` field in the metadata section above. The gate takes `head -1` of the first matching line — if metadata and verdict disagree, the gate judges by whichever renders first (metadata). Always keep them identical.
  </rule>
</section>

<rule name="verdict-logic">
  Critical findings exist --> Blocked.
  High findings greater than 3, or any AC not met, or scenario coverage less than 100% --> Changes Requested.
  High or Medium findings exist --> Approved with Comments.
  Otherwise --> Approved.
</rule>

</document>
