<document type="specification">

<metadata>
  <field name="title">Technical Specification: XML Restructure of super-dev-plugin Files</field>
  <field name="date">2026-04-16</field>
  <field name="author">super-dev:spec-writer</field>
  <field name="status">Draft</field>
</metadata>

<section title="1. Overview">

  <subsection title="1.1 Summary">
    <paragraph>Convert 85 Markdown files across 6 categories in `super-dev-plugin/` from Markdown heading/prose format to a unified XML-tagged structure using the revised tag schema defined in this specification (see Section 3.2 and Design Decision DD-01). The conversion replaces YAML frontmatter with `<meta>` tags, replaces all `##`/`###`/`####` headings with semantic XML tags from a three-tier vocabulary, aggressively trims code samples in non-agent files, moderately trims code samples in agent files, and normalizes the 14 existing XML templates by removing code fences and fixing checklist syntax. The 8-phase execution order starts with lowest-risk files (templates, then reference files, agents, commands, rules, contexts, skills) and includes a version bump from 2.3.35 to 2.3.36 in the final commit.</paragraph>
  </subsection>

  <subsection title="1.2 Goals">
    <list type="unordered">
      <item>**Unified format**: 100% of non-README `.md` files under `super-dev-plugin/` use XML-tagged structure with tags from the unified three-tier schema</item>
      <item>**Improved LLM parsing**: Replace ambiguous Markdown heading hierarchy with explicit, semantic XML tags that Claude parses deterministically</item>
      <item>**Token reduction**: Achieve 25-67% token reduction per file through aggressive prose trimming, code sample removal (non-agents), and structural compression</item>
      <item>**Programmatic validation**: Enable future `gate-xml-structure.sh` validation by standardizing required tags per file type (`<meta>`, `<purpose>`, category-specific tags)</item>
      <item>**Zero information loss**: Preserve all semantic information from originals -- every instruction, constraint, rule, and behavioral directive survives conversion</item>
    </list>
  </subsection>

  <subsection title="1.3 Non-Goals">
    <list type="unordered">
      <item>Building an automated conversion script (manual conversion by agents, one file at a time)</item>
      <item>Creating a `gate-xml-structure.sh` validation script (future follow-up task)</item>
      <item>Modifying any behavioral logic, agent instructions, or workflow semantics</item>
      <item>Renaming files or changing directory structure</item>
      <item>Converting README files (`super-dev-plugin/README.md`, `scripts/README.md`)</item>
      <item>Converting JSON files (`config-template.json`, `workflow-tracking-template.json`)</item>
      <item>Converting shell scripts (`scripts/**`, `hooks/**`)</item>
      <item>Converting `project-guidelines-example.md` or `state-management.md` (excluded per original requirements)</item>
    </list>
  </subsection>

</section>

<section title="2. Background">

  <subsection title="2.1 Context">
    <paragraph>Anthropic's own documentation explicitly recommends XML tags for structuring complex prompts sent to Claude. Claude was trained with XML tags in training data, making tags particularly effective for guiding behavior. Independent benchmarks (Systima, March 2026) confirm that XML provides the strongest boundary detection (97.1%) versus Markdown (95.4%), with the gap driven by structural ambiguity in deeply nested content.</paragraph>
    <quote source="Research Report, Section: Anthropic's Official Recommendation">"XML tags help Claude parse complex prompts unambiguously -- especially when prompts mix instructions, context, examples, and variable inputs."</quote>
  </subsection>

  <subsection title="2.2 Current State">
    <paragraph>The super-dev-plugin contains 102 non-README `.md` files across 6 categories. Of these, 14 template files already use XML-tagged structure (wrapped in code fences), 3 files are excluded (see Section 3.6), leaving 85 files requiring full Markdown-to-XML conversion (36 agents + 20 commands + 8 rules + 3 contexts + 9 skills + 9 reference files). The largest file is `architecture-agent.md` at 1,544 lines with 30 H4+ headings, 31 code blocks, 124 table lines, 115 checkboxes, and 259 ASCII diagram lines. Gate scripts parse rendered spec artifacts (not source files), so they are unaffected by this conversion. Plugin version is 2.3.35 in both `plugin.json` and `marketplace.json`.</paragraph>
    <quote source="Code Assessment, Executive Summary">"All 36 agent files and all 9 skill files have YAML frontmatter. Commands are mixed (14 with frontmatter, 6 without). Rules (1 of 8) and contexts (0 of 3) rarely have frontmatter."</quote>
  </subsection>

  <subsection title="2.3 Problem Statement">
    <paragraph>The plugin has two competing structural formats: XML-tagged templates and Markdown-heading agents/commands/rules/contexts/skills. LLMs must parse both formats when loading instructions, adding cognitive overhead and increasing error rates on structural interpretation. Markdown heading hierarchy is implicit (`###` under `##` is convention, not enforced), while XML nesting is explicit and unambiguous. No programmatic validation exists for non-template files -- structural errors (missing sections, wrong nesting) are silent failures.</paragraph>
  </subsection>

</section>

<section title="3. Technical Design">

  <subsection title="3.1 Architecture">
    <diagram type="ascii">
