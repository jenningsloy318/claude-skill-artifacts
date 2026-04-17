<document type="task-list">

  <metadata>
    <field name="title">Task List: XML Restructure of super-dev-plugin Files</field>
    <field name="date">2026-04-16</field>
    <field name="author">super-dev:spec-writer</field>
    <field name="status">Pending</field>
    <field name="spec-reference">./05-specification.md</field>
    <field name="plan-reference">./06-implementation-plan.md</field>
    <field name="total-tasks">93</field>
    <field name="completed-tasks">0</field>
  </metadata>

  <section title="Tasks">

    <subsection title="Phase 1: Template Fence Removal (5 files)">
      <checklist>
        <item status="pending" domain="mixed">
          **T1.1** Remove ` ```xml ` / ` ``` ` code fences from `implementation-plan-template.md`
          - Files: `super-dev-plugin/templates/reference/implementation-plan-template.md`
          - Dependencies: None
          - Acceptance: File contains bare XML after YAML frontmatter, no ` ```xml ` or ` ``` ` lines
        </item>
        <item status="pending" domain="mixed">
          **T1.2** Remove code fences from `task-list-template.md`
          - Files: `super-dev-plugin/templates/reference/task-list-template.md`
          - Dependencies: None
          - Acceptance: File contains bare XML after YAML frontmatter, no code fences
        </item>
        <item status="pending" domain="mixed">
          **T1.3** Remove code fences from `requirements-template.md`
          - Files: `super-dev-plugin/templates/reference/requirements-template.md`
          - Dependencies: None
          - Acceptance: File contains bare XML after YAML frontmatter, no code fences
        </item>
        <item status="pending" domain="mixed">
          **T1.4** Remove code fences from `behavior-scenarios-template.md`
          - Files: `super-dev-plugin/templates/reference/behavior-scenarios-template.md`
          - Dependencies: None
          - Acceptance: File contains bare XML after YAML frontmatter, no code fences
        </item>
        <item status="pending" domain="mixed">
          **T1.5** Remove code fences from `qa-report-template.md`
          - Files: `super-dev-plugin/templates/reference/qa-report-template.md`
          - Dependencies: None
          - Acceptance: File contains bare XML after YAML frontmatter, no code fences
        </item>
      </checklist>
    </subsection>

    <subsection title="Phase 2: Template Checklist Fix (1 file)">
      <checklist>
        <item status="pending" domain="mixed">
          **T2.1** Fix raw checkbox syntax in `spec-review-template.md` to `<checklist><item>` XML tags. Remove code fences if present.
          - Files: `super-dev-plugin/templates/reference/spec-review-template.md`
          - Dependencies: None
          - Acceptance: No `- [ ]` or `- [x]` patterns remain; all use `<item status="open|done">`
        </item>
      </checklist>
    </subsection>

    <subsection title="Phase 3: Reference File Conversion (9 files)">
      <checklist>
        <item status="pending" domain="mixed">
          **T3.1** Convert `bdd-patterns.md` (119 lines) to XML-tagged structure
          - Files: `super-dev-plugin/templates/reference/bdd-patterns.md`
          - Dependencies: T1.1-T1.5, T2.1
          - Acceptance: Has `<meta>` + `<purpose>`, no `##`/`###` headings, only Tier 1/2/3 tags, code samples aggressively trimmed
        </item>
        <item status="pending" domain="mixed">
          **T3.2** Convert `research-methodology.md` (380 lines) to XML-tagged structure
          - Files: `super-dev-plugin/templates/reference/research-methodology.md`
          - Dependencies: T1.1-T1.5, T2.1
          - Acceptance: Same as T3.1. Research steps in `<process><step>` tags.
        </item>
        <item status="pending" domain="mixed">
          **T3.3** Convert `debugging-patterns.md` (401 lines) to XML-tagged structure
          - Files: `super-dev-plugin/templates/reference/debugging-patterns.md`
          - Dependencies: T1.1-T1.5, T2.1
          - Acceptance: Same as T3.1. 1 H4+ heading flattened.
        </item>
        <item status="pending" domain="mixed">
          **T3.4** Convert `coding-standards.md` (520 lines) to XML-tagged structure
          - Files: `super-dev-plugin/templates/reference/coding-standards.md`
          - Dependencies: T1.1-T1.5, T2.1
          - Acceptance: Same as T3.1. Numbered principles in `<principles><principle>` tags. Code examples aggressively removed.
        </item>
        <item status="pending" domain="mixed">
          **T3.5** Convert `architecture-patterns.md` (343 lines) to XML-tagged structure
          - Files: `super-dev-plugin/templates/reference/architecture-patterns.md`
          - Dependencies: T1.1-T1.5, T2.1
          - Acceptance: Same as T3.1. 21 H4+ headings flattened to `<topic>` tags.
        </item>
        <item status="pending" domain="mixed">
          **T3.6** Convert `ui-ux-patterns.md` (520 lines) to XML-tagged structure
          - Files: `super-dev-plugin/templates/reference/ui-ux-patterns.md`
          - Dependencies: T1.1-T1.5, T2.1
          - Acceptance: Same as T3.1. 9 H4+ headings flattened.
        </item>
        <item status="pending" domain="mixed">
          **T3.7** Convert `frontend-patterns.md` (632 lines) to XML-tagged structure
          - Files: `super-dev-plugin/templates/reference/frontend-patterns.md`
          - Dependencies: T1.1-T1.5, T2.1
          - Acceptance: Same as T3.1. Heavy code blocks removed. JSX in code blocks handled correctly.
        </item>
        <item status="pending" domain="mixed">
          **T3.8** Convert `backend-patterns.md` (582 lines) to XML-tagged structure
          - Files: `super-dev-plugin/templates/reference/backend-patterns.md`
          - Dependencies: T1.1-T1.5, T2.1
          - Acceptance: Same as T3.1. Heavy code blocks removed.
        </item>
        <item status="pending" domain="mixed">
          **T3.9** Convert `testing-patterns.md` (928 lines) to XML-tagged structure
          - Files: `super-dev-plugin/templates/reference/testing-patterns.md`
          - Dependencies: T1.1-T1.5, T2.1
          - Acceptance: Same as T3.1. Largest reference file. Heavy code blocks removed. Testing conventions converted to `<process>`, `<principles>`, `<constraints>` tags.
        </item>
      </checklist>
    </subsection>

    <subsection title="Phase 4: Agent Conversion (36 files)">
      <checklist>
        <item status="pending" domain="mixed">
          **T4.1** Convert `handoff-writer.md` (93 lines) to XML
          - Files: `super-dev-plugin/agents/handoff-writer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: `<meta>` + `<purpose>`, no MD headings, moderate code trim (1 per concept), YAML frontmatter removed
        </item>
        <item status="pending" domain="mixed">
          **T4.2** Convert `planner.md` (118 lines) to XML
          - Files: `super-dev-plugin/agents/planner.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.3** Convert `bdd-scenario-writer.md` (158 lines) to XML
          - Files: `super-dev-plugin/agents/bdd-scenario-writer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.4** Convert `code-assessor.md` (201 lines) to XML
          - Files: `super-dev-plugin/agents/code-assessor.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.5** Convert `architect.md` (210 lines) to XML
          - Files: `super-dev-plugin/agents/architect.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.6** Convert `adversarial-reviewer.md` (236 lines) to XML. **Note:** 3 H4+ headings, 1 XML-like line in code block, `---` horizontal rules in body.
          - Files: `super-dev-plugin/agents/adversarial-reviewer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1. H4+ flattened. Horizontal rules removed. XML in code blocks preserved.
        </item>
        <item status="pending" domain="mixed">
          **T4.7** Convert `macos-app-developer.md` (245 lines) to XML
          - Files: `super-dev-plugin/agents/macos-app-developer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.8** Convert `windows-app-developer.md` (250 lines) to XML
          - Files: `super-dev-plugin/agents/windows-app-developer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.9** Convert `search-agent.md` (268 lines) to XML. **Note:** 19 `${CLAUDE_PLUGIN_ROOT}` references, 2 XML-like lines.
          - Files: `super-dev-plugin/agents/search-agent.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1. All 19 placeholder vars preserved.
        </item>
        <item status="pending" domain="mixed">
          **T4.10** Convert `doc-validator.md` (268 lines) to XML. **Note:** 6 XML-like lines (template refs).
          - Files: `super-dev-plugin/agents/doc-validator.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1. XML template references inside code samples preserved.
        </item>
        <item status="pending" domain="mixed">
          **T4.11** Convert `tdd-guide.md` (279 lines) to XML
          - Files: `super-dev-plugin/agents/tdd-guide.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.12** Convert `docs-executor.md` (284 lines) to XML
          - Files: `super-dev-plugin/agents/docs-executor.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.13** Convert `code-reviewer.md` (293 lines) to XML
          - Files: `super-dev-plugin/agents/code-reviewer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.14** Convert `spec-reviewer.md` (297 lines) to XML. **Note:** 8 H4+ headings.
          - Files: `super-dev-plugin/agents/spec-reviewer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1. H4+ headings flattened.
        </item>
        <item status="pending" domain="mixed">
          **T4.15** Convert `android-developer.md` (300 lines) to XML
          - Files: `super-dev-plugin/agents/android-developer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.16** Convert `refactor-cleaner.md` (305 lines) to XML
          - Files: `super-dev-plugin/agents/refactor-cleaner.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.17** Convert `dev-executor.md` (309 lines) to XML
          - Files: `super-dev-plugin/agents/dev-executor.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.18** Convert `spec-writer.md` (326 lines) to XML. **Note:** 1 XML-like line.
          - Files: `super-dev-plugin/agents/spec-writer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.19** Convert `debug-analyzer.md` (328 lines) to XML. **Note:** 2 H4+ headings.
          - Files: `super-dev-plugin/agents/debug-analyzer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1. H4+ headings flattened.
        </item>
        <item status="pending" domain="mixed">
          **T4.20** Convert `investigator.md` (333 lines) to XML
          - Files: `super-dev-plugin/agents/investigator.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.21** Convert `ios-developer.md` (337 lines) to XML
          - Files: `super-dev-plugin/agents/ios-developer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.22** Convert `requirements-clarifier.md` (360 lines) to XML
          - Files: `super-dev-plugin/agents/requirements-clarifier.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.23** Convert `frontend-developer.md` (447 lines) to XML. **Note:** 9 XML-like lines (React JSX in code blocks).
          - Files: `super-dev-plugin/agents/frontend-developer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1. JSX content in code samples preserved.
        </item>
        <item status="pending" domain="mixed">
          **T4.24** Convert `doc-updater.md` (451 lines) to XML
          - Files: `super-dev-plugin/agents/doc-updater.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.25** Convert `product-designer.md` (458 lines) to XML. **Note:** 2 XML-like lines.
          - Files: `super-dev-plugin/agents/product-designer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.26** Convert `rust-developer.md` (469 lines) to XML. **Note:** 5 XML-like lines (HTML in test assertions).
          - Files: `super-dev-plugin/agents/rust-developer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.27** Convert `backend-developer.md` (477 lines) to XML
          - Files: `super-dev-plugin/agents/backend-developer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.28** Convert `build-error-resolver.md` (531 lines) to XML. **Note:** 4 XML-like lines.
          - Files: `super-dev-plugin/agents/build-error-resolver.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.29** Convert `security-reviewer.md` (544 lines) to XML
          - Files: `super-dev-plugin/agents/security-reviewer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.30** Convert `research-agent.md` (628 lines) to XML. **Note:** 10 H4+ headings, 20 `${CLAUDE_PLUGIN_ROOT}` refs, 2 XML-like lines (MCP examples).
          - Files: `super-dev-plugin/agents/research-agent.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1. H4+ flattened. All 20 placeholder vars preserved.
        </item>
        <item status="pending" domain="mixed">
          **T4.31** Convert `e2e-runner.md` (707 lines) to XML
          - Files: `super-dev-plugin/agents/e2e-runner.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.32** Convert `golang-developer.md` (726 lines) to XML
          - Files: `super-dev-plugin/agents/golang-developer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.33** Convert `ui-ux-designer.md` (829 lines) to XML. **Note:** 5 XML-like lines (JSX/HTML in code blocks).
          - Files: `super-dev-plugin/agents/ui-ux-designer.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1
        </item>
        <item status="pending" domain="mixed">
          **T4.34** Convert `qa-agent.md` (966 lines) to XML. **Note:** 5 XML-like lines, 41 code blocks (highest density).
          - Files: `super-dev-plugin/agents/qa-agent.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1. Moderate trim: keep max 1 code sample per concept from the 41 blocks.
        </item>
        <item status="pending" domain="mixed">
          **T4.35** Convert `team-lead.md` (1,035 lines) to XML. **Note:** 3 XML-like lines (template refs), 122 table lines, 103 ASCII diagram lines.
          - Files: `super-dev-plugin/agents/team-lead.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1. Tables compressed where possible. Diagrams in `<code-sample>` or removed.
        </item>
        <item status="pending" domain="mixed">
          **T4.36** Convert `architecture-agent.md` (1,544 lines) to XML. **HIGHEST COMPLEXITY:** 30 H4+ headings, 31 code blocks, 124 table lines, 115 checkboxes, 259 ASCII diagram lines, 4 XML-like lines.
          - Files: `super-dev-plugin/agents/architecture-agent.md`
          - Dependencies: T3.1-T3.9
          - Acceptance: Same as T4.1. All 30 H4+ headings flattened. 115 checkboxes converted to `<checklist><check>`. ASCII diagrams handled. Tables compressed.
        </item>
      </checklist>
    </subsection>

    <subsection title="Phase 5: Command Conversion (20 files)">
      <checklist>
        <item status="pending" domain="mixed">
          **T5.1** Convert `update-codemaps.md` (17 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/commands/update-codemaps.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: `<meta>` derived from H1, `<purpose>`, no MD headings, code blocks removed
        </item>
        <item status="pending" domain="mixed">
          **T5.2** Convert `test-coverage.md` (27 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/commands/test-coverage.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.1
        </item>
        <item status="pending" domain="mixed">
          **T5.3** Convert `refactor-clean.md` (28 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/commands/refactor-clean.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.1
        </item>
        <item status="pending" domain="mixed">
          **T5.4** Convert `build-fix.md` (29 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/commands/build-fix.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.1
        </item>
        <item status="pending" domain="mixed">
          **T5.5** Convert `update-docs.md` (31 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/commands/update-docs.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.1
        </item>
        <item status="pending" domain="mixed">
          **T5.6** Convert `golang.md` (45 lines, has frontmatter) to XML. **Note:** 1 XML-like line in code block.
          - Files: `super-dev-plugin/commands/golang.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: `<meta>` from frontmatter, `<purpose>`, no MD headings, code blocks removed
        </item>
        <item status="pending" domain="mixed">
          **T5.7** Convert `learn.md` (70 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/commands/learn.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.1
        </item>
        <item status="pending" domain="mixed">
          **T5.8** Convert `usage-report.md` (74 lines, has frontmatter) to XML. **Note:** 6 `${CLAUDE_PLUGIN_*}` references.
          - Files: `super-dev-plugin/commands/usage-report.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6. All 6 placeholder vars preserved.
        </item>
        <item status="pending" domain="mixed">
          **T5.9** Convert `code-review.md` (82 lines, has frontmatter) to XML
          - Files: `super-dev-plugin/commands/code-review.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6
        </item>
        <item status="pending" domain="mixed">
          **T5.10** Convert `research.md` (87 lines, has frontmatter) to XML
          - Files: `super-dev-plugin/commands/research.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6
        </item>
        <item status="pending" domain="mixed">
          **T5.11** Convert `debug-analysis.md` (89 lines, has frontmatter) to XML
          - Files: `super-dev-plugin/commands/debug-analysis.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6
        </item>
        <item status="pending" domain="mixed">
          **T5.12** Convert `code-assessment.md` (89 lines, has frontmatter) to XML
          - Files: `super-dev-plugin/commands/code-assessment.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6
        </item>
        <item status="pending" domain="mixed">
          **T5.13** Convert `execute.md` (90 lines, has frontmatter) to XML
          - Files: `super-dev-plugin/commands/execute.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6
        </item>
        <item status="pending" domain="mixed">
          **T5.14** Convert `documentation.md` (97 lines, has frontmatter) to XML
          - Files: `super-dev-plugin/commands/documentation.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6
        </item>
        <item status="pending" domain="mixed">
          **T5.15** Convert `adversarial-review.md` (104 lines, has frontmatter) to XML
          - Files: `super-dev-plugin/commands/adversarial-review.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6
        </item>
        <item status="pending" domain="mixed">
          **T5.16** Convert `plan.md` (113 lines, has frontmatter -- description only) to XML
          - Files: `super-dev-plugin/commands/plan.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6
        </item>
        <item status="pending" domain="mixed">
          **T5.17** Convert `architecture-design.md` (114 lines, has frontmatter) to XML
          - Files: `super-dev-plugin/commands/architecture-design.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6
        </item>
        <item status="pending" domain="mixed">
          **T5.18** Convert `ui-ux-design.md` (203 lines, has frontmatter) to XML
          - Files: `super-dev-plugin/commands/ui-ux-design.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6
        </item>
        <item status="pending" domain="mixed">
          **T5.19** Convert `tdd.md` (326 lines, has frontmatter -- description only) to XML
          - Files: `super-dev-plugin/commands/tdd.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6. Extensive TypeScript code blocks removed.
        </item>
        <item status="pending" domain="mixed">
          **T5.20** Convert `e2e.md` (363 lines, has frontmatter -- description only) to XML
          - Files: `super-dev-plugin/commands/e2e.md`
          - Dependencies: T4.1-T4.36
          - Acceptance: Same as T5.6. Extensive TypeScript code blocks removed.
        </item>
      </checklist>
    </subsection>

    <subsection title="Phase 6: Rule Conversion (8 files)">
      <checklist>
        <item status="pending" domain="mixed">
          **T6.1** Convert `security.md` (36 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/rules/security.md`
          - Dependencies: T5.1-T5.20
          - Acceptance: `<meta>` from H1, `<purpose>`, `<directives>` with severity attributes, code blocks removed, checkboxes as `<checklist><check>`
        </item>
        <item status="pending" domain="mixed">
          **T6.2** Convert `performance.md` (47 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/rules/performance.md`
          - Dependencies: T5.1-T5.20
          - Acceptance: Same as T6.1
        </item>
        <item status="pending" domain="mixed">
          **T6.3** Convert `testing.md` (50 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/rules/testing.md`
          - Dependencies: T5.1-T5.20
          - Acceptance: Same as T6.1
        </item>
        <item status="pending" domain="mixed">
          **T6.4** Convert `rust-project.md` (52 lines, has frontmatter) to XML
          - Files: `super-dev-plugin/rules/rust-project.md`
          - Dependencies: T5.1-T5.20
          - Acceptance: `<meta>` from frontmatter, same as T6.1
        </item>
        <item status="pending" domain="mixed">
          **T6.5** Convert `patterns.md` (55 lines, no frontmatter) to XML. **Note:** 1 XML-like line in code block.
          - Files: `super-dev-plugin/rules/patterns.md`
          - Dependencies: T5.1-T5.20
          - Acceptance: Same as T6.1
        </item>
        <item status="pending" domain="mixed">
          **T6.6** Convert `coding-style.md` (70 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/rules/coding-style.md`
          - Dependencies: T5.1-T5.20
          - Acceptance: Same as T6.1. 8 checkboxes converted.
        </item>
        <item status="pending" domain="mixed">
          **T6.7** Convert `git-workflow.md` (73 lines, no frontmatter) to XML. **Note:** 4 XML-like lines (angle brackets in branch patterns).
          - Files: `super-dev-plugin/rules/git-workflow.md`
          - Dependencies: T5.1-T5.20
          - Acceptance: Same as T6.1
        </item>
        <item status="pending" domain="mixed">
          **T6.8** Convert `agents.md` (75 lines, no frontmatter) to XML. **Note:** 1 `${CLAUDE_PLUGIN_ROOT}` reference.
          - Files: `super-dev-plugin/rules/agents.md`
          - Dependencies: T5.1-T5.20
          - Acceptance: Same as T6.1. Placeholder var preserved.
        </item>
      </checklist>
    </subsection>

    <subsection title="Phase 7: Context Conversion (3 files)">
      <checklist>
        <item status="pending" domain="mixed">
          **T7.1** Convert `dev.md` (20 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/contexts/dev.md`
          - Dependencies: T6.1-T6.8
          - Acceptance: `<meta>` from H1, `<purpose>`, `<mode>` tag, `<priorities>` with `<priority n="N">`, `<tools>` tag, no MD headings
        </item>
        <item status="pending" domain="mixed">
          **T7.2** Convert `review.md` (22 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/contexts/review.md`
          - Dependencies: T6.1-T6.8
          - Acceptance: Same as T7.1
        </item>
        <item status="pending" domain="mixed">
          **T7.3** Convert `research.md` (26 lines, no frontmatter) to XML
          - Files: `super-dev-plugin/contexts/research.md`
          - Dependencies: T6.1-T6.8
          - Acceptance: Same as T7.1
        </item>
      </checklist>
    </subsection>

    <subsection title="Phase 8: Skill Conversion + Version Bump (9 + 2 files)">
      <checklist>
        <item status="pending" domain="mixed">
          **T8.1** Convert `careful/SKILL.md` (66 lines) to XML
          - Files: `super-dev-plugin/skills/careful/SKILL.md`
          - Dependencies: T7.1-T7.3
          - Acceptance: `<meta>` from frontmatter (replaces YAML), `<purpose>`, no MD headings, code blocks removed, tables compressed
        </item>
        <item status="pending" domain="mixed">
          **T8.2** Convert `freeze/SKILL.md` (67 lines) to XML
          - Files: `super-dev-plugin/skills/freeze/SKILL.md`
          - Dependencies: T7.1-T7.3
          - Acceptance: Same as T8.1
        </item>
        <item status="pending" domain="mixed">
          **T8.3** Convert `autoresearch/SKILL.md` (181 lines) to XML. **Note:** Nested `metadata:` YAML block, 3 XML-like lines.
          - Files: `super-dev-plugin/skills/autoresearch/SKILL.md`
          - Dependencies: T7.1-T7.3
          - Acceptance: Same as T8.1. Nested metadata flattened into `<meta>`.
        </item>
        <item status="pending" domain="mixed">
          **T8.4** Convert `dev-rules/SKILL.md` (184 lines) to XML. **Note:** 1 XML-like line.
          - Files: `super-dev-plugin/skills/dev-rules/SKILL.md`
          - Dependencies: T7.1-T7.3
          - Acceptance: Same as T8.1
        </item>
        <item status="pending" domain="mixed">
          **T8.5** Convert `verify/SKILL.md` (260 lines) to XML
          - Files: `super-dev-plugin/skills/verify/SKILL.md`
          - Dependencies: T7.1-T7.3
          - Acceptance: Same as T8.1
        </item>
        <item status="pending" domain="mixed">
          **T8.6** Convert `adversarial-review/SKILL.md` (314 lines) to XML. **Note:** 3 H4+ headings, 5 XML-like lines.
          - Files: `super-dev-plugin/skills/adversarial-review/SKILL.md`
          - Dependencies: T7.1-T7.3
          - Acceptance: Same as T8.1. H4+ flattened.
        </item>
        <item status="pending" domain="mixed">
          **T8.7** Convert `tdd-workflow/SKILL.md` (420 lines) to XML. **Note:** 3 H4+ headings.
          - Files: `super-dev-plugin/skills/tdd-workflow/SKILL.md`
          - Dependencies: T7.1-T7.3
          - Acceptance: Same as T8.1. H4+ flattened.
        </item>
        <item status="pending" domain="mixed">
          **T8.8** Convert `security-review/SKILL.md` (505 lines) to XML. **Note:** 31 H4+ headings (deepest nesting of any skill), 1 XML-like line.
          - Files: `super-dev-plugin/skills/security-review/SKILL.md`
          - Dependencies: T7.1-T7.3
          - Acceptance: Same as T8.1. All 31 H4+ headings flattened.
        </item>
        <item status="pending" domain="mixed">
          **T8.9** Convert `super-dev/SKILL.md` (817 lines) to XML. **Note:** Most complex YAML frontmatter (nested `metadata:` with `keywords:` list), 3 XML-like lines, 7 `${CLAUDE_PLUGIN_*}` references.
          - Files: `super-dev-plugin/skills/super-dev/SKILL.md`
          - Dependencies: T7.1-T7.3
          - Acceptance: Same as T8.1. All nested frontmatter fields in `<meta>`. All 7 placeholder vars preserved.
        </item>
        <item status="pending" domain="mixed">
          **T8.10** Bump version to 2.3.36 in plugin.json
          - Files: `super-dev-plugin/.claude-plugin/plugin.json`
          - Dependencies: T8.1-T8.9
          - Acceptance: Version field reads `"2.3.36"`
        </item>
        <item status="pending" domain="mixed">
          **T8.11** Bump version to 2.3.36 in marketplace.json (super-dev entry)
          - Files: `.claude-plugin/marketplace.json`
          - Dependencies: T8.10
          - Acceptance: Super-dev entry version reads `"2.3.36"`, matches plugin.json
        </item>
      </checklist>
    </subsection>

  </section>

  <section title="Progress">
    <list type="unordered">
      <item>**Completed:** 0/93 tasks</item>
      <item>**Current:** None (pending implementation start)</item>
      <item>**Status:** Pending</item>
      <item>**Blocked:** None</item>
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
        <cell>super-dev-plugin/templates/reference/implementation-plan-template.md</cell>
        <cell>Modified</cell>
        <cell>T1.1</cell>
        <cell>Remove code fences</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/task-list-template.md</cell>
        <cell>Modified</cell>
        <cell>T1.2</cell>
        <cell>Remove code fences</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/requirements-template.md</cell>
        <cell>Modified</cell>
        <cell>T1.3</cell>
        <cell>Remove code fences</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/behavior-scenarios-template.md</cell>
        <cell>Modified</cell>
        <cell>T1.4</cell>
        <cell>Remove code fences</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/qa-report-template.md</cell>
        <cell>Modified</cell>
        <cell>T1.5</cell>
        <cell>Remove code fences</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/spec-review-template.md</cell>
        <cell>Modified</cell>
        <cell>T2.1</cell>
        <cell>Fix checklist syntax to XML, remove fences</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/bdd-patterns.md</cell>
        <cell>Modified</cell>
        <cell>T3.1</cell>
        <cell>Convert Markdown to XML-tagged structure</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/research-methodology.md</cell>
        <cell>Modified</cell>
        <cell>T3.2</cell>
        <cell>Convert Markdown to XML-tagged structure</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/debugging-patterns.md</cell>
        <cell>Modified</cell>
        <cell>T3.3</cell>
        <cell>Convert Markdown to XML-tagged structure</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/coding-standards.md</cell>
        <cell>Modified</cell>
        <cell>T3.4</cell>
        <cell>Convert Markdown to XML-tagged structure</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/architecture-patterns.md</cell>
        <cell>Modified</cell>
        <cell>T3.5</cell>
        <cell>Convert Markdown to XML-tagged structure, 21 H4+ flattened</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/ui-ux-patterns.md</cell>
        <cell>Modified</cell>
        <cell>T3.6</cell>
        <cell>Convert Markdown to XML-tagged structure, 9 H4+ flattened</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/frontend-patterns.md</cell>
        <cell>Modified</cell>
        <cell>T3.7</cell>
        <cell>Convert Markdown to XML-tagged structure, code blocks removed</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/backend-patterns.md</cell>
        <cell>Modified</cell>
        <cell>T3.8</cell>
        <cell>Convert Markdown to XML-tagged structure, code blocks removed</cell>
      </row>
      <row>
        <cell>super-dev-plugin/templates/reference/testing-patterns.md</cell>
        <cell>Modified</cell>
        <cell>T3.9</cell>
        <cell>Convert Markdown to XML-tagged structure, code blocks removed (928 lines, largest reference file)</cell>
      </row>
      <row>
        <cell>super-dev-plugin/agents/*.md (36 files)</cell>
        <cell>Modified</cell>
        <cell>T4.1-T4.36</cell>
        <cell>Convert Markdown to XML-tagged structure, moderate code trim</cell>
      </row>
      <row>
        <cell>super-dev-plugin/commands/*.md (20 files)</cell>
        <cell>Modified</cell>
        <cell>T5.1-T5.20</cell>
        <cell>Convert Markdown to XML-tagged structure, code blocks removed</cell>
      </row>
      <row>
        <cell>super-dev-plugin/rules/*.md (8 files)</cell>
        <cell>Modified</cell>
        <cell>T6.1-T6.8</cell>
        <cell>Convert Markdown to XML-tagged structure, severity directives</cell>
      </row>
      <row>
        <cell>super-dev-plugin/contexts/*.md (3 files)</cell>
        <cell>Modified</cell>
        <cell>T7.1-T7.3</cell>
        <cell>Convert Markdown to XML-tagged structure, type-specific tags</cell>
      </row>
      <row>
        <cell>super-dev-plugin/skills/*/SKILL.md (9 files)</cell>
        <cell>Modified</cell>
        <cell>T8.1-T8.9</cell>
        <cell>Convert Markdown to XML-tagged structure, complex frontmatter</cell>
      </row>
      <row>
        <cell>super-dev-plugin/.claude-plugin/plugin.json</cell>
        <cell>Modified</cell>
        <cell>T8.10</cell>
        <cell>Version bump 2.3.35 to 2.3.36</cell>
      </row>
      <row>
        <cell>.claude-plugin/marketplace.json</cell>
        <cell>Modified</cell>
        <cell>T8.11</cell>
        <cell>Version bump 2.3.35 to 2.3.36 (super-dev entry)</cell>
      </row>
    </table>
  </section>

  <section title="Technical Decisions Log">
    <list type="ordered">
      <item>
        **Single version bump at end instead of per-phase bumps** (All tasks)
        - Rationale: Per-phase bumping would reach 2.3.43, which is misleading for a single restructuring effort. A single bump (2.3.36) communicates "one logical change."
        - Alternatives considered: Per-phase bumping (rejected: version inflation), no bump (rejected: violates CLAUDE.md rule)
      </item>
      <item>
        **YAML frontmatter removed instead of preserved** (T4.1-T8.9)
        - Rationale: Original requirements specify `<meta>` replaces `---` frontmatter. The `<meta>` tag provides equivalent data. Exception: XML template files retain YAML for plugin system `doc-type:` and `gate-profile:` fields.
        - Alternatives considered: Dual frontmatter+meta (rejected: redundancy per original requirements)
      </item>
      <item>
        **No `<document>` root wrapper on instruction files** (T3.1-T8.9)
        - Rationale: Original requirements schema uses `<meta>` as first tag. `<document>` is reserved for template spec-artifact output. Instruction files are flat sequences of top-level blocks.
        - Alternatives considered: Wrapping in `<document type="agent">` (rejected: not in original requirements schema)
      </item>
    </list>
  </section>

  <section title="Challenges and Resolutions">
    <paragraph>No challenges encountered yet -- task list is in pending state.</paragraph>
  </section>

  <section title="Specification Deviations">
    <paragraph>None -- implementation matches specification.</paragraph>
  </section>

</document>
