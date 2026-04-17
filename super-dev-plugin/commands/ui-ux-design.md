<meta>
  <name>ui-ux-design</name>
  <type>command</type>
  <description>Create UI/UX design specifications for features with user interfaces</description>
</meta>

<purpose>Activate the ui-ux-designer agent for Phase 5.5 UI/UX design. Produces wireframes (Pencil MCP or ASCII), design tokens, interaction patterns, accessibility requirements, and responsive behavior specs.</purpose>

<usage>/super-dev:ui-ux-design [feature description]</usage>

<output name="Design Output">
  Wireframes: Visual (Pencil MCP .pen files) or ASCII diagrams for all screens. Design Tokens: Typography, spacing, colors, border radius, breakpoints in YAML. Interactions: State transitions, animations, error handling UX. Accessibility: WCAG 2.1 AA compliance, keyboard navigation, screen reader support. Responsive: Behavior at all breakpoints (mobile, tablet, desktop).
</output>

<output>
  <format>Design specification (`[doc-index]-design-spec.md`) with: executive summary, screen inventory, component specifications, design tokens, accessibility requirements, responsive behavior, implementation notes.</format>
</output>

<constraints>
  <constraint>3-5 design options presented with comparison matrix</constraint>
  <constraint>User selection required before finalizing</constraint>
  <constraint>WCAG 2.1 AA compliance mandatory</constraint>
  <constraint>Checks for Pencil MCP availability for visual wireframes</constraint>
</constraints>
