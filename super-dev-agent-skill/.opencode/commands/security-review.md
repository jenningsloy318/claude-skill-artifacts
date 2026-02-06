---
description: Perform security audit and review
agent: security-reviewer
---

Perform security audit:

1. Check for hardcoded secrets
2. Validate input sanitization
3. Review authentication/authorization
4. Check for injection vulnerabilities
5. Verify error handling (no info leaks)

Security checklist:
- [ ] No hardcoded secrets/credentials
- [ ] Input validation on all endpoints
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Proper authentication
- [ ] Authorization checks
- [ ] Rate limiting
- [ ] Error message sanitization
- [ ] Secure dependencies

Files to review: $ARGUMENTS

Generate security report with findings and recommendations.
Mark Critical/High severity issues that must be fixed.