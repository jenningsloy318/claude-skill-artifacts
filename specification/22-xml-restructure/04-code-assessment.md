```xml
<document type="code-assessment">

  <metadata>
    <field name="title">Code Assessment: XML Restructure of super-dev-plugin Files</field>
    <field name="date">2026-04-16</field>
    <field name="author">super-dev:code-assessor</field>
    <field name="source">01-requirements.md, 02-behavior-scenarios.md, 03-research-report.md</field>
    <field name="status">Complete</field>
    <field name="scope">super-dev-plugin/ — all .md files targeted for Markdown-to-XML conversion</field>
  </metadata>

  <section title="Executive Summary">
    <paragraph>The super-dev-plugin contains **101 `.md` files** across 6 categories plus 2 READMEs. Of these, **14 template files** already use XML-tagged structure (wrapped in code fences), leaving **85 files** requiring conversion. All 36 agent files and all 9 skill files have YAML frontmatter. Commands are mixed (14 with frontmatter, 6 without). Rules (1 of 8) and contexts (0 of 3) rarely have frontmatter. The largest file is `architecture-agent.md` at 1,544 lines with 30 H4+ headings, 31 code blocks, 124 table lines, 115 checkboxes, and 259 ASCII diagram lines — making it the most complex conversion target. Gate scripts parse **rendered spec artifacts** (not source files), so they are unaffected by this conversion. Plugin version is **2.3.35** in both `plugin.json` and `marketplace.json`.</paragraph>
  </section>

  <section title="Category 1: Agents (agents/*.md)">

    <subsection title="File Inventory">
      <field name="count">36</field>
      <field name="total-lines">15,610</field>
      <field name="average-lines">433</field>
      <field name="frontmatter">36/36 have YAML frontmatter (100%)</field>
      <field name="frontmatter-fields">All have `name:` and `description:`. 8 files also have `tools:` (architect, build-error-resolver, doc-updater, e2e-runner, planner, refactor-cleaner, security-reviewer, tdd-guide)</field>

      <paragraph>**Complete file list (sorted by line count, descending):**</paragraph>
      <list type="unordered">
        <item>`architecture-agent.md` — 1,544 lines (LARGEST in entire plugin)</item>
        <item>`team-lead.md` — 1,035 lines</item>
        <item>`qa-agent.md` — 966 lines</item>
        <item>`ui-ux-designer.md` — 829 lines</item>
        <item>`golang-developer.md` — 726 lines</item>
        <item>`e2e-runner.md` — 707 lines</item>
        <item>`research-agent.md` — 628 lines</item>
        <item>`security-reviewer.md` — 544 lines</item>
        <item>`build-error-resolver.md` — 531 lines</item>
        <item>`backend-developer.md` — 477 lines</item>
        <item>`rust-developer.md` — 469 lines</item>
        <item>`product-designer.md` — 458 lines</item>
        <item>`doc-updater.md` — 451 lines</item>
        <item>`frontend-developer.md` — 447 lines</item>
        <item>`requirements-clarifier.md` — 360 lines</item>
        <item>`ios-developer.md` — 337 lines</item>
        <item>`investigator.md` — 333 lines</item>
        <item>`debug-analyzer.md` — 328 lines</item>
        <item>`spec-writer.md` — 326 lines</item>
        <item>`dev-executor.md` — 309 lines</item>
        <item>`refactor-cleaner.md` — 305 lines</item>
        <item>`android-developer.md` — 300 lines</item>
        <item>`spec-reviewer.md` — 297 lines</item>
        <item>`code-reviewer.md` — 293 lines</item>
        <item>`docs-executor.md` — 284 lines</item>
        <item>`tdd-guide.md` — 279 lines</item>
        <item>`search-agent.md` — 268 lines</item>
        <item>`doc-validator.md` — 268 lines</item>
        <item>`windows-app-developer.md` — 250 lines</item>
        <item>`macos-app-developer.md` — 245 lines</item>
        <item>`adversarial-reviewer.md` — 236 lines</item>
        <item>`architect.md` — 210 lines</item>
        <item>`code-assessor.md` — 201 lines</item>
        <item>`bdd-scenario-writer.md` — 158 lines</item>
        <item>`planner.md` — 118 lines</item>
        <item>`handoff-writer.md` — 93 lines (SMALLEST agent file)</item>
      </list>
    </subsection>

    <subsection title="Common Markdown Patterns">
      <paragraph>**Heading structure:** All 36 agents use `#` (H1) for the title, `##` (H2) for major sections, `###` (H3) for subsections. Five files use `####` (H4+) headings:</paragraph>
      <list type="unordered">
        <item>`architecture-agent.md` — 30 H4+ headings (most deeply nested)</item>
        <item>`research-agent.md` — 10 H4+ headings</item>
        <item>`spec-reviewer.md` — 8 H4+ headings</item>
        <item>`adversarial-reviewer.md` — 3 H4+ headings</item>
        <item>`debug-analyzer.md` — 2 H4+ headings</item>
      </list>

      <paragraph>**YAML frontmatter format:** All agents follow this pattern:</paragraph>
      <code language="yaml">
