# Task List: Architecture Agent

**Date:** 2025-11-23
**Version:** 1.0.0

## Tasks

### Task 1: Create Architecture Agent File

**File:** `dev-workflow-plugin/agents/architecture-agent.md`

**Subtasks:**
- [ ] 1.1 Create frontmatter (name, description, model: sonnet)
- [ ] 1.2 Write philosophy section (YAGNI, SOLID, DRY)
- [ ] 1.3 Define core capabilities
- [ ] 1.4 Define input context
- [ ] 1.5 Implement Phase 1: Context Gathering
- [ ] 1.6 Implement Phase 2: Requirements Analysis with verification
- [ ] 1.7 Implement Phase 3: Module Decomposition with YAGNI check
- [ ] 1.8 Implement Phase 4: Technology Evaluation with matrix
- [ ] 1.9 Implement Phase 5: Interface Design with verification
- [ ] 1.10 Implement Phase 6: Documentation
- [ ] 1.11 Implement Phase 7: Validation with final checklist
- [ ] 1.12 Add MADR 3.0.0 ADR template
- [ ] 1.13 Add output format template
- [ ] 1.14 Add quality standards and anti-patterns
- [ ] 1.15 Add anti-hallucination measures

---

### Task 2: Update dev-workflow SKILL.md

**File:** `dev-workflow-plugin/skills/dev-workflow/SKILL.md`

**Subtasks:**
- [ ] 2.1 Add Phase 4.5: Architecture Design section after Phase 4
- [ ] 2.2 Update workflow checklist to include Phase 4.5
- [ ] 2.3 Add architecture-agent to Agents Reference table
- [ ] 2.4 Update Phase 6 to reference architecture.md as input

---

### Task 3: Update Spec Writer Agent

**File:** `dev-workflow-plugin/agents/spec-writer.md`

**Subtasks:**
- [ ] 3.1 Add architecture.md to input context (optional)
- [ ] 3.2 Reference architecture decisions in specification output

---

### Task 4: Validation

**Subtasks:**
- [ ] 4.1 Verify agent file follows existing patterns
- [ ] 4.2 Verify all phases have clear success criteria
- [ ] 4.3 Verify ADR template is MADR 3.0.0 compliant
- [ ] 4.4 Verify output format is complete
- [ ] 4.5 Verify integration with SKILL.md is correct

---

## Summary

| Task | Status | Priority |
|------|--------|----------|
| 1. Create agent file | Pending | Critical |
| 2. Update SKILL.md | Pending | High |
| 3. Update spec-writer | Pending | Medium |
| 4. Validation | Pending | High |

## Definition of Done

- [ ] All agent phases implemented
- [ ] Verification checkpoints at phases 2, 3, 5, 7
- [ ] MADR 3.0.0 ADR template included
- [ ] Output format template complete
- [ ] SKILL.md includes Phase 4.5
- [ ] Agents Reference table updated
- [ ] Files follow existing code patterns
