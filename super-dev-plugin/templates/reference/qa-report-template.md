---
name: qa-report-template
description: Structured QA report template with test execution results, BDD scenario coverage mapping, defect tracking, and quality verdict for spec directory traceability.
doc-type: qa-report
gate-profile: gate-build.sh
---

<document type="qa-report">

  <metadata>
    <field name="title">QA Report: [Feature/Fix Name]</field>
    <field name="date">[timestamp]</field>
    <field name="author">super-dev:qa-agent</field>
    <field name="status">PASS | FAIL</field>
    <field name="spec-reference">[path to [doc-index]-specification.md]</field>
    <field name="bdd-reference">[path to [doc-index]-behavior-scenarios.md]</field>
    <field name="implementation-reference">[path to [doc-index]-implementation-summary.md]</field>
    <field name="application-modality">CLI | Desktop UI | Web App</field>
  </metadata>

  <section title="Executive Summary">
    <table>
      <row header="true">
        <cell>Metric</cell>
        <cell>Value</cell>
      </row>
      <row>
        <cell>Total Tests</cell>
        <cell>[count]</cell>
      </row>
      <row>
        <cell>Passed</cell>
        <cell>[count]</cell>
      </row>
      <row>
        <cell>Failed</cell>
        <cell>[count]</cell>
      </row>
      <row>
        <cell>Skipped</cell>
        <cell>[count]</cell>
      </row>
      <row>
        <cell>Coverage (overall)</cell>
        <cell>[percentage]</cell>
      </row>
      <row>
        <cell>Coverage (new/changed code)</cell>
        <cell>[percentage]</cell>
      </row>
      <row>
        <cell>BDD Scenario Coverage</cell>
        <cell>[M]/[N] ([percentage])</cell>
      </row>
      <row>
        <cell>Duration</cell>
        <cell>[time]</cell>
      </row>
    </table>
  </section>

  <section title="BDD Scenario Coverage">
    <table>
      <row header="true">
        <cell>Scenario ID</cell>
        <cell>Title</cell>
        <cell>AC Ref</cell>
        <cell>Test File</cell>
        <cell>Test Name</cell>
        <cell>Status</cell>
      </row>
      <row>
        <cell>SCENARIO-001</cell>
        <cell>[scenario title]</cell>
        <cell>AC-01</cell>
        <cell>[test file path]</cell>
        <cell>[test function/describe name]</cell>
        <cell>PASS | FAIL</cell>
      </row>
      <row>
        <cell>SCENARIO-002</cell>
        <cell>[scenario title]</cell>
        <cell>AC-02</cell>
        <cell>[test file path]</cell>
        <cell>[test function/describe name]</cell>
        <cell>PASS | FAIL</cell>
      </row>
    </table>

    <subsection title="Coverage Summary">
      <list type="unordered">
        <item>**Total Scenarios:** [N]</item>
        <item>**Covered (with passing test):** [M]</item>
        <item>**Uncovered:** [N-M] (must be 0 for Phase 9 gate)</item>
        <item>**Coverage:** [M/N * 100]%</item>
      </list>
    </subsection>
  </section>

  <section title="Test Results by Category">

    <subsection title="Unit Tests">
      <table>
        <row header="true">
          <cell>Test Suite</cell>
          <cell>Tests</cell>
          <cell>Passed</cell>
          <cell>Failed</cell>
          <cell>Duration</cell>
        </row>
        <row>
          <cell>[suite name]</cell>
          <cell>[count]</cell>
          <cell>[count]</cell>
          <cell>[count]</cell>
          <cell>[time]</cell>
        </row>
      </table>
    </subsection>

    <subsection title="Integration Tests">
      <table>
        <row header="true">
          <cell>Test Suite</cell>
          <cell>Tests</cell>
          <cell>Passed</cell>
          <cell>Failed</cell>
          <cell>Duration</cell>
        </row>
        <row>
          <cell>[suite name]</cell>
          <cell>[count]</cell>
          <cell>[count]</cell>
          <cell>[count]</cell>
          <cell>[time]</cell>
        </row>
      </table>
    </subsection>

    <subsection title="Browser Smoke Test">
      <paragraph>Omit this section for CLI-only or backend-only changes.</paragraph>
      <table>
        <row header="true">
          <cell>Route</cell>
          <cell>Screenshot</cell>
          <cell>Console Errors</cell>
          <cell>Network Errors</cell>
          <cell>A11y Violations</cell>
        </row>
        <row>
          <cell>[route]</cell>
          <cell>OK | FAIL</cell>
          <cell>[count]</cell>
          <cell>[count]</cell>
          <cell>[count]</cell>
        </row>
      </table>
    </subsection>

    <subsection title="CodeRabbit Review">
      <paragraph>Omit this section if CodeRabbit is not available.</paragraph>
      <table>
        <row header="true">
          <cell>Severity</cell>
          <cell>Found</cell>
          <cell>Resolved</cell>
        </row>
        <row>
          <cell>Critical</cell>
          <cell>[count]</cell>
          <cell>[count]</cell>
        </row>
        <row>
          <cell>High</cell>
          <cell>[count]</cell>
          <cell>[count]</cell>
        </row>
        <row>
          <cell>Medium</cell>
          <cell>[count]</cell>
          <cell>[count]</cell>
        </row>
        <row>
          <cell>Low</cell>
          <cell>[count]</cell>
          <cell>[count]</cell>
        </row>
      </table>
    </subsection>

  </section>

  <section title="Defects Found">
    <paragraph>List all defects discovered during testing. If none: "No defects found."</paragraph>

    <subsection title="DEF-001: [Defect Title]">
      <list type="unordered">
        <item>**Severity:** Critical | High | Medium | Low</item>
        <item>**Scenario:** SCENARIO-XXX (or N/A)</item>
        <item>**Test Case:** [test name]</item>
        <item>**Steps to Reproduce:** [steps]</item>
        <item>**Expected:** [expected behavior]</item>
        <item>**Actual:** [actual behavior]</item>
        <item>**Status:** Fixed | Open | Deferred</item>
        <item>**Evidence:** [screenshot/log path or inline snippet]</item>
      </list>
    </subsection>

    <!-- Repeat for each defect -->

  </section>

  <section title="Quality Gates Checklist">
    <checklist>
      <item status="open">All tests pass (zero failures)</item>
      <item status="open">Coverage meets threshold for new/changed code</item>
      <item status="open">BDD scenario coverage = 100%</item>
      <item status="open">No critical or high defects remain open</item>
      <item status="open">Browser smoke test passed (web apps only)</item>
      <item status="open">CodeRabbit review passed (if available)</item>
      <item status="open">Build succeeds</item>
    </checklist>
  </section>

  <section title="Artifacts">
    <list type="unordered">
      <item>**Test traces:** [path or N/A]</item>
      <item>**Screenshots:** [path or N/A]</item>
      <item>**Network logs:** [path or N/A]</item>
      <item>**JUnit XML:** [path or N/A]</item>
      <item>**Coverage report:** [path or N/A]</item>
    </list>
  </section>

</document>

## Rendering Rules

When rendering this template to markdown:

| XML Element | Markdown Rendering |
|-------------|-------------------|
| `<item status="open">` | `- [ ]` checkbox |
| `<item status="done">` | `- [x]` checkbox |
| `<table>` | Standard markdown table |
| `<paragraph>` | Normal paragraph text |

## Usage Notes

- Load this template via `${CLAUDE_PLUGIN_ROOT}/templates/reference/qa-report-template.md`
- Write to the EXACT filename given by Team Lead in the spawn prompt's `OUTPUT FILENAME` field
- Every BDD scenario from `[doc-index]-behavior-scenarios.md` MUST appear in the BDD Scenario Coverage table
- Omit Browser Smoke Test and CodeRabbit sections when not applicable (do not leave empty tables)
- Update Quality Gates Checklist items to `status="done"` as each gate passes
