---
name: implementation-plan-template
description: XML-tagged template for phased implementation plans with milestones, dependency graphs, risk assessment, and rollback strategy. Used by planner agent and spec-writer agent to produce actionable, trackable implementation plans.
doc-type: implementation-plan
gate-profile: gate-spec-trace.sh
---

<document type="implementation-plan">

  <metadata>
    <field name="title">Implementation Plan: [Feature/Fix Name]</field>
    <field name="date">[timestamp]</field>
    <field name="author">super-dev:planner</field>
    <field name="status">Draft | Review | Approved</field>
    <field name="spec-reference">[path to [doc-index]-specification.md]</field>
    <field name="requirements-reference">[path to [doc-index]-requirements.md]</field>
  </metadata>

  <section title="Overview">
    <paragraph>[2-3 sentence summary of what will be implemented, why, and the high-level approach]</paragraph>

    <subsection title="Goals">
      <list type="unordered">
        <item>[Goal 1]</item>
        <item>[Goal 2]</item>
      </list>
    </subsection>

    <subsection title="Non-Goals">
      <list type="unordered">
        <item>[What is explicitly out of scope]</item>
      </list>
    </subsection>

    <subsection title="Assumptions">
      <list type="unordered">
        <item>[Assumption 1]: [rationale]</item>
        <item>[Assumption 2]: [rationale]</item>
      </list>
    </subsection>
  </section>

  <section title="Phased Milestones">

    <subsection title="Phase 1: [Phase Name]">
      <paragraph label="Objective">[What this phase achieves and why it comes first]</paragraph>

      <list type="ordered">
        <task id="T1.1" file="[path/to/file]" risk="Low | Medium | High" domain="[rust|go|frontend|backend|ios|android|windows|macos|mixed]">
          <paragraph label="Task Name">[Task Name]</paragraph>
          <paragraph>Action: [Specific action to take]</paragraph>
          <paragraph>Why: [Reason for this task]</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T1.2" file="[path/to/file]" risk="Low | Medium | High" domain="[rust|go|frontend|backend|ios|android|windows|macos|mixed]">
          <paragraph label="Task Name">[Task Name]</paragraph>
          <paragraph>Action: [Specific action to take]</paragraph>
          <paragraph>Why: [Reason for this task]</paragraph>
          <paragraph>Dependencies: T1.1</paragraph>
        </task>
      </list>

      <paragraph label="Deliverables"></paragraph>
      <list type="unordered">
        <item>[Deliverable 1: description]</item>
        <item>[Deliverable 2: description]</item>
      </list>

      <paragraph label="Exit Criteria"></paragraph>
      <checklist>
        <item status="open">[Criterion for Phase 1 completion]</item>
        <item status="open">[Criterion for Phase 1 completion]</item>
      </checklist>
    </subsection>

    <subsection title="Phase 2: [Phase Name]">
      <paragraph label="Objective">[What this phase achieves]</paragraph>

      <list type="ordered">
        <task id="T2.1" file="[path/to/file]" risk="Low | Medium | High" domain="[rust|go|frontend|backend|ios|android|windows|macos|mixed]">
          <paragraph label="Task Name">[Task Name]</paragraph>
          <paragraph>Action: [Specific action to take]</paragraph>
          <paragraph>Why: [Reason for this task]</paragraph>
          <paragraph>Dependencies: T1.2</paragraph>
        </task>
        <task id="T2.2" file="[path/to/file]" risk="Low | Medium | High" domain="[rust|go|frontend|backend|ios|android|windows|macos|mixed]">
          <paragraph label="Task Name">[Task Name]</paragraph>
          <paragraph>Action: [Specific action to take]</paragraph>
          <paragraph>Why: [Reason for this task]</paragraph>
          <paragraph>Dependencies: T2.1</paragraph>
        </task>
      </list>

      <paragraph label="Deliverables"></paragraph>
      <list type="unordered">
        <item>[Deliverable 1: description]</item>
      </list>

      <paragraph label="Exit Criteria"></paragraph>
      <checklist>
        <item status="open">[Criterion for Phase 2 completion]</item>
      </checklist>
    </subsection>

    <subsection title="Phase 3: [Phase Name]">
      <paragraph label="Objective">[What this phase achieves]</paragraph>

      <list type="ordered">
        <task id="T3.1" file="[path/to/file]" risk="Low | Medium | High" domain="[rust|go|frontend|backend|ios|android|windows|macos|mixed]">
          <paragraph label="Task Name">[Task Name]</paragraph>
          <paragraph>Action: [Specific action to take]</paragraph>
          <paragraph>Why: [Reason for this task]</paragraph>
          <paragraph>Dependencies: T2.1, T2.2</paragraph>
        </task>
      </list>

      <paragraph label="Deliverables"></paragraph>
      <list type="unordered">
        <item>[Deliverable 1: description]</item>
      </list>

      <paragraph label="Exit Criteria"></paragraph>
      <checklist>
        <item status="open">[Criterion for Phase 3 completion]</item>
      </checklist>
    </subsection>

    <!-- Add more phases as needed. Target 3-5 phases for complex work. -->

  </section>

  <section title="Dependency Graph">
    <diagram>
