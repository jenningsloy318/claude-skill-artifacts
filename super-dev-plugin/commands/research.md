---
name: super-dev:research
description: Conduct comprehensive research on best practices, patterns, and documentation
---

# Phase 3: Research

Research best practices, documentation, and patterns with Time MCP integration for recency awareness.

## Usage

```
/super-dev:research [research topic]
```

## What This Command Does

When invoked, this command activates the `super-dev:research-agent` to:

1. **Gets current timestamp**: Uses Time MCP for year context
2. **Firecrawl MCP (MANDATORY first)**: `firecrawl_search` → `firecrawl_scrape` → `firecrawl_extract` across all online sources
3. **Supplementary search**: Exa, DeepWiki, Context7, GitHub scripts for targeted gaps
4. **Focuses on industry standards**: Prioritizes latest best practices and production-proven patterns
5. **Checks for deprecations**: Identifies outdated patterns
6. **Creates research report**: Documents findings with freshness scores

## Research Areas

### Best Practices & Design Patterns
- Established patterns for the feature/fix type
- Anti-patterns to avoid
- Recommended architectures
- Industry standards

### Official Documentation
- API references for libraries/frameworks
- Configuration options
- Language-specific guidelines

### Community Knowledge
- Blog posts and tutorials
- Stack Overflow discussions
- GitHub issues and discussions
- Conference talks and videos

### Performance & Edge Cases
- Performance benchmarks
- Known limitations
- Security considerations
- Edge cases to handle

## Time MCP Integration

- Gets current timestamp before research
- Adds year context to queries (e.g., "2024 2025")
- Filters results by recency
- Flags potentially outdated information
- Computes freshness scores for sources

## Arguments

`$ARGUMENTS` contains the topic or technology to research.

## Output

Creates `[doc-index]-research-report.md` with:
- Summary of findings
- Deprecation warnings
- Best practices and anti-patterns
- Official documentation references
- Community insights
- Performance considerations
- Source freshness analysis

## Examples

```
/super-dev:research React hooks best practices
/super-dev:research Rust async programming patterns
/super-dev:research GraphQL schema design
```

## Notes

- Firecrawl MCP first, then supplementary scripts
- No source limits; focus on latest industry standards
- Emphasizes recent sources (last 6-12 months)
- Flags deprecated patterns