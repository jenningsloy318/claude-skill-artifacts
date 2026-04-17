---
name: handoff-template
description: Structured handoff document template for passing work between AI agent sessions. Designed for machine consumption with prioritized unfinished items and concrete next steps.
doc-type: handoff
gate-profile: none
---

<document type="handoff">

<metadata>
  <field name="title">Handoff: [Feature/Fix Name]</field>
  <field name="date">[timestamp]</field>
  <field name="spec">specification/[spec-index]-[spec-name]</field>
  <field name="status">[Complete / Partial -- specify what is missing]</field>
  <field name="commits">[N] commits on branch [branch-name]</field>
</metadata>

<section title="Objective">
  <paragraph>[1-2 sentences: what problem, what deliverable, what "done" means]</paragraph>
  <reference target="[doc-index]-requirements.md" section="Acceptance Criteria">
    AC reference: See requirements document Acceptance Criteria section
  </reference>
</section>

<section title="Progress">
  <table>
    <row header="true">
      <cell>Phase</cell>
      <cell>Status</cell>
      <cell>Notes</cell>
    </row>
    <row>
      <cell>Requirements</cell>
      <cell>[done/partial]</cell>
      <cell></cell>
    </row>
    <row>
      <cell>BDD Scenarios</cell>
      <cell>[done/partial]</cell>
      <cell></cell>
    </row>
    <row>
      <cell>Research</cell>
      <cell>[done/partial/skipped]</cell>
      <cell></cell>
    </row>
    <row>
      <cell>Specification</cell>
      <cell>[done/partial]</cell>
      <cell></cell>
    </row>
    <row>
      <cell>Implementation</cell>
      <cell>[done/partial]</cell>
      <cell></cell>
    </row>
    <row>
      <cell>Code Review</cell>
      <cell>[verdict]</cell>
      <cell></cell>
    </row>
    <row>
      <cell>Adversarial Review</cell>
      <cell>[verdict]</cell>
      <cell></cell>
    </row>
    <row>
      <cell>Documentation</cell>
      <cell>[done/partial]</cell>
      <cell></cell>
    </row>
  </table>
</section>

<section title="Key Decisions">
  <list type="unordered">
    <item name="[Decision 1]">[choice] -- why: [1-line rationale]</item>
    <item name="[Decision 2]">[choice] -- why: [1-line rationale]</item>
  </list>
  <reference target="[doc-index]-specification.md" section="[N]">
    Full context in specification document Section [N]
  </reference>
</section>

<section title="Unfinished Items">
  <subsection title="P0: Critical">
    <list type="unordered">
      <item>[Item] -- See [source file/section]</item>
    </list>
  </subsection>
  <subsection title="P1: Important">
    <list type="unordered">
      <item>[Item] -- See [source file/section]</item>
    </list>
  </subsection>
  <subsection title="P2: Nice-to-Have">
    <list type="unordered">
      <item>[Item]</item>
    </list>
  </subsection>
</section>

<section title="Risks and Gotchas">
  <list type="unordered">
    <item>[Risk 1]: [1-line description + what to watch for]</item>
    <item>[Risk 2]: [1-line description]</item>
  </list>
  <paragraph>Directions NOT worth pursuing: [approach already tried and rejected, with reason]</paragraph>
</section>

<section title="Read These First">
  <list type="ordered">
    <item><code>[path]</code> -- [why this file matters, 5 words]</item>
    <item><code>[path]</code> -- [why]</item>
    <item><code>[path]</code> -- [why]</item>
  </list>
</section>

<section title="Next Steps">
  <list type="ordered">
    <item>[Concrete action -- e.g., "Run `make test` to verify green build"]</item>
    <item>[Concrete action -- e.g., "Address P0 item: [description]"]</item>
    <item>[Concrete action]</item>
    <item>[Concrete action]</item>
    <item>[Concrete action]</item>
  </list>
</section>

<rule>Under 300 lines total. No section exceeds 30 lines.</rule>
<rule>No copy-pasted content from spec artifacts.</rule>
<rule>Written FOR an AI agent -- concrete paths, commands, and IDs only.</rule>

</document>
