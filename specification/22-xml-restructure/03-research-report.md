```xml
<document type="research-report">

  <metadata>
    <field name="title">Research Report: XML-Tagged Structure for LLM Instruction Files</field>
    <field name="date">2026-04-16</field>
    <field name="author">super-dev:research-agent</field>
    <field name="source">01-requirements.md, 02-behavior-scenarios.md</field>
    <field name="status">Complete</field>
  </metadata>

  <section title="Executive Summary">
    <paragraph>This report synthesizes research on converting Markdown-based LLM instruction files to XML-tagged structure within `.md` files. The evidence strongly supports using XML tags for Claude system prompts — Anthropic's own documentation explicitly recommends XML tags for structuring complex prompts. Token efficiency tradeoffs are nuanced: XML adds ~10-20% overhead per file versus bare Markdown, but the structural clarity improves instruction adherence and eliminates an entire class of parsing ambiguity errors. Five conversion strategy options are presented, ranging from lightweight hybrid approaches to full semantic XML conversion.</paragraph>
  </section>

  <section title="Research Question 1: XML Tags in LLM Prompts — Established Patterns">

    <subsection title="Anthropic's Official Recommendation">
      <paragraph>Anthropic's prompting best practices documentation (docs.anthropic.com/en/docs/use-xml-tags) explicitly recommends XML tags for Claude. Key findings from official docs:</paragraph>
      <list type="unordered">
        <item>**"XML tags help Claude parse complex prompts unambiguously"** — especially when prompts mix instructions, context, examples, and variable inputs</item>
        <item>**Wrapping each content type in its own tag** (e.g., `<instructions>`, `<context>`, `<examples>`) reduces misinterpretation</item>
        <item>**Best practices**: Use consistent, descriptive tag names; nest tags when content has a natural hierarchy</item>
        <item>**Claude was explicitly trained with XML tags in the training data** — making tags particularly effective for guiding behavior</item>
        <item>**Multi-document structuring**: Anthropic recommends `<documents><document index="1"><source>...</source><document_content>...</document_content></document></documents>` for organizing multiple inputs</item>
        <item>**Output formatting**: XML tags can direct Claude to write within specific tags (e.g., `<findings>`, `<recommendations>`), enabling deterministic parsing</item>
      </list>
      <paragraph>Source: Anthropic Prompting Best Practices (https://docs.anthropic.com/en/docs/use-xml-tags)</paragraph>
    </subsection>

    <subsection title="Independent Benchmark: The Delimiter Hypothesis (Systima, March 2026)">
      <paragraph>A rigorous 600-call benchmark by Systima tested XML, Markdown, and JSON across 4 frontier models (GPT-5.2, Claude Opus 4.6, MiniMax M2.5, Kimi K2.5) on 10 tasks over 2 rounds.</paragraph>
      <list type="unordered">
        <item>**Combined boundary scores**: XML 97.1%, JSON 97.3%, Markdown 95.4%</item>
        <item>**For Claude Opus 4.6 specifically**: Format differences were within run-to-run variance (96.3% across all formats in Round 2) — Claude handles all formats nearly equally well</item>
        <item>**Key finding**: "Format rarely matters, but when it does, Markdown is the weak link" — Markdown trailed XML/JSON by ~2 percentage points overall</item>
        <item>**Nuance**: The gap was driven primarily by one model (MiniMax M2.5, 12.4-point Markdown drop). For Claude, the practical difference is minimal</item>
      </list>
      <paragraph>Source: Systima — The Delimiter Hypothesis (https://systima.ai/blog/delimiter-hypothesis)</paragraph>
    </subsection>

    <subsection title="Practitioner Evidence">
      <paragraph>Multiple practitioner reports confirm the structural benefits:</paragraph>
      <list type="unordered">
        <item>**Rephrase.it (Feb 2026)**: "Closing tags create symmetry that helps the model keep track of boundaries. Practitioners routinely report that explicit sectioning reduces drift and cross-contamination." Recommends XML for sections you control, Markdown code fences for user payloads.</item>
        <item>**Towards AI (Dec 2025)**: Describes XML prompting as "Anthropic's most practical reliability hack — turning prompts into contracts with labeled compartments."</item>
        <item>**aiwithgrant**: "Without XML tags, Claude produces verbose letter-style reports. With tags, it generates concise, properly formatted output."</item>
      </list>
    </subsection>

    <subsection title="Key Insight for This Project">
      <paragraph>The evidence is strongest for **section-level XML structuring** — wrapping logical blocks in named tags. The evidence does NOT support wrapping every individual paragraph or list item in XML tags, which adds token overhead without proportional benefit. This is a critical distinction for the conversion strategy.</paragraph>
    </subsection>

  </section>

  <section title="Research Question 2: Token Efficiency Analysis">

    <subsection title="Token Cost of XML vs Markdown">
      <paragraph>Multiple sources provide quantitative comparisons:</paragraph>
      <table>
        <row header="true">
          <cell>Source</cell>
          <cell>Finding</cell>
        </row>
        <row>
          <cell>ShShell.com (Jan 2026)</cell>
          <cell>Token density: Markdown = Low cost, XML = Medium cost, JSON = High cost, YAML = Lowest cost</cell>
        </row>
        <row>
          <cell>RDD10+ Comparative Analysis (Mar 2025)</cell>
          <cell>"XML increases token count due to tag verbosity, potentially increasing costs." Markdown "requires fewer tokens for the same basic structure."</cell>
        </row>
        <row>
          <cell>web2md.org benchmarks (Apr 2026)</cell>
          <cell>System prompt compression yields 50-85% savings. But this compares verbose prompts to compressed, not XML to Markdown.</cell>
        </row>
        <row>
          <cell>Claude.ai public artifact analysis</cell>
          <cell>"Markdown delivers 16% average token efficiency over JSON." XML falls between Markdown and JSON.</cell>
        </row>
      </table>
    </subsection>

    <subsection title="Quantitative Estimate for This Project">
      <paragraph>Based on the research, converting from Markdown headings to XML tags introduces the following token changes per element:</paragraph>
      <table>
        <row header="true">
          <cell>Markdown Element</cell>
          <cell>Tokens</cell>
          <cell>XML Replacement</cell>
          <cell>Tokens</cell>
          <cell>Delta</cell>
        </row>
        <row>
          <cell>`## Section Name`</cell>
          <cell>~3-4</cell>
          <cell>`<section title="Section Name">`...`</section>`</cell>
          <cell>~6-8</cell>
          <cell>+3-4</cell>
        </row>
        <row>
          <cell>`### Subsection`</cell>
          <cell>~3-5</cell>
          <cell>`<subsection title="Subsection">`...`</subsection>`</cell>
          <cell>~7-9</cell>
          <cell>+4</cell>
        </row>
        <row>
          <cell>`- item`</cell>
          <cell>~2</cell>
          <cell>`<item>item</item>`</cell>
          <cell>~4-5</cell>
          <cell>+2-3</cell>
        </row>
        <row>
          <cell>```code```</cell>
          <cell>~2</cell>
          <cell>`<code language="...">`</cell>
          <cell>~5-6</cell>
          <cell>+3-4</cell>
        </row>
        <row>
          <cell>Bare paragraph</cell>
          <cell>0</cell>
          <cell>`<paragraph>`...`</paragraph>`</cell>
          <cell>~3</cell>
          <cell>+3</cell>
        </row>
      </table>

      <paragraph>**Estimated net impact**: For a typical 300-line agent file with ~20 headings, ~40 list items, ~5 code blocks, and ~30 paragraphs, XML conversion adds approximately 200-300 tokens. On a file that is typically 2000-4000 tokens, this represents a **5-15% token increase**.</paragraph>

      <paragraph>**Mitigation**: The requirements specify a 5% max increase target. To meet this, the conversion strategy must be selective — applying XML tags at the section/subsection level (where structural clarity matters most) while leaving fine-grained content (individual list items, paragraphs) in lightweight format.</paragraph>
    </subsection>

    <subsection title="ShShell Key Insight">
      <paragraph>"XML provides unambiguous bookends for data. If you have a 10,000-token document, wrapping it in tags costs only 4 tokens, but it allows the attention mechanism to isolate that document perfectly from your instructions." — The value of XML is proportional to the ambiguity it resolves, not the amount of content it wraps.</paragraph>
    </subsection>

  </section>

  <section title="Research Question 3: Tag Schema Design Best Practices">

    <subsection title="Naming Conventions">
      <list type="unordered">
        <item>**Anthropic**: "Use consistent, descriptive tag names across your prompts" and "There are no canonical 'best' XML tags — just use names that make sense"</item>
        <item>**Rephrase.it**: Use lowercase, hyphenated names that describe function (e.g., `<role>`, `<task>`, `<constraints>`) not structure</item>
        <item>**aiwithgrant**: Common patterns include `<instructions>`, `<context>`, `<examples>`, `<output_format>`</item>
      </list>
    </subsection>

    <subsection title="Nesting Depth">
      <list type="unordered">
        <item>**Anthropic**: "Nest tags when content has a natural hierarchy" — but does not prescribe maximum depth</item>
        <item>**RDD10+ Analysis**: "The complexity of XML can become an obstacle: Malformed tags can break the entire structure." Recommends limiting nesting to 2-3 levels for maintainability</item>
        <item>**LLMLingua Bug #201**: Demonstrates that nested XML tags inside prompt compression tools can break regex-based parsers — a real pitfall when tools process these files</item>
        <item>**Practitioner consensus**: 2-3 nesting levels is the sweet spot. Beyond that, the structural overhead outweighs the clarity benefit</item>
      </list>
    </subsection>

    <subsection title="Attribute Usage">
      <list type="unordered">
        <item>Anthropic uses `index` attributes on `<document>` tags for multi-document contexts</item>
        <item>The existing templates in this project use `type` on `<document>`, `title` on `<section>`/`<subsection>`, `name` on `<field>`, `type` on `<list>`, `severity` on `<rule>` — a well-designed vocabulary already</item>
        <item>Attributes work well for classification metadata (type, severity, status) but should not carry content that the LLM needs to act on — content belongs in tag bodies</item>
      </list>
    </subsection>

    <subsection title="Existing Project Schema Assessment">
      <paragraph>The unified tag schema already defined in the requirements document (01-requirements.md, Design Decisions section) is well-aligned with best practices. It uses:</paragraph>
      <list type="unordered">
        <item>3-level nesting maximum: `<document>` > `<section>` > `<subsection>` (H4+ flattened)</item>
        <item>Descriptive, lowercase tag names with semantic meaning</item>
        <item>Attributes for classification, not content</item>
        <item>Separation of structural tags (`<section>`, `<subsection>`) from content tags (`<paragraph>`, `<list>`, `<code>`) from semantic tags (`<persona>`, `<rule>`, `<example>`)</item>
      </list>
      <paragraph>**Assessment**: The proposed schema is sound and consistent with research findings. No changes recommended to the tag vocabulary.</paragraph>
    </subsection>

  </section>

  <section title="Research Question 4: Conversion Pitfalls">

    <subsection title="Known Failure Modes">
      <list type="ordered">
        <item>**Over-wrapping (Token Bloat)**: Wrapping every paragraph, list item, and inline element in XML tags can increase token count by 15-25% without proportional benefit. The ShShell research is clear: "Markdown by default. XML for context wrapping." The risk is converting prose-heavy agent files into verbose tag soup.</item>

        <item>**Nested Tags Inside Code Blocks**: Files like `research-agent.md` contain code examples that include XML-like content (e.g., MCP tool call examples). Converting structural Markdown while leaving code block content untouched requires careful boundary detection. The LLMLingua bug demonstrates this: regex-based tools break when encountering nested tags.</item>

        <item>**Loss of Implicit Semantic Cues**: Markdown's `**bold**` and `*italic*` carry emphasis meaning. If the conversion strips these (the requirements say it should not), the LLM loses emphasis cues. Similarly, blank lines between paragraphs in Markdown serve as visual separators — XML tags make these explicit but the conversion must ensure readability is maintained.</item>

        <item>**YAML Frontmatter Corruption**: The Claude Code plugin system parses YAML frontmatter separately. If the conversion accidentally modifies the frontmatter delimiters (`---`) or introduces XML before the frontmatter, the plugin system will fail to register the agent/command/skill.</item>

        <item>**Gate Script Breakage via Template Contamination**: Gate scripts parse rendered spec artifacts. If the conversion inadvertently modifies template files (the 13 that already use XML), gate scripts that grep for specific patterns could break. The requirements address this with FR-07 (do not modify XML templates), but the risk must be actively managed during implementation.</item>

        <item>**H4+ Heading Flattening Ambiguity**: When `####` headings are flattened to `<subsection>` tags, the original nesting relationship with parent `###` sections is lost. For files with deeply nested content (like `team-lead.md` at 1036 lines), this could change how an LLM interprets the section hierarchy. Mitigation: use `title` attributes that encode enough context to preserve the relationship.</item>

        <item>**Mixed Content Inside Tags**: Some agent files contain inline code, bold text, links, and placeholder variables all within the same paragraph. The XML conversion must leave all inline Markdown formatting intact inside XML tags. This is explicitly addressed in the requirements (FR-09, Content Preservation Rules item 4).</item>
      </list>
    </subsection>

    <subsection title="Mitigation Strategy">
      <paragraph>The phased approach (Option 2 in requirements) naturally mitigates most pitfalls: start with the simplest files (3 contexts), validate the approach, then scale to increasingly complex files. Additionally:</paragraph>
      <list type="unordered">
        <item>Use a "before/after diff" check on rendered text content (strip tags/headings, compare) for each converted file</item>
        <item>Run gate scripts after each phase commit</item>
        <item>Manually review files that contain embedded XML examples (templates, research-agent.md)</item>
      </list>
    </subsection>

  </section>

  <section title="Research Question 5: Existing Examples and Frameworks">

    <subsection title="AgentML (agentflare-ai/agentml)">
      <paragraph>An early-alpha universal language for AI agents inspired by HTML, built on the W3C SCXML standard. Uses XML root elements (`<agentml>`) with namespaces for extensibility. Agent definitions are `.aml` files containing state machine definitions in XML. Relevant pattern: schema-guided events where LLM outputs are validated against JSON schemas.</paragraph>
      <paragraph>**Relevance to this project**: Validates that XML-based agent definition is a viable pattern. However, AgentML is a full runtime language, not XML-within-Markdown. Different use case.</paragraph>
    </subsection>

    <subsection title="sub-agents-mcp (shinpr/sub-agents-mcp)">
      <paragraph>Defines task-specific AI sub-agents in Markdown files. Each `.md` file becomes an agent. Uses standard Markdown structure (`# Agent Name`, `## Task`, `## Rules`). 80 stars on GitHub.</paragraph>
      <paragraph>**Relevance**: This is the Markdown-first approach — the opposite of what this project is converting away from. Demonstrates that Markdown-based agent definitions are common but lack structural validation.</paragraph>
    </subsection>

    <subsection title="MarkdownLM MCP Server">
      <paragraph>A persistence and governance layer for AI coding agents. Defines rules in categorized Markdown. Uses plain Markdown for storage but provides structured query/validation tools via MCP.</paragraph>
      <paragraph>**Relevance**: Shows the governance/validation gap that pure Markdown creates — they had to build validation tools on top because Markdown itself does not provide structural guarantees.</paragraph>
    </subsection>

    <subsection title="Palinode (Paul-Kyle/palinode)">
      <paragraph>Persistent memory for AI agents using Markdown files with YAML frontmatter. Indexes with SQLite-vec, compacts with LLM. Uses the pattern of "Markdown + YAML frontmatter" as source of truth.</paragraph>
      <paragraph>**Relevance**: Validates the YAML-frontmatter-above-XML-body pattern that this project's requirements specify. Palinode also uses YAML frontmatter for metadata and Markdown body for content — showing this is a widely adopted pattern.</paragraph>
    </subsection>

    <subsection title="Claude Code's Own System Prompts">
      <paragraph>Anthropic's own Claude Code product uses XML tags extensively in its system prompts (visible in the system-reminder blocks that appear in conversations). Tags like `<system-reminder>`, `<env>`, `<functions>` are used to structure context injection. This is the strongest endorsement: Anthropic uses XML tags in their own product to structure instructions sent to Claude.</paragraph>
    </subsection>

    <subsection title="Key Finding">
      <paragraph>No existing framework uses the exact pattern proposed here (XML tags within `.md` files for agent definitions with YAML frontmatter preserved). This project's approach is novel but well-grounded in established patterns. The closest analogue is Claude Code's own system prompt structure, which uses XML tags extensively.</paragraph>
    </subsection>

  </section>

  <section title="Conversion Strategy Options">

    <option id="1" label="Lightweight Hybrid: XML Sections + Markdown Content">
      <paragraph>Convert only structural elements (headings) to XML tags. Leave all content-level elements (paragraphs, lists, code blocks, tables) in native Markdown format inside the XML sections.</paragraph>

      <subsection title="Before">
        <code language="markdown">
