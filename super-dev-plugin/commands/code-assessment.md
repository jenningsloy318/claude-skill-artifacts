<meta>
  <name>code-assessment</name>
  <type>command</type>
  <description>Assess existing codebase for architecture, standards, and framework patterns</description>
</meta>

<purpose>Activate the code-assessor agent to evaluate codebase architecture, standards compliance, framework patterns, and technical debt. Maps existing patterns before implementing changes.</purpose>

<usage>/super-dev:code-assessment [feature/area to assess]</usage>

<reference name="Assessment Areas">
  Architecture: Module organization, design patterns, code structure, integration boundaries. Standards Compliance: Coding style, naming conventions, error handling, testing practices. Framework Usage: Frameworks/libraries, version compatibility, integration patterns, custom configs. Technical Debt: Complexity hotspots, duplication, outdated patterns, performance concerns.
</reference>

<arguments>
  Feature or area to implement, specific concerns, integration requirements.
</arguments>

<output>
  <format>Assessment report (`[doc-index]-code-assessment.md`) with: architecture overview, standards findings, framework inventory, integration recommendations, technical debt assessment, implementation guidance.</format>
</output>
