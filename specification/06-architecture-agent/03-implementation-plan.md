# Implementation Plan: Architecture Agent

**Date:** 2025-11-23
**Version:** 1.0.0

## Overview

This plan outlines the implementation steps to add the Architecture Agent to the dev-workflow plugin.

## Implementation Phases

### Phase 1: Create Agent File

**File:** `dev-workflow-plugin/agents/architecture-agent.md`

**Structure:**
1. Frontmatter (name, description, model: sonnet)
2. Philosophy (YAGNI, SOLID, DRY)
3. Core Capabilities
4. Input Context
5. 7-Phase Methodology with verifications
6. ADR Template (MADR 3.0.0)
7. Output Format
8. Quality Standards
9. Anti-Hallucination Measures

**Pattern to Follow:** `ui-ux-designer.md` and `code-assessor.md`

---

### Phase 2: Update SKILL.md

**File:** `dev-workflow-plugin/skills/dev-workflow/SKILL.md`

**Changes:**

1. **Add Phase 4.5** between Code Assessment and UI/UX Design:
```markdown
## Phase 4.5: Architecture Design (Complex Features)

**AGENT:** Invoke `dev-workflow:architecture-agent`

Task(
  prompt: "Design architecture for: [feature/fix name]",
  context: {
    requirements: "[path to requirements]",
    assessment: "[path to assessment]"
  },
  subagent_type: "dev-workflow:architecture-agent"
)

Skip this phase for:
- Simple bug fixes
- Minor feature changes
- Cosmetic updates

**Output:** `[index]-architecture.md` and ADRs in spec directory
```

2. **Update Workflow Checklist** - Add Phase 4.5 checkbox

3. **Update Agents Reference Table** - Add architecture-agent row

4. **Update Phase 6 (Spec Writing)** - Reference architecture.md as input

---

### Phase 3: Update Spec Writer

**File:** `dev-workflow-plugin/agents/spec-writer.md`

**Changes:**
1. Add `architecture` to Input Context (optional)
2. Reference architecture decisions in specification output
3. Update "Cross-Reference" capability to include architecture

---

### Phase 4: Testing

**Validation Steps:**
1. Verify agent file follows existing patterns
2. Test agent invocation standalone
3. Test integration with full dev-workflow
4. Verify output format matches specification
5. Verify ADR format is correct MADR 3.0.0

---

## Implementation Order

```
1. Create architecture-agent.md agent file
   ↓
2. Update SKILL.md with Phase 4.5
   ↓
3. Update spec-writer.md to reference architecture
   ↓
4. Validate implementation
```

## Effort Estimate

| Task | Complexity |
|------|------------|
| Create agent file | High (primary task) |
| Update SKILL.md | Low |
| Update spec-writer | Low |
| Validation | Medium |

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Agent too verbose | Medium | YAGNI verification checkpoints |
| ADR format incorrect | Low | Use exact MADR 3.0.0 template |
| Integration issues | Medium | Follow existing agent patterns |
| Over-architecture | High | Multiple YAGNI checkpoints |

## Success Criteria

- [ ] Agent file created following existing patterns
- [ ] SKILL.md updated with Phase 4.5
- [ ] Agent produces valid architecture.md
- [ ] ADRs follow MADR 3.0.0 format
- [ ] YAGNI checkpoints prevent over-architecture
- [ ] Output is implementation-ready
