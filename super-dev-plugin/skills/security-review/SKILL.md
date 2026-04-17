<meta>
  <name>security-review</name>
  <type>skill</type>
  <description>Comprehensive security review skill for authentication, user input, secrets, API endpoints, and OWASP Top 10</description>
</meta>

<purpose>Provide comprehensive security checklist and patterns when adding authentication, handling user input, working with secrets, creating API endpoints, or implementing payment/sensitive features. Flags secrets, SSRF, injection, unsafe crypto, and OWASP Top 10 vulnerabilities.</purpose>

<triggers>Triggers on: adding authentication, handling user input, working with secrets, creating API endpoints, implementing payment/sensitive features</triggers>

<workflow>
  1. **Automated Scan**: Run npm audit, eslint-plugin-security, grep for hardcoded secrets, check exposed env vars.
  2. **OWASP Top 10**: Check each category — injection, broken auth, sensitive data exposure, XXE, broken access control, security misconfiguration, XSS, insecure deserialization, vulnerable components, insufficient logging.
  3. **Domain-Specific Checks**: Financial security (atomic transactions, balance checks, rate limiting), blockchain security (wallet signatures, private keys, slippage protection), authentication (JWT validation, session management), database (RLS, parameterized queries), API (auth required, input validation, CORS).
  4. **Report**: Findings by severity (Critical/High/Medium/Low) with: description, impact, proof of concept, remediation code, OWASP/CWE references.
</workflow>

<constraints>
  <constraint>**CRITICAL**: No hardcoded secrets — use environment variables</constraint>
  <constraint>**CRITICAL**: Parameterized queries only — no string interpolation in SQL</constraint>
  <constraint>**CRITICAL**: No shell command injection — use libraries, not exec()</constraint>
  <constraint>**CRITICAL**: Hashed password comparison only — never plaintext</constraint>
  <constraint>**CRITICAL**: Authorization check on every protected route</constraint>
  <constraint>**CRITICAL**: Atomic transactions for financial operations with row locks</constraint>
  <constraint>**HIGH**: Rate limiting on all financial and auth endpoints</constraint>
  <constraint>**HIGH**: XSS prevention — never innerHTML with user input</constraint>
  <constraint>**HIGH**: SSRF prevention — validate URLs against domain allowlist</constraint>
  <constraint>**MEDIUM**: Sanitize logs — never log passwords, API keys, or full PII</constraint>
</constraints>

<principles>
  <principle>Defense in depth — multiple layers of security</principle>
  <principle>Least privilege — minimum permissions required</principle>
  <principle>Fail securely — errors must not expose data</principle>
  <principle>Don't trust input — validate and sanitize everything</principle>
  <principle>Verify context before flagging — not every finding is a vulnerability</principle>
</principles>