---
name: agent-name
description: One-line or multi-line description
tools: Read, Grep, Glob  # Optional, present in 8 files
---
      </code>

      <paragraph>**Persona section:** Most agents begin with a `## Persona:` section immediately after frontmatter, containing a bold persona name and cognitive mode description. Some use the pattern `## Persona: [Name] ([Role])`. This is a semantic pattern ideal for `<persona>` tag wrapping.</paragraph>

      <paragraph>**Code blocks:** 35 of 36 agents contain fenced code blocks (only `handoff-writer.md` has none). Languages include: `bash`, `typescript`, `javascript`, `json`, `jsonl`, `markdown`, `xml`, `python`, `sql`, `go`, `rust`, `swift`, `kotlin`, `css`, `yaml`, unnamed. The highest density is `qa-agent.md` with 41 code blocks.</paragraph>

      <paragraph>**Tables:** 28 of 36 agents contain Markdown pipe tables. The densest are `architecture-agent.md` (124 table lines) and `team-lead.md` (122 table lines).</paragraph>

      <paragraph>**Checkbox lists:** 33 of 36 agents contain checkbox lists (`- [ ]` / `- [x]`). The densest is `architecture-agent.md` with 115 checkboxes.</paragraph>

      <paragraph>**ASCII diagrams:** 27 of 36 agents contain ASCII diagrams using box-drawing characters. The densest is `architecture-agent.md` with 259 diagram lines, followed by `team-lead.md` with 103.</paragraph>

      <paragraph>**Placeholder variables:** 17 of 36 agents reference `${CLAUDE_PLUGIN_ROOT}` or `${CLAUDE_PLUGIN_DATA}`. The most references: `research-agent.md` (20), `search-agent.md` (19).</paragraph>
    </subsection>

    <subsection title="Partial XML Usage">
      <paragraph>13 of 36 agent files contain XML-like tags (inside code blocks or as inline content, NOT as structural markup):</paragraph>
      <list type="unordered">
        <item>`architecture-agent.md` — 4 XML-like lines (in code examples)</item>
        <item>`frontend-developer.md` — 9 XML-like lines (React JSX in code blocks)</item>
        <item>`qa-agent.md` — 5 XML-like lines (test framework examples)</item>
        <item>`rust-developer.md` — 5 XML-like lines (in code examples)</item>
        <item>`doc-validator.md` — 6 XML-like lines (XML template references)</item>
        <item>`ui-ux-designer.md` — 5 XML-like lines (JSX/HTML in code blocks)</item>
        <item>`build-error-resolver.md` — 4 XML-like lines (in code examples)</item>
        <item>`team-lead.md` — 3 XML-like lines (template references)</item>
        <item>`product-designer.md` — 2 XML-like lines</item>
        <item>`research-agent.md` — 2 XML-like lines (MCP tool call examples)</item>
        <item>`search-agent.md` — 2 XML-like lines</item>
        <item>`adversarial-reviewer.md` — 1 XML-like line</item>
        <item>`spec-writer.md` — 1 XML-like line</item>
      </list>
      <paragraph>**IMPORTANT:** None of these use XML as structural markup. All XML-like content is inside fenced code blocks (as examples or JSX) and must be preserved as-is inside `<code>` tags during conversion.</paragraph>
    </subsection>

    <subsection title="Representative Examples">

      <paragraph>**Example 1: Small, simple agent — `planner.md` (118 lines)**</paragraph>
      <code language="markdown">
---
name: planner
description: Expert planning specialist for complex features...
tools: Read, Grep, Glob
---

You are an expert planning specialist focused on creating comprehensive...

## Your Role

- Analyze requirements and create detailed implementation plans
- Break down complex features into manageable steps

### 1. Requirements Analysis
- Understand the feature request completely
- Ask clarifying questions if needed

### 2. Architecture Review
- Analyze existing codebase structure

## Plan Format

```markdown
# Implementation Plan: [Feature Name]
...
```
      </code>
      <paragraph>Pattern: Frontmatter + prose intro + H2 sections + H3 numbered subsections + bulleted lists + code block with template.</paragraph>

      <paragraph>**Example 2: Complex agent with deep nesting — `architecture-agent.md` (1,544 lines, opening)**</paragraph>
      <code language="markdown">
---
name: architecture-agent
description: Produce concise, implementation-ready architecture...
---

## Persona: Engineering Manager (Architecture Lock-Down)

You are an **Engineering Manager** who locks down architecture...

**Cognitive Mode:** Lock-down discipline...

### Architecture Review Readiness Dashboard

| Dimension | Score | Notes |
|-----------|-------|-------|
| Module boundaries clear | /10 | Can you draw the dependency graph? |

### Gotchas (Common Architecture Failures Claude Misses)

- **Premature microservices**: Splitting into services...
      </code>
      <paragraph>Pattern: Frontmatter + persona section + tables + H3 subsections + H4 deep headings + extensive code blocks + ASCII diagrams + checkbox checklists.</paragraph>

      <paragraph>**Example 3: Agent with heavy placeholder variables — `research-agent.md` (628 lines, mid-section)**</paragraph>
      <code language="markdown">
### Exa (Web &amp; Code Search)
```bash
# Web search
${CLAUDE_PLUGIN_ROOT}/scripts/exa/exa_search.sh --query "[query]" --type auto
# Code context search
${CLAUDE_PLUGIN_ROOT}/scripts/exa/exa_code.sh --query "[query]" --tokens 5000
```

### DeepWiki (GitHub Repo Documentation)
```bash
${CLAUDE_PLUGIN_ROOT}/scripts/deepwiki/deepwiki_structure.sh --repo "[owner/repo]"
```
      </code>
      <paragraph>Pattern: H3 subsections containing bash code blocks with `${CLAUDE_PLUGIN_ROOT}` references. These variables must be preserved character-identical.</paragraph>
    </subsection>

    <subsection title="Conversion Challenges">
      <list type="ordered">
        <item>**H4+ heading flattening**: 5 files with H4+ headings need flattening to `<subsection>`. `architecture-agent.md` has 30 H4+ headings — the most complex flattening target.</item>
        <item>**XML inside code blocks**: 13 files contain XML-like content in code blocks (JSX, XML examples, MCP tool calls). The converter must NOT touch content inside fenced code blocks.</item>
        <item>**File size**: `architecture-agent.md` at 1,544 lines is the largest. Context window constraints during conversion must be managed.</item>
        <item>**ASCII diagrams inside and outside code blocks**: Some diagrams are inside code fences, others are bare. Bare diagrams need `<diagram>` wrapping; code-fenced ones need `<code>` wrapping.</item>
        <item>**Checkbox density**: `architecture-agent.md` has 115 checkboxes across multiple sections. Each needs `<checklist>` / `<item status="open|done">` conversion.</item>
        <item>**Persona detection**: The persona section is identified by the heading `## Persona:` but the exact format varies. Some are `## Persona: Name (Role)`, others are just `## Persona`.</item>
        <item>**Horizontal rules**: `adversarial-reviewer.md` uses `---` as section separators within the body (after frontmatter). These must not be confused with YAML frontmatter delimiters.</item>
      </list>
    </subsection>

  </section>

  <section title="Category 2: Commands (commands/*.md)">

    <subsection title="File Inventory">
      <field name="count">20</field>
      <field name="total-lines">2,078</field>
      <field name="average-lines">103</field>
      <field name="frontmatter">14/20 have YAML frontmatter (70%)</field>
      <field name="frontmatter-fields">All frontmatter files have `description:`. 13 also have `name:`. 3 have only `description:` (e2e.md, plan.md, tdd.md)</field>

      <paragraph>**Files WITHOUT frontmatter (6):** `build-fix.md`, `learn.md`, `refactor-clean.md`, `test-coverage.md`, `update-codemaps.md`, `update-docs.md`</paragraph>

      <paragraph>**Complete file list (sorted by line count, descending):**</paragraph>
      <list type="unordered">
        <item>`e2e.md` — 363 lines</item>
        <item>`tdd.md` — 326 lines</item>
        <item>`ui-ux-design.md` — 203 lines</item>
        <item>`architecture-design.md` — 114 lines</item>
        <item>`plan.md` — 113 lines</item>
        <item>`adversarial-review.md` — 104 lines</item>
        <item>`documentation.md` — 97 lines</item>
        <item>`execute.md` — 90 lines</item>
        <item>`debug-analysis.md` — 89 lines</item>
        <item>`code-assessment.md` — 89 lines</item>
        <item>`research.md` — 87 lines</item>
        <item>`code-review.md` — 82 lines</item>
        <item>`usage-report.md` — 74 lines</item>
        <item>`learn.md` — 70 lines</item>
        <item>`golang.md` — 45 lines</item>
        <item>`update-docs.md` — 31 lines</item>
        <item>`build-fix.md` — 29 lines</item>
        <item>`refactor-clean.md` — 28 lines</item>
        <item>`test-coverage.md` — 27 lines</item>
        <item>`update-codemaps.md` — 17 lines (SMALLEST)</item>
      </list>
    </subsection>

    <subsection title="Common Markdown Patterns">
      <paragraph>**Heading structure:** All use `#` (H1) for title, `##` (H2) for sections, `###` (H3) for subsections. **No H4+ headings** in any command file — commands are structurally simpler than agents.</paragraph>

      <paragraph>**Typical structure:** Title (H1) + "What This Command Does" (H2) with numbered list + "When to Use" (H2) with bulleted list + "How It Works" (H2) with numbered steps + "Example Usage" (H2) with code block + "Related Agents" (H2).</paragraph>

      <paragraph>**Code blocks:** Present in 9 of 20 files. Largest code blocks are in `e2e.md` and `tdd.md` (both contain extensive TypeScript test examples).</paragraph>

      <paragraph>**Tables:** Minimal — only `adversarial-review.md` and `execute.md` contain tables.</paragraph>

      <paragraph>**Placeholder variables:** 6 of 20 commands reference `${CLAUDE_PLUGIN_ROOT}` or `${CLAUDE_PLUGIN_DATA}`. `usage-report.md` has the most (6 references).</paragraph>
    </subsection>

    <subsection title="Partial XML Usage">
      <paragraph>Only 1 command file has XML-like content: `golang.md` (1 line, inside a code block). This is trivial.</paragraph>
    </subsection>

    <subsection title="Representative Examples">

      <paragraph>**Example 1: Small command without frontmatter — `update-codemaps.md` (17 lines)**</paragraph>
      <code language="markdown">