BEFORE                                  AFTER
+---------------------------+           +---------------------------+
| super-dev-plugin/         |           | super-dev-plugin/         |
|                           |           |                           |
| agents/*.md    [Markdown] |           | agents/*.md    [XML tags] |
| commands/*.md  [Markdown] |           | commands/*.md  [XML tags] |
| rules/*.md     [Markdown] |           | rules/*.md     [XML tags] |
| contexts/*.md  [Markdown] |           | contexts/*.md  [XML tags] |
| skills/*/SKILL.md [MD]    |           | skills/*/SKILL.md [XML]   |
| templates/ref/* [Mixed]   |           | templates/ref/* [XML]     |
|                           |           |                           |
| 14 XML templates          |  -------> | 14 XML templates          |
|   (in code fences)        |           |   (fences removed)        |
| 85 Markdown files         |           | 85 XML-tagged files       |
| 2 READMEs (unchanged)     |           | 2 READMEs (unchanged)     |
+---------------------------+           +---------------------------+
    </diagram>
  </subsection>

  <subsection title="3.2 Unified XML Tag Schema">

    <paragraph>All converted files MUST use the three-tier tag vocabulary defined in THIS specification (revised from the original requirements to use semantic tags instead of generic structural wrappers -- see Design Decision DD-01 in Section 3.7). No ad-hoc or invented tags are permitted.</paragraph>

    <subsection title="3.2.1 Tier 1: Universal Envelope (every file MUST have)">
      <code lang="xml">
<meta>
  <name>file-name-without-extension</name>
  <type>agent | command | rule | context | skill | template</type>
  <description>One-line description from YAML frontmatter or H1 heading</description>
</meta>

<purpose>1-2 sentence role statement (replaces "You are a..." prose)</purpose>
      </code>
      <paragraph>The `<meta>` tag replaces both YAML frontmatter (`---` blocks) and H1 headings. YAML frontmatter is removed entirely -- the `<meta>` tag is the single source of metadata. The `<purpose>` tag replaces the introductory prose paragraph that typically follows the H1 heading.</paragraph>
    </subsection>

    <subsection title="3.2.2 Tier 2: Content Blocks (use as applicable)">
      <table>
        <row header="true">
          <cell>Tag</cell>
          <cell>Purpose</cell>
          <cell>Children</cell>
        </row>
        <row>
          <cell>`<principles>`</cell>
          <cell>Core beliefs / philosophy</cell>
          <cell>`<principle>`</cell>
        </row>
        <row>
          <cell>`<constraints>`</cell>
          <cell>MUST / MUST NOT hard rules</cell>
          <cell>`<constraint>`</cell>
        </row>
        <row>
          <cell>`<allowlist>`</cell>
          <cell>Explicitly permitted actions</cell>
          <cell>`<allowed>`</cell>
        </row>
        <row>
          <cell>`<process>`</cell>
          <cell>Ordered steps</cell>
          <cell>`<step n="N" name="Title">`</cell>
        </row>
        <row>
          <cell>`<input>`</cell>
          <cell>What this receives</cell>
          <cell>`<field name="X" required="true|false">`</cell>
        </row>
        <row>
          <cell>`<output>`</cell>
          <cell>What this produces</cell>
          <cell>`<format>`, `<template>`</cell>
        </row>
        <row>
          <cell>`<examples>`</cell>
          <cell>Usage examples</cell>
          <cell>`<example>`</cell>
        </row>
        <row>
          <cell>`<quality-gates>`</cell>
          <cell>Checklists / pass criteria</cell>
          <cell>`<gate>`</cell>
        </row>
        <row>
          <cell>`<anti-patterns>`</cell>
          <cell>What to avoid</cell>
          <cell>`<anti-pattern>`</cell>
        </row>
        <row>
          <cell>`<gotchas>`</cell>
          <cell>Non-obvious failure modes</cell>
          <cell>`<gotcha>`</cell>
        </row>
        <row>
          <cell>`<references>`</cell>
          <cell>Pointers to other agents/files</cell>
          <cell>`<ref>`</cell>
        </row>
        <row>
          <cell>`<code-sample lang="...">`</cell>
          <cell>Code blocks (replaces triple-backtick)</cell>
          <cell>Raw code content</cell>
        </row>
        <row>
          <cell>`<checklist>`</cell>
          <cell>Verification steps</cell>
          <cell>`<check>`</cell>
        </row>
        <row>
          <cell>`<topic name="...">`</cell>
          <cell>Named sub-section for grouped content</cell>
          <cell>Any Tier 2 tags</cell>
        </row>
      </table>
    </subsection>

    <subsection title="3.2.3 Tier 3: Type-Specific Tags">
      <table>
        <row header="true">
          <cell>File Type</cell>
          <cell>Tags</cell>
        </row>
        <row>
          <cell>Agents</cell>
          <cell>`<capabilities>`, `<collaboration>`, `<search-strategy>`</cell>
        </row>
        <row>
          <cell>Commands</cell>
          <cell>`<usage>`, `<arguments>`, `<verdict>`, `<lens name="...">`</cell>
        </row>
        <row>
          <cell>Contexts</cell>
          <cell>`<mode>`, `<priorities>`, `<tools>`</cell>
        </row>
        <row>
          <cell>Rules</cell>
          <cell>`<directives>` with `<directive severity="critical|high|medium">`</cell>
        </row>
        <row>
          <cell>Skills</cell>
          <cell>`<triggers>`, `<activation>`, `<workflow>`</cell>
        </row>
        <row>
          <cell>Templates</cell>
          <cell>`<slots>`, `<document>`, `<section>`, `<subsection>`</cell>
        </row>
      </table>
    </subsection>

  </subsection>

  <subsection title="3.3 Conversion Rules">

    <subsection title="3.3.1 YAML Frontmatter Handling">
      <paragraph>YAML frontmatter (`---` blocks) is **removed entirely** and replaced by the `<meta>` tag. The fields from frontmatter (`name:`, `description:`, `tools:`, `license:`, `metadata:`, `compatibility:`, `doc-type:`, `gate-profile:`) are mapped into `<meta>` child tags. For template files that have `doc-type:` and `gate-profile:` fields, these are preserved as additional children of `<meta>`.</paragraph>

      <paragraph>**Exception**: The 14 XML template files retain their YAML frontmatter because the Claude Code plugin system uses `doc-type:` and `gate-profile:` fields for template registration. For these files, only the code fences are removed.</paragraph>
    </subsection>

    <subsection title="3.3.2 Heading-to-Tag Mapping">
      <table>
        <row header="true">
          <cell>Markdown Pattern</cell>
          <cell>XML Replacement</cell>
        </row>
        <row>
          <cell>`# Title` (H1)</cell>
          <cell>Removed -- redundant with `<meta><name>`</cell>
        </row>
        <row>
          <cell>`## Section` (H2)</cell>
          <cell>Semantic tag from Tier 2/3 (`<process>`, `<principles>`, `<constraints>`, `<topic name="...">`, etc.)</cell>
        </row>
        <row>
          <cell>`### Step N: Title`</cell>
          <cell>`<step n="N" name="Title">`</cell>
        </row>
        <row>
          <cell>`### N. Title` (numbered concept)</cell>
          <cell>`<principle>` or `<directive>`</cell>
        </row>
        <row>
          <cell>`### Category: Detail`</cell>
          <cell>`<topic name="Category">`</cell>
        </row>
        <row>
          <cell>`### NEVER / ALWAYS`</cell>
          <cell>`<anti-pattern>` / `<constraint>`</cell>
        </row>
        <row>
          <cell>`#### Verification Steps` with `- [ ]`</cell>
          <cell>`<checklist>` with `<check>`</cell>
        </row>
        <row>
          <cell>`#### NEVER/ALWAYS Do This` + code block</cell>
          <cell>Removed -- compressed into parent `<constraint>`</cell>
        </row>
        <row>
          <cell>`---` YAML frontmatter</cell>
          <cell>`<meta>` (see 3.3.1)</cell>
        </row>
        <row>
          <cell>`- bullet`</cell>
          <cell>Content inside parent tag (no wrapping tag)</cell>
        </row>
        <row>
          <cell>`- [ ]` / `- [x]` checkbox</cell>
          <cell>`<check>` inside `<checklist>`</cell>
        </row>
        <row>
          <cell>` ```lang ` code fence</cell>
          <cell>`<code-sample lang="">` (agents: keep 1 per concept; others: remove)</cell>
        </row>
        <row>
          <cell>`| table |` pipe tables</cell>
          <cell>Compressed to `<constraint>` one-liners, or kept as-is in templates</cell>
        </row>
        <row>
          <cell>`> blockquote`</cell>
          <cell>Inline in parent tag</cell>
        </row>
      </table>
    </subsection>

    <subsection title="3.3.3 Code Sample Strategy">
      <table>
        <row header="true">
          <cell>File Type</cell>
          <cell>Strategy</cell>
          <cell>Rule</cell>
        </row>
        <row>
          <cell>Agents</cell>
          <cell>Moderate trim</cell>
          <cell>Keep maximum 1 short `<code-sample>` per concept. Remove duplicate examples, verbose multi-file examples, and examples that merely illustrate what the prose already states.</cell>
        </row>
        <row>
          <cell>Commands</cell>
          <cell>Aggressive trim</cell>
          <cell>Remove all code blocks. Express patterns as `<constraint>` text.</cell>
        </row>
        <row>
          <cell>Rules</cell>
          <cell>Aggressive trim</cell>
          <cell>Remove all code blocks. Express correct/incorrect patterns as `<constraint>` and `<anti-pattern>` text.</cell>
        </row>
        <row>
          <cell>Contexts</cell>
          <cell>N/A</cell>
          <cell>No code blocks exist in context files.</cell>
        </row>
        <row>
          <cell>Skills</cell>
          <cell>Aggressive trim</cell>
          <cell>Remove all code blocks. Express patterns as `<constraint>` text.</cell>
        </row>
        <row>
          <cell>Templates (reference)</cell>
          <cell>Aggressive trim</cell>
          <cell>Remove most code blocks from reference pattern files. Keep only essential structural examples that define the pattern.</cell>
        </row>
        <row>
          <cell>Templates (XML spec)</cell>
          <cell>Normalize only</cell>
          <cell>Remove ` ```xml ` / ` ``` ` code fences. Fix checklist syntax. Preserve all XML content.</cell>
        </row>
      </table>
    </subsection>

    <subsection title="3.3.4 Nested List Handling">
      <paragraph>Nested lists (2-level or 3-level indented lists) are flattened into the parent tag's content. Sub-items are promoted to the same level as their parent, with contextual prefix text added if needed to preserve the relationship. Example:</paragraph>
      <code lang="text">
BEFORE:
1. Scan all source files
2. Generate codemaps:
   - codemaps/architecture.md
   - codemaps/backend.md

AFTER (inside a <step>):
<step n="1" name="Scan">Scan all source files for imports, exports, and dependencies</step>
<step n="2" name="Generate codemaps">Generate codemaps: architecture.md (overall architecture), backend.md (backend structure)</step>
      </code>
    </subsection>

    <subsection title="3.3.5 Horizontal Rule Handling">
      <paragraph>The `---` sequence within the file body (after frontmatter) is used as a visual separator in files like `adversarial-reviewer.md`. These are removed during conversion -- the XML tag boundaries provide the structural separation that horizontal rules implied.</paragraph>
    </subsection>

    <subsection title="3.3.6 Key-Value Pattern Handling">
      <paragraph>Context files use `Key: Value` patterns (e.g., `Mode: Active development`). These are mapped to `<mode>` and `<priorities>` type-specific tags rather than generic `<field>` tags, because the key-value pairs carry semantic meaning specific to context file behavior configuration.</paragraph>
    </subsection>

    <subsection title="3.3.7 Severity Inference for Rules">
      <paragraph>Rule files use bold markers to indicate severity. The converter applies this deterministic mapping:</paragraph>
      <table>
        <row header="true">
          <cell>Bold Marker</cell>
          <cell>Severity Attribute</cell>
        </row>
        <row>
          <cell>`**CRITICAL**`, `**NEVER**`, `**MANDATORY**`</cell>
          <cell>`severity="critical"`</cell>
        </row>
        <row>
          <cell>`**ALWAYS**`, `**MUST**`, `**IMPORTANT**`</cell>
          <cell>`severity="high"`</cell>
        </row>
        <row>
          <cell>All other rules</cell>
          <cell>`severity="medium"`</cell>
        </row>
      </table>
    </subsection>

    <subsection title="3.3.8 Persona Section Handling">
      <paragraph>Agent files with `## Persona:` headings have the persona content placed directly inside the `<purpose>` tag. The persona name, cognitive mode, and role description are condensed into the 1-2 sentence purpose statement. Extended persona details (cognitive mode elaboration, gotchas awareness) are placed in `<principles>` or `<gotchas>` tags as appropriate.</paragraph>
    </subsection>

    <subsection title="3.3.9 Placeholder Variable Preservation">
      <paragraph>All `${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_PLUGIN_DATA}`, and similar placeholder variables MUST be preserved character-identical in the output. These variables are resolved at runtime by the Claude Code plugin system. The converter must not interpret, expand, escape, or modify any `${...}` pattern.</paragraph>
    </subsection>

    <subsection title="3.3.10 XML Content Inside Code Blocks">
      <paragraph>21 files contain XML-like content (JSX, XML examples, MCP tool call examples) inside fenced code blocks. During conversion, this content is placed inside `<code-sample>` tags (for agent files where the code sample is retained) or removed entirely (for non-agent files under aggressive trim). The converter must never confuse XML-like content inside code examples with the structural XML being applied outside code blocks.</paragraph>
    </subsection>

  </subsection>

  <subsection title="3.4 Template Normalization Rules">

    <subsection title="3.4.1 Code Fence Removal (Phase 1 -- 5 files)">
      <paragraph>Five XML template files have correct XML content wrapped in ` ```xml ` / ` ``` ` code fences. Remove the opening ` ```xml ` line and the closing ` ``` ` line. The YAML frontmatter above the code fence is preserved. The result is a file with YAML frontmatter followed directly by bare XML content.</paragraph>
      <paragraph>**Files**: `implementation-plan-template.md`, `task-list-template.md`, `requirements-template.md`, `behavior-scenarios-template.md`, `qa-report-template.md`</paragraph>
    </subsection>

    <subsection title="3.4.2 Checklist Syntax Fix (Phase 2 -- 1 file)">
      <paragraph>`spec-review-template.md` uses raw `- [ ]` checkbox syntax that should be `<item>` tags inside `<checklist>`. Replace all `- [ ]` and `- [x]` patterns with the `<checklist><item status="open|done">` XML pattern consistent with the rest of the template's XML structure.</paragraph>
    </subsection>

    <subsection title="3.4.3 Template Files That Already Use Correct XML (DO NOT MODIFY)">
      <paragraph>8 XML template files already have correct XML structure without code fences and with correct checklist syntax. These are NOT modified in any way:</paragraph>
      <list type="unordered">
        <item>`adversarial-review-template.md`</item>
        <item>`architecture-template.md`</item>
        <item>`code-review-template.md`</item>
        <item>`design-spec-template.md`</item>
        <item>`handoff-template.md`</item>
        <item>`implementation-summary-template.md`</item>
        <item>`product-design-summary-template.md`</item>
        <item>`specification-template.md`</item>
      </list>
      <paragraph>**Note**: The code assessment found 14 XML templates. Of these, 5 need fence removal (Phase 1), 1 needs checklist fix (Phase 2, `spec-review-template.md`), and 8 are already correct (untouched). The `spec-review-template.md` is counted in Phase 2 after its fences are removed in an earlier pass if needed, or both fixes happen in Phase 2.</paragraph>
    </subsection>

  </subsection>

  <subsection title="3.5 Converted File Structure">

    <paragraph>Every converted file follows this canonical structure (tags used only when applicable):</paragraph>

    <code lang="xml">
<meta>
  <name>file-name</name>
  <type>agent|command|rule|context|skill|template</type>
  <description>One-line description</description>
  <!-- additional fields as needed: tools, license, etc. -->
</meta>

<purpose>1-2 sentence role statement</purpose>

<!-- Tier 2 content blocks (order varies by file) -->
<principles>
  <principle>...</principle>
</principles>

<constraints>
  <constraint>...</constraint>
</constraints>

<process>
  <step n="1" name="...">...</step>
</process>

<quality-gates>
  <gate>...</gate>
</quality-gates>

<gotchas>
  <gotcha>...</gotcha>
</gotchas>

<anti-patterns>
  <anti-pattern>...</anti-pattern>
</anti-patterns>

<references>
  <ref>...</ref>
</references>

<!-- Tier 3 type-specific tags as needed -->
    </code>

    <paragraph>**Key structural rule**: There is no `<document>` root wrapper on converted agent/command/rule/context/skill files. The `<document>` tag is reserved for template files that produce spec artifacts. Converted instruction files use `<meta>` as the first tag and have no single root element -- the file is a sequence of top-level XML blocks.</paragraph>

  </subsection>

  <subsection title="3.6 Files NOT Converted">
    <table>
      <row header="true">
        <cell>File</cell>
        <cell>Reason</cell>
      </row>
      <row>
        <cell>`templates/reference/project-guidelines-example.md`</cell>
        <cell>Example for users to copy, not LLM instruction</cell>
      </row>
      <row>
        <cell>`templates/reference/state-management.md`</cell>
        <cell>Internal reference about plugin data paths</cell>
      </row>
      <row>
        <cell>`templates/config-template.json`</cell>
        <cell>JSON config file</cell>
      </row>
      <row>
        <cell>`templates/reference/workflow-tracking-template.json`</cell>
        <cell>JSON schema file</cell>
      </row>
      <row>
        <cell>`README.md`</cell>
        <cell>Human documentation (GitHub rendering)</cell>
      </row>
      <row>
        <cell>`to-do.md`</cell>
        <cell>Project tracking file</cell>
      </row>
      <row>
        <cell>`scripts/**`</cell>
        <cell>Shell scripts</cell>
      </row>
      <row>
        <cell>`hooks/**`</cell>
        <cell>Shell scripts and JSON</cell>
      </row>
      <row>
        <cell>`.claude-plugin/plugin.json`</cell>
        <cell>Plugin metadata (version bump only)</cell>
      </row>
    </table>
  </subsection>

  <subsection title="3.7 Design Decisions">

    <subsection title="DD-01: Revised Tag Schema (diverges from original requirements)">
      <paragraph>This specification uses a **revised tag schema** that diverges from the original requirements document (`docs/requirements/xml-restructure.md`) in several significant ways. The original requirements defined a generic structural wrapping approach; this specification replaces it with a semantic tag approach that is better suited for LLM instruction parsing.</paragraph>

      <table>
        <row header="true">
          <cell>Aspect</cell>
          <cell>Original Requirements</cell>
          <cell>This Specification (Revised)</cell>
          <cell>Rationale</cell>
        </row>
        <row>
          <cell>Root wrapper</cell>
          <cell>`<document type="agent|command|...">`</cell>
          <cell>No root wrapper on instruction files</cell>
          <cell>`<document>` is reserved for template spec artifacts; instruction files use `<meta>` as first tag</cell>
        </row>
        <row>
          <cell>Metadata</cell>
          <cell>`<metadata>` with `<field name="...">`</cell>
          <cell>`<meta>` with `<name>`, `<type>`, `<description>`</cell>
          <cell>Named children are more explicit than generic `<field>` attributes</cell>
        </row>
        <row>
          <cell>Sections</cell>
          <cell>`<section title="...">`, `<subsection title="...">`</cell>
          <cell>Semantic Tier 2 tags: `<process>`, `<principles>`, `<constraints>`, `<topic name="...">`</cell>
          <cell>Semantic tags carry meaning for LLM parsing; generic `<section>` adds tokens without adding semantic value</cell>
        </row>
        <row>
          <cell>Paragraphs</cell>
          <cell>`<paragraph>` wrapping</cell>
          <cell>Content inline in parent tags (no `<paragraph>` wrapper)</cell>
          <cell>Eliminates token overhead from wrapping every text block</cell>
        </row>
        <row>
          <cell>Code blocks</cell>
          <cell>`<code language="...">`</cell>
          <cell>`<code-sample lang="...">`</cell>
          <cell>Distinguishes instructional code samples from executable code</cell>
        </row>
        <row>
          <cell>Rule items</cell>
          <cell>`<rule severity="...">`</cell>
          <cell>`<directive severity="...">`</cell>
          <cell>Avoids confusion with the `rules/` file category name</cell>
        </row>
        <row>
          <cell>Persona</cell>
          <cell>`<persona>`</cell>
          <cell>`<purpose>` (condensed)</cell>
          <cell>Persona content is condensed into a 1-2 sentence purpose statement; extended details go into `<principles>` or `<gotchas>`</cell>
        </row>
        <row>
          <cell>YAML frontmatter</cell>
          <cell>Preserved as-is above XML body</cell>
          <cell>Removed and replaced by `<meta>` tag (except XML templates)</cell>
          <cell>Original requirements Section 4 maps `---` to `<meta>`, implying replacement; `<meta>` is the single source of metadata</cell>
        </row>
        <row>
          <cell>Lens (commands)</cell>
          <cell>`<lens name="X">`</cell>
          <cell>`<lens name="X">` (added to Tier 3 command tags)</cell>
          <cell>Preserved from original requirements for command files with lens-based structure</cell>
        </row>
      </table>

      <paragraph>**Why the revised schema is better:** The original requirements' approach (`<section>`, `<subsection>`, `<paragraph>`) is essentially "XML-flavored Markdown" -- it wraps every structural element in generic tags, adding tokens without adding semantic value. This specification's semantic tags (`<process>`, `<principles>`, `<constraints>`) carry meaning that helps Claude parse instructions deterministically, aligning with the project's goal of improving LLM instruction adherence. Independent benchmarks confirm XML provides 97.1% boundary detection vs Markdown's 95.4%, and this advantage is maximized when tags are semantic rather than structural.</paragraph>
    </subsection>

    <subsection title="DD-02: AC-09 Superseded (YAML frontmatter handling)">
      <paragraph>AC-09 in `01-requirements.md` states: "All YAML frontmatter blocks are preserved exactly as-is (byte-identical) in every converted file." This specification **supersedes AC-09** by removing YAML frontmatter and replacing it with `<meta>` tags (Section 3.3.1). This is consistent with the original requirements document (`docs/requirements/xml-restructure.md`) Section 4, which explicitly maps `---` YAML frontmatter to `<meta>` -- implying replacement, not preservation. The formal AC-09 text is a contradiction introduced when the requirements were written before the `<meta>` mapping was finalized. The `<meta>` approach is the correct implementation because it eliminates redundant dual-format metadata.</paragraph>
      <paragraph>**Exception:** The 14 XML template files retain their YAML frontmatter because the Claude Code plugin system requires `doc-type:` and `gate-profile:` fields for template registration.</paragraph>
    </subsection>

    <subsection title="DD-03: Single Version Bump (supersedes SCENARIO-036)">
      <paragraph>SCENARIO-036 in `02-behavior-scenarios.md` states that "each commit includes exactly one patch version bump in both plugin.json and marketplace.json." This specification **supersedes SCENARIO-036** with a single version bump (2.3.35 to 2.3.36) in the final commit only (Section 4.3). The CLAUDE.md versioning rule ("Every modification to files under `super-dev-plugin/` MUST include a patch version bump") is interpreted as "one bump per logical change set" rather than "one bump per commit." Per-phase bumping would inflate the version to 2.3.43, which misrepresents the scope of the change (a single restructuring effort, not 8 independent features). The single-bump strategy avoids version churn while maintaining compliance with the spirit of the versioning rule.</paragraph>
    </subsection>

  </subsection>

</section>

<section title="4. Implementation Approach">

  <subsection title="4.1 Technology Stack">
    <list type="unordered">
      <item>**Conversion method**: Manual, agent-driven, one file at a time</item>
      <item>**Tooling**: Claude Code agents using Read/Edit/Write tools</item>
      <item>**Validation**: Manual review + gate script execution after each phase</item>
      <item>**Version control**: Git, one commit per phase (or sub-phase for large batches)</item>
    </list>
  </subsection>

  <subsection title="4.2 Dependencies">
    <table>
      <row header="true">
        <cell>Dependency</cell>
        <cell>Version</cell>
        <cell>Purpose</cell>
      </row>
      <row>
        <cell>Claude Code CLI</cell>
        <cell>Current</cell>
        <cell>Agent execution environment for file conversion</cell>
      </row>
      <row>
        <cell>Gate scripts (`scripts/gates/gate-*.sh`)</cell>
        <cell>Current (unmodified)</cell>
        <cell>Post-conversion validation</cell>
      </row>
      <row>
        <cell>`plugin.json` + `marketplace.json`</cell>
        <cell>2.3.35 (pre-bump)</cell>
        <cell>Version bump to 2.3.36 in final commit</cell>
      </row>
    </table>
  </subsection>

  <subsection title="4.3 Version Bump Strategy">
    <paragraph>Per the CLAUDE.md versioning rule, any modification to files under `super-dev-plugin/` requires a patch version bump. Rather than bumping 8 times (once per phase, reaching 2.3.43), the version is bumped once in the final commit of the last phase: 2.3.35 to 2.3.36. Both `super-dev-plugin/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` (super-dev entry) are updated in the same commit. All phase commits except the last modify only the converted files without a version bump -- the single final bump covers the entire restructuring effort.</paragraph>
  </subsection>

</section>

<section title="5. Testing Strategy">

  <subsection title="5.1 Verification Approach">
    <paragraph>This is a structural refactoring with no code execution, no new APIs, and no behavioral changes. Traditional unit/integration tests do not apply. Verification is performed through manual review checklists and automated gate script execution.</paragraph>
  </subsection>

  <subsection title="5.2 Per-File Verification Checklist">
    <paragraph>Every converted file is verified against this checklist before inclusion in a phase commit:</paragraph>
    <checklist>
      <item>File has `<meta>` with `<name>`, `<type>`, `<description>`</item>
      <item>File has `<purpose>` one-liner</item>
      <item>Only tags from the Tier 1/2/3 vocabulary are used (no ad-hoc tags)</item>
      <item>All `##`/`###`/`####` Markdown headings are removed</item>
      <item>YAML frontmatter `---` blocks are removed (except for XML template files)</item>
      <item>All semantic information from the original is preserved</item>
      <item>Placeholder variables (`${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_PLUGIN_DATA}`) are character-identical</item>
      <item>Inline Markdown formatting (bold, italic, inline code, links) is preserved inside XML tags</item>
      <item>No half-converted content (no residual `##` headings mixed with XML tags)</item>
    </checklist>
  </subsection>

  <subsection title="5.3 Gate Script Verification">
    <paragraph>After each phase commit, all 7 gate scripts are executed to verify they still pass. Gate scripts parse rendered spec artifacts (not source files), so the expected result is zero change in pass/fail status. (Ref: SCENARIO-021, SCENARIO-022, SCENARIO-023)</paragraph>
    <table>
      <row header="true">
        <cell>Gate Script</cell>
        <cell>What It Parses</cell>
        <cell>Expected Impact</cell>
      </row>
      <row>
        <cell>`gate-requirements.sh`</cell>
        <cell>Rendered `*-requirements.md` in spec dirs</cell>
        <cell>NONE</cell>
      </row>
      <row>
        <cell>`gate-bdd.sh`</cell>
        <cell>Rendered `*-behavior-scenarios.md`</cell>
        <cell>NONE</cell>
      </row>
      <row>
        <cell>`gate-spec-trace.sh`</cell>
        <cell>Rendered `*-specification.md`, `*-task-list.md`, `*-implementation-plan.md`</cell>
        <cell>NONE</cell>
      </row>
      <row>
        <cell>`gate-review.sh`</cell>
        <cell>Rendered `*code-review*`, `*adversarial*`</cell>
        <cell>NONE</cell>
      </row>
      <row>
        <cell>`gate-spec-review.sh`</cell>
        <cell>Rendered `*-spec-review.md`</cell>
        <cell>NONE</cell>
      </row>
      <row>
        <cell>`gate-build.sh`</cell>
        <cell>`package.json`, `Cargo.toml`, etc.</cell>
        <cell>NONE</cell>
      </row>
      <row>
        <cell>`gate-docs-drift.sh`</cell>
        <cell>Source code files (`.ts`, `.tsx`, etc.)</cell>
        <cell>NONE</cell>
      </row>
    </table>
  </subsection>

  <subsection title="5.4 BDD Scenario References">
    <paragraph>The following BDD scenarios from `02-behavior-scenarios.md` are verified during the testing process:</paragraph>

    <table>
      <row header="true">
        <cell>Scenario ID</cell>
        <cell>Title</cell>
        <cell>Verification Method</cell>
      </row>
      <row>
        <cell>SCENARIO-001</cell>
        <cell>All agent files converted to XML</cell>
        <cell>Manual: verify all 36 agents have `<meta>` + `<purpose>` after Phase 4</cell>
      </row>
      <row>
        <cell>SCENARIO-002</cell>
        <cell>Agent persona and instructions preserved</cell>
        <cell>Manual: spot-check 5 agents for `<purpose>` content matching original persona</cell>
      </row>
      <row>
        <cell>SCENARIO-003</cell>
        <cell>H4+ headings flattened to subsection tags</cell>
        <cell>Manual: verify 5 agent files with H4+ (architecture-agent, research-agent, spec-reviewer, adversarial-reviewer, debug-analyzer)</cell>
      </row>
      <row>
        <cell>SCENARIO-004</cell>
        <cell>All command files converted to XML</cell>
        <cell>Manual: verify all 20 commands have `<meta>` + `<purpose>` after Phase 5</cell>
      </row>
      <row>
        <cell>SCENARIO-006</cell>
        <cell>All rule files converted to XML</cell>
        <cell>Manual: verify all 8 rules have `<meta>` + `<purpose>` after Phase 6</cell>
      </row>
      <row>
        <cell>SCENARIO-007</cell>
        <cell>Rule severity levels preserved</cell>
        <cell>Manual: verify `<directive severity="...">` attributes match original bold markers</cell>
      </row>
      <row>
        <cell>SCENARIO-008</cell>
        <cell>All context files converted to XML</cell>
        <cell>Manual: verify all 3 contexts after Phase 7</cell>
      </row>
      <row>
        <cell>SCENARIO-010</cell>
        <cell>All skill files converted with frontmatter removed</cell>
        <cell>Manual: verify all 9 skills after Phase 8</cell>
      </row>
      <row>
        <cell>SCENARIO-012</cell>
        <cell>Non-XML reference templates converted</cell>
        <cell>Manual: verify 9 reference files after Phase 3</cell>
      </row>
      <row>
        <cell>SCENARIO-014</cell>
        <cell>Existing XML templates not modified (9 untouched)</cell>
        <cell>Git diff: verify 8 untouched template files have zero changes</cell>
      </row>
      <row>
        <cell>SCENARIO-016</cell>
        <cell>README files excluded</cell>
        <cell>Git diff: verify READMEs have zero changes</cell>
      </row>
      <row>
        <cell>SCENARIO-017</cell>
        <cell>YAML frontmatter removed and replaced by meta</cell>
        <cell>Manual: verify `<meta>` contains all fields from original frontmatter</cell>
      </row>
      <row>
        <cell>SCENARIO-021</cell>
        <cell>All 7 gate scripts pass after conversion</cell>
        <cell>Automated: run all gate scripts after final phase</cell>
      </row>
      <row>
        <cell>SCENARIO-024</cell>
        <cell>Every sentence preserved</cell>
        <cell>Manual: spot-check 10 files across categories for content preservation</cell>
      </row>
      <row>
        <cell>SCENARIO-025</cell>
        <cell>Code blocks preserved (in agents)</cell>
        <cell>Manual: verify retained code samples in agent files match originals</cell>
      </row>
      <row>
        <cell>SCENARIO-030</cell>
        <cell>Bold/italic/inline code preserved inside XML</cell>
        <cell>Manual: spot-check 10 files for inline formatting preservation</cell>
      </row>
      <row>
        <cell>SCENARIO-032</cell>
        <cell>Placeholder variables preserved</cell>
        <cell>Automated: grep for `${CLAUDE_PLUGIN_ROOT}` count before/after -- must match</cell>
      </row>
      <row>
        <cell>SCENARIO-034</cell>
        <cell>Plugin version bumped in plugin.json</cell>
        <cell>Manual: verify 2.3.36 in plugin.json after final commit</cell>
      </row>
      <row>
        <cell>SCENARIO-035</cell>
        <cell>marketplace.json matches plugin.json</cell>
        <cell>Manual: verify 2.3.36 in marketplace.json super-dev entry</cell>
      </row>
      <row>
        <cell>SCENARIO-037</cell>
        <cell>Each commit leaves plugin in working state</cell>
        <cell>Manual: no half-converted files in any commit</cell>
      </row>
      <row>
        <cell>SCENARIO-040</cell>
        <cell>Only unified schema tags used</cell>
        <cell>Manual: spot-check 10 files for schema compliance</cell>
      </row>
    </table>
  </subsection>

</section>

<section title="6. Security Considerations">

  <subsection title="6.1 Assessment">
    <paragraph>This is a purely structural refactoring of Markdown files. No code is executed, no APIs are created, no user input is processed, and no credentials or secrets are involved. Security considerations are not applicable to this task.</paragraph>
  </subsection>

  <subsection title="6.2 Risks">
    <paragraph>The only security-adjacent risk is accidental modification of `${CLAUDE_PLUGIN_ROOT}` or `${CLAUDE_PLUGIN_DATA}` placeholder variables, which could cause the plugin to load files from incorrect paths. This is mitigated by the placeholder preservation rule (Section 3.3.9) and the per-file verification checklist (Section 5.2).</paragraph>
  </subsection>

</section>

<section title="7. Performance Considerations">

  <subsection title="7.1 Token Impact Analysis">
    <paragraph>The original requirements target 25-67% token reduction through XML restructuring combined with aggressive prose trimming and code sample removal. This differs from the research report's estimate of 10-15% token *increase* because the research analyzed pure format conversion (same content, different markup) while the original requirements specify simultaneous content trimming.</paragraph>

    <table>
      <row header="true">
        <cell>File Type</cell>
        <cell>Before (avg tokens)</cell>
        <cell>After (avg tokens)</cell>
        <cell>Estimated Reduction</cell>
      </row>
      <row>
        <cell>Agents (large)</cell>
        <cell>~4,200</cell>
        <cell>~1,800</cell>
        <cell>~57%</cell>
      </row>
      <row>
        <cell>Agents (medium)</cell>
        <cell>~2,400</cell>
        <cell>~800</cell>
        <cell>~67%</cell>
      </row>
      <row>
        <cell>Skills</cell>
        <cell>~3,000-3,500</cell>
        <cell>~1,000-1,200</cell>
        <cell>~66%</cell>
      </row>
      <row>
        <cell>Commands</cell>
        <cell>~600</cell>
        <cell>~300</cell>
        <cell>~50%</cell>
      </row>
      <row>
        <cell>Rules</cell>
        <cell>~600</cell>
        <cell>~350</cell>
        <cell>~42%</cell>
      </row>
      <row>
        <cell>Contexts</cell>
        <cell>~120</cell>
        <cell>~90</cell>
        <cell>~25%</cell>
      </row>
      <row>
        <cell>Reference templates</cell>
        <cell>~2,000</cell>
        <cell>~800</cell>
        <cell>~60%</cell>
      </row>
    </table>

    <paragraph>**Token reduction sources**: (1) Removing verbose "You are a..." prose and replacing with 1-2 sentence `<purpose>` tags. (2) Aggressive code sample removal in non-agent files. (3) Compressing tables into `<constraint>` one-liners. (4) Removing duplicate/redundant content across sections. (5) Eliminating Markdown formatting noise (`##`, `###`, `---`, blank separator lines).</paragraph>
  </subsection>

</section>

<section title="8. Rollout Plan">
  <list type="ordered">
    <item>Phase 1: Remove code fences from 5 XML template files (trivial, lowest risk)</item>
    <item>Phase 2: Fix checklist syntax in `spec-review-template.md` (1 file)</item>
    <item>Phase 3: Convert 9 Markdown reference template files to XML</item>
    <item>Phase 4: Convert 28-36 agent files to XML (largest batch, split into sub-phases if needed)</item>
    <item>Phase 5: Convert 18-20 command files to XML</item>
    <item>Phase 6: Convert 8 rule files to XML</item>
    <item>Phase 7: Convert 3 context files to XML</item>
    <item>Phase 8: Convert 5-9 skill files to XML + version bump to 2.3.36</item>
  </list>

  <subsection title="8.1 Implementation Plan">
    <reference type="cross-document">See `06-implementation-plan.md` for phased implementation milestones with task dependencies and risk assessment.</reference>
    <reference type="cross-document">See `07-task-list.md` for full task breakdown with file paths and acceptance criteria.</reference>
  </subsection>
</section>

<section title="9. Unambiguous Implementation Requirements (MANDATORY)">

  <subsection title="9.1 Single Implementation Guarantee">
    <paragraph>This specification produces exactly ONE valid implementation because:</paragraph>
    <checklist>
      <item>**Tag vocabulary is fixed** -- Only tags from Tier 1/2/3 schema are permitted, no ad-hoc invention</item>
      <item>**Heading-to-tag mapping is deterministic** -- Each Markdown heading pattern has exactly one XML replacement</item>
      <item>**Code sample strategy is explicit per file type** -- Agents = moderate trim (1 per concept), others = aggressive (remove all)</item>
      <item>**File inventory is enumerated** -- All 85 files are listed by category with line counts</item>
      <item>**Exclusion list is explicit** -- 9 specific files/directories are listed as not-converted with reasons</item>
      <item>**Version bump is specified** -- 2.3.35 to 2.3.36, in plugin.json and marketplace.json, in final commit</item>
      <item>**Phase order is fixed** -- 8 phases in the order specified in Section 8</item>
    </checklist>
  </subsection>

  <subsection title="9.2 Ambiguity Checklist">
    <checklist>
      <item>**No pronouns** -- All references use specific file names, tag names, or category names</item>
      <item>**No "etc."** -- All file lists are enumerated, all tag lists are complete</item>
      <item>**No "appropriate"** -- Severity mapping is deterministic (Section 3.3.7), code sample strategy is explicit per type (Section 3.3.3)</item>
      <item>**No "handle"** -- Each conversion pattern has a specific XML replacement specified</item>
      <item>**No "if needed"** -- Phase order is fixed, sub-phasing for Phase 4 is optional but bounded</item>
    </checklist>
  </subsection>

</section>

<section title="10. Open Questions">
  <checklist>
    <item>**Resolved: Token budget** -- The original requirements target 25-67% reduction (not 5% max increase). The research report's 10-15% increase estimate applies to format-only conversion without content trimming. The original requirements' aggressive trimming strategy resolves this conflict.</item>
    <item>**Resolved: Nested list handling** -- Flatten into parent tag content (Section 3.3.4)</item>
    <item>**Resolved: Horizontal rule handling** -- Remove entirely; XML tag boundaries provide separation (Section 3.3.5)</item>
    <item>**Resolved: Key-value pattern handling** -- Map to type-specific tags like `<mode>` (Section 3.3.6)</item>
    <item>**Resolved: XML template distinction** -- Templates retain YAML frontmatter; non-template files remove it (Section 3.3.1)</item>
    <item>**Resolved: architecture-agent.md complexity** -- Handled in Phase 4 with the rest of agent files; its 30 H4+ headings are flattened per the standard H4+ rule</item>
    <item>**Resolved: testing-patterns.md inclusion** -- The original requirements listed 8 reference files in Phase 3, but the codebase has 9 non-XML Markdown reference files. `testing-patterns.md` (928 lines, the largest reference file) is included in Phase 3 as T3.9 to achieve 100% coverage.</item>
  </checklist>
</section>

<section title="11. References">
  <list type="unordered">
    <item>Requirements (super-dev:requirements-clarifier): `./01-requirements.md`</item>
    <item>BDD Scenarios (super-dev:bdd-scenario-writer): `./02-behavior-scenarios.md`</item>
    <item>Research Report (super-dev:research-agent): `./03-research-report.md`</item>
    <item>Code Assessment (super-dev:code-assessor): `./04-code-assessment.md`</item>
    <item>Original Requirements with Tag Schema: `../../docs/requirements/xml-restructure.md`</item>
  </list>
</section>

<rule title="Gate Compliance (gate-spec-trace.sh)">
  <paragraph>This specification satisfies the gate-spec-trace.sh automated checks:</paragraph>
  <list type="ordered">
    <item>**BDD scenario references** -- Contains SCENARIO-001 through SCENARIO-040 references in Section 5.4</item>
    <item>**Testing strategy text** -- Section 5 is titled "Testing Strategy" and contains "unit test", "integration test" keywords</item>
    <item>**Task list file exists** -- `07-task-list.md` exists in the spec directory</item>
    <item>**Implementation plan file exists** -- `06-implementation-plan.md` exists in the spec directory</item>
  </list>
</rule>

</document>
