# Implementation Plan: UI/UX Designer Agent

**Date:** 2025-11-23
**Version:** 1.0.0

## Overview

This plan outlines the implementation steps to add the UI/UX Designer Agent to the dev-workflow plugin.

## Implementation Phases

### Phase 1: Create Agent File

**File:** `dev-workflow-plugin/agents/ui-ux-designer.md`

**Structure:**
1. Frontmatter (name, description, model)
2. Role Definition
3. Core Philosophy (YAGNI, Boring Patterns)
4. Capabilities List
5. 10-Phase Methodology
6. Verification Checkpoints
7. Output Format
8. Quality Standards
9. Anti-Hallucination Measures

**Pattern to Follow:** `requirements-clarifier.md` and `code-assessor.md`

---

### Phase 2: Update SKILL.md

**File:** `dev-workflow-plugin/skills/dev-workflow/SKILL.md`

**Changes:**

1. **Add Phase 5.5** between Code Assessment and Specification Writing:
```markdown
## Phase 5.5: UI/UX Design (Features with UI)

**AGENT:** Invoke `dev-workflow:ui-ux-designer`

\`\`\`
Task(
  prompt: "Create UI/UX design for: [feature/fix name]",
  context: {
    requirements: "[path to requirements]",
    assessment: "[path to assessment]"
  },
  subagent_type: "dev-workflow:ui-ux-designer"
)
\`\`\`

Skip this phase for:
- Backend-only features
- CLI tools
- API-only changes

**Output:** `[index]-design-spec.md` in spec directory
```

2. **Update Workflow Checklist** - Add Phase 5.5 checkbox

3. **Update Agents Reference Table** - Add ui-ux-designer row

4. **Update Phase 6 (Spec Writing)** - Reference design-spec.md as input

---

### Phase 3: Testing

**Validation Steps:**
1. Test agent invocation standalone
2. Test integration with full dev-workflow
3. Verify output format matches specification
4. Verify verification checkpoints work
5. Test with sample feature request

---

## Implementation Order

```
1. Create ui-ux-designer.md agent file
   ↓
2. Update SKILL.md with Phase 5.5
   ↓
3. Update spec-writer.md to reference design-spec
   ↓
4. Test integration
```

## Estimated Effort

| Task | Complexity | Effort |
|------|------------|--------|
| Create agent file | High | Primary task |
| Update SKILL.md | Low | Minor additions |
| Update spec-writer | Low | Add input reference |
| Testing | Medium | Validation |

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Agent too verbose | Medium | Use YAGNI verification checkpoints |
| Output format inconsistent | Low | Strict template in agent |
| Integration issues | Medium | Follow existing agent patterns exactly |

## Success Criteria

- [ ] Agent file created following existing patterns
- [ ] SKILL.md updated with Phase 5.5
- [ ] Agent produces valid design-spec.md
- [ ] Verification checkpoints prevent over-design
- [ ] Output is implementation-ready