# Update Codemaps

Analyze the codebase structure and update architecture documentation:

1. Scan all source files for imports, exports, and dependencies
2. Generate token-lean codemaps in the following format:
   - codemaps/architecture.md - Overall architecture
   - codemaps/backend.md - Backend structure  

3. Calculate diff percentage from previous version
4. If changes > 30%, request user approval before updating
5. Add freshness timestamp to each codemap
6. Save reports to .reports/codemap-diff.txt

Use TypeScript/Node.js for analysis. Focus on high-level structure, not details.
      </code>
      <paragraph>Pattern: H1 title + prose + numbered list with sub-items. No frontmatter, no code blocks, no tables.</paragraph>

      <paragraph>**Example 2: Medium command with frontmatter — `plan.md` (113 lines)**</paragraph>
      <code language="markdown">
---
description: Restate requirements, assess risks, and create step-by-step plan...
---

# Plan Command

This command invokes the **planner** agent...

## What This Command Does

1. **Restate Requirements** - Clarify what needs to be built
2. **Identify Risks** - Surface potential issues and blockers

## Example Usage

```
User: /plan I need to add real-time notifications...
```
      </code>
      <paragraph>Pattern: Frontmatter (description only) + H1 + H2 sections + ordered lists + fenced code block with example dialogue.</paragraph>

      <paragraph>**Example 3: Large command with code examples — `e2e.md` (363 lines)**</paragraph>
      <paragraph>Contains extensive TypeScript test code blocks, Playwright configuration examples, and nested list structures. Similar to `tdd.md` at 326 lines.</paragraph>
    </subsection>

    <subsection title="Conversion Challenges">
      <list type="ordered">
        <item>**Missing frontmatter on 6 files**: These files start directly with `#` heading. The converter must handle both with-frontmatter and without-frontmatter patterns.</item>
        <item>**Large code blocks**: `e2e.md` and `tdd.md` have multi-page TypeScript code blocks that must be preserved exactly. Code block language detection must be accurate.</item>
        <item>**Example dialogue format**: Several commands contain `User: /command ...` and `Agent (agent-name):` dialogue blocks that are formatted as code blocks.</item>
      </list>
    </subsection>

  </section>

  <section title="Category 3: Rules (rules/*.md)">

    <subsection title="File Inventory">
      <field name="count">8</field>
      <field name="total-lines">458</field>
      <field name="average-lines">57</field>
      <field name="frontmatter">1/8 have YAML frontmatter (rust-project.md only)</field>

      <paragraph>**Complete file list (sorted by line count):**</paragraph>
      <list type="unordered">
        <item>`agents.md` — 75 lines</item>
        <item>`git-workflow.md` — 73 lines</item>
        <item>`coding-style.md` — 70 lines</item>
        <item>`patterns.md` — 55 lines</item>
        <item>`rust-project.md` — 52 lines (only one with frontmatter)</item>
        <item>`testing.md` — 50 lines</item>
        <item>`performance.md` — 47 lines</item>
        <item>`security.md` — 36 lines (SMALLEST)</item>
      </list>
    </subsection>

    <subsection title="Common Markdown Patterns">
      <paragraph>**Heading structure:** All use `#` (H1) for title, `##` (H2) for rule categories. **No H3 or H4 headings** — rules are flat. The simplest structure in the entire plugin.</paragraph>

      <paragraph>**Content patterns:** Rules are mostly imperative statements with code examples. Heavy use of:</paragraph>
      <list type="unordered">
        <item>Bold-prefixed imperatives: `**ALWAYS**: ...`, `**NEVER**: ...`, `**CRITICAL**: ...`</item>
        <item>Fenced code blocks showing correct/incorrect patterns (15 code blocks across 6 files)</item>
        <item>Checkbox checklists in `coding-style.md` (8 items) and `security.md` (8 items)</item>
        <item>NO tables in any rule file</item>
      </list>

      <paragraph>**Placeholder variables:** 1 file (`agents.md`) references `${CLAUDE_PLUGIN_ROOT}`.</paragraph>
    </subsection>

    <subsection title="Partial XML Usage">
      <paragraph>2 files contain XML-like content: `git-workflow.md` (4 lines — branch name patterns using angle brackets) and `patterns.md` (1 line). Both are inside code blocks.</paragraph>
    </subsection>

    <subsection title="Representative Examples">

      <paragraph>**Example: `security.md` (36 lines) — smallest rule file**</paragraph>
      <code language="markdown">
