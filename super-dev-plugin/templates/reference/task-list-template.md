---
name: task-list-template
description: XML-tagged template for task tracking across implementation milestones. Used by docs-executor agent to maintain task completion status, file change tracking, and progress reporting throughout the development lifecycle.
doc-type: task-list
gate-profile: gate-docs-drift.sh
---

```xml
<document type="task-list">

  <metadata>
    <field name="title">Task List: [Feature/Fix Name]</field>
    <field name="date">[timestamp]</field>
    <field name="author">super-dev:docs-executor</field>
    <field name="status">In Progress | Complete</field>
    <field name="spec-reference">[path to [doc-index]-specification.md]</field>
    <field name="plan-reference">[path to [doc-index]-implementation-plan.md]</field>
    <field name="total-tasks">[total count]</field>
    <field name="completed-tasks">[completed count]</field>
  </metadata>

  <section title="Tasks">

    <subsection title="Phase 1: [Phase/Milestone Name]">
      <checklist>
        <item status="done" domain="[rust|go|frontend|backend|ios|android|windows|macos|mixed]">
          **T1.1** [Task description]
          - Completed: [timestamp]
          - Files: [files modified]
          - Dependencies: None
          - Notes: [any notes]
        </item>
        <item status="done" domain="[rust|go|frontend|backend|ios|android|windows|macos|mixed]">
          **T1.2** [Task description]
          - Completed: [timestamp]
          - Files: [files modified]
          - Dependencies: T1.1
          - Notes: [any notes]
        </item>
        <item status="in-progress" domain="[rust|go|frontend|backend|ios|android|windows|macos|mixed]">
          **T1.3** [Task description]
          - Started: [timestamp]
          - Files: [files being modified]
          - Dependencies: T1.2
          - Notes: [any notes]
        </item>
        <item status="pending" domain="[rust|go|frontend|backend|ios|android|windows|macos|mixed]">
          **T1.4** [Task description]
          - Dependencies: None
        </item>
      </checklist>
    </subsection>

    <subsection title="Phase 2: [Phase/Milestone Name]">
      <checklist>
        <item status="pending" domain="[rust|go|frontend|backend|ios|android|windows|macos|mixed]">
          **T2.1** [Task description]
          - Dependencies: T1.2
        </item>
        <item status="pending" domain="[rust|go|frontend|backend|ios|android|windows|macos|mixed]">
          **T2.2** [Task description]
          - Dependencies: T2.1
        </item>
      </checklist>
    </subsection>

    <!-- Repeat for each phase/milestone from the implementation plan. -->

  </section>

  <section title="Progress">
    <list type="unordered">
      <item>**Completed:** [X]/[Y] tasks</item>
      <item>**Current:** [Task ID currently in progress]</item>
      <item>**Status:** In Progress | Complete</item>
      <item>**Blocked:** [Task ID if any] - [reason]</item>
    </list>
  </section>

  <section title="File Change Tracking">
    <table>
      <row header="true">
        <cell>File</cell>
        <cell>Action</cell>
        <cell>Task</cell>
        <cell>Description</cell>
      </row>
      <row>
        <cell>[path/to/file]</cell>
        <cell>Created | Modified | Deleted</cell>
        <cell>[T1.1]</cell>
        <cell>[Brief description of changes]</cell>
      </row>
      <row>
        <cell>[path/to/file]</cell>
        <cell>Created | Modified | Deleted</cell>
        <cell>[T1.2]</cell>
        <cell>[Brief description of changes]</cell>
      </row>
    </table>
  </section>

  <section title="Technical Decisions Log">
    <list type="ordered">
      <item>
        **[Decision]** (Task [T1.1])
        - Rationale: [why this approach was chosen]
        - Alternatives considered: [what else was evaluated]
      </item>
      <item>
        **[Decision]** (Task [T2.1])
        - Rationale: [why this approach was chosen]
        - Alternatives considered: [what else was evaluated]
      </item>
    </list>
  </section>

  <section title="Challenges and Resolutions">
    <list type="ordered">
      <item>
        **[Challenge]** (Task [T1.2])
        - Impact: [what was affected]
        - Resolution: [how it was resolved]
      </item>
    </list>
  </section>

  <section title="Specification Deviations">
    <paragraph>Document any implementation choices that diverge from the original specification:</paragraph>
    <list type="unordered">
      <item>
        **[Section X.Y]** (Task [T1.3])
        <quote>[What the spec originally said]</quote>
        Changed to: [What was actually implemented]
        Reason: [Why the change was necessary]
      </item>
    </list>
    <paragraph>If no deviations: "None -- implementation matches specification."</paragraph>
  </section>

</document>
```

## Rendering Rules

When rendering this template to markdown:

| XML Element | Markdown Rendering |
|-------------|-------------------|
| `<item status="done">` | `- [x]` checkbox (completed) |
| `<item status="in-progress">` | `- [ ]` checkbox with "(in progress)" annotation |
| `<item status="pending">` | `- [ ]` checkbox (pending) |
| `<table>` | Standard markdown table |
| `<quote>` | `> blockquote` |

## Update Protocol

1. **After each task completion:** Update the corresponding `<item>` status from `pending` to `done`, add completion timestamp, files modified, and notes
2. **After each phase completion:** Update `<section title="Progress">` totals
3. **After code review:** Incorporate any findings into the Technical Decisions Log or Challenges sections
4. **Final pass:** Ensure File Change Tracking table is complete and all statuses are accurate
