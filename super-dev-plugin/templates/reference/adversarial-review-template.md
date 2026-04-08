---
name: adversarial-review-template
description: Structured adversarial review template with destructive action gate, multi-lens attack vectors, and deterministic verdict logic for security and correctness validation.
doc-type: adversarial-review
gate-profile: adversarial-review
---

<document type="adversarial-review">

<metadata>
  <field name="title">Adversarial Review: [Feature/Fix Name]</field>
  <field name="date">[timestamp]</field>
  <field name="reviewer">super-dev:adversarial-reviewer</field>
  <field name="verdict">PASS | CONTESTED | REJECT</field>
</metadata>

<section title="Intent">
  <paragraph>[What the author is trying to achieve]</paragraph>
</section>

<section title="Verdict Summary">
  <paragraph>[One-line summary]</paragraph>
</section>

<section title="Change Scope">
  <table>
    <row header="true">
      <cell>Metric</cell>
      <cell>Value</cell>
    </row>
    <row><cell>Lines changed</cell><cell>X</cell></row>
    <row><cell>Files changed</cell><cell>X</cell></row>
    <row><cell>Size classification</cell><cell>Small/Medium/Large</cell></row>
    <row><cell>Reviewers activated</cell><cell>Skeptic [+ Architect] [+ Minimalist]</cell></row>
    <row><cell>Attack vectors applied</cell><cell>V1-V6, V8 [+ V7]</cell></row>
  </table>
</section>

<section title="Destructive Action Gate">
  <field name="gate-verdict">CLEAR | BLOCKED</field>
  <rule name="halt-placeholder-rendering">
    CRITICAL: The verdict metadata field MUST render BEFORE this section in the output file. The gate regex `grep -iE '(PASS|CONTESTED|REJECT|HALT)'` takes `head -1`, so the verdict line must appear first. Also: replace placeholder `CLEAR/HALT` with the ACTUAL value (either `CLEAR` or `HALT`, never both on one line). Leaving `CLEAR/HALT` as literal text causes the gate to match "HALT" in the table body.
  </rule>

  <table>
    <row header="true">
      <cell>Check</cell>
      <cell>Status</cell>
      <cell>Evidence</cell>
    </row>
    <row>
      <cell>Data Destruction (DAT)</cell>
      <cell>[CLEAR or HALT]</cell>
      <cell>[details or file:line]</cell>
    </row>
    <row>
      <cell>Irreversible State (IRR)</cell>
      <cell>[CLEAR or HALT]</cell>
      <cell>[details or file:line]</cell>
    </row>
    <row>
      <cell>Production Impact (PRD)</cell>
      <cell>[CLEAR or HALT]</cell>
      <cell>[details or file:line]</cell>
    </row>
    <row>
      <cell>Permission Escalation (PRM)</cell>
      <cell>[CLEAR or HALT]</cell>
      <cell>[details or file:line]</cell>
    </row>
    <row>
      <cell>Secret Operations (SEC)</cell>
      <cell>[CLEAR or HALT]</cell>
      <cell>[details or file:line]</cell>
    </row>
  </table>

  <subsection title="HALT Findings">
    <paragraph>[DAG-XXX entries if any, or "None"]</paragraph>
  </subsection>
</section>

<section title="Findings">
  <paragraph>Ordered by severity: HALT then high then medium then low. Each finding tagged with Lens/Vector.</paragraph>

  <subsection title="High">
    <finding id="AF-001" lens="Skeptic" vector="V2" location="file:line">
      <paragraph><strong>Issue:</strong> [description]</paragraph>
      <paragraph><strong>Recommendation:</strong> [concrete action, not vague advice]</paragraph>
    </finding>
  </subsection>

  <subsection title="Medium">
    <finding id="AF-002" lens="Architect" vector="V7" location="file:line">
      <paragraph><strong>Issue:</strong> [description]</paragraph>
      <paragraph><strong>Recommendation:</strong> [concrete action]</paragraph>
    </finding>
  </subsection>

  <subsection title="Low">
    <finding id="AF-003" lens="Minimalist" vector="V7" location="file:line">
      <paragraph><strong>Issue:</strong> [description]</paragraph>
      <paragraph><strong>Recommendation:</strong> [concrete action]</paragraph>
    </finding>
  </subsection>
</section>

<section title="Vector Coverage">
  <table>
    <row header="true">
      <cell>Vector</cell>
      <cell>Lens</cell>
      <cell>Findings</cell>
      <cell>Highest Severity</cell>
    </row>
    <row>
      <cell>V1: False Assumptions</cell>
      <cell>Skeptic</cell>
      <cell>0</cell>
      <cell>--</cell>
    </row>
    <row>
      <cell>V2: Edge Cases</cell>
      <cell>Skeptic</cell>
      <cell>0</cell>
      <cell>--</cell>
    </row>
    <row>
      <cell>V3: Failure Modes</cell>
      <cell>Skeptic</cell>
      <cell>0</cell>
      <cell>--</cell>
    </row>
    <row>
      <cell>V4: Adversarial Input</cell>
      <cell>Skeptic</cell>
      <cell>0</cell>
      <cell>--</cell>
    </row>
    <row>
      <cell>V5: Safety and Compliance</cell>
      <cell>Skeptic</cell>
      <cell>0</cell>
      <cell>--</cell>
    </row>
    <row>
      <cell>V6: Grounding Audit</cell>
      <cell>Skeptic</cell>
      <cell>0</cell>
      <cell>--</cell>
    </row>
    <row>
      <cell>V7: Dependencies</cell>
      <cell>Architect</cell>
      <cell>0</cell>
      <cell>--</cell>
    </row>
    <row>
      <cell>V8: Behavior Coverage</cell>
      <cell>Skeptic</cell>
      <cell>0</cell>
      <cell>--</cell>
    </row>
  </table>
</section>

<section title="What Went Well">
  <list type="unordered">
    <item>[1-3 things the reviewers found no issue with]</item>
  </list>
</section>

<section title="Lead Judgment">
  <paragraph>For each finding: accept or reject with a one-line rationale.</paragraph>
  <list type="unordered">
    <item><strong>AF-001:</strong> [accept/reject] -- [rationale]</item>
    <item><strong>AF-002:</strong> [accept/reject] -- [rationale]</item>
    <item><strong>AF-003:</strong> [accept/reject] -- [rationale]</item>
  </list>
</section>

<rule name="verdict-logic">
  HALT findings present --> CONTESTED minimum; multiple HALTs --> REJECT.
  No high-severity findings --> PASS.
  High-severity with disagreement among lenses --> CONTESTED.
  High-severity with consensus among lenses --> REJECT.
</rule>

</document>
