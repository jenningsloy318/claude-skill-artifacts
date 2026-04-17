---
name: debug-analysis
description: Perform systematic root cause analysis for bugs and errors
---

<purpose>Activate the debug-analyzer agent for systematic root cause analysis with evidence collection, pattern search, and reproducible steps.</purpose>

<usage>/super-dev:debug-analysis [bug description or error details]</usage>

<process name="Analysis Process">
  Evidence Collection: Parse error messages and stack traces, identify affected components, collect logs. Pattern Search: Search for similar error patterns (grep/ast-grep), find related code, identify recent changes. Root Cause Analysis: Trace execution flow, identify failure points, analyze data flow, check edge cases. Reproduction: Document exact steps, note required conditions, create test scenarios.
</process>

<arguments>
  Error messages or stack traces, description of unexpected behavior, steps already attempted, context about when the issue occurs.
</arguments>

<output>
  <format>Debug analysis report (`[doc-index]-debug-analysis.md`) with: issue summary, evidence, root cause analysis, reproduction steps, proposed solutions, related findings.</format>
</output>

<constraints>
  <constraint>Only used for bugs and errors (skip for new features)</constraint>
  <constraint>Requires clear error description or logs</constraint>
  <constraint>Produces actionable fix recommendations</constraint>
</constraints>
