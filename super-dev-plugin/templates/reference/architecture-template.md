---
name: architecture-template
description: XML-tagged template for architecture documentation. Agents load this template and fill in placeholders to produce consistently formatted architecture documents with module specs, ADRs, and technology decisions.
doc-type: architecture
gate-profile: null
---

<document type="architecture">

<metadata>
  <field name="title">Architecture: [Feature Name]</field>
  <field name="date">[timestamp]</field>
  <field name="author">Claude</field>
  <field name="status">Draft</field>
</metadata>

<section title="Overview">
  <paragraph>[2-3 sentences describing the architecture]</paragraph>
</section>

<section title="Architectural Drivers">
  <list type="unordered">
    <item>[Primary driver 1]</item>
    <item>[Primary driver 2]</item>
  </list>
</section>

<section title="Module Architecture">
  <diagram type="ascii">
[ASCII diagram showing modules and relationships]
  </diagram>
</section>

<section title="Module Specifications">

  <subsection title="Module 1: [Name]">
    <field name="purpose">[single sentence]</field>
    <list type="unordered" label="Responsibilities">
      <item>[responsibility 1]</item>
      <item>[responsibility 2]</item>
    </list>
    <field name="dependencies">[list of modules this depends on]</field>
    <field name="public-interface">
      <code lang="typescript">
interface [Name]Service {
  operation(): Promise&lt;Result&gt;;
}
      </code>
    </field>
  </subsection>

  <subsection title="Module 2: [Name]">
    <field name="purpose">[single sentence]</field>
    <list type="unordered" label="Responsibilities">
      <item>[responsibility 1]</item>
      <item>[responsibility 2]</item>
    </list>
    <field name="dependencies">[list of modules this depends on]</field>
    <field name="public-interface">
      <code lang="typescript">
interface [Name]Service {
  operation(): Promise&lt;Result&gt;;
}
      </code>
    </field>
  </subsection>

</section>

<section title="Data Flow">
  <diagram type="ascii">
[Sequence or flow diagram showing data movement]
  </diagram>
</section>

<section title="Technology Stack">
  <table>
    <row header="true">
      <cell>Layer</cell>
      <cell>Technology</cell>
      <cell>Rationale</cell>
    </row>
    <row>
      <cell>[layer]</cell>
      <cell>[tech]</cell>
      <cell>[why]</cell>
    </row>
  </table>
</section>

<section title="ADRs">
  <list type="unordered">
    <item>ADR-001: [Title] - [link]</item>
    <item>ADR-002: [Title] - [link]</item>
  </list>
</section>

<section title="Security Considerations">
  <list type="unordered">
    <item>[Security measure 1]</item>
    <item>[Security measure 2]</item>
  </list>
</section>

<section title="Performance Considerations">
  <list type="unordered">
    <item>[Performance measure 1]</item>
    <item>[Performance measure 2]</item>
  </list>
</section>

<section title="Future Considerations">
  <list type="unordered">
    <item>[Item for future - NOT to be implemented now]</item>
  </list>
</section>

</document>
