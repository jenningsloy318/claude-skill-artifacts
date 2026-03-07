# Task List: Adversarial Review Enhancement

**Date:** 2026-03-07
**Spec:** 03-specification.md
**Plan:** 05-implementation-plan.md

---

## Milestone 1: Update Agent File (`agents/adversarial-reviewer.md`)

- [x] **T1.1** Add V1-V6 attack vector sub-checklist to Skeptic lens (after existing questions)
- [x] **T1.2** Add V1, V3, V5, V7 attack vector sub-checklist to Architect lens (after existing questions)
- [x] **T1.3** Add V7 attack vector sub-checklist to Minimalist lens (after existing questions)
- [x] **T1.4** Insert Step 2.5 -- Apply Attack Vectors (instruction to address each vector explicitly)
- [x] **T1.5** Insert Step 3 -- Destructive Action Gate (5 categories, patterns, gate logic, HALT format)
- [x] **T1.6** Renumber existing Step 3 to Step 4 (Synthesize Verdict)
- [x] **T1.7** Update verdict logic in Step 4 (HALT -> CONTESTED min, multiple HALTs -> REJECT)
- [x] **T1.8** Update Output Template: add `Attack vectors applied` to Change Scope table
- [x] **T1.9** Update Output Template: add Destructive Action Gate section
- [x] **T1.10** Update Output Template: change finding tags to `Lens/Vector` format
- [x] **T1.11** Update Output Template: add Vector Coverage summary table
- [x] **T1.12** Add HALT severity to Severity Reference table

## Milestone 2: Update Command File (`commands/adversarial-review.md`)

- [x] **T2.1** Update "What This Command Does" numbered steps (5 -> 7 steps)
- [x] **T2.2** Fix output file naming: `[doc-index]` -> `[spec-index]-[spec-name]`
- [x] **T2.3** Add "Attack Vectors" section (brief description of 7 vectors)
- [x] **T2.4** Add "Destructive Action Gate" section (5 categories, HALT severity)
- [x] **T2.5** Update Verdicts table (add HALT override notes)
- [x] **T2.6** Update Notes section (mention vectors and gate)

## Milestone 3: Update SKILL.md Phase 10 (`skills/super-dev/SKILL.md`)

- [x] **T3.1** Update Phase 10 section: add vector and gate descriptions
- [x] **T3.2** Update Phase 10 verdict logic: add HALT -> CONTESTED/REJECT rule
- [x] **T3.3** Update adversarial-reviewer description in teammate role tables (2 tables)

## Milestone 4: Verification

- [x] **T4.1** Cross-file consistency check: output naming, vector names, gate categories, verdict rules
- [x] **T4.2** Backward compatibility check: all existing lens questions, thresholds, formats preserved