---
name: planner
description: Expert planning specialist
---

## Your Role
- Analyze requirements
- Create implementation plans

### 1. Requirements Analysis
- Understand the feature request
- Identify success criteria
        </code>
      </subsection>

      <subsection title="After">
        <code language="markdown">
---
name: planner
description: Expert planning specialist
---

<document type="agent">
<section title="Your Role">

- Analyze requirements
- Create implementation plans

<subsection title="1. Requirements Analysis">

- Understand the feature request
- Identify success criteria

</subsection>
</section>
</document>
        </code>
      </subsection>

      <list type="unordered">
        <item>**Pros**: Minimal token overhead (~3-5% increase). Preserves human readability. Fastest to implement. Lowest risk of content corruption. Content renders normally in Markdown viewers.</item>
        <item>**Cons**: Does NOT match the existing template format (templates use `<paragraph>`, `<list>`, `<item>`, etc.). Creates a two-tier system: templates use full XML, agents/commands use hybrid. Does not enable programmatic validation of list/paragraph structure.</item>
        <item>**Token impact**: +3-5% (only section/subsection tags added)</item>
        <item>**Consistency with existing templates**: LOW — templates already wrap every content element</item>
      </list>
    </option>

    <option id="2" label="Full Schema Compliance: Match Existing Template Format">
      <paragraph>Convert every structural AND content element to XML tags exactly as defined in the requirements' unified tag schema. Every paragraph gets `<paragraph>`, every list gets `<list><item>`, every code block gets `<code language="...">`. This matches the format already used by the 13 spec-artifact templates.</paragraph>

      <subsection title="Before">
        <code language="markdown">