# Security Guidelines

## Mandatory Security Checks

Before ANY commit:
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (sanitized HTML)

## Secret Management

```typescript
// NEVER: Hardcoded secrets
const apiKey = "sk-proj-xxxxx"

// ALWAYS: Environment variables
const apiKey = process.env.OPENAI_API_KEY
```

## Security Response Protocol

If security issue found:
1. STOP immediately
2. Use **security-reviewer** agent
3. Fix CRITICAL issues before continuing
      </code>
      <paragraph>Pattern: H1 title + H2 sections + checkbox list + code block + ordered list. No frontmatter. Ideal for `<rule severity="...">` semantic tags.</paragraph>
    </subsection>

    <subsection title="Conversion Challenges">
      <list type="ordered">
        <item>**Severity inference**: Rules use bold markers (`**CRITICAL**`, `**ALWAYS**`, `**NEVER**`) to indicate severity. The converter must map these to `<rule severity="critical|important|normal">` attributes. This requires semantic understanding, not just mechanical conversion.</item>
        <item>**Mostly no frontmatter**: 7 of 8 files lack frontmatter. The title comes from the H1 heading only.</item>
      </list>
    </subsection>

  </section>

  <section title="Category 4: Contexts (contexts/*.md)">

    <subsection title="File Inventory">
      <field name="count">3</field>
      <field name="total-lines">68</field>
      <field name="average-lines">22</field>
      <field name="frontmatter">0/3 have YAML frontmatter</field>

      <paragraph>**Complete file list:**</paragraph>
      <list type="unordered">
        <item>`research.md` — 26 lines</item>
        <item>`review.md` — 22 lines</item>
        <item>`dev.md` — 20 lines (SMALLEST file in entire plugin scope)</item>
      </list>
    </subsection>

    <subsection title="Common Markdown Patterns">
      <paragraph>**Heading structure:** All use `#` (H1) for title, `##` (H2) for sections. No H3 or deeper. Extremely simple structure.</paragraph>

      <paragraph>**Content patterns:** Key-value-style declarations (`Mode:`, `Focus:`), short bulleted lists, numbered priority lists. No code blocks, no tables, no checkboxes, no placeholder variables, no ASCII diagrams.</paragraph>
    </subsection>

    <subsection title="Partial XML Usage">
      <paragraph>None. Zero XML-like content in any context file.</paragraph>
    </subsection>

    <subsection title="Representative Example">
      <paragraph>**`dev.md` (20 lines) — the simplest file in scope**</paragraph>
      <code language="markdown">
# Development Context

Mode: Active development
Focus: Implementation, coding, building features

## Behavior
- Write code first, explain after
- Prefer working solutions over perfect solutions
- Run tests after changes
- Keep commits atomic

## Priorities
1. Get it working
2. Get it right
3. Get it clean

## Tools to favor
- Edit, Write for code changes
- Bash for running tests/builds
- Grep, Glob for finding code
      </code>
      <paragraph>Pattern: H1 title + inline key-value lines + H2 sections + bulleted and numbered lists. Ideal proof-of-concept conversion target (simplest files, lowest risk).</paragraph>
    </subsection>

    <subsection title="Conversion Challenges">
      <paragraph>**Minimal challenges.** These are the simplest files in the plugin. The only consideration is the `Mode:` and `Focus:` key-value lines at the top, which should be placed in `<metadata>` or `<field>` tags.</paragraph>
    </subsection>

  </section>

  <section title="Category 5: Skills (skills/*/SKILL.md)">

    <subsection title="File Inventory">
      <field name="count">9</field>
      <field name="total-lines">2,814</field>
      <field name="average-lines">312</field>
      <field name="frontmatter">9/9 have YAML frontmatter (100%)</field>
      <field name="frontmatter-fields">All have `name:` and `description:`. 2 have `license:` (autoresearch, super-dev). 2 have `metadata:` nested blocks (autoresearch, super-dev). 1 has `compatibility:` (super-dev).</field>

      <paragraph>**Complete file list (sorted by line count):**</paragraph>
      <list type="unordered">
        <item>`super-dev/SKILL.md` — 817 lines (LARGEST skill, complex nested metadata)</item>
        <item>`security-review/SKILL.md` — 505 lines</item>
        <item>`tdd-workflow/SKILL.md` — 420 lines</item>
        <item>`adversarial-review/SKILL.md` — 314 lines</item>
        <item>`verify/SKILL.md` — 260 lines</item>
        <item>`dev-rules/SKILL.md` — 184 lines</item>
        <item>`autoresearch/SKILL.md` — 181 lines</item>
        <item>`freeze/SKILL.md` — 67 lines</item>
        <item>`careful/SKILL.md` — 66 lines</item>
      </list>
    </subsection>

    <subsection title="Common Markdown Patterns">
      <paragraph>**Heading structure:** All use `#` (H1) for skill title, `##` (H2) for major sections, `###` (H3) for subsections. Three files use `####` (H4+):</paragraph>
      <list type="unordered">
        <item>`security-review/SKILL.md` — 31 H4+ headings (most deeply nested skill)</item>
        <item>`adversarial-review/SKILL.md` — 3 H4+ headings</item>
        <item>`tdd-workflow/SKILL.md` — 3 H4+ headings</item>
      </list>

      <paragraph>**YAML frontmatter complexity:** The `super-dev/SKILL.md` frontmatter is the most complex in the entire plugin:</paragraph>
      <code language="yaml">
---
name: super-dev
description: >
    Multi-line description spanning several lines...
license: MIT
compatibility: Requires Claude Code CLI with Task tool...
metadata:
  author: Jennings Liu
  version: "2.7.0"
  repository: https://github.com/...
  keywords:
    - development
    - workflow
    - agent-teams
