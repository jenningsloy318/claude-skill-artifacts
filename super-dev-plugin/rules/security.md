<meta>
  <name>security</name>
  <type>rule</type>
  <description>Security guidelines for mandatory checks before commits</description>
</meta>

<purpose>Enforce mandatory security checks before any commit to prevent vulnerabilities from reaching production.</purpose>

<directives>
  <directive severity="critical">No hardcoded secrets (API keys, passwords, tokens) — use environment variables with existence checks</directive>
  <directive severity="critical">All user inputs validated and sanitized</directive>
  <directive severity="critical">SQL injection prevention via parameterized queries</directive>
  <directive severity="critical">XSS prevention via sanitized HTML output</directive>
  <directive severity="high">CSRF protection enabled</directive>
  <directive severity="high">Authentication/authorization verified on all protected routes</directive>
  <directive severity="high">Rate limiting on all endpoints</directive>
  <directive severity="high">Error messages do not leak sensitive data</directive>
</directives>

<process>
  <step n="1" name="Security Response">If security issue found: STOP immediately</step>
  <step n="2" name="Engage Specialist">Use security-reviewer agent</step>
  <step n="3" name="Fix Critical">Fix CRITICAL issues before continuing</step>
  <step n="4" name="Rotate Secrets">Rotate any exposed secrets</step>
  <step n="5" name="Review Codebase">Review entire codebase for similar issues</step>
</process>
