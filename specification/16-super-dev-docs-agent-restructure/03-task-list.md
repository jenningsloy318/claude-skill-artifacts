# Task List: Super Dev Documentation Agent Restructure

**Plan:** [link to implementation plan]
**Total Tasks:** 13

## Tasks

### Milestone 1: Update Workflow Documentation (SKILL.md)

- [ ] **T1.1** Update workflow phases diagram in SKILL.md
  - **Files:** `super-dev-plugin/skills/super-dev/SKILL.md`
  - **Details:** Modify the ASCII diagram to show docs-executor in Phase 10, remove from Phase 8
  - **Acceptance:** Diagram shows docs-executor only in Phase 10

- [ ] **T1.2** Update Phase 8 description in SKILL.md
  - **Files:** `super-dev-plugin/skills/super-dev/SKILL.md`
  - **Details:** Remove docs-executor from Phase 8 parallel agents list
  - **Acceptance:** Phase 8 only lists dev-executor and qa-agent

- [ ] **T1.3** Add Phase 10 description in SKILL.md
  - **Files:** `super-dev-plugin/skills/super-dev/SKILL.md`
  - **Details:** Insert new Phase 10 before current Phase 10 (which becomes Phase 11)
  - **Acceptance:** Phase 10 clearly describes documentation phase

- [ ] **T1.4** Update phase numbering in SKILL.md workflow list
  - **Files:** `super-dev-plugin/skills/super-dev/SKILL.md`
  - **Details:** Shift all phases after 9 by +1 (10→11, 11→12, add new 12)
  - **Acceptance:** Phase list shows 0-12 sequentially

- [ ] **T1.5** Update agent reference table in SKILL.md
  - **Files:** `super-dev-plugin/skills/super-dev/SKILL.md`
  - **Details:** Update docs-executor description to reflect Phase 10 execution
  - **Acceptance:** Agent table shows docs-executor in Phase 10

### Milestone 2: Update Coordinator Agent (coordinator.md)

- [ ] **T2.1** Update phase flow definition in coordinator.md
  - **Files:** `super-dev-plugin/agents/coordinator.md`
  - **Details:** Modify Phase 8 to show only 2 agents, add Phase 10
  - **Acceptance:** Phase flow matches new structure

- [ ] **T2.2** Update Phase 8 parallel execution in coordinator.md
  - **Files:** `super-dev-plugin/agents/coordinator.md`
  - **Details:** Remove docs-executor from Phase 8 task assignment
  - **Acceptance:** Phase 8 only invokes dev-executor and qa-agent

- [ ] **T2.3** Add Phase 10 task assignment in coordinator.md
  - **Files:** `super-dev-plugin/agents/coordinator.md`
  - **Details:** Add docs-executor invocation in Phase 10
  - **Acceptance:** Phase 10 task invokes docs-executor

- [ ] **T2.4** Update iteration logic for Phase 8/9 loop
  - **Files:** `super-dev-plugin/agents/coordinator.md`
  - **Details:** Ensure docs-executor not part of iteration loop
  - **Acceptance:** Iteration only affects dev and qa agents

- [ ] **T2.5** Update quality gates for phase transitions
  - **Files:** `super-dev-plugin/agents/coordinator.md`
  - **Details:** Adjust checkpoints to include new Phase 10
  - **Acceptance:** Quality gates reference correct phases

### Milestone 3: Update docs-executor Agent (docs-executor.md)

- [ ] **T3.1** Remove parallel execution references from docs-executor.md
  - **Files:** `super-dev-plugin/agents/docs-executor.md`
  - **Details:** Remove mentions of working in parallel with other agents
  - **Acceptance:** No references to parallel execution

- [ ] **T3.2** Update agent description for Phase 10 execution
  - **Files:** `super-dev-plugin/agents/docs-executor.md`
  - **Details:** Change from Phase 8 parallel to Phase 10 sequential
  - **Acceptance:** Description clearly states sequential execution

- [ ] **T3.3** Update trigger conditions in docs-executor.md
  - **Files:** `super-dev-plugin/agents/docs-executor.md`
  - **Details:** Change trigger from Phase 8 start to Phase 10 entry
  - **Acceptance:** Trigger references code review completion

- [ ] **T3.4** Modify update patterns for sequential mode
  - **Files:** `super-dev-plugin/agents/docs-executor.md`
  - **Details:** Remove real-time update requirements, add batch processing
  - **Acceptance:** Documentation describes single-pass updates

### Milestone 4: Final Verification

- [ ] **T4.1** Cross-reference all phase numbers across files
  - **Files:** All modified files
  - **Details:** Search for phase references to ensure consistency
  - **Acceptance:** All phase numbers match between files

- [ ] **T4.2** Verify workflow consistency
  - **Files:** All modified files
  - **Details:** Ensure agent-phase assignments match across documents
  - **Acceptance:** No contradictions in workflow description

### Final Tasks

- [ ] **TF.1** Review all changes for consistency
  - **Command:** Manual review of all modified files
  - **Acceptance:** Changes are logical and consistent

- [ ] **TF.2** Create implementation summary
  - **Files:** Create `04-implementation-summary.md`
  - **Acceptance:** Summary documents all changes made

- [ ] **TF.3** Code review (self-review)
  - **Agent:** Manual review
  - **Acceptance:** No blocking issues identified

- [ ] **TF.4** Commit and push changes
  - **Message format:** "refactor: move docs-executor from Phase 8 to Phase 10 for post-review documentation"
  - **Acceptance:** Changes pushed to remote

## Task Dependencies

```
T1.1 ──┬──▶ T1.2 ──┬──▶ T1.3 ──┬──▶ T1.4 ──┬──▶ T1.5
       │          │          │          │
       └──▶ T2.1 ──┴──▶ T2.2 ──┴──▶ T2.3 ──┴──▶ T2.4 ──┬──▶ T2.5
                                                  │
T3.1 ──┬──▶ T3.2 ──┬──▶ T3.3 ──────────────────────┘
       │          │
       └──▶ T3.4 ──┘

T4.1 ──┬──▶ T4.2
       │
TF.1 ◀─┘
TF.2
TF.3
TF.4
```

## Priority Order
1. T1.1-T1.5 - Update core workflow documentation first
2. T2.1-T2.5 - Update coordinator to match new workflow
3. T3.1-T3.4 - Update docs-executor for new execution mode
4. T4.1-T4.2 - Verify consistency across all changes
5. TF.1-TF.4 - Final validation and commit

## Notes
- All file paths are relative to `/home/jenningsl/development/personal/jenningsloy318/super-skill-claude-artifacts/`
- Phase numbering must be carefully updated to avoid gaps
- Remember to shift all phases after 9 by +1
- Ensure workflow diagrams match textual descriptions