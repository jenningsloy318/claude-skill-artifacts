<meta>
  <name>architecture-design</name>
  <type>command</type>
  <description>Design architecture and create Architecture Decision Records (ADRs) for complex features</description>
</meta>

<purpose>Activate the architecture-agent (or product-designer for features needing both architecture and UI) for Phase 5.3 architecture design. Produces module decomposition, interfaces, ADRs, data flow diagrams, and evaluation matrices.</purpose>

<usage>/super-dev:architecture-design [feature description]</usage>

<topic name="Design Output">
  **Module Decomposition**: Components with responsibilities, interfaces, dependencies. **ADRs**: MADR 3.0.0 format with status, context, decision drivers, 3+ considered options, evaluation matrix. **Data Flow**: Diagrams showing how data moves through the system. **API Contracts**: Interface definitions between modules.
</topic>

<output>
  <format>Architecture document (`[doc-index]-architecture.md`) with: module breakdown, interfaces, ADRs, data flow, evaluation matrix (technical quality, delivery, operational criteria).</format>
</output>

<constraints>
  <constraint>3-5 architecture options presented with comparison matrix</constraint>
  <constraint>User selection required before finalizing</constraint>
  <constraint>Anti-hallucination: all file/API references verified against codebase</constraint>
</constraints>
