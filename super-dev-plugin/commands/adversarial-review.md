---
name: super-dev:adversarial-review
description: Perform multi-lens adversarial review to challenge implementation correctness, structural fitness, and necessity
---

# Phase 9: Adversarial Review (runs parallel with Code Review)

Perform multi-lens adversarial review that challenges the implementation from distinct critical perspectives.

## Usage

```
/super-dev:adversarial-review [implementation context]
```

## What This Command Does

When invoked, this command activates the `super-dev:adversarial-reviewer` agent to:

1. **Determine scope**: Assess change size and select reviewer count (1-3 lenses)
2. **State intent**: Identify what the author is trying to achieve
3. **Apply lenses**: Challenge implementation from Skeptic, Architect, and/or Minimalist perspectives with attack vector sub-checklists (V1-V7)
4. **Run Destructive Action Gate**: Scan diff for irreversible operations (always-on, independent of lens count)
5. **Synthesize verdict**: Produce PASS, CONTESTED, or REJECT with evidence
6. **Generate report**: Write adversarial review report with findings

### Output: Creates `[doc-index]-adversarial-review-report.md`

## Reviewer Lenses

### Skeptic (always active)
- Challenges correctness and completeness
- Finds unhandled error paths, race conditions, unproven assumptions

### Architect (50+ lines changed)
- Challenges structural fitness
- Finds coupling issues, boundary violations, implicit scale assumptions

### Minimalist (200+ lines changed)
- Challenges necessity and complexity
- Finds premature abstractions, unnecessary configuration, over-engineering

## Attack Vectors

Each lens applies structured attack vector sub-checklists (V1-V7) as part of its analysis:

| ID | Vector | Primary Lens |
|----|--------|-------------|
| V1 | False Assumptions Hunt | Skeptic |
| V2 | Edge Case Injection | Skeptic |
| V3 | Failure Mode Probing | Skeptic |
| V4 | Adversarial Input Simulation | Skeptic |
| V5 | Safety & Compliance Verification | Skeptic |
| V6 | Grounding & Hallucination Audit | Skeptic |
| V7 | Dependency & API Verification | Architect |

Vectors run as sub-checklists within each lens -- not independently. Findings use combined `Lens/Vector` tags (e.g., `Skeptic/V2`).

## Destructive Action Gate

An always-on checkpoint that scans every diff for irreversible operations, regardless of change size.

**Categories scanned:** Data Destruction, Irreversible State, Production Impact, Permission Escalation, Secret Operations

**HALT severity:** A new severity level above High, exclusive to the gate. HALT findings represent irreversible operations without safeguards and cannot be downgraded.

**Verdict impact:**
- Single HALT finding → CONTESTED minimum
- Multiple HALT findings → REJECT
- Gate findings use `DAG-XXX` numbering (separate from `AF-XXX`)

## Verdicts

| Verdict | Meaning | Action |
|---------|---------|--------|
| **PASS** | No high-severity findings | Proceed to documentation |
| **CONTESTED** | High-severity findings, reviewers disagree | Team Lead decides |
| **REJECT** | High-severity findings, reviewer consensus | Loop back to execution |

**Note:** HALT findings from the Destructive Action Gate force CONTESTED minimum (single HALT) or REJECT (multiple HALTs), regardless of other findings.

## Arguments

`$ARGUMENTS` should include:
- Context of implementation changes
- Specification references
- Phase 8/9 output summary

## Examples

```
/super-dev:adversarial-review Authentication system after execution phase
/super-dev:adversarial-review Payment processing module - post Phase 8
```

## Notes

- Produces a verdict, NOT code modifications
- Complements code review with adversarial perspective (both run in Phase 9 in parallel)
- Part of the Phase 8/9 quality loop
- REJECT verdict forces loop back to Phase 8 for fixes
- Each lens applies structured attack vector sub-checklists (V1-V7) for systematic probing
- An always-on Destructive Action Gate scans for irreversible operations on every review
- Gate BLOCKED verdict forces loop back to Phase 8
