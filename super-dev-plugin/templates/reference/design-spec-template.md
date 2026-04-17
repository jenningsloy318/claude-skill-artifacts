---
name: design-spec-template
description: XML-tagged template for UI/UX design specifications. Agents load this template and fill in placeholders to produce consistently formatted design specs with wireframes, tokens, interactions, accessibility, and responsiveness.
doc-type: design-spec
gate-profile: null
---

<document type="design-spec">

<metadata>
  <field name="title">Design Specification: [Feature Name]</field>
  <field name="date">[timestamp]</field>
  <field name="version">1.0.0</field>
</metadata>

<section title="Executive Summary">
  <paragraph>[2-3 sentences: what, why, key decisions]</paragraph>
</section>

<section title="User Context">
  <list type="unordered">
    <item name="Target Users">[Persona description]</item>
    <item name="Primary Goal">[What users accomplish]</item>
    <item name="Success Criteria">[How we measure success]</item>
  </list>
</section>

<section title="User Flows">
  <paragraph>[Mermaid diagrams for all critical paths]</paragraph>
  <diagram type="mermaid">
graph TD
    A[Entry Point] --> B{Decision?}
    B -->|Yes| C[Action Screen]
    B -->|No| D[Alternative Path]
    C --> E{Success?}
    E -->|Yes| F[Success State]
    E -->|No| G[Error State]
    G --> C
  </diagram>
</section>

<section title="Screen Inventory">

  <subsection title="Screen 1: [Name]">
    <paragraph>[Wireframe + specifications]</paragraph>
    <diagram type="ascii">
┌─────────────────────────────────────┐
│ Header: [Logo] [Nav] [User Menu]   │
├─────────────────────────────────────┤
│ ┌─────────────┬───────────────────┐ │
│ │ Sidebar     │ Main Content      │ │
│ │ - Item 1    │ [Hero/Heading]    │ │
│ │ - Item 2    │ [Content Area]    │ │
│ │ - Item 3    │ [Action Buttons]  │ │
│ └─────────────┴───────────────────┘ │
├─────────────────────────────────────┤
│ Footer: [Links] [Copyright]        │
└─────────────────────────────────────┘
    </diagram>
    <list type="unordered" label="Interactive Elements">
      <item>[Element]: [Action] -> [Result]</item>
    </list>
    <list type="unordered" label="States">
      <item>Default: [Description]</item>
      <item>Hover: [Changes]</item>
      <item>Active/Focus: [Changes]</item>
      <item>Disabled: [Appearance]</item>
      <item>Error: [Appearance + Message]</item>
      <item>Loading: [Indicator]</item>
      <item>Empty: [Empty state message]</item>
    </list>
  </subsection>

  <subsection title="Screen 2: [Name]">
    <paragraph>[Wireframe + specifications]</paragraph>
  </subsection>

</section>

<section title="Component Specifications">
  <paragraph>[Visual design + states + interactions + accessibility]</paragraph>

  <code lang="yaml">
component: [ComponentName]
variants:
  primary:
    background: brand.primary
    text_color: white
    padding: "12px 24px"
    border_radius: "8px"
    font_weight: 600
    states:
      hover: { background: "darken(primary, 10%)" }
      active: { transform: "scale(0.98)" }
      disabled: { opacity: 0.5, cursor: "not-allowed" }
      loading: { content: "spinner + 'Loading...'" }
  </code>
</section>

<section title="Design Tokens">
  <code lang="yaml">
typography:
  font_families:
    primary: "[font-family]"
    monospace: "[monospace-font]"
  scale:
    h1: { size: "[size]", weight: [weight], line_height: [lh] }
    h2: { size: "[size]", weight: [weight], line_height: [lh] }
    h3: { size: "[size]", weight: [weight], line_height: [lh] }
    body: { size: "[size]", weight: [weight], line_height: [lh] }
    small: { size: "[size]", weight: [weight], line_height: [lh] }

colors:
  brand:
    primary: "[hex]"
    secondary: "[hex]"
  semantic:
    success: "[hex]"
    warning: "[hex]"
    error: "[hex]"
    info: "[hex]"
  neutrals:
    gray_900: "[hex]"
    gray_700: "[hex]"
    gray_400: "[hex]"
    gray_200: "[hex]"
    gray_50: "[hex]"
    white: "[hex]"

spacing:
  xs: "[value]"
  sm: "[value]"
  md: "[value]"
  lg: "[value]"
  xl: "[value]"
  xxl: "[value]"

borders:
  radius:
    sm: "[value]"
    md: "[value]"
    lg: "[value]"
    full: "[value]"
  </code>
</section>

<section title="Accessibility Requirements">
  <subsection title="Keyboard Navigation">
    <list type="unordered">
      <item>All interactive elements Tab-accessible</item>
      <item>Focus indicators: 2px solid outline, brand.primary</item>
      <item>Tab order: Matches visual hierarchy</item>
      <item>Skip links: "Skip to main content" for screen readers</item>
      <item>Escape: Closes modals/dropdowns</item>
    </list>
  </subsection>

  <subsection title="Screen Reader Support">
    <list type="unordered">
      <item>Semantic HTML: Proper heading hierarchy (h1 -> h2 -> h3)</item>
      <item>ARIA labels: All icons, buttons without visible text</item>
      <item>ARIA live regions: Announce dynamic content changes</item>
      <item>Alt text: All meaningful images (max 150 chars)</item>
    </list>
  </subsection>

  <subsection title="Visual Accessibility">
    <list type="unordered">
      <item>Color contrast: 4.5:1 minimum for text, 3:1 for large text</item>
      <item>Don't rely on color alone: Use icons, patterns, labels</item>
      <item>Text sizing: 16px minimum body, scalable to 200%</item>
      <item>Focus indicators: Always visible</item>
    </list>
  </subsection>

  <checklist label="WCAG 2.1 AA Compliance">
    <item>All interactive elements keyboard-accessible</item>
    <item>Color contrast ratios verified (4.5:1)</item>
    <item>ARIA labels for all non-text content</item>
    <item>Heading hierarchy logical (no skipped levels)</item>
    <item>Focus indicators visible on ALL elements</item>
    <item>Error messages associated with fields</item>
  </checklist>
</section>

<section title="Responsive Behavior">
  <code lang="yaml">
breakpoints:
  mobile: "< 768px"
  tablet: "768px - 1024px"
  desktop: "> 1024px"
  wide: "> 1440px"

mobile:
  navigation: "[pattern]"
  grid: "[columns]"
  spacing: "[adjustment]"
  touch_targets: "44x44px minimum"

tablet:
  navigation: "[pattern]"
  grid: "[columns]"
  spacing: "[adjustment]"

desktop:
  navigation: "[pattern]"
  grid: "[columns]"
  spacing: "[adjustment]"
  </code>
</section>

<section title="Implementation Notes">
  <list type="unordered">
    <item>Framework guidance: [framework-specific notes]</item>
    <item>Libraries to use: [component libraries, utilities]</item>
    <item>Performance considerations: [lazy loading, code splitting]</item>
    <item>Edge cases: [boundary conditions, error states]</item>
  </list>
</section>

<section title="Definition of Done">
  <checklist>
    <item>All screens implemented</item>
    <item>All states handled (default, hover, error, loading, empty)</item>
    <item>Accessibility verified (WCAG 2.1 AA)</item>
    <item>Responsive tested (mobile, tablet, desktop)</item>
    <item>No visual regressions</item>
  </checklist>
</section>

</document>
