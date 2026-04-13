---
name: spec-review-template
description: Structured specification review report template with 8-dimension analysis, grounding verification, and deterministic verdict logic.
doc-type: spec-review
gate-profile: spec-review
---

<document type="spec-review">

<metadata>
  <field name="title">Specification Review: [Feature/Fix Name]</field>
  <field name="date">[timestamp]</field>
  <field name="reviewer">super-dev:spec-reviewer</field>
  <field name="status">[Approved / Approved with Revisions / Revisions Needed / Rejected]</field>
  <field name="spec-size">[Small / Medium / Large]</field>
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
      <cell>Status</cell>
    </row>
    <row><cell>D1: Completeness</cell><cell>X</cell><cell>Pass/Fail</cell></row>
    <row><cell>D2: Consistency</cell><cell>X</cell><cell>Pass/Fail</cell></row>
    <row><cell>D3: Feasibility</cell><cell>X</cell><cell>Pass/Fail</cell></row>
    <row><cell>D4: Testability</cell><cell>X</cell><cell>Pass/Fail</cell></row>
    <row><cell>D5: Traceability</cell><cell>X</cell><cell>Pass/Fail</cell></row>
    <row><cell>D6: Grounding</cell><cell>X</cell><cell>Pass/Fail</cell></row>
    <row><cell>D7: Complexity Fitness</cell><cell>X</cell><cell>Pass/Fail</cell></row>
    <row><cell>D8: Ambiguity Detection</cell><cell>X</cell><cell>Pass/Fail</cell></row>
  </table>
</section>

<section title="D1: Completeness">
  <checklist>
    - [ ] All ACs from requirements have corresponding spec sections
    - [ ] All SCENARIO-XXX referenced or addressed
    - [ ] Error handling specified per operation
    - [ ] NFRs addressed
    - [ ] Edge cases accounted for
  </checklist>
  <findings>
    [SR-001 format findings or "No issues found"]
  </findings>
</section>

<section title="D2: Consistency">
  <checklist>
    - [ ] Data model names consistent across sections
    - [ ] API paths match between spec and plan
    - [ ] Terminology consistent
    - [ ] Task list aligns with spec sections
  </checklist>
  <findings>
    [SR-002+ format findings or "No issues found"]
  </findings>
</section>

<section title="D3: Feasibility">
  <checklist>
    - [ ] Architecture fits project patterns
    - [ ] Stack capabilities sufficient
    - [ ] No circular dependencies
    - [ ] External dependencies available
  </checklist>
  <findings>
    [findings or "No issues found"]
  </findings>
</section>

<section title="D4: Testability">
  <checklist>
    - [ ] ACs have measurable pass/fail criteria
    - [ ] Testing strategy specifies concrete types
    - [ ] Performance thresholds are numeric
    - [ ] Error scenarios have testable behaviors
  </checklist>
  <findings>
    [findings or "No issues found"]
  </findings>
</section>

<section title="D5: Traceability">
  <checklist>
    - [ ] AC → spec section mapping complete
    - [ ] SCENARIO-XXX → task mapping complete
    - [ ] No orphan tasks or spec sections
    - [ ] Cross-reference IDs consistent
  </checklist>
  <findings>
    [findings or "No issues found"]
  </findings>
</section>

<section title="D6: Grounding">
  <verification-results>
    <table>
      <row header="true">
        <cell>Reference</cell>
        <cell>Type</cell>
        <cell>Status</cell>
      </row>
      <row>
        <cell>[file/API/dependency]</cell>
        <cell>[file/function/package/config]</cell>
        <cell>[Verified / Not Found / Hallucinated]</cell>
      </row>
    </table>
  </verification-results>
  <findings>
    [findings or "All references verified"]
  </findings>
</section>

<section title="D7: Complexity Fitness">
  <checklist>
    - [ ] File count proportional to scope
    - [ ] Abstractions justified (2+ implementors)
    - [ ] No unnecessary patterns
    - [ ] Simplest viable approach chosen
  </checklist>
  <findings>
    [findings or "No issues found"]
  </findings>
</section>

<section title="D8: Ambiguity Detection">
  <checklist>
    - [ ] API schemas fully defined
    - [ ] State transitions explicit
    - [ ] Error responses specified
    - [ ] Default values stated
  </checklist>
  <findings>
    [findings or "No issues found"]
  </findings>
</section>

<section title="Findings Detail">
  [For each finding:]

  **SR-XXX** | [Dimension] | [Severity]
  **Section:** [spec section where issue found]
  **Issue:** [what is wrong]
  **Impact:** [what will go wrong during implementation if not fixed]
  **Recommendation:** [specific fix]
</section>

<section title="Verdict">
  **Verdict:** [Approved / Approved with Revisions / Revisions Needed / Rejected]

  **Verdict Logic:**
  - Critical findings: [count]
  - High findings: [count]
  - Dimensions with issues: [list]
  - Grounding failures: [count]

  **Gate Compliance:**
  - Verdict determination follows deterministic logic:
    - Critical > 0 → Rejected
    - High > 3 OR any dimension 0% → Revisions Needed
    - High/Medium exist → Approved with Revisions
    - Else → Approved
</section>

</document>
