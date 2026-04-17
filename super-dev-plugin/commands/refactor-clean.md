---
name: refactor-clean
description: Safely identify and remove dead code with test verification
---

<purpose>Run dead code analysis tools (knip, depcheck, ts-prune), categorize findings by severity, propose safe deletions, and verify with tests before and after each deletion.</purpose>

<process>
  <step n="1" name="Analyze">Run knip (unused exports/files), depcheck (unused deps), ts-prune (unused TS exports). Generate report in .reports/dead-code-analysis.md.</step>
  <step n="2" name="Categorize">SAFE (test files, unused utilities), CAUTION (API routes, components), DANGER (config files, main entry points). Propose safe deletions only.</step>
  <step n="3" name="Delete Safely">Before each deletion: run full test suite, verify pass, apply change, re-run tests, rollback if tests fail.</step>
</process>

<constraints>
  <constraint>Never delete code without running tests first</constraint>
</constraints>
