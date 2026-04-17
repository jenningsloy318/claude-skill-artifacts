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
    <item status="open">All ACs from requirements have corresponding spec sections</item>
    <item status="open">All SCENARIO-XXX referenced or addressed</item>
    <item status="open">Error handling specified per operation</item>
    <item status="open">NFRs addressed</item>
    <item status="open">Edge cases accounted for</item>
  </checklist>
  <findings>
    [SR-001 format findings or "No issues found"]
  </findings>
</section>

<section title="D2: Consistency">
  <checklist>
    <item status="open">Data model names consistent across sections</item>
    <item status="open">API paths match between spec and plan</item>
    <item status="open">Terminology consistent</item>
    <item status="open">Task list aligns with spec sections</item>
  </checklist>
  <findings>
    [SR-002+ format findings or "No issues found"]
  </findings>
</section>

<section title="D3: Feasibility">
  <checklist>
    <item status="open">Architecture fits project patterns</item>
    <item status="open">Stack capabilities sufficient</item>
    <item status="open">No circular dependencies</item>
    <item status="open">External dependencies available</item>
  </checklist>
  <findings>
    [findings or "No issues found"]
  </findings>
</section>

<section title="D4: Testability">
  <checklist>
    <item status="open">ACs have measurable pass/fail criteria</item>
    <item status="open">Testing strategy specifies concrete types</item>
    <item status="open">Performance thresholds are numeric</item>
    <item status="open">Error scenarios have testable behaviors</item>
  </checklist>
  <findings>
    [findings or "No issues found"]
  </findings>
</section>

<section title="D5: Traceability">
  <checklist>
    <item status="open">AC → spec section mapping complete</item>
    <item status="open">SCENARIO-XXX → task mapping complete</item>
    <item status="open">No orphan tasks or spec sections</item>
    <item status="open">Cross-reference IDs consistent</item>
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
    <item status="open">File count proportional to scope</item>
    <item status="open">Abstractions justified (2+ implementors)</item>
    <item status="open">No unnecessary patterns</item>
    <item status="open">Simplest viable approach chosen</item>
  </checklist>
  <findings>
    [findings or "No issues found"]
  </findings>
</section>

<section title="D8: Ambiguity Detection">
  <checklist>
    <item status="open">API schemas fully defined</item>
    <item status="open">State transitions explicit</item>
    <item status="open">Error responses specified</item>
    <item status="open">Default values stated</item>
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
