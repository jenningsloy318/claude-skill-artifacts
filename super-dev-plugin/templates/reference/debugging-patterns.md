<meta>
  <name>debugging-patterns</name>
  <type>template</type>
  <description>Systematic debugging methodology, evidence collection, root cause analysis, and bug investigation techniques</description>
</meta>

<purpose>Reference for systematic root cause analysis and bug investigation during Stage 5 (Debug Analysis) of the super-dev workflow.</purpose>

<principles>
  <principle name="First Principles Analysis">Break down bugs to fundamental truths — what actually happens vs. what should happen — then build understanding from there</principle>
  <principle name="Evidence-Based Reasoning">Form hypotheses from concrete evidence, not assumptions; verify each with supporting/contradicting data</principle>
  <principle name="Systematic Investigation">Follow structured process — gather evidence, reproduce, trace execution, verify root cause — never skip steps</principle>
  <principle name="Minimal Reproduction">Reduce complex issues to minimal reproducible cases for faster root cause identification</principle>
</principles>

<process>
  <step n="1" name="Gather Evidence">Collect all available information before forming hypotheses. Error Information: exact error messages, stack traces, error codes. Logs: console, build, runtime, debug logs. Visual Evidence: screenshots, screen recordings, network request/response data. Context: when it started, recent code changes, environment details.</step>
  <step n="2" name="Reproduce the Issue">Follow provided reproduction steps. Verify issue occurs consistently. Note any variations in behavior. Identify minimal reproduction case. Document exact conditions. If cannot reproduce: request more information, try different environments, check for race conditions.</step>
  <step n="3" name="Codebase Analysis">Locate Relevant Code: Use code search tools to find error message strings, function definitions from stack trace, related class/module structures, import statements and dependencies. Trace Execution Path: Document entry point to error location, data transformations along the path, conditional branches taken, error handling (or lack thereof).</step>
  <step n="4" name="Root Cause Analysis">Hypothesis Formation: Form 2-3 hypotheses ranked by likelihood with supporting and contradicting evidence. Verification: For each hypothesis determine what evidence supports it, what contradicts it, how to verify it, what to expect if true. Confirmation: Root cause is confirmed when evidence strongly supports the hypothesis, no contradicting evidence exists, and the fix can be logically derived.</step>
  <step n="5" name="Document Findings">Document all available evidence, reproducible steps with rate and minimal repro, code execution path with line numbers, multiple hypotheses considered, verified root cause with evidence, actionable fix and test plan, related issues and prevention steps.</step>
</process>

<process name="Code Search Strategy">
  Text Pattern Search (Grep): Search for exact error text, function names from stack trace, error types (`Error|Exception|panic|unwrap`), logging statements, config values, state mutations.

  Structural Analysis (ast-grep): Use for call hierarchy (find all callers), error propagation tracing, state mutation locations, missing null checks, async pattern analysis.

  Coverage for Debugging Scope: Identify scope from stack trace, search all relevant files, track what was searched, report coverage percentage.
</process>

<pattern name="Common Bug Patterns">
  Null/Undefined Reference: Symptoms include `TypeError: Cannot read property` or `NullPointerException`. Check variable initialization, optional chaining usage, object construction, API response structure.

  Race Conditions: Symptoms include intermittent failures, different results each run. Add logging at critical points, reproduce with controlled timing, check shared state access, verify synchronization.

  Off-by-One Errors: Symptoms include index out of bounds, loop count errors. Check loop conditions, verify array indexing (0-based vs 1-based), trace iteration counts.

  Type Errors: Symptoms include type mismatch or implicit any errors. Check type annotations, verify type assertions, trace type conversions.
</pattern>

<constraints>
  <constraint>Start with evidence, not assumptions</constraint>
  <constraint>Reproduce the bug before attempting to fix it</constraint>
  <constraint>Form multiple hypotheses (2-3 minimum)</constraint>
  <constraint>Verify fixes with tests</constraint>
  <constraint>Document findings for future reference</constraint>
  <constraint>Use minimal reproduction cases</constraint>
</constraints>

<anti-patterns>
  <anti-pattern>Skipping reproduction steps and jumping to code changes</anti-pattern>
  <anti-pattern>Fixing symptoms without finding root cause</anti-pattern>
  <anti-pattern>Making assumptions without evidence</anti-pattern>
  <anti-pattern>Changing multiple things at once during debugging</anti-pattern>
  <anti-pattern>Ignoring intermittent bugs</anti-pattern>
  <anti-pattern>Fixing without adding regression tests</anti-pattern>
</anti-patterns>

<tools name="Debugging Tools">
  Logging Strategies: Use structured logging with consistent formats, appropriate log levels (DEBUG, INFO, WARN, ERROR), include relevant context variables, avoid logging in hot loops.

  Breakpoint Strategies: Line breakpoints (pause at specific line), conditional breakpoints (pause when condition met), exception breakpoints (pause on throw), watchpoints (pause when variable modified).
</tools>

<references>
  <ref>Extracted from `super-dev:debug-analyzer` agent. For full agent behavior during Stage 5, invoke with subagent_type "super-dev:debug-analyzer".</ref>
</references>
