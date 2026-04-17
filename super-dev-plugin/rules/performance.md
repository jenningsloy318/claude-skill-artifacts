<meta>
  <name>performance</name>
  <type>rule</type>
  <description>Performance optimization rules for model selection, context management, and build troubleshooting</description>
</meta>

<purpose>Guide performance optimization through model selection strategy, context window management, and build troubleshooting escalation.</purpose>

<directives>
  <directive severity="high">**Haiku 4.5** (90% of Sonnet, 3x savings): Use for lightweight agents, pair programming, worker agents in multi-agent systems</directive>
  <directive severity="high">**Sonnet 4.5** (best coding model): Use for main development work, orchestrating workflows, complex coding tasks</directive>
  <directive severity="high">**Opus 4.5** (deepest reasoning): Use for complex architecture decisions, maximum reasoning, research and analysis</directive>
  <directive severity="medium">Avoid last 20% of context window for large-scale refactoring, multi-file features, and debugging complex interactions</directive>
  <directive severity="medium">Lower context sensitivity tasks (single-file edits, utility creation, docs, simple bugs) are safe at any context level</directive>
  <directive severity="medium">For complex tasks: use `ultrathink` for enhanced thinking, enable Plan Mode, use split role sub-agents for diverse analysis</directive>
  <directive severity="medium">If build fails: use **build-error-resolver** agent, analyze errors, fix incrementally, verify after each fix</directive>
</directives>
