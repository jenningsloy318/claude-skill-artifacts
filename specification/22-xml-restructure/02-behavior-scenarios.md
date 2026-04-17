```xml
<document type="behavior-scenarios">

  <metadata>
    <field name="title">Behavior Scenarios: XML Restructure of super-dev-plugin Files</field>
    <field name="date">2026-04-16</field>
    <field name="author">super-dev:bdd-scenario-writer</field>
    <field name="source">./01-requirements.md</field>
    <field name="total-scenarios">45</field>
  </metadata>

  <section title="Feature: Agent File Conversion (AC-01)">

    <scenario id="SCENARIO-001" title="All agent files are converted to XML-tagged structure">
      <field name="acceptance-criteria">AC-01 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** the super-dev-plugin contains 36 agent files in `agents/` using Markdown heading format
        **When** the XML restructure conversion is applied to all agent files
        **Then** all 36 agent files use XML-tagged structure with `<document type="agent">` as the root wrapper
        **And** every `##` heading is replaced by a `<section>` tag and every `###` heading by a `<subsection>` tag
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-002" title="Agent file preserves persona and instruction sections after conversion">
      <field name="acceptance-criteria">AC-01 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** an agent file containing persona definition and step-by-step instructions under Markdown headings
        **When** the file is converted to XML-tagged structure
        **Then** the persona content appears within a `<persona>` tag
        **And** all instruction steps are preserved with identical semantic meaning inside `<section>` or `<subsection>` tags
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-003" title="Agent file with deeply nested headings flattens H4+ to subsection tags">
      <field name="acceptance-criteria">AC-01 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** an agent file with 4+ levels of heading hierarchy (e.g., `####` and deeper)
        **When** the file is converted to XML-tagged structure
        **Then** all `####` and deeper headings are converted to `<subsection>` tags without introducing deeper nesting levels
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Command File Conversion (AC-02)">

    <scenario id="SCENARIO-004" title="All command files are converted to XML-tagged structure">
      <field name="acceptance-criteria">AC-02 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** the super-dev-plugin contains 20 command files in `commands/` using Markdown heading format
        **When** the XML restructure conversion is applied to all command files
        **Then** all 20 command files use XML-tagged structure with `<document type="command">` as the root wrapper
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-005" title="Command file retains usage examples and integration notes after conversion">
      <field name="acceptance-criteria">AC-02 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** a command file containing usage examples and integration notes under Markdown headings
        **When** the file is converted to XML-tagged structure
        **Then** all usage examples appear within `<example>` or `<code>` tags
        **And** integration notes are preserved within `<section>` tags with identical content
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Rule File Conversion (AC-03)">

    <scenario id="SCENARIO-006" title="All rule files are converted to XML-tagged structure">
      <field name="acceptance-criteria">AC-03 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** the super-dev-plugin contains 8 rule files in `rules/` using Markdown heading format
        **When** the XML restructure conversion is applied to all rule files
        **Then** all 8 rule files use XML-tagged structure with `<document type="rule">` as the root wrapper
        **And** individual rules are wrapped in `<rule>` tags with appropriate severity attributes
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-007" title="Rule severity levels are preserved in converted rule files">
      <field name="acceptance-criteria">AC-03 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** a rule file containing rules with varying enforcement levels (critical, important, normal)
        **When** the file is converted to XML-tagged structure
        **Then** each rule's severity is expressed via the `severity` attribute on the `<rule>` tag
        **And** the enforcement intent of every rule is unchanged
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Context File Conversion (AC-04)">

    <scenario id="SCENARIO-008" title="All context files are converted to XML-tagged structure">
      <field name="acceptance-criteria">AC-04 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** the super-dev-plugin contains 3 context files in `contexts/` using Markdown heading format
        **When** the XML restructure conversion is applied to all context files
        **Then** all 3 context files use XML-tagged structure with `<document type="context">` as the root wrapper
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-009" title="Context file mode-specific behavior configuration is preserved">
      <field name="acceptance-criteria">AC-04 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** a context file that defines mode-specific behavior configuration under Markdown headings
        **When** the file is converted to XML-tagged structure
        **Then** all mode-specific configuration sections are preserved with identical behavioral semantics inside XML tags
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Skill File Conversion (AC-05)">

    <scenario id="SCENARIO-010" title="All skill SKILL.md files are converted to XML-tagged structure with frontmatter preserved">
      <field name="acceptance-criteria">AC-05 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** the super-dev-plugin contains 9 skill SKILL.md files using Markdown heading format with YAML frontmatter including `metadata:` blocks
        **When** the XML restructure conversion is applied to all skill files
        **Then** all 9 skill files use XML-tagged structure with `<document type="skill">` as the root wrapper
        **And** the YAML frontmatter is retained exactly as-is above the XML body
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-011" title="Skill file architecture and phase flow content is preserved">
      <field name="acceptance-criteria">AC-05 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** a skill SKILL.md file containing architecture descriptions and phase flow definitions
        **When** the file is converted to XML-tagged structure
        **Then** all architecture descriptions and phase flow steps appear in the converted file with identical meaning
        **And** no instructional content is lost or reworded
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Reference Template Conversion (AC-06)">

    <scenario id="SCENARIO-012" title="All non-XML reference templates are converted to XML-tagged structure">
      <field name="acceptance-criteria">AC-06 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** 11 non-XML reference templates in `templates/reference/` (patterns, standards, methodology, example files) using Markdown heading format
        **When** the XML restructure conversion is applied to all non-XML reference templates
        **Then** all 11 files use XML-tagged structure with `<document type="reference">` as the root wrapper
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-013" title="Reference template with embedded XML examples preserves them inside code tags">
      <field name="acceptance-criteria">AC-06 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** a reference template containing XML-like content inside fenced code blocks as examples
        **When** the file is converted to XML-tagged structure
        **Then** the XML-like content inside code blocks is left untouched within `<code>` tags
        **And** only the structural Markdown outside code blocks is converted to XML tags
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Existing XML Templates Untouched (AC-07)">

    <scenario id="SCENARIO-014" title="Spec-artifact templates already using XML are not modified">
      <field name="acceptance-criteria">AC-07 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** 13 spec-artifact templates in `templates/reference/` that already use XML-tagged format
        **When** the XML restructure conversion process executes
        **Then** none of the 13 spec-artifact templates are modified in any way
        **And** their file contents remain byte-identical to the pre-conversion state
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-015" title="Conversion process correctly distinguishes XML templates from Markdown templates">
      <field name="acceptance-criteria">AC-07 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** the `templates/reference/` directory contains both XML-tagged templates and Markdown-formatted reference files
        **When** the conversion process evaluates which files to convert
        **Then** only files still using Markdown heading format are selected for conversion
        **And** files already using `<document>` root tags are excluded from processing
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: README Files Untouched (AC-08)">

    <scenario id="SCENARIO-016" title="README files are excluded from conversion">
      <field name="acceptance-criteria">AC-08 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** the plugin directory contains `super-dev-plugin/README.md` and `scripts/README.md`
        **When** the XML restructure conversion process executes
        **Then** neither README file is modified
        **And** their contents remain byte-identical to the pre-conversion state
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: YAML Frontmatter Preservation (AC-09)">

    <scenario id="SCENARIO-017" title="YAML frontmatter blocks are preserved exactly in agent files">
      <field name="acceptance-criteria">AC-09 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** an agent file with a YAML frontmatter block containing `name:` and `description:` fields enclosed in `---` delimiters
        **When** the file is converted to XML-tagged structure
        **Then** the YAML frontmatter block is byte-identical to the original
        **And** the frontmatter remains at the top of the file, above the XML body
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-018" title="YAML frontmatter blocks are preserved exactly in command files">
      <field name="acceptance-criteria">AC-09 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** a command file with a YAML frontmatter block containing `name:` and `description:` fields
        **When** the file is converted to XML-tagged structure
        **Then** the YAML frontmatter block is byte-identical to the original
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-019" title="YAML frontmatter with metadata blocks is preserved in skill files">
      <field name="acceptance-criteria">AC-09 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** a skill SKILL.md file with a YAML frontmatter block containing a `metadata:` block with nested fields
        **When** the file is converted to XML-tagged structure
        **Then** the entire YAML frontmatter block including the nested `metadata:` structure is byte-identical to the original
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-020" title="Conversion fails gracefully if frontmatter is malformed">
      <field name="acceptance-criteria">AC-09 from requirements</field>
      <field name="priority">P2</field>

      <paragraph>
        **Given** a file with improperly closed YAML frontmatter (missing closing `---`)
        **When** the conversion process encounters this file
        **Then** the file is flagged for manual review rather than silently corrupting the frontmatter
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Gate Script Compatibility (AC-10)">

    <scenario id="SCENARIO-021" title="All seven gate scripts pass after conversion">
      <field name="acceptance-criteria">AC-10 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** all seven gate scripts (`gate-requirements.sh`, `gate-bdd.sh`, `gate-spec-trace.sh`, `gate-review.sh`, `gate-spec-review.sh`, `gate-build.sh`, `gate-docs-drift.sh`) pass before conversion
        **When** all non-template files have been converted to XML-tagged structure
        **Then** all seven gate scripts produce identical pass/fail results as before conversion
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-022" title="Gate scripts that parse rendered template output are unaffected by source file conversion">
      <field name="acceptance-criteria">AC-10 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** gate scripts parse rendered spec artifacts (requirements, behavior-scenarios, etc.) produced by templates that already use XML
        **When** the source instruction files (agents, commands, rules) are converted from Markdown to XML
        **Then** the rendered spec artifacts remain unchanged
        **And** gate script regex patterns continue to match their expected patterns
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-023" title="Gate scripts are verified after each conversion phase">
      <field name="acceptance-criteria">AC-10, AC-15 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** conversion proceeds in multiple phases with incremental commits
        **When** a conversion phase is completed and committed
        **Then** all gate scripts are run against the post-commit state
        **And** any gate failure blocks the next conversion phase from starting
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Zero Content Loss (AC-11)">

    <scenario id="SCENARIO-024" title="Every sentence and paragraph is preserved after conversion">
      <field name="acceptance-criteria">AC-11 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** a file containing prose paragraphs, instructions, and explanatory text under Markdown headings
        **When** the file is converted to XML-tagged structure
        **Then** every sentence present in the original file appears in the converted file with identical wording
        **And** no explanatory text, annotations, or content is added that was not in the original
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-025" title="All code blocks are preserved after conversion">
      <field name="acceptance-criteria">AC-11 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** a file containing fenced code blocks with language identifiers (e.g., ` ```bash `, ` ```xml `)
        **When** the file is converted to XML-tagged structure
        **Then** every code block appears within a `<code language="...">` tag with the content byte-identical to the original
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-026" title="All tables are preserved after conversion">
      <field name="acceptance-criteria">AC-11 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** a file containing Markdown pipe tables with header rows and data rows
        **When** the file is converted to XML-tagged structure
        **Then** every table row and cell value appears in the converted file within `<table>`, `<row>`, and `<cell>` tags
        **And** the data is semantically identical to the original table
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-027" title="All list items are preserved after conversion">
      <field name="acceptance-criteria">AC-11 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** a file containing ordered and unordered lists under Markdown headings
        **When** the file is converted to XML-tagged structure
        **Then** every list item appears within `<list>` and `<item>` tags with the correct list type attribute
        **And** no list items are omitted or reordered
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-028" title="All diagrams and ASCII art are preserved after conversion">
      <field name="acceptance-criteria">AC-11 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** a file containing ASCII diagrams or flow charts
        **When** the file is converted to XML-tagged structure
        **Then** every diagram appears within a `<diagram>` tag with the content character-identical to the original
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-029" title="Checkbox lists are preserved as checklists after conversion">
      <field name="acceptance-criteria">AC-11 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** a file containing checkbox lists (`- [ ] item` and `- [x] item`)
        **When** the file is converted to XML-tagged structure
        **Then** every checkbox item appears within `<checklist>` and `<item status="open|done">` tags
        **And** the checked/unchecked status of each item is preserved accurately
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Inline Markdown Preservation (AC-12)">

    <scenario id="SCENARIO-030" title="Bold, italic, and inline code formatting is preserved inside XML tags">
      <field name="acceptance-criteria">AC-12 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** a file containing inline Markdown formatting: bold (`**text**`), italic (`*text*`), and inline code (`` `code` ``)
        **When** the file is converted to XML-tagged structure
        **Then** all bold, italic, and inline code markers remain as-is inside the XML tags
        **And** no inline formatting is stripped, escaped, or converted to XML attributes
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-031" title="Markdown links are preserved inside XML tags">
      <field name="acceptance-criteria">AC-12 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** a file containing Markdown links (`[text](url)`)
        **When** the file is converted to XML-tagged structure
        **Then** all link syntax remains as-is inside the XML tags with both text and URL unchanged
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Placeholder Variable Preservation (AC-13)">

    <scenario id="SCENARIO-032" title="Plugin root and data path variables are preserved exactly">
      <field name="acceptance-criteria">AC-13 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** a file containing placeholder variables `${CLAUDE_PLUGIN_ROOT}` and `${CLAUDE_PLUGIN_DATA}`
        **When** the file is converted to XML-tagged structure
        **Then** every placeholder variable appears in the converted file character-identical to the original
        **And** no variable is interpreted, expanded, or escaped during conversion
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-033" title="All placeholder variable patterns are preserved across all file types">
      <field name="acceptance-criteria">AC-13 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** files across agents, commands, skills, and rules containing various `${...}` placeholder patterns
        **When** all files are converted to XML-tagged structure
        **Then** a text comparison of placeholder variables before and after conversion shows zero differences
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Plugin Version Bump (AC-14)">

    <scenario id="SCENARIO-034" title="Plugin version is bumped in plugin.json after conversion">
      <field name="acceptance-criteria">AC-14 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** the current plugin version is recorded in `super-dev-plugin/.claude-plugin/plugin.json`
        **When** any file under `super-dev-plugin/` is modified as part of the XML restructure
        **Then** the patch version in `plugin.json` is incremented (e.g., 2.3.35 becomes 2.3.36)
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-035" title="Plugin version in marketplace.json matches plugin.json">
      <field name="acceptance-criteria">AC-14 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** the plugin version must be synchronized between `super-dev-plugin/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`
        **When** the plugin version is bumped as part of the XML restructure
        **Then** the version in `marketplace.json` for the super-dev entry is identical to the version in `plugin.json`
        **And** both files are included in the same commit
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-036" title="Version is bumped exactly once per conversion phase commit">
      <field name="acceptance-criteria">AC-14, AC-15 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** conversion is performed in multiple phases with separate commits
        **When** each phase commit modifies files under `super-dev-plugin/`
        **Then** each commit includes exactly one patch version bump in both `plugin.json` and `marketplace.json`
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Incremental Working State Commits (AC-15)">

    <scenario id="SCENARIO-037" title="Each commit leaves the plugin in a fully working state">
      <field name="acceptance-criteria">AC-15 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** the XML restructure is performed in multiple phases
        **When** a conversion phase is committed
        **Then** every file in the commit is fully converted (no half-converted files with mixed Markdown headings and XML tags)
        **And** the plugin can be loaded and used by agents without errors
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-038" title="No commit contains a partially converted file">
      <field name="acceptance-criteria">AC-15 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** a batch of files is being converted in a single phase
        **When** the phase commit is created
        **Then** every file in the commit either retains its original Markdown format entirely or is fully converted to XML-tagged structure
        **And** no file exists in an intermediate state with some headings converted and others not
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-039" title="Conversion failure in one file does not corrupt other files in the batch">
      <field name="acceptance-criteria">AC-15 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** a batch of files is being converted in a single phase
        **When** one file encounters a conversion issue (e.g., ambiguous nesting)
        **Then** the problematic file is excluded from the commit and flagged for manual review
        **And** all other successfully converted files in the batch remain in a consistent state
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Unified Tag Schema Compliance (Cross-Cutting)">

    <scenario id="SCENARIO-040" title="Converted files use only tags from the unified tag schema">
      <field name="acceptance-criteria">AC-01, AC-02, AC-03, AC-04, AC-05, AC-06 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** the unified tag schema defines structural tags (`<document>`, `<metadata>`, `<section>`, `<subsection>`), content tags (`<paragraph>`, `<list>`, `<code>`, `<table>`, `<diagram>`, `<checklist>`), and semantic tags (`<persona>`, `<rule>`, `<example>`, `<option>`, `<field>`)
        **When** any file is converted to XML-tagged structure
        **Then** only tags from the unified tag schema are used in the converted file
        **And** no ad-hoc or invented tags appear in the output
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-041" title="Every converted file has a document root with correct type attribute">
      <field name="acceptance-criteria">AC-01, AC-02, AC-03, AC-04, AC-05, AC-06 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** the unified tag schema requires a `<document type="...">` root wrapper with a type attribute matching the file category
        **When** any file is converted to XML-tagged structure
        **Then** the file's XML body is wrapped in exactly one `<document type="...">` tag
        **And** the type attribute matches the file's category (agent, command, rule, context, skill, or reference)
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-042" title="Every converted file contains a metadata section">
      <field name="acceptance-criteria">AC-01, AC-02, AC-03, AC-04, AC-05, AC-06 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** the unified tag schema requires a `<metadata>` section with `<field>` entries
        **When** any file is converted to XML-tagged structure
        **Then** the converted file contains a `<metadata>` section with at minimum a `<field name="title">` entry
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Token Budget Compliance (Non-Functional)">

    <scenario id="SCENARIO-043" title="Converted files do not exceed 5% token increase">
      <field name="acceptance-criteria">AC-11 from requirements (NFR: token budget)</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** a file has a measured token count before conversion
        **When** the file is converted to XML-tagged structure
        **Then** the post-conversion token count does not exceed 105% of the pre-conversion count
      </paragraph>
    </scenario>

  </section>

  <section title="Feature: Heading-to-Tag Mapping Correctness (Cross-Cutting)">

    <scenario id="SCENARIO-044" title="H1 headings are converted to document title metadata">
      <field name="acceptance-criteria">AC-01, AC-02, AC-03, AC-04, AC-05, AC-06 from requirements</field>
      <field name="priority">P0</field>

      <paragraph>
        **Given** a file begins with an H1 heading (`# Title`)
        **When** the file is converted to XML-tagged structure
        **Then** the H1 content becomes a `<field name="title">` entry inside the `<metadata>` section
        **And** the original `#` heading marker is removed
      </paragraph>
    </scenario>

    <scenario id="SCENARIO-045" title="YAML frontmatter is duplicated into metadata section for in-document reference">
      <field name="acceptance-criteria">AC-09, AC-11 from requirements</field>
      <field name="priority">P1</field>

      <paragraph>
        **Given** a file has YAML frontmatter with `name:` and `description:` fields AND the conversion adds a `<metadata>` section
        **When** the file is converted to XML-tagged structure
        **Then** the YAML frontmatter remains untouched above the XML body
        **And** key fields from the frontmatter are duplicated as `<field>` entries in the `<metadata>` section for in-document reference
      </paragraph>
    </scenario>

  </section>

  <section title="Scenario-Acceptance Criteria Traceability Matrix">
    <table>
      <row header="true">
        <cell>Acceptance Criterion</cell>
        <cell>Scenario IDs</cell>
        <cell>Coverage</cell>
      </row>
      <row>
        <cell>AC-01: Agent files converted to XML</cell>
        <cell>SCENARIO-001, SCENARIO-002, SCENARIO-003, SCENARIO-040, SCENARIO-041, SCENARIO-042, SCENARIO-044</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-02: Command files converted to XML</cell>
        <cell>SCENARIO-004, SCENARIO-005, SCENARIO-040, SCENARIO-041, SCENARIO-042, SCENARIO-044</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-03: Rule files converted to XML</cell>
        <cell>SCENARIO-006, SCENARIO-007, SCENARIO-040, SCENARIO-041, SCENARIO-042, SCENARIO-044</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-04: Context files converted to XML</cell>
        <cell>SCENARIO-008, SCENARIO-009, SCENARIO-040, SCENARIO-041, SCENARIO-042, SCENARIO-044</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-05: Skill files converted with frontmatter preserved</cell>
        <cell>SCENARIO-010, SCENARIO-011, SCENARIO-040, SCENARIO-041, SCENARIO-042, SCENARIO-044</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-06: Non-XML reference templates converted</cell>
        <cell>SCENARIO-012, SCENARIO-013, SCENARIO-040, SCENARIO-041, SCENARIO-042, SCENARIO-044</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-07: XML spec-artifact templates NOT modified</cell>
        <cell>SCENARIO-014, SCENARIO-015</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-08: README files NOT modified</cell>
        <cell>SCENARIO-016</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-09: YAML frontmatter preserved byte-identical</cell>
        <cell>SCENARIO-017, SCENARIO-018, SCENARIO-019, SCENARIO-020, SCENARIO-045</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-10: All 7 gate scripts pass after conversion</cell>
        <cell>SCENARIO-021, SCENARIO-022, SCENARIO-023</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-11: Zero content loss</cell>
        <cell>SCENARIO-024, SCENARIO-025, SCENARIO-026, SCENARIO-027, SCENARIO-028, SCENARIO-029, SCENARIO-043, SCENARIO-045</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-12: Inline Markdown formatting preserved</cell>
        <cell>SCENARIO-030, SCENARIO-031</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-13: Placeholder variables preserved</cell>
        <cell>SCENARIO-032, SCENARIO-033</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-14: Plugin version bumped in both files</cell>
        <cell>SCENARIO-034, SCENARIO-035, SCENARIO-036</cell>
        <cell>Covered</cell>
      </row>
      <row>
        <cell>AC-15: Each commit leaves plugin in working state</cell>
        <cell>SCENARIO-023, SCENARIO-036, SCENARIO-037, SCENARIO-038, SCENARIO-039</cell>
        <cell>Covered</cell>
      </row>
    </table>
    <rule>Every acceptance criterion from 01-requirements.md appears in this matrix with at least one scenario. Zero uncovered items.</rule>
  </section>

  <section title="Coverage Summary">
    <list type="unordered">
      <item>**Total Acceptance Criteria:** 15</item>
      <item>**Covered by Scenarios:** 15</item>
      <item>**Uncovered:** 0</item>
      <item>**Total Scenarios:** 45</item>
      <item>**Scenarios per AC (avg):** 3.0</item>
    </list>
  </section>

  <section title="Quality Validation">

    <subsection title="Per-Scenario Checks">
      <table>
        <row header="true">
          <cell>Scenario</cell>
          <cell>Q1</cell>
          <cell>Q2</cell>
          <cell>Q3</cell>
          <cell>Q4</cell>
          <cell>Q5</cell>
          <cell>Q6</cell>
          <cell>Q7</cell>
          <cell>Q8</cell>
          <cell>Q9</cell>
          <cell>Q10</cell>
          <cell>Pass</cell>
        </row>
        <row><cell>SCENARIO-001</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-002</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-003</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-004</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-005</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-006</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-007</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-008</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-009</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-010</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-011</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-012</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-013</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-014</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-015</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-016</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-017</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-018</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-019</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-020</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-021</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-022</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-023</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-024</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-025</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-026</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-027</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-028</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-029</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-030</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-031</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-032</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-033</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-034</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-035</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-036</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-037</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-038</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-039</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-040</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-041</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-042</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-043</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-044</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
        <row><cell>SCENARIO-045</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell><cell>Y</cell></row>
      </table>
      <paragraph>
        Q1: Single Behavior | Q2: Declarative Style | Q3: Business Language |
        Q4: Meaningful Title | Q5: Independence | Q6: Concise Steps |
        Q7: Concrete Examples | Q8: AC Traceability | Q9: No Implementation Leakage |
        Q10: Testable Outcome
      </paragraph>
    </subsection>

    <subsection title="Per-Document Checks">
      <checklist>
        <item status="pass">D1: All AC covered (15/15)</item>
        <item status="pass">D2: Scenario count within limits (2-8 per feature area, 45 total across 15 areas)</item>
        <item status="pass">D3: Traceability matrix complete</item>
        <item status="pass">D4: All IDs unique (SCENARIO-001 through SCENARIO-045)</item>
        <item status="pass">D5: Priorities assigned (P0/P1/P2 on all scenarios)</item>
        <item status="pass">D6: Happy paths first (each feature area leads with the golden scenario)</item>
        <item status="pass">D7: Error cases included (SCENARIO-020 malformed frontmatter, SCENARIO-039 conversion failure)</item>
        <item status="pass">D8: No duplicates (each scenario tests a distinct behavior)</item>
      </checklist>
    </subsection>

  </section>

</document>
```
