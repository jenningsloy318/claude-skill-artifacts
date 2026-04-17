---
name: plan
description: "Restate requirements, assess risks, and create step-by-step implementation plan. WAIT for user CONFIRM before touching any code."
---

<purpose>Invoke the planner agent to create a comprehensive implementation plan before writing any code. Analyzes requirements, reviews architecture, creates detailed step breakdowns with dependencies and risks, and waits for user confirmation.</purpose>

<usage>/super-dev:plan [feature or task description]</usage>

<process>
  <step n="1" name="Requirements Analysis">Understand the feature request, identify success criteria, list assumptions and constraints</step>
  <step n="2" name="Architecture Review">Analyze existing codebase, identify affected components, review similar implementations</step>
  <step n="3" name="Step Breakdown">Clear actions with file paths, dependencies, complexity estimates, and risks</step>
  <step n="4" name="Implementation Order">Prioritize by dependencies, group related changes, minimize context switching</step>
</process>

<constraints>
  <constraint>WAIT for user CONFIRM before touching any code</constraint>
  <constraint>Be specific: exact file paths, function names, variable names</constraint>
  <constraint>Consider edge cases and error scenarios</constraint>
  <constraint>Each step should be independently verifiable</constraint>
</constraints>
