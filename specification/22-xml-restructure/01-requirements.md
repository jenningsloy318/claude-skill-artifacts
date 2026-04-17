```xml
<document type="requirements">

  <metadata>
    <field name="title">Requirements: XML Restructure of super-dev-plugin Files</field>
    <field name="date">2026-04-16</field>
    <field name="author">super-dev:requirements-clarifier</field>
    <field name="type">Improvement</field>
    <field name="priority">High</field>
    <field name="status">Draft</field>
  </metadata>

  <section title="Executive Summary">
    <paragraph>Convert all ~77 Markdown files under `super-dev-plugin/` from Markdown heading/prose format to a unified XML-tagged structure. The 13 spec-artifact templates (requirements, specification, code-review, etc.) already use XML tags and serve as the proven reference format. The remaining files — 36 agents, 20 commands, 8 rules, 3 contexts, 9 skills, and 11 reference/pattern templates — still use Markdown headings (`##`, `###`) and unstructured prose. This restructuring standardizes the entire plugin on one structural format, improving LLM parsing efficiency, reducing token consumption, and enabling programmatic validation via gate scripts.</paragraph>
  </section>

  <section title="The Real Need (Root Cause Analysis)">

    <subsection title="Surface Request">
      <paragraph>Convert all `.md` files in `super-dev-plugin/` from Markdown heading format to XML-tagged structure for consistency with the template files that already use XML.</paragraph>
    </subsection>

    <subsection title="5 Whys Analysis">
      <list type="ordered">
        <item>Why restructure? The plugin has two inconsistent formats: XML-tagged templates and Markdown-heading agents/commands/rules/contexts/skills/patterns.</item>
        <item>Why is inconsistency a problem? LLMs must parse both formats when loading instructions, adding cognitive overhead and increasing error rates on structural interpretation.</item>
        <item>Why does LLM parsing matter? These files are loaded into agent context windows as system prompts. Ambiguous structure leads to misinterpreted instructions, missed rules, and skipped sections.</item>
        <item>Why not just improve the Markdown? XML tags provide explicit, unambiguous section boundaries that LLMs can parse deterministically, whereas Markdown heading hierarchy is implicit and error-prone for deeply nested content.</item>
        <item>Why now? The plugin has grown to 101 files (77 non-template + 25 templates, minus 1 README). The 13 templates that already use XML have proven the format works. Standardizing now prevents the format debt from growing further.</item>
      </list>
    </subsection>

    <subsection title="Job to Be Done">
      <paragraph>
        **When** a super-dev agent loads its prompt file at the start of a workflow phase
        **I want to** have all instruction files in a consistent XML-tagged structure
        **So I can** parse sections deterministically, reduce token waste from ambiguous formatting, and enable programmatic validation of file structure
      </paragraph>

      <paragraph>**Job Type:**</paragraph>
      <list type="unordered">
        <item>Functional: Unify file format across the entire plugin for reliable LLM parsing</item>
        <item>Emotional: Confidence that agent instructions are interpreted correctly every time</item>
        <item>Social: Demonstrate engineering rigor — the plugin uses a single, validated format throughout</item>
      </list>
    </subsection>

  </section>

  <section title="Workflow Context">

    <subsection title="Current State">
      <paragraph>The super-dev-plugin contains 101 `.md` files across 6 categories. Of these, 13 spec-artifact templates already use XML-tagged format. The remaining 88 files use Markdown headings (`#`, `##`, `###`), YAML frontmatter (`---`), fenced code blocks, and inline formatting. There is no structural validation for non-template files — errors in heading hierarchy or missing sections go undetected.</paragraph>
    </subsection>

    <subsection title="File Inventory">
      <list type="unordered">
        <item>**Agents** (`agents/`): 36 files — persona definitions, step-by-step instructions, quality checklists</item>
        <item>**Commands** (`commands/`): 20 files — slash-command descriptions, usage examples, integration notes</item>
        <item>**Rules** (`rules/`): 8 files — coding style rules, workflow rules, pattern enforcement</item>
        <item>**Contexts** (`contexts/`): 3 files — mode-specific behavior configuration</item>
        <item>**Skills** (`skills/*/SKILL.md`): 9 files — skill definitions with metadata, architecture, phase flows</item>
        <item>**Templates (already XML)** (`templates/reference/*-template.md`): 13 files — spec-artifact templates, NO changes needed</item>
        <item>**Templates (still Markdown)** (`templates/reference/*-patterns.md`, `*-standards.md`, etc.): 11 files — reference patterns and examples</item>
        <item>**READMEs**: 2 files (`super-dev-plugin/README.md`, `scripts/README.md`) — excluded from conversion</item>
      </list>
    </subsection>

    <subsection title="Pain Points">
      <list type="unordered">
        <item>Two competing structural formats within the same plugin create cognitive load for both LLM agents and human maintainers</item>
        <item>Markdown heading hierarchy is implicit — `###` under `##` is convention, not enforced. XML nesting is explicit and unambiguous</item>
        <item>No programmatic validation exists for agent/command/rule files — structural errors (missing sections, wrong nesting) are silent</item>
        <item>LLMs parse XML tags more efficiently than Markdown headings, especially for deeply nested content with code blocks</item>
        <item>Token waste: Markdown `#` characters and blank separator lines consume tokens without carrying structural information that XML tags provide more compactly</item>
      </list>
    </subsection>

    <subsection title="Workflow Map">
      <diagram>