## Your Role
- Analyze requirements
- Create implementation plans

### 1. Requirements Analysis
- Understand the feature request
- Identify success criteria

```bash
echo "hello"
```
        </code>
      </subsection>

      <subsection title="After">
        <code language="xml">
<section title="Your Role">
  <list type="unordered">
    <item>Analyze requirements</item>
    <item>Create implementation plans</item>
  </list>

  <subsection title="1. Requirements Analysis">
    <list type="unordered">
      <item>Understand the feature request</item>
      <item>Identify success criteria</item>
    </list>

    <code language="bash">
echo "hello"
    </code>
  </subsection>
</section>
        </code>
      </subsection>

      <list type="unordered">
        <item>**Pros**: 100% format consistency across the entire plugin. Enables programmatic validation (lint-xml-structure.sh). Matches the proven template format. Unambiguous structure at every level. Strongest LLM parsing signal.</item>
        <item>**Cons**: Higher token overhead (~10-15% increase). Reduced human readability for editing. More labor-intensive conversion. Higher risk of content corruption during conversion. Files no longer render nicely in Markdown viewers.</item>
        <item>**Token impact**: +10-15% (all elements wrapped)</item>
        <item>**Consistency with existing templates**: HIGH — identical format</item>
      </list>
    </option>

    <option id="3" label="Semantic XML: Section-Level Tags + Semantic Tags Only">
      <paragraph>Convert headings to `<section>`/`<subsection>` tags. Leave generic content (paragraphs, lists, code) in Markdown. BUT add semantic XML tags where they provide domain-specific value: `<persona>`, `<rule severity="...">`, `<example>`, `<diagram>`. This targets the highest-value XML tags without wrapping every content element.</paragraph>

      <subsection title="Before">
        <code language="markdown">