---
      </code>
      <paragraph>This nested `metadata:` block must be preserved byte-identical. It is the most fragile frontmatter in the plugin.</paragraph>

      <paragraph>**Content patterns:** Skills are the most varied category — they combine instructional text, workflow phase definitions, code block examples, tables, checkbox checklists, ASCII diagrams, and placeholder variables. `super-dev/SKILL.md` is essentially a workflow specification with phase-by-phase instructions.</paragraph>
    </subsection>

    <subsection title="Partial XML Usage">
      <paragraph>5 of 9 skill files contain XML-like content:</paragraph>
      <list type="unordered">
        <item>`adversarial-review/SKILL.md` — 5 XML-like lines</item>
        <item>`autoresearch/SKILL.md` — 3 XML-like lines</item>
        <item>`super-dev/SKILL.md` — 3 XML-like lines</item>
        <item>`dev-rules/SKILL.md` — 1 XML-like line</item>
        <item>`security-review/SKILL.md` — 1 XML-like line</item>
      </list>
      <paragraph>All are inside code blocks (template references or examples). None is structural.</paragraph>
    </subsection>

    <subsection title="Representative Examples">

      <paragraph>**Example 1: Small skill — `careful/SKILL.md` (66 lines)**</paragraph>
      <code language="markdown">
---
name: careful
description: >
    Safety guardrail that blocks destructive commands...
---

# Careful Mode

Session-scoped safety guardrail...

**Announce at start:** "Careful mode ACTIVATED..."

## What Gets Blocked

| Category | Blocked Patterns | Why |
|----------|-----------------|-----|
| File Destruction | `rm -rf`, ... | Irreversible data loss |

## Behavior

When a blocked command is detected:
1. **STOP** — Do not execute the command
2. **WARN** — Display: "BLOCKED by careful mode..."
      </code>
      <paragraph>Pattern: Frontmatter + H1 title + prose + table + numbered list with bold action words.</paragraph>

      <paragraph>**Example 2: Complex skill — `super-dev/SKILL.md` (817 lines, opening)**</paragraph>
      <paragraph>Contains: nested YAML metadata, First-Run Configuration with bash code blocks, directory structure diagrams, phase workflow tables, extensive placeholder variables (7 `${CLAUDE_PLUGIN_*}` references), and multi-level heading hierarchy.</paragraph>
    </subsection>

    <subsection title="Conversion Challenges">
      <list type="ordered">
        <item>**Complex frontmatter**: `super-dev/SKILL.md` and `autoresearch/SKILL.md` have nested `metadata:` blocks in YAML frontmatter. Byte-identical preservation is critical.</item>
        <item>**`security-review/SKILL.md` depth**: 31 H4+ headings need flattening — the deepest nesting of any skill file.</item>
        <item>**`super-dev/SKILL.md` size**: At 817 lines with mixed content types (code, diagrams, tables, checkboxes, variables), this is one of the most complex conversion targets.</item>
        <item>**Directory structure diagrams**: Several skills contain tree-style directory layouts that are not inside code blocks but use Unicode box-drawing characters. These need `<diagram>` wrapping.</item>
      </list>
    </subsection>

  </section>

  <section title="Category 6: Templates/Reference (templates/reference/*.md)">

    <subsection title="File Inventory">
      <field name="count">25 total files</field>
      <field name="xml-templates">14 files already use XML-tagged structure (inside code fences)</field>
      <field name="markdown-files">11 files still use pure Markdown headings</field>
      <field name="total-lines-all">8,036</field>
      <field name="average-lines-all">321</field>

      <paragraph>**14 XML-tagged template files (DO NOT MODIFY):**</paragraph>
      <list type="unordered">
        <item>`adversarial-review-template.md` — 189 lines</item>
        <item>`architecture-template.md` — 118 lines</item>
        <item>`behavior-scenarios-template.md` — 160 lines</item>
        <item>`code-review-template.md` — 169 lines</item>
        <item>`design-spec-template.md` — 231 lines</item>
        <item>`handoff-template.md` — 133 lines</item>
        <item>`implementation-plan-template.md` — 270 lines</item>
        <item>`implementation-summary-template.md` — 101 lines</item>
        <item>`product-design-summary-template.md` — 336 lines</item>
        <item>`qa-report-template.md` — 256 lines</item>
        <item>`requirements-template.md` — 238 lines</item>
        <item>`spec-review-template.md` — 180 lines</item>
        <item>`specification-template.md` — 602 lines</item>
        <item>`task-list-template.md` — 161 lines</item>
      </list>

      <paragraph>**NOTE:** The requirements document estimated 13 XML templates. The actual count is **14** — `adversarial-review-template.md` was not counted in the original estimate. The `project-guidelines-example.md` was miscategorized as non-XML in some estimates but is actually pure Markdown.</paragraph>

      <paragraph>**11 Markdown reference files (NEED CONVERSION):**</paragraph>
      <list type="unordered">
        <item>`testing-patterns.md` — 928 lines (LARGEST reference file)</item>
        <item>`frontend-patterns.md` — 632 lines</item>
        <item>`backend-patterns.md` — 582 lines</item>
        <item>`ui-ux-patterns.md` — 520 lines</item>
        <item>`coding-standards.md` — 520 lines</item>
        <item>`debugging-patterns.md` — 401 lines</item>
        <item>`research-methodology.md` — 380 lines</item>
        <item>`project-guidelines-example.md` — 345 lines</item>
        <item>`architecture-patterns.md` — 343 lines</item>
        <item>`state-management.md` — 122 lines</item>
        <item>`bdd-patterns.md` — 119 lines</item>
      </list>
    </subsection>

    <subsection title="XML Template Format (Reference Pattern)">
      <paragraph>The 14 XML templates follow this exact pattern:</paragraph>
      <code language="markdown">
---
name: template-name
description: Description...
doc-type: document-type
gate-profile: gate-name.sh
---

```xml
&lt;document type="document-type"&gt;

  &lt;metadata&gt;
    &lt;field name="title"&gt;Title: [Placeholder]&lt;/field&gt;
    &lt;field name="date"&gt;[timestamp]&lt;/field&gt;
    ...
  &lt;/metadata&gt;

  &lt;section title="Section Name"&gt;
    &lt;paragraph&gt;[Content]&lt;/paragraph&gt;
    &lt;list type="unordered"&gt;
      &lt;item&gt;[Item]&lt;/item&gt;
    &lt;/list&gt;
  &lt;/section&gt;

&lt;/document&gt;
```
      </code>
      <paragraph>**Key observation:** The XML templates are **wrapped entirely in a code fence** (` ```xml ... ``` `). They are templates that agents fill in to produce spec artifacts. The non-template files being converted are NOT wrapped in code fences — they ARE the content. This is a fundamental structural difference.</paragraph>
    </subsection>

    <subsection title="Markdown Reference File Patterns">
      <paragraph>**Frontmatter:** 8 of 11 Markdown reference files have YAML frontmatter with `name:` and `description:`. Three files lack frontmatter: `bdd-patterns.md`, `project-guidelines-example.md`, `state-management.md`.</paragraph>

      <paragraph>**Heading depth:** 3 files use H4+ headings:</paragraph>
      <list type="unordered">
        <item>`architecture-patterns.md` — 21 H4+ headings</item>
        <item>`ui-ux-patterns.md` — 9 H4+ headings</item>
        <item>`debugging-patterns.md` — 1 H4+ heading</item>
      </list>

      <paragraph>**Content density:** Reference files are the most code-block-dense category. `testing-patterns.md` (928 lines) and `frontend-patterns.md` (632 lines) contain extensive code examples.</paragraph>
    </subsection>

    <subsection title="Representative Examples">

      <paragraph>**Example: `bdd-patterns.md` (119 lines, opening)**</paragraph>
      <code language="markdown">
