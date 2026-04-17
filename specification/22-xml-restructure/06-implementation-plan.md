<document type="implementation-plan">

  <metadata>
    <field name="title">Implementation Plan: XML Restructure of super-dev-plugin Files</field>
    <field name="date">2026-04-16</field>
    <field name="author">super-dev:spec-writer</field>
    <field name="status">Draft</field>
    <field name="spec-reference">./05-specification.md</field>
    <field name="requirements-reference">./01-requirements.md</field>
  </metadata>

  <section title="Overview">
    <paragraph>Convert 85 Markdown files under `super-dev-plugin/` from Markdown heading/prose format to unified XML-tagged structure using the revised three-tier tag schema defined in the specification (05-specification.md Section 3.2 and DD-01). Execution follows 8 phases ordered by risk (lowest first): template normalization, then reference file conversion, then agents, commands, rules, contexts, and skills. Each phase produces a single commit with all files in that batch fully converted. A single version bump (2.3.35 to 2.3.36) is applied in the final commit.</paragraph>

    <subsection title="Goals">
      <list type="unordered">
        <item>100% of non-README `.md` files use XML-tagged structure after all 8 phases</item>
        <item>25-67% token reduction per file through structural conversion + content trimming</item>
        <item>Zero gate script regressions across all phases</item>
        <item>Zero content/semantic loss in any converted file</item>
      </list>
    </subsection>

    <subsection title="Non-Goals">
      <list type="unordered">
        <item>Building automated conversion tooling (manual agent-driven conversion)</item>
        <item>Creating structural validation gate scripts (future follow-up)</item>
        <item>Modifying READMEs, JSON files, shell scripts, or excluded files</item>
      </list>
    </subsection>

    <subsection title="Assumptions">
      <list type="unordered">
        <item>Gate scripts parse rendered spec artifacts, not source instruction files -- verified in code assessment (zero risk from source file conversion)</item>
        <item>YAML frontmatter removal does not affect Claude Code plugin registration because the `<meta>` tag provides equivalent data at parse time</item>
        <item>All 14 XML template files retain their YAML frontmatter (required by plugin system for `doc-type:` and `gate-profile:` fields)</item>
        <item>The conversion agent can process files up to 1,544 lines (architecture-agent.md) within a single context window</item>
      </list>
    </subsection>
  </section>

  <section title="Phased Milestones">

    <subsection title="Phase 1: Template Fence Removal (5 files)">
      <paragraph>**Objective:** Remove ` ```xml ` / ` ``` ` code fences from 5 XML template files that already have correct XML content. This is the lowest-risk change -- only 2 lines removed per file (opening and closing fence). Validates that bare XML content works correctly when loaded by agents.</paragraph>

      <list type="ordered">
        <task id="T1.1" file="super-dev-plugin/templates/reference/implementation-plan-template.md" risk="Low" domain="mixed">
          <paragraph>**Remove code fences from implementation-plan-template.md**</paragraph>
          <paragraph>Action: Delete the ` ```xml ` line after YAML frontmatter and the closing ` ``` ` line at end of file. Preserve all content between fences and all YAML frontmatter above.</paragraph>
          <paragraph>Why: Template XML content should not be wrapped in code fences -- agents fill the template directly.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T1.2" file="super-dev-plugin/templates/reference/task-list-template.md" risk="Low" domain="mixed">
          <paragraph>**Remove code fences from task-list-template.md**</paragraph>
          <paragraph>Action: Same as T1.1 -- delete opening ` ```xml ` and closing ` ``` ` lines.</paragraph>
          <paragraph>Why: Consistency with other unfenced templates.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T1.3" file="super-dev-plugin/templates/reference/requirements-template.md" risk="Low" domain="mixed">
          <paragraph>**Remove code fences from requirements-template.md**</paragraph>
          <paragraph>Action: Same as T1.1.</paragraph>
          <paragraph>Why: Consistency with other unfenced templates.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T1.4" file="super-dev-plugin/templates/reference/behavior-scenarios-template.md" risk="Low" domain="mixed">
          <paragraph>**Remove code fences from behavior-scenarios-template.md**</paragraph>
          <paragraph>Action: Same as T1.1.</paragraph>
          <paragraph>Why: Consistency with other unfenced templates.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T1.5" file="super-dev-plugin/templates/reference/qa-report-template.md" risk="Low" domain="mixed">
          <paragraph>**Remove code fences from qa-report-template.md**</paragraph>
          <paragraph>Action: Same as T1.1.</paragraph>
          <paragraph>Why: Consistency with other unfenced templates.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
      </list>

      <paragraph>**Deliverables:**</paragraph>
      <list type="unordered">
        <item>5 template files with bare XML content (no code fences)</item>
        <item>YAML frontmatter preserved in all 5 files</item>
      </list>

      <paragraph>**Exit Criteria:**</paragraph>
      <checklist>
        <item status="open">All 5 files have XML content without ` ```xml ` / ` ``` ` wrappers</item>
        <item status="open">YAML frontmatter is byte-identical to pre-conversion state</item>
        <item status="open">All 7 gate scripts pass</item>
      </checklist>
    </subsection>

    <subsection title="Phase 2: Template Checklist Fix (1 file)">
      <paragraph>**Objective:** Fix raw `- [ ]` checkbox syntax in `spec-review-template.md` to use `<checklist><item>` XML tags, consistent with the template's existing XML structure.</paragraph>

      <list type="ordered">
        <task id="T2.1" file="super-dev-plugin/templates/reference/spec-review-template.md" risk="Low" domain="mixed">
          <paragraph>**Fix checklist syntax in spec-review-template.md**</paragraph>
          <paragraph>Action: Replace all `- [ ]` and `- [x]` patterns with `<item status="open">` and `<item status="done">` inside `<checklist>` tags. Also remove code fences if present.</paragraph>
          <paragraph>Why: Raw checkbox syntax is inconsistent with the template's XML structure.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
      </list>

      <paragraph>**Deliverables:**</paragraph>
      <list type="unordered">
        <item>1 template file with correct `<checklist>` XML syntax</item>
      </list>

      <paragraph>**Exit Criteria:**</paragraph>
      <checklist>
        <item status="open">No raw `- [ ]` or `- [x]` patterns remain in the file</item>
        <item status="open">All `<checklist>` blocks use `<item status="open|done">` syntax</item>
        <item status="open">All 7 gate scripts pass</item>
      </checklist>
    </subsection>

    <subsection title="Phase 3: Reference File Conversion (9 files)">
      <paragraph>**Objective:** Convert 9 pure Markdown reference files in `templates/reference/` to XML-tagged structure. These are reference pattern/standards documents loaded by agents during development phases. Aggressive code sample trimming applies.</paragraph>

      <list type="ordered">
        <task id="T3.1" file="super-dev-plugin/templates/reference/bdd-patterns.md" risk="Low" domain="mixed">
          <paragraph>**Convert bdd-patterns.md (119 lines)**</paragraph>
          <paragraph>Action: Replace YAML frontmatter with `<meta>`, add `<purpose>`, convert H2/H3 headings to semantic tags, aggressively trim code samples, preserve scenario structure conventions.</paragraph>
          <paragraph>Why: Smallest reference file, good first conversion target.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T3.2" file="super-dev-plugin/templates/reference/research-methodology.md" risk="Low" domain="mixed">
          <paragraph>**Convert research-methodology.md (380 lines)**</paragraph>
          <paragraph>Action: Same conversion pattern. Convert research process steps to `<process><step>` tags.</paragraph>
          <paragraph>Why: Medium-sized reference file with clear step-based structure.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T3.3" file="super-dev-plugin/templates/reference/debugging-patterns.md" risk="Low" domain="mixed">
          <paragraph>**Convert debugging-patterns.md (401 lines)**</paragraph>
          <paragraph>Action: Same conversion pattern. 1 H4+ heading needs flattening.</paragraph>
          <paragraph>Why: Low H4+ count makes this a simpler conversion.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T3.4" file="super-dev-plugin/templates/reference/coding-standards.md" risk="Medium" domain="mixed">
          <paragraph>**Convert coding-standards.md (520 lines)**</paragraph>
          <paragraph>Action: Convert numbered principles to `<principles><principle>` tags. Aggressively trim code examples.</paragraph>
          <paragraph>Why: Code-heavy file requires careful code sample removal.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T3.5" file="super-dev-plugin/templates/reference/architecture-patterns.md" risk="Medium" domain="mixed">
          <paragraph>**Convert architecture-patterns.md (343 lines)**</paragraph>
          <paragraph>Action: Same conversion pattern. 21 H4+ headings need flattening -- highest H4+ density in reference files.</paragraph>
          <paragraph>Why: H4+ flattening complexity requires careful section hierarchy preservation.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T3.6" file="super-dev-plugin/templates/reference/ui-ux-patterns.md" risk="Medium" domain="mixed">
          <paragraph>**Convert ui-ux-patterns.md (520 lines)**</paragraph>
          <paragraph>Action: Same conversion pattern. 9 H4+ headings need flattening.</paragraph>
          <paragraph>Why: Design pattern file with moderate H4+ nesting.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T3.7" file="super-dev-plugin/templates/reference/frontend-patterns.md" risk="Medium" domain="mixed">
          <paragraph>**Convert frontend-patterns.md (632 lines)**</paragraph>
          <paragraph>Action: Same conversion pattern. Heavy code blocks require aggressive trimming. JSX/HTML content in code blocks must be handled carefully.</paragraph>
          <paragraph>Why: Code-dense file requires careful code sample removal vs preservation decisions.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T3.8" file="super-dev-plugin/templates/reference/backend-patterns.md" risk="Medium" domain="mixed">
          <paragraph>**Convert backend-patterns.md (582 lines)**</paragraph>
          <paragraph>Action: Same conversion pattern. Heavy code blocks require aggressive trimming.</paragraph>
          <paragraph>Why: Code-dense file, similar complexity to frontend-patterns.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
        <task id="T3.9" file="super-dev-plugin/templates/reference/testing-patterns.md" risk="High" domain="mixed">
          <paragraph>**Convert testing-patterns.md (928 lines)**</paragraph>
          <paragraph>Action: Same conversion pattern. Largest reference file. Heavy code blocks require aggressive trimming. Testing conventions and patterns converted to `<process>`, `<principles>`, `<constraints>` tags.</paragraph>
          <paragraph>Why: Largest reference file; omitted from original requirements Phase 3 list but required for 100% coverage.</paragraph>
          <paragraph>Dependencies: None</paragraph>
        </task>
      </list>

      <paragraph>**Note:** `testing-patterns.md` (928 lines) was not listed in the original requirements Phase 3 file list but is included here as T3.9 because it matches the "pure Markdown reference files" criteria and is required for 100% conversion coverage.</paragraph>

      <paragraph>**Deliverables:**</paragraph>
      <list type="unordered">
        <item>9 reference files converted to XML-tagged structure</item>
        <item>All code samples aggressively trimmed</item>
      </list>

      <paragraph>**Exit Criteria:**</paragraph>
      <checklist>
        <item status="open">All 9 files have `<meta>` + `<purpose>` tags</item>
        <item status="open">No `##` / `###` Markdown headings remain</item>
        <item status="open">Only Tier 1/2/3 tags used</item>
        <item status="open">All 7 gate scripts pass</item>
      </checklist>
    </subsection>

    <subsection title="Phase 4: Agents (36 files)">
      <paragraph>**Objective:** Convert all 36 agent files to XML-tagged structure. Moderate code sample trimming (keep 1 short `<code-sample>` per concept). This is the largest batch and highest-complexity phase due to file sizes (93-1,544 lines), H4+ headings in 5 files, XML content inside code blocks in 13 files, and extensive tables/checklists/diagrams.</paragraph>

      <paragraph>**Sub-phasing (optional):** If the batch is too large for a single commit review, split into 3 sub-phases:</paragraph>
      <list type="unordered">
        <item>Phase 4a: Small agents (93-300 lines, 12 files): handoff-writer, planner, bdd-scenario-writer, code-assessor, architect, adversarial-reviewer, macos-app-developer, windows-app-developer, search-agent, doc-validator, tdd-guide, docs-executor</item>
        <item>Phase 4b: Medium agents (284-477 lines, 12 files): code-reviewer, spec-reviewer, android-developer, refactor-cleaner, dev-executor, spec-writer, debug-analyzer, investigator, ios-developer, requirements-clarifier, frontend-developer, doc-updater</item>
        <item>Phase 4c: Large agents (458-1,544 lines, 12 files): product-designer, rust-developer, backend-developer, build-error-resolver, security-reviewer, research-agent, e2e-runner, golang-developer, ui-ux-designer, qa-agent, team-lead, architecture-agent</item>
      </list>

      <list type="ordered">
        <task id="T4.1" file="super-dev-plugin/agents/*.md (36 files)" risk="High" domain="mixed">
          <paragraph>**Convert all 36 agent files to XML**</paragraph>
          <paragraph>Action: For each agent file: (1) Replace YAML frontmatter with `<meta>` tag, (2) Extract persona into `<purpose>`, (3) Convert H2 headings to semantic Tier 2 tags, (4) Convert H3 headings to `<step>`/`<topic>`/`<principle>` per mapping table, (5) Flatten H4+ to same-level tags, (6) Convert checkbox lists to `<checklist><check>`, (7) Moderately trim code samples (keep 1 per concept), (8) Preserve placeholder variables, (9) Preserve inline Markdown formatting.</paragraph>
          <paragraph>Why: Core conversion phase -- agents are the primary consumers of the XML format.</paragraph>
          <paragraph>Dependencies: T1.1-T1.5, T2.1, T3.1-T3.9 (earlier phases validate the approach)</paragraph>
        </task>
      </list>

      <paragraph>**Deliverables:**</paragraph>
      <list type="unordered">
        <item>36 agent files converted to XML-tagged structure</item>
        <item>All persona sections in `<purpose>` tags</item>
        <item>Code samples moderately trimmed (max 1 per concept)</item>
      </list>

      <paragraph>**Exit Criteria:**</paragraph>
      <checklist>
        <item status="open">All 36 files have `<meta>` + `<purpose>` tags</item>
        <item status="open">No `##` / `###` / `####` Markdown headings remain</item>
        <item status="open">H4+ headings in 5 files (architecture-agent, research-agent, spec-reviewer, adversarial-reviewer, debug-analyzer) are flattened</item>
        <item status="open">XML content inside code blocks in 13 files is preserved in `<code-sample>` tags</item>
        <item status="open">All placeholder variables (`${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_PLUGIN_DATA}`) are character-identical</item>
        <item status="open">All 7 gate scripts pass</item>
      </checklist>
    </subsection>

    <subsection title="Phase 5: Commands (20 files)">
      <paragraph>**Objective:** Convert all 20 command files to XML-tagged structure. Aggressive code sample trimming (remove all code blocks, express as `<constraint>` text). Commands are structurally simpler than agents (no H4+ headings, average 103 lines).</paragraph>

      <list type="ordered">
        <task id="T5.1" file="super-dev-plugin/commands/*.md (20 files)" risk="Medium" domain="mixed">
          <paragraph>**Convert all 20 command files to XML**</paragraph>
          <paragraph>Action: For each command file: (1) Replace YAML frontmatter with `<meta>` (14 files have frontmatter, 6 do not -- for those without, derive `<meta>` from H1 heading), (2) Add `<purpose>`, (3) Convert H2/H3 headings to semantic tags, (4) Remove all code blocks, express patterns as `<constraint>` text, (5) Preserve placeholder variables.</paragraph>
          <paragraph>Why: Commands are medium complexity with simple structure.</paragraph>
          <paragraph>Dependencies: T4.1 (agent conversion validates approach on complex files)</paragraph>
        </task>
      </list>

      <paragraph>**Deliverables:**</paragraph>
      <list type="unordered">
        <item>20 command files converted to XML-tagged structure</item>
        <item>All code blocks removed and expressed as constraint text</item>
      </list>

      <paragraph>**Exit Criteria:**</paragraph>
      <checklist>
        <item status="open">All 20 files have `<meta>` + `<purpose>` tags</item>
        <item status="open">No `##` / `###` Markdown headings remain</item>
        <item status="open">No fenced code blocks remain (all removed or compressed)</item>
        <item status="open">6 files without original frontmatter have `<meta>` derived from H1</item>
        <item status="open">All 7 gate scripts pass</item>
      </checklist>
    </subsection>

    <subsection title="Phase 6: Rules (8 files)">
      <paragraph>**Objective:** Convert all 8 rule files to XML-tagged structure. Aggressive code sample trimming. Map bold severity markers (`**CRITICAL**`, `**ALWAYS**`, `**NEVER**`) to `<directive severity="...">` attributes per the deterministic mapping in Section 3.3.7 of the specification.</paragraph>

      <list type="ordered">
        <task id="T6.1" file="super-dev-plugin/rules/*.md (8 files)" risk="Medium" domain="mixed">
          <paragraph>**Convert all 8 rule files to XML**</paragraph>
          <paragraph>Action: For each rule file: (1) Replace YAML frontmatter with `<meta>` (only `rust-project.md` has frontmatter -- for the other 7, derive from H1), (2) Add `<purpose>`, (3) Convert H2 headings to `<directives>` or `<topic>` tags, (4) Map individual rules to `<directive severity="critical|high|medium">` using severity inference heuristic, (5) Remove code blocks, express as constraint text, (6) Convert checkboxes to `<checklist><check>`.</paragraph>
          <paragraph>Why: Rules are structurally flat (no H3/H4) and small (36-75 lines).</paragraph>
          <paragraph>Dependencies: T5.1</paragraph>
        </task>
      </list>

      <paragraph>**Deliverables:**</paragraph>
      <list type="unordered">
        <item>8 rule files converted to XML-tagged structure</item>
        <item>All rules have `<directive severity="...">` attributes</item>
      </list>

      <paragraph>**Exit Criteria:**</paragraph>
      <checklist>
        <item status="open">All 8 files have `<meta>` + `<purpose>` tags</item>
        <item status="open">Every rule has a `severity` attribute matching the bold marker mapping</item>
        <item status="open">No `##` Markdown headings remain</item>
        <item status="open">All 7 gate scripts pass</item>
      </checklist>
    </subsection>

    <subsection title="Phase 7: Contexts (3 files)">
      <paragraph>**Objective:** Convert all 3 context files to XML-tagged structure. These are the simplest files in the entire plugin (20-26 lines, no frontmatter, no code blocks, no tables, flat structure). Key-value patterns (`Mode:`, `Focus:`) are mapped to type-specific tags (`<mode>`, `<priorities>`, `<tools>`).</paragraph>

      <list type="ordered">
        <task id="T7.1" file="super-dev-plugin/contexts/*.md (3 files)" risk="Low" domain="mixed">
          <paragraph>**Convert all 3 context files to XML**</paragraph>
          <paragraph>Action: For each context file: (1) Create `<meta>` from H1 heading (no frontmatter exists), (2) Add `<purpose>`, (3) Map `Mode:` line to `<mode>`, (4) Map `Focus:` line to purpose content, (5) Convert `## Behavior` to `<constraints>`, (6) Convert `## Priorities` to `<priorities><priority n="N">`, (7) Convert `## Tools to favor` to `<tools>`.</paragraph>
          <paragraph>Why: Simplest files -- ideal for late-phase conversion when the pattern is well-established.</paragraph>
          <paragraph>Dependencies: T6.1</paragraph>
        </task>
      </list>

      <paragraph>**Deliverables:**</paragraph>
      <list type="unordered">
        <item>3 context files converted to XML-tagged structure</item>
        <item>Key-value patterns mapped to type-specific tags</item>
      </list>

      <paragraph>**Exit Criteria:**</paragraph>
      <checklist>
        <item status="open">All 3 files have `<meta>` + `<purpose>` tags</item>
        <item status="open">`Mode:` lines are inside `<mode>` tags</item>
        <item status="open">Priority lists use `<priorities><priority n="N">` tags</item>
        <item status="open">All 7 gate scripts pass</item>
      </checklist>
    </subsection>

    <subsection title="Phase 8: Skills + Version Bump (9 files + 2 version files)">
      <paragraph>**Objective:** Convert all 9 skill SKILL.md files to XML-tagged structure. Aggressive code sample trimming. Complex YAML frontmatter (including nested `metadata:` blocks in `super-dev/SKILL.md` and `autoresearch/SKILL.md`) is replaced by `<meta>` with all nested fields flattened. H4+ headings in 3 files need flattening. This phase also includes the single version bump from 2.3.35 to 2.3.36.</paragraph>

      <list type="ordered">
        <task id="T8.1" file="super-dev-plugin/skills/*/SKILL.md (9 files)" risk="High" domain="mixed">
          <paragraph>**Convert all 9 skill SKILL.md files to XML**</paragraph>
          <paragraph>Action: For each skill file: (1) Replace YAML frontmatter with `<meta>` (all 9 have frontmatter -- nested `metadata:` blocks are flattened into `<meta>` children), (2) Add `<purpose>`, (3) Convert H2/H3 headings to semantic tags (`<workflow>`, `<triggers>`, `<activation>`, etc.), (4) Flatten H4+ headings in 3 files (security-review 31 H4+, adversarial-review 3 H4+, tdd-workflow 3 H4+), (5) Remove code blocks, (6) Preserve placeholder variables.</paragraph>
          <paragraph>Why: Skills have the most complex frontmatter and mixed content types.</paragraph>
          <paragraph>Dependencies: T7.1</paragraph>
        </task>
        <task id="T8.2" file="super-dev-plugin/.claude-plugin/plugin.json" risk="Low" domain="mixed">
          <paragraph>**Bump version in plugin.json**</paragraph>
          <paragraph>Action: Change version from `"2.3.35"` to `"2.3.36"` in `super-dev-plugin/.claude-plugin/plugin.json`.</paragraph>
          <paragraph>Why: CLAUDE.md versioning rule requires patch bump for any super-dev-plugin file modification.</paragraph>
          <paragraph>Dependencies: T8.1</paragraph>
        </task>
        <task id="T8.3" file=".claude-plugin/marketplace.json" risk="Low" domain="mixed">
          <paragraph>**Bump version in marketplace.json**</paragraph>
          <paragraph>Action: Change the super-dev entry version from `"2.3.35"` to `"2.3.36"` in `.claude-plugin/marketplace.json`.</paragraph>
          <paragraph>Why: marketplace.json version must match plugin.json per CLAUDE.md rule.</paragraph>
          <paragraph>Dependencies: T8.2</paragraph>
        </task>
      </list>

      <paragraph>**Deliverables:**</paragraph>
      <list type="unordered">
        <item>9 skill files converted to XML-tagged structure</item>
        <item>Complex nested YAML frontmatter replaced by flat `<meta>` tags</item>
        <item>Version bumped to 2.3.36 in both plugin.json and marketplace.json</item>
      </list>

      <paragraph>**Exit Criteria:**</paragraph>
      <checklist>
        <item status="open">All 9 skill files have `<meta>` + `<purpose>` tags</item>
        <item status="open">Nested `metadata:` YAML blocks are correctly flattened into `<meta>` children</item>
        <item status="open">H4+ headings in 3 files are flattened</item>
        <item status="open">plugin.json version is `"2.3.36"`</item>
        <item status="open">marketplace.json super-dev version is `"2.3.36"`</item>
        <item status="open">All 7 gate scripts pass</item>
        <item status="open">All 85 converted files + 6 normalized template files are in XML-tagged format</item>
      </checklist>
    </subsection>

  </section>

  <section title="Dependency Graph">
    <diagram>
