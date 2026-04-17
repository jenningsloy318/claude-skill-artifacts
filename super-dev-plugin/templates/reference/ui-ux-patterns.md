<meta>
  <name>ui-ux-patterns</name>
  <type>template</type>
  <description>UI/UX design patterns, principles, and best practices for user interface design</description>
</meta>

<purpose>Reference for user interface and experience design during Phase 5.5 (UI/UX Design) of the super-dev workflow. Covers layout patterns, navigation, components, interaction patterns, state handling, design tokens, accessibility, and responsive design.</purpose>

<principles>
  <principle name="YAGNI">Design only screens/components explicitly required. No speculative UI variants. Each UI element must serve documented requirements.</principle>
  <principle name="Boring Patterns First">Prefer familiar, proven UI patterns over novel interactions. Users shouldn't need training for standard actions.</principle>
  <principle name="Simple over Clever">If standard components work, don't create custom. If flat information architecture works, don't add hierarchy. Working design first, pixel-perfect later.</principle>
  <principle name="No Wheel Reinvention">Prefer reusing mature open-source UI components and design systems.</principle>
  <principle name="Interface-first Modularity">Define component contracts (props, events, states) before implementations.</principle>
</principles>

<reference name="UX Research Questions">
  Who is this for and why? Primary user persona, goals/success criteria, pain points being solved, context of use (environment, device, urgency).

  What is the core user journey? Entry points (discovery/access), critical path (minimum steps to goal), decision points and branches, exit points and next actions.

  What are usability priorities? Learnability (how quickly new users understand), Efficiency (how fast experts complete tasks), Error prevention (what could go wrong), Satisfaction (delight vs frustration).

  What are design constraints? Accessibility (screen readers, keyboard, contrast), Performance (load time, interaction latency), Content (text length, image sizes), Technical (browser support, API limitations).
</reference>

<pattern name="Layout Patterns">
  Card Layout: Image/Title/Action grid. Best for product listings, dashboards, content grids. Scalable, flexible, responsive-friendly.

  List Layout: Vertical item list with actions. Best for data tables, settings, navigation. High information density, scan-friendly.

  Split View (Master-Detail): Item list alongside detail pane. Best for email, file browsers, dashboards. Maintains context, supports exploration.

  Dashboard Layout: Header/Search/Actions bar with Filter sidebar, Chart/List main area, KPI/Activity sidebar. Best for analytics, admin panels, monitoring.
</pattern>

<pattern name="Navigation Patterns">
  Top Navigation (Tabs): Best for 3-5 sections of equal importance. Visible, scan-friendly, mobile-friendly.

  Sidebar Navigation: Best for 5+ sections, hierarchical content. Scalable, supports sub-navigation.

  Breadcrumbs: Best for deep hierarchies, e-commerce. Shows location, supports back navigation.

  Mega Menu: Best for large sites with many categories. Previews content, reduces clicks.
</pattern>

<pattern name="Component Patterns">
  Buttons: Variants (primary, secondary, ghost, danger), Sizes (sm, md, lg), States (default, hover, active, disabled, loading).

  Forms: Single column (simple forms, mobile-first), Two column (desktop, related field grouping), Wizard/Stepped (complex forms, multi-step processes).

  Data Display: Tables (comparable data, sortable/filterable), List Groups (items with rich previews and actions).
</pattern>

<pattern name="Interaction Patterns">
  Modals: Use for critical confirmations and focused input. Avoid for non-critical info or large content.

  Inline Expansion: Use for progressive disclosure, FAQs. Maintains context, reduces cognitive load.

  Side Panel (Drawer): Use for edit forms, details, filters. Preserves context, provides larger space.

  Toast Notifications: Use for non-blocking feedback. Positions: top-right, bottom-right, bottom-center.
</pattern>

<pattern name="State Patterns">
  Empty States: Icon/illustration + message + call-to-action (e.g., "No items found. Try adjusting your filters. [Create New Item]").

  Loading States: Spinner or skeleton placeholders that match content layout.

  Error States: Error message + recovery actions (Retry, Go Back).
</pattern>

<reference name="Design Tokens">
  Typography: Primary font Inter/system-ui/sans-serif, monospace Fira Code. Sizes from xs (12px) to 3xl (30px). Weights 400-700. Line heights 1.25-1.75.

  Spacing (8px Grid): 0 to 12 units (0px to 48px). Consistent spacing creates rhythm and hierarchy.

  Colors (Semantic): Primary (#3B82F6), Secondary (#6B7280), Success (#10B981), Warning (#F59E0B), Error (#EF4444). Each with main/light/dark variants.

  Border Radius: none (0), sm (2px), md (6px), lg (8px), xl (12px), full (pill).
</reference>

<constraint name="Accessibility (WCAG 2.1 AA)">
  <constraints>
    <constraint name="Color contrast">Normal text minimum 4.5:1, large text (18px+) minimum 3:1, interactive elements minimum 3:1</constraint>
    <constraint name="Keyboard navigation">All interactive elements keyboard accessible, visible focus indicator, logical tab order, skip links for main content</constraint>
    <constraint name="Screen reader">Semantic HTML (`nav`, `main`, `article`, `button`), ARIA labels for icon-only buttons, ARIA live regions for dynamic content, descriptive link text</constraint>
    <constraint name="Touch targets">Minimum 44x44 CSS pixels, adequate spacing, swipe gestures have alternative controls</constraint>
  </constraints>
</constraint>

<pattern name="Responsive Design">
  Breakpoints: xs 0px (mobile), sm 640px (mobile landscape), md 768px (tablet), lg 1024px (desktop), xl 1280px (large desktop), 2xl 1536px (extra large).

  Mobile-first: Touch-friendly controls (min 44px), single column layout, simplified navigation (hamburger), optimized images (lazy loading, responsive), reduced motion support.

  Responsive patterns: Mobile uses single column, full-width cards, bottom/hamburger nav, stacked forms. Tablet uses two columns, side-by-side content, tab navigation. Desktop uses multi-column grid, max-width containers, persistent navigation.
</pattern>

<pattern name="Visual Design Best Practices">
  Visual hierarchy: Size (larger = more important), Color (bright/bold = more important), Position (top/left = more important), Contrast (high = more attention).

  Whitespace: Micro whitespace (4-8px) between related elements, macro whitespace (16-32px) between sections. Guides the eye and creates breathing room.

  Alignment: Left-align text for readability, center-align only for short headings, right-align numbers for comparison. Consistent alignment creates visual flow.

  Consistency: Same component for similar actions, consistent spacing, reuse color semantics, follow design system patterns.
</pattern>

<references>
  <ref>Extracted from `super-dev:ui-ux-designer` agent. For full agent behavior during Phase 5.5, invoke with subagent_type "super-dev:ui-ux-designer".</ref>
</references>