## Persona: Research Scout
You are a **Research Scout** operating like an intelligence analyst.

### Gotchas (Common Research Failures)
- **Outdated information**: Library docs from 2 versions ago
- **Tutorial bias**: Blog posts showing happy path only
        </code>
      </subsection>

      <subsection title="After">
        <code language="markdown">
<section title="Persona">
<persona>
You are a **Research Scout** operating like an intelligence analyst.
</persona>
</section>

<section title="Gotchas (Common Research Failures)">

- **Outdated information**: Library docs from 2 versions ago
- **Tutorial bias**: Blog posts showing happy path only

</section>
        </code>
      </subsection>

      <list type="unordered">
        <item>**Pros**: Best of both worlds — structural clarity where it matters (persona, rules, examples) without token bloat on generic content. ~5-8% token increase. Adds the most semantically valuable tags. Human-readable content areas preserved.</item>
        <item>**Cons**: Creates a third format tier (templates = full XML, agents = semantic XML, old = Markdown). Subjective judgment required for which content gets semantic tags. Harder to define deterministic conversion rules.</item>
        <item>**Token impact**: +5-8% (section tags + selective semantic tags)</item>
        <item>**Consistency with existing templates**: MEDIUM — structural tags match, content tags differ</item>
      </list>
    </option>

    <option id="4" label="Full Schema + Token-Optimized: Minified Inner Content">
      <paragraph>Apply the full unified tag schema (Option 2) but omit `<paragraph>` tags for single-paragraph sections and use compact list notation. This preserves full schema compliance for validation while reducing the token overhead of the most verbose tags.</paragraph>

      <subsection title="Approach">
        <list type="unordered">
          <item>Use `<section>`, `<subsection>`, `<list>`, `<item>`, `<code>`, `<table>` tags (full compliance)</item>
          <item>Omit `<paragraph>` when a section contains exactly one block of prose text (the text is directly inside the section)</item>
          <item>Use `<paragraph>` only when a section contains multiple distinct prose blocks that need separation</item>
          <item>Always use `<list><item>` (these carry the most structural value — list type is lost without them)</item>
        </list>
      </subsection>

      <list type="unordered">
        <item>**Pros**: Near-full schema compliance. Enables validation. ~7-10% token increase (vs 10-15% for strict full schema). Practical balance.</item>
        <item>**Cons**: Adds a rule exception ("omit paragraph when single block") that complicates validation. Slightly inconsistent with templates that always use `<paragraph>`.</item>
        <item>**Token impact**: +7-10%</item>
        <item>**Consistency with existing templates**: HIGH (with minor paragraph exception)</item>
      </list>
    </option>

    <option id="5" label="Recommended: Full Schema Compliance (Option 2) with Phased Execution">
      <paragraph>Adopt the full unified tag schema as defined in the requirements (Option 2 above), but execute in 8 phases as recommended in the requirements document. The token overhead is justified by the consistency and validation benefits. Accept the ~10-15% token increase as an investment in structural reliability.</paragraph>

      <subsection title="Rationale">
        <list type="ordered">
          <item>**Consistency is the primary goal**: The requirements explicitly state that unifying on one format is the objective. A hybrid approach defeats this purpose.</item>
          <item>**The templates prove the format works**: 13 templates already use full XML. Agents producing spec artifacts from these templates must match the format to avoid cognitive switching.</item>
          <item>**Token overhead is acceptable**: Even at 15% increase, the overhead per file is ~300-600 tokens on files that are 2000-4000 tokens. In a 200K token context window, this is negligible.</item>
          <item>**Programmatic validation enabled**: Only with full schema compliance can a lint script validate that every agent has required `<persona>` and `<instructions>` sections.</item>
          <item>**Anthropic endorses the pattern**: Claude was trained with XML tags. Anthropic's own products use XML structuring. The evidence supports full XML over hybrid.</item>
        </list>
      </subsection>

      <list type="unordered">
        <item>**Pros**: Maximum consistency. Maximum validation capability. Aligned with Anthropic's recommendations. Proven by existing templates. Clear, deterministic conversion rules.</item>
        <item>**Cons**: Highest token overhead. Reduced Markdown rendering aesthetics. Most labor-intensive conversion.</item>
        <item>**Token impact**: +10-15%</item>
        <item>**Consistency with existing templates**: HIGHEST</item>
      </list>
    </option>

  </section>

  <section title="Strategy Comparison Matrix">
    <table>
      <row header="true">
        <cell>Criterion</cell>
        <cell>Opt 1: Hybrid</cell>
        <cell>Opt 2: Full Schema</cell>
        <cell>Opt 3: Semantic</cell>
        <cell>Opt 4: Optimized</cell>
        <cell>Opt 5: Full+Phased</cell>
      </row>
      <row>
        <cell>Token overhead</cell>
        <cell>+3-5%</cell>
        <cell>+10-15%</cell>
        <cell>+5-8%</cell>
        <cell>+7-10%</cell>
        <cell>+10-15%</cell>
      </row>
      <row>
        <cell>Template consistency</cell>
        <cell>Low</cell>
        <cell>High</cell>
        <cell>Medium</cell>
        <cell>High</cell>
        <cell>Highest</cell>
      </row>
      <row>
        <cell>Validation capability</cell>
        <cell>Low</cell>
        <cell>High</cell>
        <cell>Medium</cell>
        <cell>High</cell>
        <cell>High</cell>
      </row>
      <row>
        <cell>Human readability</cell>
        <cell>High</cell>
        <cell>Medium</cell>
        <cell>High</cell>
        <cell>Medium</cell>
        <cell>Medium</cell>
      </row>
      <row>
        <cell>Conversion effort</cell>
        <cell>Low</cell>
        <cell>High</cell>
        <cell>Medium</cell>
        <cell>High</cell>
        <cell>High</cell>
      </row>
      <row>
        <cell>Risk of content corruption</cell>
        <cell>Low</cell>
        <cell>Medium</cell>
        <cell>Low</cell>
        <cell>Medium</cell>
        <cell>Medium (mitigated by phases)</cell>
      </row>
      <row>
        <cell>Aligns with requirements</cell>
        <cell>Partial</cell>
        <cell>Full</cell>
        <cell>Partial</cell>
        <cell>Near-full</cell>
        <cell>Full</cell>
      </row>
    </table>
  </section>

  <section title="Recommendation">
    <paragraph>**Option 5 (Full Schema Compliance with Phased Execution)** is the recommended strategy. This is effectively Option 2 from the requirements document combined with the 8-phase execution plan. The reasoning:</paragraph>
    <list type="ordered">
      <item>The requirements already specify a unified tag schema. The research confirms this schema is well-designed and aligned with Anthropic's best practices.</item>
      <item>The 5% token ceiling in the NFR is likely too tight for full XML conversion. The research suggests 10-15% is realistic. This should be flagged as an open question for user decision: either relax the NFR to 15% or adopt Option 1/3 (hybrid) to stay within 5%.</item>
      <item>The phased approach (8 phases, lowest-risk first) mitigates the primary risks identified in the pitfall analysis.</item>
      <item>Full schema compliance is the only option that truly unifies the plugin on one format — which is the stated goal.</item>
    </list>

    <subsection title="Open Question for User">
      <paragraph>**Token budget decision required**: The research indicates full XML conversion will increase per-file token count by 10-15%, exceeding the current 5% NFR ceiling. Should the team:</paragraph>
      <list type="unordered">
        <item>**(A)** Relax the NFR to 15% max increase and proceed with full schema compliance (recommended)</item>
        <item>**(B)** Keep the 5% ceiling and adopt Option 1 (Lightweight Hybrid) or Option 3 (Semantic XML)</item>
        <item>**(C)** Measure actual token impact on the first phase (3 context files) before deciding — use empirical data rather than estimates</item>
      </list>
    </subsection>
  </section>

  <section title="Sources">
    <list type="unordered">
      <item>Anthropic Prompting Best Practices — https://docs.anthropic.com/en/docs/use-xml-tags</item>
      <item>Anthropic Prompting Best Practices (docs.claude.com mirror) — https://docs.claude.com/en/docs/use-xml-tags</item>
      <item>Systima: The Delimiter Hypothesis (March 2026) — https://systima.ai/blog/delimiter-hypothesis</item>
      <item>Towards AI: Anthropic XML Prompting (Dec 2025) — https://pub.towardsai.net/stop-writing-blob-prompts-anthropics-xml-tags-turn-claude-into-a-contract-machine-aa45ccc4232c</item>
      <item>aiwithgrant: Use XML Tags to Structure Prompts — https://www.aiwithgrant.com/guides/anthropic-xml-tags</item>
      <item>RDD10+: Comparative Analysis XML vs Markdown in Prompt Engineering (Mar 2025) — https://www.robertodiasduarte.com.br/en/analise-comparativa-entre-xml-e-markdown-na-engenharia-de-prompts-para-modelos-de-linguagem/</item>
      <item>ShShell.com: Token-Efficient Formatting Markdown vs XML vs JSON (Jan 2026) — https://www.shshell.com/blog/token-efficiency-module-4-lesson-4-efficient-formatting</item>
      <item>web2md.org: How to Reduce LLM Token Usage (Apr 2026) — https://web2md.org/blog/reduce-llm-token-usage-practical-guide</item>
      <item>Rephrase.it: How to Structure Prompts with XML and Markdown Tags (Feb 2026) — https://rephrase-it.com/blog/how-to-structure-prompts-with-xml-and-markdown-tags-so-they-</item>
      <item>OpenAI Community: XML vs Markdown for High Performance Tasks (May 2025) — https://community.openai.com/t/xml-vs-markdown-for-high-performance-tasks/1260014</item>
      <item>AgentML Framework — https://github.com/agentflare-ai/agentml</item>
      <item>sub-agents-mcp — https://github.com/shinpr/sub-agents-mcp</item>
      <item>LLMLingua Bug #201 (nested tag parsing) — https://github.com/microsoft/LLMLingua/issues/201</item>
      <item>Token Efficiency Comparison Tool — https://wonderwhy-er.github.io/format-token-comparison/</item>
    </list>
  </section>

</document>
```
