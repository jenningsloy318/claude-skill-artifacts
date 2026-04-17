<meta>
  <name>research</name>
  <type>command</type>
  <description>Conduct comprehensive research on best practices, patterns, and documentation</description>
</meta>

<purpose>Activate the research-agent to research best practices, documentation, and patterns with Time MCP integration for recency awareness. Firecrawl MCP first, then supplementary search tools.</purpose>

<usage>/super-dev:research [research topic]</usage>

<topic name="Research Areas">
  Best Practices and Design Patterns: Established patterns, anti-patterns, recommended architectures, industry standards. Official Documentation: API references, configuration options, language-specific guidelines. Community Knowledge: Blog posts, tutorials, Stack Overflow, GitHub issues, conference talks. Performance and Edge Cases: Benchmarks, known limitations, security considerations.
</topic>

<output>
  <format>Research report (`[doc-index]-research-report.md`) with: summary, deprecation warnings, best practices and anti-patterns, official docs, community insights, performance considerations, source freshness analysis.</format>
</output>

<constraints>
  <constraint>Firecrawl MCP first, then supplementary scripts</constraint>
  <constraint>No source limits; focus on latest industry standards</constraint>
  <constraint>Emphasizes recent sources (last 6-12 months)</constraint>
  <constraint>Flags deprecated patterns</constraint>
</constraints>
