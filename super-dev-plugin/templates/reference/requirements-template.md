---
name: requirements-template
description: XML-tagged template for structured requirements documents. Used by requirements-clarifier agent to produce consistent, implementation-ready requirements with root cause analysis, acceptance criteria, and solution options.
doc-type: requirements
gate-profile: gate-requirements.sh
---

```xml
<document type="requirements">

  <metadata>
    <field name="title">Requirements: [Feature/Fix Name]</field>
    <field name="date">[timestamp]</field>
    <field name="author">super-dev:requirements-clarifier</field>
    <field name="type">Feature | Bug Fix | Improvement</field>
    <field name="priority">High | Medium | Low</field>
    <field name="status">Draft | Review | Approved</field>
  </metadata>

  <section title="Executive Summary">
    <paragraph>[2-3 sentence overview of the real need, not just the surface request]</paragraph>
  </section>

  <section title="The Real Need (Root Cause Analysis)">

    <subsection title="Surface Request">
      <paragraph>[What the user explicitly asked for]</paragraph>
    </subsection>

    <subsection title="5 Whys Analysis">
      <list type="ordered">
        <item>Why: [First why and answer]</item>
        <item>Why: [Second why and answer]</item>
        <item>Why: [Third why and answer]</item>
        <item>Why: [Fourth why and answer]</item>
        <item>Why: [Root cause identified]</item>
      </list>
    </subsection>

    <subsection title="Job to Be Done">
      <paragraph>
        **When** [situation/context]
        **I want to** [motivation/goal]
        **So I can** [expected outcome]
      </paragraph>

      <paragraph>**Job Type:**</paragraph>
      <list type="unordered">
        <item>Functional: [practical task]</item>
        <item>Emotional: [how they want to feel]</item>
        <item>Social: [how they want to be perceived]</item>
      </list>
    </subsection>

  </section>

  <section title="Workflow Context">

    <subsection title="Current State">
      <paragraph>[How the user currently accomplishes this]</paragraph>
    </subsection>

    <subsection title="Pain Points">
      <list type="unordered">
        <item>[Pain point 1]</item>
        <item>[Pain point 2]</item>
      </list>
    </subsection>

    <subsection title="Workflow Map">
      <diagram>
[Before] --> [Requested Action] --> [After]
                    |
                    v
            [Related Actions]
      </diagram>
    </subsection>

    <subsection title="Stakeholders">
      <list type="unordered">
        <item>[Who else is involved or affected]</item>
      </list>
    </subsection>

  </section>

  <section title="Requirements">

    <subsection title="Functional Requirements">
      <list type="ordered">
        <item>[Requirement 1]</item>
        <item>[Requirement 2]</item>
      </list>
    </subsection>

    <subsection title="Non-Functional Requirements">
      <list type="unordered">
        <item>Performance: [requirements]</item>
        <item>Security: [requirements]</item>
        <item>Accessibility: [requirements]</item>
      </list>
    </subsection>

    <subsection title="Anticipated Downstream Needs">
      <paragraph>Based on workflow analysis:</paragraph>
      <list type="unordered">
        <item>[Anticipated need 1]: [rationale]</item>
        <item>[Anticipated need 2]: [rationale]</item>
      </list>
    </subsection>

  </section>

  <section title="Proposed Solution Options">

    <option id="1" label="Minimum Viable">
      <paragraph>[Description of simplest solution]</paragraph>
      <list type="unordered">
        <item>Pros: [benefits]</item>
        <item>Cons: [limitations]</item>
      </list>
    </option>

    <option id="2" label="Recommended">
      <paragraph>[Description of recommended solution that addresses root need]</paragraph>
      <list type="unordered">
        <item>Pros: [benefits]</item>
        <item>Cons: [limitations]</item>
      </list>
    </option>

    <option id="3" label="Comprehensive">
      <paragraph>[Description of full-featured solution]</paragraph>
      <list type="unordered">
        <item>Pros: [benefits]</item>
        <item>Cons: [limitations]</item>
      </list>
    </option>

  </section>

  <section title="Impact Assessment">

    <subsection title="Business Outcome">
      <paragraph>[What business goal does this support?]</paragraph>
    </subsection>

    <subsection title="Success Metrics">
      <list type="unordered">
        <item>[Metric 1]: [target]</item>
        <item>[Metric 2]: [target]</item>
      </list>
    </subsection>

    <subsection title="Behavior Change Expected">
      <paragraph>[How will user behavior change after implementation?]</paragraph>
    </subsection>

  </section>

  <section title="Technical Considerations">

    <subsection title="Integration Points">
      <list type="unordered">
        <item>[System/API 1]</item>
        <item>[System/API 2]</item>
      </list>
    </subsection>

    <subsection title="Technical Constraints">
      <list type="unordered">
        <item>[Constraint 1]</item>
        <item>[Constraint 2]</item>
      </list>
    </subsection>

    <subsection title="Design References">
      <list type="unordered">
        <item>[Links to designs if applicable]</item>
      </list>
    </subsection>

  </section>

  <section title="Assumptions">
    <list type="unordered">
      <item>[Assumption 1]: [rationale]</item>
      <item>[Assumption 2]: [rationale]</item>
    </list>
  </section>

  <section title="Open Questions">
    <list type="unordered">
      <item>[Question 1]</item>
      <item>[Question 2]</item>
    </list>
    <rule>Render as plain bullet items (- Question), NOT as checkboxes (- [ ] Question). Checkboxes here would inflate the AC count in gate-requirements.sh.</rule>
  </section>

  <section title="Acceptance Criteria">
    <checklist>
      <item status="open">**AC-01**: [Criterion 1]</item>
      <item status="open">**AC-02**: [Criterion 2]</item>
      <item status="open">**AC-03**: [Criterion 3]</item>
    </checklist>
    <rule>
      MANDATORY RENDERING: Each item MUST render as EITHER:
        (a) `- [ ] **AC-XX**: description` (checkbox format), OR
        (b) `- **AC-XX**: description` (AC-ID format)
      The gate regex requires `^\s*-\s*\[` OR `^\s*-\s*\*{0,2}AC-[0-9]`.
      Minimum 2 items required. Always produce 3+ items.
      AC-IDs must be sequential: AC-01, AC-02, AC-03, etc.
    </rule>
  </section>

  <section title="Recommendations">
    <paragraph>Based on the analysis, I recommend:</paragraph>
    <list type="ordered">
      <item>**Immediate**: [What to build now]</item>
      <item>**Next**: [What to consider for follow-up]</item>
      <item>**Future**: [What to keep in mind for roadmap]</item>
    </list>
  </section>

</document>
```

## Gate Compliance Notes

The rendered document MUST satisfy `gate-requirements.sh`:

| # | Gate Check | How This Template Satisfies It |
|---|-----------|-------------------------------|
| 1 | "acceptance criteria" text present | `<section title="Acceptance Criteria">` renders the heading |
| 2 | Minimum 2 acceptance criteria items | `<checklist>` contains 3+ `<item>` entries with `- [ ] **AC-XX**:` or `- **AC-XX**:` format |
| 3 | Non-functional keywords present | `<subsection title="Non-Functional Requirements">` includes performance, security, accessibility |
| 4 | Summary keyword present | `<section title="Executive Summary">` renders the heading |
| 5 | Minimum 500 characters | Full template expansion produces well above 500 characters |
