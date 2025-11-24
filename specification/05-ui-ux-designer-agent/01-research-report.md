# Research Report: UI/UX Designer Agent

**Date:** 2025-11-23
**Version:** 1.0.0

## Executive Summary

This research investigates best practices for AI-powered UI/UX design agents to add comprehensive design capabilities to the dev-workflow plugin. The goal is to create an agent that bridges the gap between requirements and implementation by producing professional, accessibility-compliant design specifications.

## Research Sources

### Primary Sources (GitHub Implementations)

| Repository | Description | Stars | Key Features |
|------------|-------------|-------|--------------|
| dimitritholen/the-gang | Full SDLC Workflow with UX/UI Designer | - | 10-phase process, verification checkpoints, YAGNI principles |
| thomasholknielsen/claude-code-config | UI/UX Analyst agent | - | RISEN framework, CARE metrics, Playwright integration |
| bacoco/BMad-Skills | BMAD UX Design skill | - | Design Thinking workshops, v0/Lovable integration |
| alfrankl1/figma-tailwind-cookiecutter | Figma-Tailwind design system | 6 | Design tokens sync, Claude MCP integration |

### Secondary Sources (Industry Best Practices)

| Source | Key Contributions |
|--------|-------------------|
| Microsoft Design - UX Design for Agents | Space/Time/Core framework, agentic design principles |
| Agentic Design AI | Human-AI interaction patterns (HITL, HOTL, Progressive Disclosure) |
| Nielsen Norman Group | 10 Usability Heuristics adapted for AI interfaces |
| Brad Frost - Atomic Design | Component hierarchy methodology |
| WCAG 2.1 | Accessibility guidelines (AA compliance minimum) |

## Key Findings

### 1. Design Methodologies

**Design Thinking (Most Common)**
```
Empathize → Define → Ideate → Prototype → Test
```
- Used by Microsoft, BMAD, the-gang
- User-centered approach starting with understanding needs
- Iterative refinement through feedback

**Atomic Design (Component Architecture)**
```
Atoms → Molecules → Organisms → Templates → Pages
```
- Design tokens as "subatomic particles"
- Hierarchical component composition
- Enables design system consistency

### 2. Core Capabilities Identified

All successful UI/UX agents include these capabilities:

| Capability | Description | Priority |
|------------|-------------|----------|
| UX Research | User personas, journey mapping, pain points | Critical |
| Information Architecture | Navigation, content hierarchy, user flows | Critical |
| Wireframing | Low-fidelity layouts (ASCII/text-based) | Critical |
| Visual Design System | Typography, colors, spacing, design tokens | High |
| Interaction Design | States, transitions, feedback patterns | High |
| Accessibility | WCAG 2.1 AA, keyboard nav, screen readers | Critical |
| Responsive Design | Mobile-first, breakpoints, touch targets | High |
| Design Handoff | Implementation-ready specs | Critical |

### 3. Process Patterns

**Verification Checkpoints (from the-gang)**
- Phase 2: Verify user needs correctly identified
- Phase 4: Verify wireframes against requirements (YAGNI)
- Phase 7: Verify WCAG compliance
- Phase 9: Verify no premature optimization
- Phase 10: Comprehensive final verification

**Quality Metrics (from thomasholknielsen - CARE Framework)**
- **C**ompleteness: >95% - All UI/UX aspects analyzed
- **A**ccuracy: >90% - Every finding has evidence
- **R**elevance: >85% - Prioritized by user impact
- **E**fficiency: <30s scan time for output

### 4. Output Formats

**Standard Output Structure:**
```markdown
# Design Specification: {Feature Name}

## Executive Summary
## User Context (Personas, Goals)
## User Flows (Mermaid diagrams)
## Screen Inventory (Wireframes)
## Component Specifications
## Design Tokens (JSON/YAML)
## Accessibility Requirements
## Responsive Behavior
## Implementation Notes
## Definition of Done
```

### 5. Integration Patterns

**Workflow Position:**
- After: Requirements Clarification, Research, Code Assessment
- Before: Specification Writing, Implementation
- Parallel: Can run alongside technical research

**Input Dependencies:**
- `requirements.md` - Functional requirements
- `assessment.md` - Technical constraints, existing patterns
- `research-report.md` - Best practices (optional)

**Output Consumers:**
- `spec-writer` agent - Uses design spec for technical specification
- `execution-coordinator` - References design during implementation
- `frontend-developer` - Implementation guidance

### 6. Anti-Patterns to Avoid

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Over-design | Creating screens/components not in requirements | YAGNI verification at each phase |
| Invented APIs | Assuming framework capabilities | Verify against actual tech stack |
| Speculative variants | Creating "just in case" component variations | Only design what's needed now |
| Accessibility afterthought | Adding a11y at the end | Integrate throughout all phases |
| Novel patterns | Inventing new interaction patterns | Use familiar, proven patterns |

### 7. Technology Integration

**Design Systems:**
- Shadcn/UI (React/Next.js) - Most recommended
- Tailwind CSS - Design tokens foundation
- Radix UI - Accessible primitives

**Icon Systems:**
- Lucide React
- Heroicons
- Material Symbols

**Typography Recommendations:**
- Inter, Geist, IBM Plex Sans, Manrope

**AI-Assisted Tools:**
- v0.dev - Component generation
- Lovable - Rapid prototyping
- Figma MCP - Design import

## Recommendations

### 1. Adopt 10-Phase Comprehensive Approach

Based on the-gang's proven structure:

1. Context Gathering
2. UX Research (with verification)
3. Information Architecture
4. Wireframing (with YAGNI verification)
5. Visual Design Specification
6. Interaction Design
7. Accessibility Specification (with WCAG verification)
8. Responsive Design Strategy
9. Design System Documentation (with over-engineering check)
10. Developer Handoff (with final verification)

### 2. Include Verification Checkpoints

Add self-critique questions at phases 2, 4, 7, 9, and 10 to:
- Prevent scope creep
- Ensure accessibility compliance
- Avoid over-engineering
- Validate feasibility

### 3. Integrate with Existing Workflow

Position as Phase 5.5 in dev-workflow:
```
Phase 5: Code Assessment
Phase 5.5: UI/UX Design ← NEW
Phase 6: Specification Writing
```

### 4. Output Structured Design Spec

Produce `[index]-design-spec.md` containing:
- User flows (Mermaid diagrams)
- ASCII wireframes
- Design tokens (YAML/JSON)
- Accessibility checklist
- Implementation notes

## Conclusion

The research validates the need for a comprehensive UI/UX designer agent in the dev-workflow plugin. The recommended approach combines:
- Design Thinking methodology for user-centered design
- Atomic Design for component architecture
- Verification checkpoints to prevent over-engineering
- WCAG 2.1 AA accessibility compliance
- Structured output for seamless developer handoff

The agent should be invoked after requirements clarification and code assessment, producing implementation-ready design specifications that guide the spec-writer and frontend developers.
