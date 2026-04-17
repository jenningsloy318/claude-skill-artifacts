<meta>
  <name>update-codemaps</name>
  <type>command</type>
  <description>Analyze codebase structure and update architecture documentation</description>
</meta>

<purpose>Scan all source files for imports, exports, and dependencies. Generate token-lean codemaps (architecture.md, backend.md, frontend.md, data.md). Calculate diff from previous version, request approval if changes exceed 30%, add freshness timestamps.</purpose>

<process>
  <step n="1" name="Scan">Scan all source files for imports, exports, and dependencies</step>
  <step n="2" name="Generate">Generate codemaps: architecture.md (overall), backend.md, frontend.md, data.md (models and schemas)</step>
  <step n="3" name="Diff">Calculate diff percentage from previous version</step>
  <step n="4" name="Approve">If changes exceed 30%, request user approval before updating</step>
  <step n="5" name="Finalize">Add freshness timestamp to each codemap. Save reports to .reports/codemap-diff.txt</step>
</process>

<constraints>
  <constraint>Use TypeScript/Node.js for analysis</constraint>
  <constraint>Focus on high-level structure, not implementation details</constraint>
</constraints>
