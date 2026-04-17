<meta>
  <name>verify</name>
  <type>skill</type>
  <description>Verify implemented features work correctly by driving browser/UI testing with screenshots and programmatic assertions</description>
</meta>

<purpose>Drive interactive testing to verify that implemented features actually work. Take screenshots, record evidence, and enforce programmatic assertions at each step. Uses Playwright MCP when available, falls back to CLI-based verification.</purpose>

<triggers>Triggers on: "verify this works", "check the output", "test the UI", "verify the feature", "screenshot test", "visual verification", "does it actually work". Do NOT trigger on: unit test writing (use tdd-workflow), code review (use code-review), standard test runs.</triggers>

<activation>Announce: "Running verification. I will test the feature interactively and capture evidence."</activation>

<workflow>
  <step n="1" name="Detect Tools">Check for Playwright MCP (`mcp__playwright__*`) or Chrome DevTools MCP (`mcp__chrome-devtools__*`). Fall back to CLI verification if unavailable.</step>
  <step n="2" name="Plan Verification Steps">From requirements/BDD scenarios, determine what to verify. Each step needs: action, expected result, assertion type.</step>
  <step n="3" name="Execute Steps">Navigate to feature, interact with UI, capture screenshots at each step, assert expected outcomes.</step>
  <step n="4" name="Record Evidence">Save screenshots, network logs, console output, assertion results.</step>
  <step n="5" name="Report">Pass/fail for each step with evidence links.</step>
</workflow>

<constraints>
  <constraint>Every assertion must be programmatic (not visual-only) — check element existence, text content, network responses</constraint>
  <constraint>Capture screenshot BEFORE and AFTER each interaction for comparison</constraint>
  <constraint>Report failures with: step number, expected vs actual, screenshot evidence</constraint>
  <constraint>If Playwright MCP unavailable, verify via CLI commands, API calls, or log output</constraint>
</constraints>
