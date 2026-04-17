---
name: build-fix
description: Incrementally fix TypeScript and build errors one at a time
---

<purpose>Run build, parse error output, and fix errors one at a time. Show error context, explain the issue, propose and apply fix, re-run build, verify resolution. Stop if fix introduces new errors, same error persists after 3 attempts, or user requests pause.</purpose>

<process>
  <step n="1" name="Build">Run build: `npm run build` or `pnpm build`</step>
  <step n="2" name="Parse">Group errors by file, sort by severity</step>
  <step n="3" name="Fix Loop">For each error: show context (5 lines before/after), explain issue, propose fix, apply, re-run build, verify resolved</step>
  <step n="4" name="Report">Show summary: errors fixed, errors remaining, new errors introduced</step>
</process>

<constraints>
  <constraint>Fix one error at a time for safety</constraint>
  <constraint>Stop if fix introduces new errors or same error persists after 3 attempts</constraint>
</constraints>
