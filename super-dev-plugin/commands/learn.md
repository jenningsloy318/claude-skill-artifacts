<meta>
  <name>learn</name>
  <type>command</type>
  <description>Extract reusable patterns from the current session and save as skills</description>
</meta>

<purpose>Analyze the current session for non-trivial patterns worth saving as skills. Extract error resolution patterns, debugging techniques, workarounds, and project-specific patterns.</purpose>

<process>
  <step n="1" name="Review">Review the session for extractable patterns</step>
  <step n="2" name="Identify">Identify the most valuable/reusable insight: error resolution patterns (what error, root cause, fix), debugging techniques (non-obvious steps, tool combinations), workarounds (library quirks, API limitations), project-specific patterns (conventions, architecture decisions)</step>
  <step n="3" name="Draft">Draft the skill file with: pattern name, context, problem, solution, example, trigger conditions</step>
  <step n="4" name="Save">Ask user to confirm. Save to `${CLAUDE_PLUGIN_DATA}/learned/[pattern-name].md`</step>
</process>

<constraints>
  <constraint>Don't extract trivial fixes (typos, syntax errors) or one-time issues (API outages)</constraint>
  <constraint>Focus on patterns that save time in future sessions</constraint>
  <constraint>One pattern per skill — keep focused</constraint>
</constraints>
