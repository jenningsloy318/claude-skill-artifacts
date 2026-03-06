---
name: super-dev:adversarial-review
description: Perform multi-lens adversarial review to challenge implementation correctness, structural fitness, and necessity
---

# Phase 10: Adversarial Review

Perform multi-lens adversarial review that challenges the implementation from distinct critical perspectives.

## Usage

```
/super-dev:adversarial-review [implementation context]
```

## What This Command Does

When invoked, this command activates the `super-dev:adversarial-reviewer` agent to:

1. **Determine scope**: Assess change size and select reviewer count (1-3 lenses)
2. **State intent**: Identify what the author is trying to achieve
3. **Apply lenses**: Challenge implementation from Skeptic, Architect, and/or Minimalist perspectives
4. **Synthesize verdict**: Produce PASS, CONTESTED, or REJECT with evidence
5. **Generate report**: Write adversarial review report with findings

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

## Verdicts

| Verdict | Meaning | Action |
|---------|---------|--------|
| **PASS** | No high-severity findings | Proceed to documentation |
| **CONTESTED** | High-severity findings, reviewers disagree | Team Lead decides |
| **REJECT** | High-severity findings, reviewer consensus | Loop back to execution |

## Arguments

`$ARGUMENTS` should include:
- Context of implementation changes
- Specification references
- Phase 8/9 output summary

## Examples

```
/super-dev:adversarial-review Authentication system after code review pass
/super-dev:adversarial-review Payment processing module - post Phase 9
```

## Notes

- Produces a verdict, NOT code modifications
- Complements Phase 9 code review with adversarial perspective
- Part of the Phase 8/9/10 quality loop
- REJECT verdict forces loop back to Phase 8 for fixes