Phase 1 [rust]         Phase 2 [frontend]     Phase 3 [mixed]
+-----------+          +-----------+          +-----------+
|  T1.1     |--------->|  T2.1     |--------->|  T3.1     |
+-----------+          +-----------+          +-----------+
      |                      |
      v                      v
+-----------+          +-----------+
|  T1.2     |--------->|  T2.2     |
+-----------+          +-----------+
    </diagram>
    <paragraph>Arrows indicate "must complete before" relationships. Tasks within the same phase without arrows can run in parallel.</paragraph>
    <paragraph>Domain labels on phases indicate which specialist agent handles them. Cross-domain arrows (e.g., rust → frontend) signal staggered parallel spawning: upstream domain specialist starts first, downstream spawns after BUILD_COMPLETE.</paragraph>
  </section>

  <section title="Risk Assessment">
    <table>
      <row header="true">
        <cell>Risk</cell>
        <cell>Likelihood</cell>
        <cell>Impact</cell>
        <cell>Affected Tasks</cell>
        <cell>Mitigation</cell>
      </row>
      <row>
        <cell>[Risk description 1]</cell>
        <cell>Low | Medium | High</cell>
        <cell>Low | Medium | High</cell>
        <cell>[T1.1, T2.2]</cell>
        <cell>[How to mitigate or avoid]</cell>
      </row>
      <row>
        <cell>[Risk description 2]</cell>
        <cell>Low | Medium | High</cell>
        <cell>Low | Medium | High</cell>
        <cell>[T2.1]</cell>
        <cell>[How to mitigate or avoid]</cell>
      </row>
    </table>
  </section>

  <section title="Timeline Estimates">
    <table>
      <row header="true">
        <cell>Phase</cell>
        <cell>Estimated Effort</cell>
        <cell>Tasks</cell>
        <cell>Parallel Potential</cell>
      </row>
      <row>
        <cell>Phase 1: [Phase Name]</cell>
        <cell>[estimate]</cell>
        <cell>[task count]</cell>
        <cell>[which tasks can run in parallel]</cell>
      </row>
      <row>
        <cell>Phase 2: [Phase Name]</cell>
        <cell>[estimate]</cell>
        <cell>[task count]</cell>
        <cell>[which tasks can run in parallel]</cell>
      </row>
      <row>
        <cell>Phase 3: [Phase Name]</cell>
        <cell>[estimate]</cell>
        <cell>[task count]</cell>
        <cell>[which tasks can run in parallel]</cell>
      </row>
      <row>
        <cell>Total</cell>
        <cell>[total estimate]</cell>
        <cell>[total task count]</cell>
        <cell></cell>
      </row>
    </table>
  </section>

  <section title="Testing Strategy">
    <subsection title="Unit Tests">
      <list type="unordered">
        <item>[Files/modules to unit test]</item>
      </list>
    </subsection>
    <subsection title="Integration Tests">
      <list type="unordered">
        <item>[Flows to integration test]</item>
      </list>
    </subsection>
    <subsection title="E2E Tests">
      <list type="unordered">
        <item>[User journeys to E2E test]</item>
      </list>
    </subsection>
  </section>

  <section title="Success Criteria">
    <checklist>
      <item status="open">[Success criterion 1]</item>
      <item status="open">[Success criterion 2]</item>
      <item status="open">[Success criterion 3]</item>
    </checklist>
    <reference doc="[doc-index]-requirements.md" section="Acceptance Criteria">Cross-reference with requirements acceptance criteria for full coverage.</reference>
  </section>

  <section title="Rollback Plan">
    <paragraph>If implementation must be reverted:</paragraph>

    <subsection title="Rollback Triggers">
      <list type="unordered">
        <item>[Condition that triggers rollback, e.g., critical test failures after Phase 2]</item>
        <item>[Condition that triggers rollback, e.g., performance regression exceeds threshold]</item>
      </list>
    </subsection>

    <subsection title="Rollback Steps">
      <list type="ordered">
        <item>[Step 1: e.g., revert commits from Phase N]</item>
        <item>[Step 2: e.g., restore previous configuration]</item>
        <item>[Step 3: e.g., verify system stability]</item>
      </list>
    </subsection>

    <subsection title="Data Safety">
      <paragraph>[Notes on data migration reversibility, backup requirements, or irreversible changes to flag]</paragraph>
    </subsection>
  </section>

</document>

## Usage Notes

- Decompose complex work into **3-5 phases**; each phase should be independently verifiable
- Every `<task>` must specify a `file` attribute with the target file path, a `risk` level, and a `domain` attribute (rust, go, frontend, backend, ios, android, windows, macos, or mixed)
- The `domain` attribute enables the Team Lead to detect cross-domain dependencies and decide between full parallel vs staggered parallel spawning in Phase 8
- The dependency graph should reflect the actual task dependency chain, with domain labels on phases to visualize cross-domain boundaries
- Update the timeline table as estimates are refined during execution
- Cross-reference the `<reference>` tag to link back to requirements acceptance criteria