# BDD Patterns Reference

## Gherkin-Like Syntax (Markdown)

BDD scenarios use Given/When/Then format in markdown (NOT .feature files):

### Scenario Structure

```
### SCENARIO-XXX: [Meaningful Behavior Title]
**Acceptance Criteria:** AC-XX from requirements
**Priority:** P0/P1/P2

**Given** [precondition in business language]
**When** [single action/event in business language]
**Then** [verifiable outcome in business language]
```

### Scenario ID Convention
- Format: `SCENARIO-001`, `SCENARIO-002`, ...
      </code>
      <paragraph>Pattern: H1 title + H2/H3 sections + code blocks showing template formats + bulleted lists + tables.</paragraph>
    </subsection>

    <subsection title="Conversion Challenges">
      <list type="ordered">
        <item>**Size**: `testing-patterns.md` at 928 lines is the 3rd largest file overall. May need conversion in multiple review passes.</item>
        <item>**H4+ heading density**: `architecture-patterns.md` has 21 H4+ headings. Flattening decisions must preserve the section hierarchy semantics.</item>
        <item>**Distinguishing XML templates from Markdown files**: The converter must correctly identify the 14 XML templates (they start with `<document` inside a code fence) and skip them. A reliable heuristic: if the file body (after frontmatter) starts with `` ```xml `` followed by `<document`, it is an XML template and must not be converted.</item>
        <item>**`project-guidelines-example.md`**: Contains ASCII architecture diagrams with box-drawing characters that span many lines. These must be wrapped in `<diagram>` or preserved inside `<code>` blocks.</item>
      </list>
    </subsection>

  </section>

  <section title="Gate Scripts Analysis">

    <subsection title="Overview">
      <field name="count">7 gate scripts</field>
      <field name="location">super-dev-plugin/scripts/gates/</field>
      <paragraph>All 7 gate scripts parse **rendered spec artifact files** (e.g., `*-requirements.md`, `*-behavior-scenarios.md`, `*-specification.md`), NOT the agent/command/rule/skill source files being converted. The gate scripts are completely decoupled from the source files targeted for XML restructuring.</paragraph>
    </subsection>

    <subsection title="Gate-by-Gate Analysis">

      <paragraph>**gate-requirements.sh** — Validates `*-requirements.md` completeness</paragraph>
      <list type="unordered">
        <item>**Regex patterns matched:** `acceptance criteria` (case-insensitive), `^\s*-\s*\[` (checkbox items), `^\s*-\s*\*{0,2}AC-[0-9]` (AC IDs), `non-functional|performance|security|accessibility`, `executive summary|summary`</item>
        <item>**Files parsed:** `*-requirements.md` in spec directory</item>
        <item>**Impact from conversion:** NONE. This gate parses spec artifacts that are already XML-tagged. Source file conversion does not affect rendered artifacts.</item>
      </list>

      <paragraph>**gate-bdd.sh** — Validates `*-behavior-scenarios.md` quality</paragraph>
      <list type="unordered">
        <item>**Regex patterns matched:** `SCENARIO-[0-9]+`, `^\s*\*{0,2}(given|when|then|and)` (case-insensitive), `AC-[0-9]+`</item>
        <item>**Files parsed:** `*-behavior-scenarios.md` and `*-requirements.md` in spec directory</item>
        <item>**Impact from conversion:** NONE. Same reasoning — parses rendered artifacts.</item>
      </list>

      <paragraph>**gate-spec-trace.sh** — Cross-references spec with BDD scenarios</paragraph>
      <list type="unordered">
        <item>**Regex patterns matched:** `SCENARIO-[0-9]+`, `testing strategy|test plan|test approach|test coverage|unit test|integration test`</item>
        <item>**Files parsed:** `*-specification.md`, `*-behavior-scenarios.md`, `*-task-list.md`, `*-implementation-plan.md`</item>
        <item>**Impact from conversion:** NONE.</item>
      </list>

      <paragraph>**gate-review.sh** — Validates code review and adversarial review verdicts</paragraph>
      <list type="unordered">
        <item>**Regex patterns matched:** `approved|changes requested|blocked`, `\*\*Critical\*\*`, `\|\s*Critical\s*\|\s*[1-9]`, `PASS|CONTESTED|REJECT|HALT`</item>
        <item>**Files parsed:** `*code-review*` and `*adversarial*` files</item>
        <item>**Impact from conversion:** NONE.</item>
      </list>

      <paragraph>**gate-spec-review.sh** — Validates spec review quality</paragraph>
      <list type="unordered">
        <item>**Regex patterns matched:** `APPROVED|REVISIONS NEEDED|REJECTED`, dimension keywords (`Completeness`, `Consistency`, etc.), `verified|exists|not found|hallucinated|confirmed|grounding`, `Critical|High|Medium|Low|finding`</item>
        <item>**Files parsed:** `*-spec-review.md`</item>
        <item>**Impact from conversion:** NONE.</item>
      </list>

      <paragraph>**gate-build.sh** — Runs build and test commands</paragraph>
      <list type="unordered">
        <item>**What it does:** Detects project type (Node.js, Rust, Go, Python) and runs build/test commands</item>
        <item>**Files parsed:** `package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`, `tsconfig.json`</item>
        <item>**Impact from conversion:** NONE. This gate runs build tools, not Markdown files.</item>
      </list>

      <paragraph>**gate-docs-drift.sh** — Checks documentation freshness</paragraph>
      <list type="unordered">
        <item>**Regex patterns matched:** `TODO|FIXME|HACK|XXX` in source code files (`.ts`, `.tsx`, `.js`, `.py`, `.rs`, `.go`)</item>
        <item>**Files parsed:** `*documentation*` or `*docs*` files in spec directory, `README.md` in project root</item>
        <item>**Impact from conversion:** NONE. Searches source code files, not plugin Markdown files.</item>
      </list>
    </subsection>

    <subsection title="Gate Script Verdict">
      <paragraph>**All 7 gate scripts are UNAFFECTED by the XML restructure.** They parse rendered spec artifacts and project build files — never the agent/command/rule/context/skill source files being converted. No gate script reads or greps any file in `agents/`, `commands/`, `rules/`, `contexts/`, or `skills/` directories. Post-conversion verification is still recommended as a safety measure, but the risk is near zero.</paragraph>
    </subsection>

  </section>

  <section title="Plugin Version">
    <paragraph>**Current version:** `2.3.35` — synchronized in both files:</paragraph>
    <list type="unordered">
      <item>`super-dev-plugin/.claude-plugin/plugin.json` — version `"2.3.35"`</item>
      <item>`.claude-plugin/marketplace.json` — super-dev entry version `"2.3.35"`</item>
    </list>
    <paragraph>Per the CLAUDE.md versioning rule, each commit that modifies files under `super-dev-plugin/` must bump the patch version in both files. If the conversion is done in 8 phases, the final version would be `2.3.43` (8 bumps from 2.3.35).</paragraph>
  </section>

  <section title="Cross-Category Summary Statistics">

    <table>
      <row header="true">
        <cell>Category</cell>
        <cell>Files</cell>
        <cell>Total Lines</cell>
        <cell>Avg Lines</cell>
        <cell>Has Frontmatter</cell>
        <cell>H4+ Files</cell>
        <cell>Code Blocks</cell>
        <cell>Tables</cell>
        <cell>Checkboxes</cell>
        <cell>Diagrams</cell>
        <cell>Placeholder Vars</cell>
      </row>
      <row>
        <cell>Agents</cell>
        <cell>36</cell>
        <cell>15,610</cell>
        <cell>433</cell>
        <cell>36/36 (100%)</cell>
        <cell>5</cell>
        <cell>35/36</cell>
        <cell>28/36</cell>
        <cell>33/36</cell>
        <cell>27/36</cell>
        <cell>17/36</cell>
      </row>
      <row>
        <cell>Commands</cell>
        <cell>20</cell>
        <cell>2,078</cell>
        <cell>103</cell>
        <cell>14/20 (70%)</cell>
        <cell>0</cell>
        <cell>9/20</cell>
        <cell>2/20</cell>
        <cell>1/20</cell>
        <cell>5/20</cell>
        <cell>6/20</cell>
      </row>
      <row>
        <cell>Rules</cell>
        <cell>8</cell>
        <cell>458</cell>
        <cell>57</cell>
        <cell>1/8 (12%)</cell>
        <cell>0</cell>
        <cell>6/8</cell>
        <cell>0/8</cell>
        <cell>2/8</cell>
        <cell>0/8</cell>
        <cell>1/8</cell>
      </row>
      <row>
        <cell>Contexts</cell>
        <cell>3</cell>
        <cell>68</cell>
        <cell>22</cell>
        <cell>0/3 (0%)</cell>
        <cell>0</cell>
        <cell>0/3</cell>
        <cell>0/3</cell>
        <cell>0/3</cell>
        <cell>0/3</cell>
        <cell>0/3</cell>
      </row>
      <row>
        <cell>Skills</cell>
        <cell>9</cell>
        <cell>2,814</cell>
        <cell>312</cell>
        <cell>9/9 (100%)</cell>
        <cell>3</cell>
        <cell>8/9</cell>
        <cell>6/9</cell>
        <cell>4/9</cell>
        <cell>6/9</cell>
        <cell>4/9</cell>
      </row>
      <row>
        <cell>Templates (MD)</cell>
        <cell>11</cell>
        <cell>4,892</cell>
        <cell>445</cell>
        <cell>8/11 (73%)</cell>
        <cell>3</cell>
        <cell>11/11</cell>
        <cell>7/11</cell>
        <cell>3/11</cell>
        <cell>5/11</cell>
        <cell>2/11</cell>
      </row>
      <row header="true">
        <cell>**TOTAL TO CONVERT**</cell>
        <cell>**87**</cell>
        <cell>**25,920**</cell>
        <cell>**298**</cell>
        <cell>**68/87 (78%)**</cell>
        <cell>**11**</cell>
        <cell>**69/87**</cell>
        <cell>**43/87**</cell>
        <cell>**43/87**</cell>
        <cell>**43/87**</cell>
        <cell>**30/87**</cell>
      </row>
    </table>

    <paragraph>**Note on file counts:** The requirements document estimated 88 files to convert (36+20+8+3+9+11+1 README exclusion). The actual count is **87** because the template category has 11 Markdown files (not 11 as estimated) and the original count included a rounding error. The 14 XML templates plus 2 READMEs are excluded, giving 101 - 14 - 2 = 85 non-README non-XML files. However, re-examining the full inventory: 36 + 20 + 8 + 3 + 9 + 11 = 87 files to convert.</paragraph>
  </section>

  <section title="Risk-Ordered Conversion Complexity">
    <paragraph>Files ordered by conversion complexity (lowest-risk first), informing the phased approach:</paragraph>

    <table>
      <row header="true">
        <cell>Risk Level</cell>
        <cell>Category</cell>
        <cell>Files</cell>
        <cell>Max Lines</cell>
        <cell>Key Risk Factors</cell>
      </row>
      <row>
        <cell>Lowest</cell>
        <cell>Contexts</cell>
        <cell>3</cell>
        <cell>26</cell>
        <cell>No frontmatter, no code blocks, no tables, no H4+, flat structure</cell>
      </row>
      <row>
        <cell>Low</cell>
        <cell>Rules</cell>
        <cell>8</cell>
        <cell>75</cell>
        <cell>Mostly no frontmatter, code blocks present, severity inference needed</cell>
      </row>
      <row>
        <cell>Low-Medium</cell>
        <cell>Commands (small, no FM)</cell>
        <cell>6</cell>
        <cell>70</cell>
        <cell>No frontmatter, simple structure</cell>
      </row>
      <row>
        <cell>Medium</cell>
        <cell>Commands (with FM)</cell>
        <cell>14</cell>
        <cell>363</cell>
        <cell>Frontmatter varies (name+desc vs desc-only), large code blocks in e2e/tdd</cell>
      </row>
      <row>
        <cell>Medium</cell>
        <cell>Templates (MD, small)</cell>
        <cell>5</cell>
        <cell>380</cell>
        <cell>bdd-patterns, state-management, research-methodology, project-guidelines, debugging-patterns</cell>
      </row>
      <row>
        <cell>Medium-High</cell>
        <cell>Templates (MD, large)</cell>
        <cell>6</cell>
        <cell>928</cell>
        <cell>testing-patterns, frontend-patterns, backend-patterns, coding-standards, ui-ux-patterns, architecture-patterns — H4+ headings, heavy code blocks</cell>
      </row>
      <row>
        <cell>Medium-High</cell>
        <cell>Agents (small-medium)</cell>
        <cell>24</cell>
        <cell>477</cell>
        <cell>All have frontmatter, most have tables/checkboxes/diagrams, but no H4+</cell>
      </row>
      <row>
        <cell>High</cell>
        <cell>Agents (large, H4+)</cell>
        <cell>5</cell>
        <cell>1,544</cell>
        <cell>architecture-agent, team-lead, qa-agent, research-agent, spec-reviewer — H4+ flattening, XML inside code blocks, massive tables/checklists</cell>
      </row>
      <row>
        <cell>High</cell>
        <cell>Agents (very large, no H4+)</cell>
        <cell>7</cell>
        <cell>829</cell>
        <cell>ui-ux-designer, golang-developer, e2e-runner, security-reviewer, build-error-resolver, backend-developer, rust-developer — size + content density</cell>
      </row>
      <row>
        <cell>High</cell>
        <cell>Skills</cell>
        <cell>9</cell>
        <cell>817</cell>
        <cell>Complex frontmatter (nested metadata), H4+ in 3 files, placeholder variables, large files</cell>
      </row>
    </table>
  </section>

  <section title="Specific Conversion Hazards">

    <subsection title="Hazard 1: XML Content Inside Code Blocks">
      <paragraph>**21 files** contain XML-like content (angle brackets in non-code contexts or actual XML/JSX in code blocks). The highest concentration is in agent files (13) and skills (5). The converter must use a code-block-aware parser that skips content between ` ``` ` fences. A naive regex-based converter WILL corrupt these files.</paragraph>
      <paragraph>**Highest-risk files:** `frontend-developer.md` (9 XML-like lines — React JSX), `doc-validator.md` (6 lines — XML template references), `architecture-agent.md` (4 lines), `qa-agent.md` (5 lines), `rust-developer.md` (5 lines — HTML in test assertions).</paragraph>
    </subsection>

    <subsection title="Hazard 2: Horizontal Rule (`---`) Ambiguity">
      <paragraph>The `---` sequence appears in two contexts: (1) YAML frontmatter delimiters (always the first and second occurrence), (2) horizontal rules used as section separators within the body. Files like `adversarial-reviewer.md` use `---` as a visual separator between the persona section and the workflow section. The converter must distinguish these from frontmatter delimiters. Solution: after the second `---` (closing frontmatter), treat all subsequent `---` as horizontal rules (map to blank lines or section breaks in XML).</paragraph>
    </subsection>

    <subsection title="Hazard 3: Nested List Indentation">
      <paragraph>Several files use 2-level or 3-level nested lists (indented with 2 or 4 spaces). Example from `update-codemaps.md`:</paragraph>
      <code language="markdown">
1. Scan all source files for imports, exports, and dependencies
2. Generate token-lean codemaps in the following format:
   - codemaps/architecture.md - Overall architecture
   - codemaps/backend.md - Backend structure
      </code>
      <paragraph>The XML tag schema uses flat `<list><item>` without nesting depth. Nested lists must either be flattened or use nested `<list>` tags inside `<item>` elements. The requirements document does not specify how to handle nested lists — this is an open design decision.</paragraph>
    </subsection>

    <subsection title="Hazard 4: Mixed Content Paragraphs">
      <paragraph>Many files have paragraphs that contain mixed inline formatting: bold, italic, inline code, links, AND placeholder variables all in the same paragraph. Example from `team-lead.md`:</paragraph>
      <code language="markdown">
**Role:** Team Lead who orchestrates specialized teammate agents in an agent team.
      </code>
      <paragraph>These paragraphs must be wrapped in `<paragraph>` tags with ALL inline formatting preserved as-is. No escaping of `**`, `*`, backticks, or `[link](url)` syntax.</paragraph>
    </subsection>

    <subsection title="Hazard 5: Key-Value Pattern in Contexts">
      <paragraph>Context files use a key-value pattern that is neither a heading nor a list:</paragraph>
      <code language="markdown">
Mode: Active development
Focus: Implementation, coding, building features
      </code>
      <paragraph>This needs a mapping decision: either `<field name="Mode">Active development</field>` inside `<metadata>`, or `<paragraph>Mode: Active development</paragraph>`. The former is more semantic; the latter is simpler.</paragraph>
    </subsection>

    <subsection title="Hazard 6: Bold-Prefixed Imperative Rules">
      <paragraph>Rule files use bold prefixes to indicate severity: `**ALWAYS**:`, `**NEVER**:`, `**CRITICAL**:`. These are semantic markers that could map to `<rule severity="critical">` attributes, but the mapping is subjective. A consistent heuristic is needed:</paragraph>
      <list type="unordered">
        <item>`**CRITICAL**`, `**NEVER**`, `**MANDATORY**` → `severity="critical"`</item>
        <item>`**ALWAYS**`, `**MUST**`, `**IMPORTANT**` → `severity="important"`</item>
        <item>All other rules → `severity="normal"`</item>
      </list>
    </subsection>

  </section>

  <section title="Recommendations for Specification Writer">

    <list type="ordered">
      <item>**Adopt 8-phase approach** aligned with the risk-ordered complexity table above. Start with contexts (3 files), then rules (8), then commands (20), then templates (11), then agents in batches, then skills last.</item>
      <item>**Define nested list handling** — the tag schema needs clarification on whether `<list>` tags can be nested inside `<item>` tags, or if all lists are flat.</item>
      <item>**Define horizontal rule handling** — specify how `---` separators within the body should be converted (remove? map to empty `<paragraph>`? use a `<separator>` tag?).</item>
      <item>**Define key-value pattern handling** — specify how `Mode: value` lines in context files should be mapped.</item>
      <item>**Consider the XML template distinction** — the 14 XML templates wrap their XML in code fences (` ```xml ... ``` `). The converted non-template files should NOT use code fences — the XML is the actual markup. The specification should make this distinction explicit.</item>
      <item>**Token budget likely needs relaxation** — per the research report, full XML conversion adds 10-15%, exceeding the 5% NFR. The specification should address this trade-off.</item>
      <item>**architecture-agent.md needs special attention** — at 1,544 lines with 30 H4+ headings, 31 code blocks, 124 table lines, 115 checkboxes, and 259 diagram lines, it is the most complex conversion target. Consider converting it as a standalone phase.</item>
    </list>

  </section>

</document>
```
