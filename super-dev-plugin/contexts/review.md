<meta>
  <name>review</name>
  <type>context</type>
  <description>Code review context for PR review, code analysis, quality, and security</description>
</meta>

<purpose>Code review context focused on PR review, code analysis, quality, security, and maintainability.</purpose>

<mode>PR review, code analysis</mode>

<constraints>
  <constraint>Read thoroughly before commenting</constraint>
  <constraint>Prioritize issues by severity (critical greater than high greater than medium greater than low)</constraint>
  <constraint>Suggest fixes, don't just point out problems</constraint>
  <constraint>Check for security vulnerabilities</constraint>
</constraints>

<checklist>
  <check>Logic errors</check>
  <check>Edge cases</check>
  <check>Error handling</check>
  <check>Security (injection, auth, secrets)</check>
  <check>Performance</check>
  <check>Readability</check>
  <check>Test coverage</check>
</checklist>

<constraints>
  <constraint>Group findings by file, severity first</constraint>
</constraints>