Phase 1 [mixed]     Phase 2 [mixed]     Phase 3 [mixed]       Phase 4 [mixed]
+-----------+       +-----------+       +---------------+     +---------------+
| T1.1-T1.5 |------>| T2.1      |------>| T3.1-T3.9     |---->| T4.1 (agents) |
| 5 fences  |       | 1 chklst  |       | 9 ref files   |     | 36 files      |
+-----------+       +-----------+       +---------------+     +---------------+
                                                                     |
     +---------------------------------------------------------------+
     |
     v
Phase 5 [mixed]     Phase 6 [mixed]     Phase 7 [mixed]     Phase 8 [mixed]
+---------------+   +---------------+   +---------------+   +------------------+
| T5.1 (cmds)  |-->| T6.1 (rules)  |-->| T7.1 (ctxts)  |-->| T8.1-T8.3        |
| 20 files      |   | 8 files       |   | 3 files        |   | 9 skills + bump  |
+---------------+   +---------------+   +---------------+   +------------------+
    </diagram>
    <paragraph>All phases are strictly sequential. Each phase depends on the previous phase completing successfully (including gate script verification). No parallel execution between phases.</paragraph>
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
        <cell>XML inside code blocks corrupted during agent conversion</cell>
        <cell>Medium</cell>
        <cell>High</cell>
        <cell>T4.1 (13 agent files with XML in code blocks)</cell>
        <cell>Converter must be code-block-aware. Manual review of all 13 affected files. Verify JSX/XML content is inside `<code-sample>` tags.</cell>
      </row>
      <row>
        <cell>H4+ heading flattening loses semantic hierarchy</cell>
        <cell>Medium</cell>
        <cell>Medium</cell>
        <cell>T4.1 (5 agents), T3.5-T3.6 (2 refs), T8.1 (3 skills)</cell>
        <cell>Use descriptive `<topic name="...">` titles that encode parent context. Manual review of architecture-agent.md (30 H4+ headings).</cell>
      </row>
      <row>
        <cell>Complex YAML frontmatter in skills corrupted during meta conversion</cell>
        <cell>Low</cell>
        <cell>High</cell>
        <cell>T8.1 (super-dev/SKILL.md, autoresearch/SKILL.md)</cell>
        <cell>Extra manual review of nested `metadata:` block conversion. Verify all frontmatter fields appear in `<meta>` output.</cell>
      </row>
      <row>
        <cell>Placeholder variable `${...}` accidentally modified</cell>
        <cell>Low</cell>
        <cell>High</cell>
        <cell>T4.1 (17 agents), T5.1 (6 commands), T8.1 (4 skills)</cell>
        <cell>Grep-based before/after count comparison for all `${CLAUDE_PLUGIN_*}` patterns.</cell>
      </row>
      <row>
        <cell>Gate script regression after template normalization</cell>
        <cell>Low</cell>
        <cell>Medium</cell>
        <cell>T1.1-T1.5, T2.1</cell>
        <cell>Run all 7 gate scripts after Phase 1 and Phase 2. Gate scripts parse rendered artifacts, not templates directly, so risk is near zero.</cell>
      </row>
      <row>
        <cell>architecture-agent.md (1,544 lines) exceeds conversion agent context window</cell>
        <cell>Low</cell>
        <cell>Medium</cell>
        <cell>T4.1</cell>
        <cell>Convert in sections: read top half, convert, then read bottom half, convert. Verify no seam artifacts at the join point.</cell>
      </row>
      <row>
        <cell>Aggressive code trimming removes semantically important examples</cell>
        <cell>Medium</cell>
        <cell>Low</cell>
        <cell>T3.4-T3.9, T5.1, T6.1, T8.1</cell>
        <cell>Trimming removes code blocks but preserves all instructional text. If a code block is the sole explanation of a concept, compress to `<constraint>` text instead of deleting.</cell>
      </row>
    </table>
  </section>

  <section title="Timeline Estimates">
    <table>
      <row header="true">
        <cell>Phase</cell>
        <cell>Files</cell>
        <cell>Total Lines</cell>
        <cell>Parallel Potential</cell>
      </row>
      <row>
        <cell>Phase 1: Template Fence Removal</cell>
        <cell>5</cell>
        <cell>~10 lines changed</cell>
        <cell>All 5 tasks can run in parallel</cell>
      </row>
      <row>
        <cell>Phase 2: Checklist Fix</cell>
        <cell>1</cell>
        <cell>~20 lines changed</cell>
        <cell>Single task</cell>
      </row>
      <row>
        <cell>Phase 3: Reference Conversion</cell>
        <cell>9</cell>
        <cell>~4,825 lines</cell>
        <cell>All 9 tasks can run in parallel</cell>
      </row>
      <row>
        <cell>Phase 4: Agent Conversion</cell>
        <cell>36</cell>
        <cell>~15,610 lines</cell>
        <cell>All agent tasks can run in parallel (or split into 3 sub-phases of 12)</cell>
      </row>
      <row>
        <cell>Phase 5: Command Conversion</cell>
        <cell>20</cell>
        <cell>~2,078 lines</cell>
        <cell>All command tasks can run in parallel</cell>
      </row>
      <row>
        <cell>Phase 6: Rule Conversion</cell>
        <cell>8</cell>
        <cell>~458 lines</cell>
        <cell>All rule tasks can run in parallel</cell>
      </row>
      <row>
        <cell>Phase 7: Context Conversion</cell>
        <cell>3</cell>
        <cell>~68 lines</cell>
        <cell>All context tasks can run in parallel</cell>
      </row>
      <row>
        <cell>Phase 8: Skill Conversion + Bump</cell>
        <cell>9 + 2</cell>
        <cell>~2,814 lines + 2 JSON edits</cell>
        <cell>Skills in parallel; version bump sequential after</cell>
      </row>
      <row>
        <cell>**Total**</cell>
        <cell>**93 file operations**</cell>
        <cell>**~26,000 lines**</cell>
        <cell></cell>
      </row>
    </table>
  </section>

  <section title="Testing Strategy">
    <subsection title="Per-Phase Verification">
      <list type="unordered">
        <item>Run per-file verification checklist (Section 5.2 of specification) on every converted file</item>
        <item>Run all 7 gate scripts after each phase commit</item>
        <item>Grep for `${CLAUDE_PLUGIN_` count before/after each phase to verify placeholder preservation</item>
      </list>
    </subsection>
    <subsection title="Final Verification">
      <list type="unordered">
        <item>Verify all 85 converted files have `<meta>` + `<purpose>` tags</item>
        <item>Verify 8 untouched XML template files are byte-identical to pre-conversion state</item>
        <item>Verify 2 README files are byte-identical to pre-conversion state</item>
        <item>Verify plugin.json and marketplace.json both show version 2.3.36</item>
        <item>Run all 7 gate scripts one final time</item>
        <item>Spot-check 10 files across all categories for semantic content preservation</item>
      </list>
    </subsection>
  </section>

  <section title="Success Criteria">
    <checklist>
      <item status="open">100% of 85 target files converted to XML-tagged structure (AC-01 through AC-06)</item>
      <item status="open">14 XML template files normalized (5 fence removals + 1 checklist fix + 8 untouched)</item>
      <item status="open">All 7 gate scripts pass after every phase (AC-10)</item>
      <item status="open">Zero content/semantic loss across all converted files (AC-11)</item>
      <item status="open">All placeholder variables preserved character-identical (AC-13)</item>
      <item status="open">Plugin version 2.3.36 in both plugin.json and marketplace.json (AC-14)</item>
      <item status="open">Every commit contains only fully-converted files, no half-converted state (AC-15)</item>
      <item status="open">2 README files untouched (AC-08)</item>
    </checklist>
    <reference doc="./01-requirements.md" section="Acceptance Criteria">Cross-reference with requirements acceptance criteria AC-01 through AC-15 for full coverage.</reference>
  </section>

  <section title="Rollback Plan">
    <paragraph>If implementation must be reverted:</paragraph>

    <subsection title="Rollback Triggers">
      <list type="unordered">
        <item>Any gate script fails after a phase commit and the failure cannot be resolved by fixing the converted files</item>
        <item>Claude Code plugin system fails to load agents/commands/skills after YAML frontmatter removal</item>
        <item>Converted files cause agent behavioral regressions (instructions misinterpreted due to XML structure)</item>
      </list>
    </subsection>

    <subsection title="Rollback Steps">
      <list type="ordered">
        <item>Identify the phase that introduced the regression</item>
        <item>`git revert` the commit(s) from that phase and all subsequent phases</item>
        <item>Verify gate scripts pass after revert</item>
        <item>Investigate root cause before re-attempting the failed phase</item>
      </list>
    </subsection>

    <subsection title="Data Safety">
      <paragraph>This refactoring modifies only `.md` files and 2 JSON version files. No databases, APIs, or external systems are affected. Git history preserves all original file content. Rollback is a simple `git revert` with zero data loss risk.</paragraph>
    </subsection>
  </section>

</document>