[Current: Mixed MD/XML files] --> [Convert non-template files to XML] --> [Unified XML plugin]
                                            |
                                            v
                                  [Validate gate scripts still pass]
                                            |
                                            v
                                  [All files: consistent XML structure]
      </diagram>
    </subsection>

    <subsection title="Stakeholders">
      <list type="unordered">
        <item>**LLM agents** (primary consumer): Load these files as system prompts — benefit from unambiguous structure</item>
        <item>**Plugin maintainers**: Edit these files — benefit from one format to learn, one structure to follow</item>
        <item>**Gate scripts** (`gate-*.sh`): Parse template output using regex — MUST NOT break</item>
        <item>**End users**: Invoke skills/commands — indirectly benefit from more reliable agent behavior</item>
      </list>
    </subsection>

  </section>

  <section title="Requirements">

    <subsection title="Functional Requirements">
      <list type="ordered">
        <item>**FR-01**: Convert all 36 agent files (`agents/*.md`) from Markdown heading format to XML-tagged structure, preserving YAML frontmatter (`---` blocks with `name:` and `description:` fields)</item>
        <item>**FR-02**: Convert all 20 command files (`commands/*.md`) from Markdown heading format to XML-tagged structure, preserving YAML frontmatter</item>
        <item>**FR-03**: Convert all 8 rule files (`rules/*.md`) from Markdown heading format to XML-tagged structure</item>
        <item>**FR-04**: Convert all 3 context files (`contexts/*.md`) from Markdown heading format to XML-tagged structure</item>
        <item>**FR-05**: Convert all 9 skill files (`skills/*/SKILL.md`) from Markdown heading format to XML-tagged structure, preserving YAML frontmatter (including `metadata:` blocks)</item>
        <item>**FR-06**: Convert all 11 non-XML reference templates (`templates/reference/*-patterns.md`, `*-standards.md`, `*-methodology.md`, `*-example.md`) from Markdown heading format to XML-tagged structure</item>
        <item>**FR-07**: Do NOT modify the 13 spec-artifact templates that already use XML format</item>
        <item>**FR-08**: Do NOT modify README files (`super-dev-plugin/README.md`, `scripts/README.md`)</item>
        <item>**FR-09**: Preserve all content — every heading, paragraph, code block, list, table, diagram, and instruction must survive the conversion with identical semantic meaning</item>
        <item>**FR-10**: Use the unified tag schema defined in the Design Decisions section for all converted files</item>
        <item>**FR-11**: All gate scripts (`gate-requirements.sh`, `gate-bdd.sh`, `gate-spec-trace.sh`, `gate-review.sh`, `gate-spec-review.sh`, `gate-build.sh`, `gate-docs-drift.sh`) must continue to pass after conversion</item>
      </list>
    </subsection>

    <subsection title="Non-Functional Requirements">
      <list type="unordered">
        <item>**Performance / Token Reduction**: The XML-tagged format should reduce or maintain token count per file compared to Markdown heading format. Target: no more than 5% token increase per file (XML tags replace heading markers, so net change should be minimal or negative)</item>
        <item>**Security**: No behavioral or logic changes — this is a purely structural refactoring. No new code, no new execution paths</item>
        <item>**Accessibility / Readability**: XML tags must be human-readable. Tag names must be descriptive (`<section>`, `<subsection>`, `<rule>`, `<persona>`) not cryptic (`<s>`, `<ss>`, `<r>`)</item>
        <item>**Compatibility**: Converted files must remain valid Markdown (XML tags are treated as inline HTML by Markdown renderers). Gate scripts that parse template output must not break</item>
        <item>**Maintainability**: The unified tag schema must be documented so future file additions follow the same structure</item>
      </list>
    </subsection>

    <subsection title="Anticipated Downstream Needs">
      <paragraph>Based on workflow analysis:</paragraph>
      <list type="unordered">
        <item>**Structural validation scripts**: Once all files use XML, a `lint-xml-structure.sh` gate could validate that every agent file has required sections (`<persona>`, `<instructions>`, `<quality-standards>`) — not in scope for this task, but enabled by it</item>
        <item>**Automated tag inventory**: With uniform XML structure, tools can programmatically extract all `<rule>` blocks across the plugin for conflict detection</item>
        <item>**Token budget analysis**: Uniform format enables accurate, automated token counting per file category</item>
      </list>
    </subsection>

  </section>

  <section title="Design Decisions">

    <subsection title="Unified Tag Schema">
      <paragraph>All converted files must use the following tag vocabulary. Tags are drawn from the existing XML templates and extended for agent/command/rule/context/skill content types.</paragraph>

      <paragraph>**Structural tags** (nesting hierarchy):</paragraph>
      <list type="unordered">
        <item>`<document type="...">` — Root wrapper. `type` attribute identifies the file category: `agent`, `command`, `rule`, `context`, `skill`, `reference`</item>
        <item>`<metadata>` — Contains `<field name="...">` entries for frontmatter-equivalent data (name, description, version, etc.)</item>
        <item>`<section title="...">` — Top-level section (replaces `##` headings)</item>
        <item>`<subsection title="...">` — Nested section (replaces `###` headings)</item>
      </list>

      <paragraph>**Content tags** (leaf-level content):</paragraph>
      <list type="unordered">
        <item>`<paragraph>` — Block of prose text</item>
        <item>`<list type="ordered|unordered">` with `<item>` children — Bulleted or numbered lists</item>
        <item>`<code language="...">` — Fenced code blocks (replaces triple-backtick blocks)</item>
        <item>`<table>` with `<row>` and `<cell>` children — Tables (replaces Markdown pipe tables)</item>
        <item>`<diagram>` — ASCII diagrams and flow charts</item>
        <item>`<checklist>` with `<item status="open|done">` — Checkbox lists</item>
      </list>

      <paragraph>**Semantic tags** (domain-specific, used where appropriate):</paragraph>
      <list type="unordered">
        <item>`<persona>` — Agent persona definition (who the agent is, cognitive mode)</item>
        <item>`<rule severity="critical|important|normal">` — Individual rule or constraint</item>
        <item>`<example>` — Worked examples, usage demonstrations</item>
        <item>`<option id="N" label="...">` — Solution options (already used in requirements template)</item>
        <item>`<field name="...">` — Key-value metadata entries</item>
      </list>
    </subsection>

    <subsection title="Heading-to-Tag Mapping">
      <paragraph>The conversion follows this deterministic mapping from Markdown to XML:</paragraph>
      <table>
        <row header="true">
          <cell>Markdown Pattern</cell>
          <cell>XML Replacement</cell>
        </row>
        <row><cell>`# Title` (H1)</cell><cell>`<document type="...">` + `<metadata><field name="title">Title</field></metadata>`</cell></row>
        <row><cell>`## Heading` (H2)</cell><cell>`<section title="Heading">`</cell></row>
        <row><cell>`### Subheading` (H3)</cell><cell>`<subsection title="Subheading">`</cell></row>
        <row><cell>`#### Deep heading` (H4+)</cell><cell>`<subsection title="Deep heading">` (flattened, no deeper nesting)</cell></row>
        <row><cell>YAML frontmatter `---`</cell><cell>`<metadata>` with `<field>` entries</cell></row>
        <row><cell>Prose paragraph</cell><cell>`<paragraph>`</cell></row>
        <row><cell>```language ... ```</cell><cell>`<code language="...">`</cell></row>
        <row><cell>`- item` / `1. item`</cell><cell>`<list type="unordered|ordered"><item>`</cell></row>
        <row><cell>`| col | col |` table</cell><cell>`<table><row><cell>`</cell></row>
        <row><cell>`- [ ] item` / `- [x] item`</cell><cell>`<checklist><item status="open|done">`</cell></row>
      </table>
    </subsection>

    <subsection title="YAML Frontmatter Handling">
      <paragraph>Files with YAML frontmatter (`---` blocks containing `name:`, `description:`, etc.) retain the frontmatter AS-IS above the XML body. The frontmatter is required by the Claude Code plugin system for agent/command/skill registration. The `<metadata>` section inside the XML body duplicates key fields for in-document reference but does NOT replace the YAML frontmatter.</paragraph>
    </subsection>

    <subsection title="Content Preservation Rules">
      <list type="ordered">
        <item>**No content deletion**: Every sentence, code block, table row, list item, and diagram must appear in the converted output</item>
        <item>**No content addition**: Do not add explanatory text, comments, or annotations that were not in the original</item>
        <item>**No behavioral changes**: Agent instructions, rule enforcement, workflow steps, and quality gates must produce identical behavior post-conversion</item>
        <item>**Inline Markdown preserved**: Bold (`**text**`), italic (`*text*`), inline code (`` `code` ``), and links (`[text](url)`) remain inside XML tags as-is. These are content-level formatting, not structural</item>
        <item>**Placeholder variables preserved**: `${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_PLUGIN_DATA}`, and similar variables must remain exactly as-is</item>
      </list>
    </subsection>

  </section>

  <section title="Proposed Solution Options">

    <option id="1" label="Minimum Viable: Convert by Category in 4 Phases">
      <paragraph>Group files into 4 conversion batches by category: (1) rules + contexts (11 files), (2) commands (20 files), (3) agents (36 files), (4) skills + reference patterns (20 files). Convert each batch as a single commit.</paragraph>
      <list type="unordered">
        <item>Pros: Simple grouping, fewer commits to manage</item>
        <item>Cons: Large batches (36 agents at once) increase review difficulty and error risk</item>
      </list>
    </option>

    <option id="2" label="Recommended: Convert in 8 Phases by Risk and Size">
      <paragraph>Split conversion into 8 phases ordered by risk (lowest-risk first) and size (smallest batches first). This allows validation of the approach on simpler files before tackling complex agents and skills. Phases: (1) contexts 3 files, (2) rules 8 files, (3) reference patterns 11 files, (4) commands batch 1 — 10 files, (5) commands batch 2 — 10 files, (6) agents batch 1 — 12 files, (7) agents batch 2 — 12 files, (8) agents batch 3 — 12 files + 9 skills.</paragraph>
      <list type="unordered">
        <item>Pros: Incremental validation, manageable review sizes, early error detection on simpler files</item>
        <item>Cons: More commits and phases to track</item>
      </list>
    </option>

    <option id="3" label="Comprehensive: Automated Conversion Script + Manual Review">
      <paragraph>Build a shell/Python script that performs the Markdown-to-XML conversion programmatically using regex/AST parsing, then manually review each file. The script handles deterministic patterns (headings, lists, code blocks) and flags ambiguous patterns for manual resolution.</paragraph>
      <list type="unordered">
        <item>Pros: Fastest execution, consistent mechanical transformation, reusable for future files</item>
        <item>Cons: Script development overhead, regex edge cases with complex nested content, still requires manual review</item>
      </list>
    </option>

  </section>

  <section title="Implementation Constraints">

    <subsection title="Hard Constraints">
      <list type="ordered">
        <item>**No logic changes**: This is a structural-only refactoring. No behavioral changes to any agent, command, rule, or skill</item>
        <item>**Gate scripts must pass**: All 7 gate scripts in `scripts/gates/` must produce identical results before and after conversion. Gate scripts parse rendered Markdown output from template-filled documents — they grep for headings, keywords, and checkbox patterns</item>
        <item>**YAML frontmatter preserved**: Files that have `---` frontmatter blocks must retain them exactly. The Claude Code plugin system uses these for registration</item>
        <item>**Plugin versioning**: Per CLAUDE.md rules, any modification to files under `super-dev-plugin/` must include a patch version bump in both `super-dev-plugin/.claude-plugin/plugin.json` AND `.claude-plugin/marketplace.json`</item>
        <item>**Incremental commits**: Each commit must leave the plugin in a working state. No half-converted files</item>
      </list>
    </subsection>

    <subsection title="Soft Constraints">
      <list type="unordered">
        <item>Prefer converting lower-risk files first (contexts, rules) to validate the approach before tackling complex files (agents, skills)</item>
        <item>Keep individual commits to 10-15 files maximum for reviewability</item>
        <item>Token count per file should not increase by more than 5% after conversion</item>
      </list>
    </subsection>

  </section>

  <section title="Impact Assessment">

    <subsection title="Business Outcome">
      <paragraph>Unified XML structure across the entire super-dev-plugin improves agent reliability by eliminating structural ambiguity in prompt files. This directly supports the plugin's core value proposition: reliable, multi-phase development workflows orchestrated by specialized agents.</paragraph>
    </subsection>

    <subsection title="Success Metrics">
      <list type="unordered">
        <item>**Format consistency**: 100% of non-README `.md` files under `super-dev-plugin/` use XML-tagged structure (currently ~57% — 13 of 101 minus 2 READMEs)</item>
        <item>**Gate script compatibility**: All 7 gate scripts pass with exit code 0 after conversion</item>
        <item>**Content preservation**: Zero content loss — diff of rendered text before/after shows only structural markers changed</item>
        <item>**Token budget**: Average token count per file does not increase by more than 5%</item>
      </list>
    </subsection>

    <subsection title="Behavior Change Expected">
      <paragraph>After conversion, all files loaded into agent context windows will use the same XML-tagged structure. Agents will parse instructions from `<section>`, `<rule>`, `<persona>` tags instead of inferring structure from Markdown heading levels. This eliminates a class of prompt-parsing errors where agents misinterpret heading hierarchy, especially in deeply nested files like `team-lead.md` (1036 lines, 4+ heading levels).</paragraph>
    </subsection>

  </section>

  <section title="Technical Considerations">

    <subsection title="Integration Points">
      <list type="unordered">
        <item>**Claude Code plugin system**: Reads YAML frontmatter for agent/command/skill registration — must remain untouched</item>
        <item>**Gate scripts** (`scripts/gates/gate-*.sh`): Parse rendered template output via grep/regex — templates that produce spec artifacts already use XML, so gates should be unaffected by converting non-template files</item>
        <item>**Agent spawn prompts** (`team-lead.md`): Reference file paths like `${CLAUDE_PLUGIN_ROOT}/agents/planner.md` — paths do not change</item>
        <item>**Skill description field**: Used by Claude Code to match user requests to skills — content must be preserved exactly</item>
      </list>
    </subsection>

    <subsection title="Technical Constraints">
      <list type="unordered">
        <item>XML tags in Markdown files are rendered as HTML by most Markdown viewers — this is acceptable and intentional (the primary consumer is LLMs, not Markdown renderers)</item>
        <item>Some files contain XML-like content inside code blocks (e.g., template examples) — these must NOT be converted, only the structural Markdown outside code blocks</item>
        <item>Files with deeply nested content (4+ heading levels) must flatten H4+ to `<subsection>` tags to avoid excessive nesting depth</item>
      </list>
    </subsection>

    <subsection title="Gate Script Analysis">
      <paragraph>Gate scripts parse **rendered spec artifacts** (requirements.md, behavior-scenarios.md, etc.), NOT the agent/command/rule source files being converted. The gate scripts grep for patterns like `acceptance criteria`, `SCENARIO-XXX`, `AC-[0-9]`, `Given/When/Then` in the rendered output documents. Since those output documents are produced by templates that already use XML, the gate scripts should be completely unaffected by this conversion of source instruction files. However, verification is still required post-conversion.</paragraph>
    </subsection>

  </section>

  <section title="Assumptions">
    <list type="unordered">
      <item>**A-01**: The 13 spec-artifact templates that already use XML represent the proven target format. The conversion should align with their tag vocabulary and nesting conventions.</item>
      <item>**A-02**: YAML frontmatter is processed separately from file body content by the Claude Code plugin system. Converting the body to XML does not affect frontmatter parsing.</item>
      <item>**A-03**: LLMs parse explicit XML tags more reliably than implicit Markdown heading hierarchy, especially at deep nesting levels. This is the core motivation for the conversion.</item>
      <item>**A-04**: No other plugins or external tools parse the non-template `.md` files in `super-dev-plugin/` — only the Claude Code agent runtime and human maintainers read them.</item>
      <item>**A-05**: The 2 README files (`super-dev-plugin/README.md`, `scripts/README.md`) serve a different purpose (human documentation on GitHub) and should remain in Markdown format.</item>
    </list>
  </section>

  <section title="Open Questions">
    - Should the conversion script (Option 3) be built as a reusable tool for future file additions, or is manual conversion sufficient given this is a one-time task?
    - Should a new gate script (`gate-xml-structure.sh`) be created as part of this task to validate the XML structure of converted files, or is that a separate follow-up task?
    - For files with mixed content (e.g., `team-lead.md` which contains both instructions and spawn-prompt templates with embedded code blocks), should the embedded templates also be wrapped in XML tags or left as-is inside `<code>` blocks?
    - What is the acceptable token budget ceiling? The current target is 5% max increase — should this be tighter (0%) or is some increase acceptable for the structural benefits?
  </section>

  <section title="Acceptance Criteria">

