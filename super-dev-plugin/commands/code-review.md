<meta>
  <name>code-review</name>
  <type>command</type>
  <description>Perform specification-aware code review focused on correctness, security, performance, and maintainability</description>
</meta>

<purpose>Activate the code-reviewer agent to review code against specification. Assess correctness, security, performance, and maintainability. Runs in parallel with adversarial review in Phase 9.</purpose>

<usage>/super-dev:code-review [code changes context]</usage>

<topic name="Review Focus Areas">
  **Correctness**: Logic matches specifications, edge cases handled, error handling comprehensive, data flow correct. **Security**: No hardcoded secrets, proper input validation, auth checks, injection prevention. **Performance**: Efficient algorithms, no unnecessary queries, proper caching, resource optimization. **Maintainability**: Follows project patterns, readable code, adequate comments, modular components.
</topic>

<arguments>
  Context of changes made, specification references, specific areas of concern.
</arguments>

<output>
  <format>Review report with: overall verdict (Approved/Needs Changes/Blocked), findings by severity (Critical/High/Medium/Low), line references and suggestions, acceptance criteria status.</format>
</output>

<constraints>
  <constraint>Specification-aware review using requirements and design docs</constraint>
  <constraint>Runs in parallel with adversarial review in Phase 9</constraint>
  <constraint>Iterative: loops back to execution if blocking issues found</constraint>
  <constraint>Proceed only when both code review approved AND adversarial review PASS</constraint>
</constraints>
