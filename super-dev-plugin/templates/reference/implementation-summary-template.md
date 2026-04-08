---
name: implementation-summary-template
description: Structured implementation summary template for tracking progress milestones, file changes, technical decisions, and spec change history during development execution.
doc-type: implementation-summary
gate-profile: none
---

<document type="implementation-summary">

<metadata>
  <field name="title">Implementation Summary: [Feature/Fix Name]</field>
  <field name="last-updated">[timestamp]</field>
  <field name="status">In Progress / Complete</field>
</metadata>

<section title="Progress Updates">

  <subsection title="[Timestamp] - Milestone X Complete">
    <paragraph><strong>Tasks Completed:</strong></paragraph>
    <list type="unordered">
      <task id="TX.1">[description]</task>
      <task id="TX.2">[description]</task>
    </list>

    <paragraph><strong>Files Changed:</strong></paragraph>
    <table>
      <row header="true">
        <cell>File</cell>
        <cell>Action</cell>
        <cell>Changes</cell>
      </row>
      <row>
        <cell>[path]</cell>
        <cell>Created/Modified/Deleted</cell>
        <cell>[description]</cell>
      </row>
    </table>

    <paragraph><strong>Technical Decisions:</strong></paragraph>
    <list type="ordered">
      <item>[Decision]: [rationale]</item>
    </list>

    <paragraph><strong>Challenges Encountered:</strong></paragraph>
    <list type="ordered">
      <item>[Challenge]: [solution]</item>
    </list>
  </subsection>

  <subsection title="[Earlier Timestamp] - Milestone Y Complete">
    <paragraph><strong>Tasks Completed:</strong></paragraph>
    <list type="unordered">
      <task id="TY.1">[description]</task>
    </list>

    <paragraph><strong>Files Changed:</strong></paragraph>
    <table>
      <row header="true">
        <cell>File</cell>
        <cell>Action</cell>
        <cell>Changes</cell>
      </row>
      <row>
        <cell>[path]</cell>
        <cell>Created/Modified/Deleted</cell>
        <cell>[description]</cell>
      </row>
    </table>

    <paragraph><strong>Technical Decisions:</strong></paragraph>
    <list type="ordered">
      <item>[Decision]: [rationale]</item>
    </list>

    <paragraph><strong>Challenges Encountered:</strong></paragraph>
    <list type="ordered">
      <item>[Challenge]: [solution]</item>
    </list>
  </subsection>

</section>

<section title="Spec Change Log">

  <subsection title="[UPDATED: YYYY-MM-DD] Section X.Y">
    <paragraph><strong>Original:</strong></paragraph>
    <quote>[What the spec originally said]</quote>

    <paragraph><strong>Changed to:</strong></paragraph>
    <quote>[New specification]</quote>

    <paragraph><strong>Reason:</strong></paragraph>
    <paragraph>[Why the change was necessary]</paragraph>

    <paragraph><strong>Impact:</strong></paragraph>
    <paragraph>[What else this affects]</paragraph>
  </subsection>

</section>

</document>