- [ ] **AC-01**: All 36 agent files in `super-dev-plugin/agents/` are converted from Markdown heading format to XML-tagged structure using the unified tag schema
- [ ] **AC-02**: All 20 command files in `super-dev-plugin/commands/` are converted from Markdown heading format to XML-tagged structure
- [ ] **AC-03**: All 8 rule files in `super-dev-plugin/rules/` are converted from Markdown heading format to XML-tagged structure
- [ ] **AC-04**: All 3 context files in `super-dev-plugin/contexts/` are converted from Markdown heading format to XML-tagged structure
- [ ] **AC-05**: All 9 skill SKILL.md files in `super-dev-plugin/skills/` are converted from Markdown heading format to XML-tagged structure, with YAML frontmatter preserved
- [ ] **AC-06**: All 11 non-XML reference templates in `super-dev-plugin/templates/reference/` (patterns, standards, methodology, example files) are converted to XML-tagged structure
- [ ] **AC-07**: The 13 spec-artifact templates that already use XML format are NOT modified
- [ ] **AC-08**: The 2 README files are NOT modified
- [ ] **AC-09**: All YAML frontmatter blocks are preserved exactly as-is (byte-identical) in every converted file
- [ ] **AC-10**: All 7 gate scripts (`gate-requirements.sh`, `gate-bdd.sh`, `gate-spec-trace.sh`, `gate-review.sh`, `gate-spec-review.sh`, `gate-build.sh`, `gate-docs-drift.sh`) produce identical pass/fail results before and after conversion
- [ ] **AC-11**: Zero content loss — every sentence, code block, table, list item, diagram, and instruction present in the original files is present in the converted files with identical semantic meaning
- [ ] **AC-12**: Inline Markdown formatting (bold, italic, inline code, links) is preserved inside XML tags
- [ ] **AC-13**: Placeholder variables (`${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_PLUGIN_DATA}`, etc.) are preserved exactly as-is
- [ ] **AC-14**: Plugin version is bumped in both `super-dev-plugin/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` per the versioning rule
- [ ] **AC-15**: Each commit leaves the plugin in a working state — no half-converted files within a single commit

  </section>

  <section title="Recommendations">
    <paragraph>Based on the analysis, I recommend:</paragraph>
    <list type="ordered">
      <item>**Immediate**: Adopt Option 2 (8-phase incremental conversion). Start with the 3 context files as a proof-of-concept to validate the tag schema and conversion approach before scaling to larger batches</item>
      <item>**Next**: After all files are converted, verify gate scripts pass and run a token-count comparison (before vs. after) to validate the NFR token budget target</item>
      <item>**Future**: Consider building a `gate-xml-structure.sh` script that validates required sections per file type (e.g., every agent file must have `<persona>` and `<instructions>` sections). This enables ongoing structural validation as new files are added</item>
    </list>
  </section>

</document>
```
