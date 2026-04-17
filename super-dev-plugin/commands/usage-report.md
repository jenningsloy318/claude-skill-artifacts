<meta>
  <name>usage-report</name>
  <type>command</type>
  <description>View skill and agent usage statistics for the super-dev plugin</description>
</meta>

<purpose>Read `${CLAUDE_PLUGIN_DATA}/global/stats.json` and `${CLAUDE_PLUGIN_DATA}/global/usage.log` to display total invocations, top skills, top agents, and recent activity.</purpose>

<usage>/super-dev:usage-report</usage>

<topic name="What It Displays">
  Total invocations: How many times skills and agents have been used. Top skills: Most frequently used, sorted by count. Top agents: Most frequently used, sorted by count. Recent activity: Last 10 invocations from usage.log.
</topic>

<constraints>
  <constraint>Usage data stored in `${CLAUDE_PLUGIN_DATA}/global/` — persists across sessions and projects</constraint>
  <constraint>Stats updated automatically via PreToolUse hook</constraint>
  <constraint>No sensitive data collected — only tool names and timestamps</constraint>
</constraints>
