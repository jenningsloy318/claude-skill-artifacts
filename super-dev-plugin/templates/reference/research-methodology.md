<meta>
  <name>research-methodology</name>
  <type>template</type>
  <description>Comprehensive research methodology for software development including multi-source search, version awareness, option presentation, and synthesis techniques</description>
</meta>

<purpose>Reference for systematic research before software implementation during Phase 3 (Research) of the super-dev workflow. Covers search tools, version awareness, option presentation format, and research output structure.</purpose>

<principles>
  <principle name="Multi-Source Research">Search across code, documentation, academic papers, and community resources for comprehensive understanding</principle>
  <principle name="Pattern Extraction">Identify established patterns and anti-patterns from multiple sources</principle>
  <principle name="Version Awareness">Always research for the latest stable versions; avoid outdated information</principle>
  <principle name="Synthesis">Compile findings into actionable recommendations with clear options and trade-offs</principle>
</principles>

<process>
  <step n="1" name="Establish Context">Get current timestamp via Time MCP for year context. Note the technology stack from requirements. Identify key topics needing research. Plan search queries WITH year context for recency.</step>
  <step n="2" name="Research Areas">Cover systematically: Best Practices and Design Patterns (established patterns, anti-patterns, recommended architectures, industry standards), Official Documentation (API references, framework docs, language guidelines, configuration options), Community Knowledge (blog posts, Stack Overflow, GitHub issues, conference talks), Performance and Edge Cases (benchmarks, known limitations, edge cases, security considerations).</step>
  <step n="3" name="Execute Searches">Step 3a — Firecrawl MCP (MANDATORY first): Run `firecrawl_search` then scrape top results and extract patterns. Step 3b — Structured tools (supplementary): Use search-agent with modes: `code` (implementation patterns), `docs` (official documentation), `academic` (research papers), `web` (blog posts, tutorials), `all` (comprehensive).</step>
  <step n="4" name="Version Awareness">Check current year. Look for latest stable versions. Note breaking changes in recent versions. Avoid outdated patterns/APIs. Verify deprecation status. Apply recency scoring: less than 6 months (+2 Fresh), 6-12 months (+1 Current), 1-2 years (0 Dated), over 2 years (-1 Potentially Outdated). Flag sources mentioning "deprecated", "legacy", "old version", "no longer recommended", "superseded by".</step>
  <step n="5" name="Synthesize Findings">Compile all findings into structured recommendations. Prioritize by relevance and authority. Cross-reference multiple sources. Identify consensus patterns. Note disagreements or alternatives.</step>
</process>

<tools name="Search Tools">
  Firecrawl MCP (MANDATORY — run first): Run before any other search. No source limits. Use `firecrawl_search` for discovery, `firecrawl_scrape` for content extraction, `firecrawl_extract` for structured data.

  Exa (Web and Code Search — Supplementary): Web search via `${CLAUDE_PLUGIN_ROOT}/scripts/exa/exa_search.sh`, code context search via `${CLAUDE_PLUGIN_ROOT}/scripts/exa/exa_code.sh`.

  DeepWiki (GitHub Repo Documentation): Get repo docs structure via `${CLAUDE_PLUGIN_ROOT}/scripts/deepwiki/deepwiki_structure.sh`, contents via `${CLAUDE_PLUGIN_ROOT}/scripts/deepwiki/deepwiki_contents.sh`, ask questions via `${CLAUDE_PLUGIN_ROOT}/scripts/deepwiki/deepwiki_ask.sh`.

  Context7 (Library Documentation): Resolve library ID via `${CLAUDE_PLUGIN_ROOT}/scripts/context7/context7_resolve.sh`, get docs via `${CLAUDE_PLUGIN_ROOT}/scripts/context7/context7_docs.sh`.

  GitHub (Code and Repo Search): Search code via `${CLAUDE_PLUGIN_ROOT}/scripts/github/github_search_code.sh`, search repos via `${CLAUDE_PLUGIN_ROOT}/scripts/github/github_search_repos.sh`, get file contents via `${CLAUDE_PLUGIN_ROOT}/scripts/github/github_file_contents.sh`.
</tools>

<process name="Time MCP Integration">
  Before ANY research, get current timestamp via `mcp__time-mcp__current_time`. Enhance all queries with year context (e.g., "React hooks best practices 2025"). Apply recency scoring to all sources.
</process>

<process name="Option Presentation">
  CRITICAL: Always present 3-5 options with detailed comparisons for decision points.

  Always present options for: Technology/library selection, framework choices, architecture patterns, implementation approaches, design decisions, tool selection, API/client library choices.

  Single answer only when: Looking up specific API documentation, finding exact configuration values, retrieving specific error messages, user explicitly requests single answer.

  Each option must include: description (1-2 sentences), strengths with source citations, weaknesses with source citations, best-for use cases, and source links. Include a comparison matrix scoring Learning Curve, Community Size, Performance, Maturity, Documentation Quality, and Maintenance Activity. End with a recommendation, rationale, trade-offs, and alternative suggestion.
</process>

<criteria name="Evaluation Criteria">
  When comparing options, score on: Learning Curve (High weight), Community Size (High), Performance (High), Maturity (High), Documentation Quality (High), Maintenance Activity (High). Scoring rubric: 5 Excellent, 4 Good, 3 Acceptable, 2 Fair, 1 Poor, 0 Unacceptable.
</criteria>

<constraints>
  <constraint>Firecrawl MCP MUST be run first before any other search tool</constraint>
  <constraint>Always include year in search queries for recency</constraint>
  <constraint>Cross-reference multiple sources; never trust single sources</constraint>
  <constraint>Present 3-5 options for all decision points</constraint>
  <constraint>Cite all sources with URLs</constraint>
  <constraint>Flag any deprecated technologies or patterns found</constraint>
  <constraint>Do not use information older than 2 years without verification</constraint>
</constraints>

<anti-patterns>
  <anti-pattern>Skipping Firecrawl MCP and going straight to supplementary tools</anti-pattern>
  <anti-pattern>Limiting source types instead of searching all categories</anti-pattern>
  <anti-pattern>Trusting single sources without cross-referencing</anti-pattern>
  <anti-pattern>Making decisions without presenting option comparisons</anti-pattern>
  <anti-pattern>Assuming blog posts are authoritative without verification</anti-pattern>
</anti-patterns>

<references>
  <ref>Extracted from `super-dev:research-agent`. For full agent behavior during Phase 3, invoke with subagent_type "super-dev:research-agent".</ref>
</references>
