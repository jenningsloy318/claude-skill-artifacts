---
name: adversarial-review
description: >
    Perform multi-lens adversarial review to challenge implementation correctness, structural fitness,
    and necessity. Applies Skeptic, Architect, and Minimalist lenses with 7 attack vectors (V1-V7) and
    a Destructive Action Gate. Produces a verdict (PASS/CONTESTED/REJECT), NOT code modifications.
    Trigger on: "adversarial review", "challenge this code", "attack the implementation",
    "review for edge cases", "check for destructive actions", "stress test the design".
    Do NOT trigger on: standard code review (use code-review skill), simple linting,
    formatting checks, or documentation review.
---

# Adversarial Review Skill

Challenge implementations from distinct critical lenses to catch issues that standard code review misses. Produces a verdict, NOT code modifications.

**Announce at start:** "Running adversarial review with multi-lens challenge and destructive action gate."

## When to Activate

- After code implementation is complete (post-execution phase)
- When you need to stress-test an implementation beyond standard code review
- Before merging critical or high-risk changes
- When reviewing code that handles destructive operations, security, or production systems
- When explicitly asked to challenge or attack an implementation

## When NOT to Activate

- For standard code quality review (use `code-review` or `code-review-expert` skills)
- For linting or formatting checks
- For simple typo fixes or trivial changes
- For documentation-only changes

## Core Principles

- **Verdict only:** Produce a verdict (PASS/CONTESTED/REJECT). NEVER make code changes.
- **Intent-aware:** Challenge whether the work achieves its intent well, not whether the intent is correct.
- **Evidence-based:** Every finding MUST include file:line references and concrete recommendations.
- **Lens-exclusive:** Each reviewer adopts one lens exclusively — no blending.
- **Severity-ordered:** Findings ordered HALT → high → medium → low.

## Required Inputs

Gather before starting the review:

- **Specification** or description of what the code should do
- **Implementation summary** — what changed and why
- **Diff scope** — either `{base_sha, head_sha}` or a list of changed files

## Review Workflow

### Step 1 — Determine Scope and Intent

1. Gather the diff (recent changes, implementation files, spec if available).
2. State the **intent** explicitly — what the author is trying to achieve.
3. Assess change size to determine reviewer count:

| Size | Threshold | Reviewers |
|------|-----------|-----------|
| Small | < 50 lines, 1-2 files | 1 (Skeptic) |
| Medium | 50-200 lines, 3-5 files | 2 (Skeptic + Architect) |
| Large | 200+ lines or 5+ files | 3 (Skeptic + Architect + Minimalist) |

### Step 2 — Apply Reviewer Lenses

Each reviewer adopts one lens exclusively:

#### Skeptic — Challenge correctness and completeness

Ask:
- What inputs, states, or sequences will break this?
- What error paths are unhandled or silently swallowed?
- What race conditions or ordering dependencies exist?
- What does the author believe is true that isn't proven?
- Where is "it works on my machine" masquerading as verification?

**Attack Vector Sub-Checks:**

- [ ] **V1 False Assumptions:** List every assumption the code makes. For each: is it validated? What happens when it's false?
- [ ] **V2 Edge Cases:** Test with: empty input, null, max boundary, max+1, negative values, unicode, zero-length arrays
- [ ] **V3 Failure Modes:** For each external call: what happens on timeout? 500? Network partition? Is retry logic present and correct?
- [ ] **V4 Adversarial Input:** Test parsing with: 10k+ char strings, `<script>`, SQL injection patterns, path traversal (`../`), null bytes
- [ ] **V5 Safety & Compliance:** Check for: PII in logs, hardcoded secrets, auth bypass paths, missing rate limiting, CORS wildcards
- [ ] **V6 Grounding Audit:** Verify every API call, config reference, and method signature exists in the actual dependency version used

#### Architect — Challenge structural fitness (50+ lines)

Ask:
- Does the design actually serve the stated goal, or does it serve a goal the author assumed?
- Where are the coupling points that will hurt when requirements shift?
- What boundary violations exist? Where does responsibility leak between components?
- What implicit assumptions about scale, concurrency, or ordering will break first?

**Attack Vector Sub-Checks:**

- [ ] **V1 False Assumptions:** Which architectural assumptions (about load, data shape, deployment topology) are unvalidated?
- [ ] **V3 Failure Modes:** Does the architecture degrade gracefully? Are there circuit breakers, fallbacks, or bulkheads?
- [ ] **V5 Safety & Compliance:** Are security boundaries (auth, authz, trust zones) architecturally enforced, not just code-enforced?
- [ ] **V7 Dependencies:** Are external dependencies justified? Are there version conflicts? Is the dependency actively maintained?

#### Minimalist — Challenge necessity and complexity (200+ lines)

Ask:
- What can be deleted without losing the stated goal?
- Where is the author solving problems they don't have yet?
- What abstractions exist for a single call site?
- Where is configuration or flexibility added without a concrete second use case?
- Is this the simplest possible path to the outcome, or is it the path that felt most thorough?

**Attack Vector Sub-Checks:**

- [ ] **V7 Dependencies:** Is each dependency necessary? Could a simpler alternative or stdlib replace it? Is the dependency scope appropriate (dev vs prod)?

### Step 2.5 — Apply Attack Vectors

For each active lens, review its **Attack Vector Sub-Checks**:

1. Address every assigned vector explicitly — check or note as not applicable with rationale.
2. Record findings with combined `Lens/Vector` tags (e.g., `Skeptic/V2`, `Architect/V7`).
3. Findings follow the standard AF-XXX format with severity, file:line, and recommendation.

**Vector-to-Lens mapping:**
- **Skeptic** is primary for V1-V6
- **Architect** is primary for V7, secondary for V1, V3, V5
- **Minimalist** is secondary for V7 only

### Step 3 — Destructive Action Gate

An always-on checkpoint that scans the diff for irreversible operations. This gate runs on **every review** regardless of change size or lens count.

**Scan all files in the diff for these categories:**

| Category | ID | Pattern Examples |
|----------|-----|-----------------|
| Data Destruction | `DAT` | `DROP TABLE`, `DELETE FROM` (no WHERE), `TRUNCATE`, `rm -rf`, `unlink` (recursive), `fs.rm`, cloud `destroy`/`terminate-instances` |
| Irreversible State | `IRR` | `git push --force`, `git reset --hard`, `git branch -D`, `DROP COLUMN`, `npm unpublish`, migration `down()` without `up()` |
| Production Impact | `PRD` | Deploy targeting prod/production/live, DB migration on non-dev env, DNS/SSL changes, load balancer config changes |
| Permission Escalation | `PRM` | `chmod 777`, `chmod +s`, adding admin/root roles, disabling auth/authz, CORS wildcard `*`, security header removal |
| Secret Operations | `SEC` | Deleting/rotating all API keys, revoking certs, clearing credential stores, hardcoded secrets in source |

**Gate logic:**

```
FOR each file in diff:
  SCAN for patterns matching any destructive category
  IF match found:
    CHECK if confirmation/undo mechanism exists:
      - Backup before delete?
      - Soft-delete instead of hard-delete?
      - Rollback migration provided?
      - Confirmation prompt before destructive command?
    IF no safeguard:
      Emit HALT finding (category, file:line, blast radius)
    ELSE:
      Emit INFO note (safeguard acknowledged)

IF any HALT findings exist:
  Gate Verdict = BLOCKED
  Overall verdict forced to CONTESTED (minimum)
  IF multiple HALT findings:
    Overall verdict forced to REJECT
ELSE:
  Gate Verdict = CLEAR
```

**HALT finding format (DAG-XXX):**

```
DAG-001 | Gate/[CATEGORY_ID] | `file:line`
Category: [category name]
Operation: [what the code does]
Reversibility: IRREVERSIBLE -- [why]
Blast Radius: [what is affected]
Safeguard Required: [concrete action to add safety]
```

### Step 4 — Synthesize Verdict

**Verdict logic:**

```
IF Gate Verdict == BLOCKED (any HALT findings):
  IF multiple HALT findings:
    Verdict = REJECT
  ELSE:
    Verdict = CONTESTED (minimum, can still be REJECT based on other findings)
ELSE:
  PASS    -- no high-severity findings
  CONTESTED -- high-severity findings but reviewers disagree
  REJECT  -- high-severity findings with reviewer consensus
```

**HALT rules:**
- HALT findings cannot be downgraded by the reviewer
- Single HALT → CONTESTED minimum
- Multiple HALTs → REJECT
- HALT findings require explicit acknowledgment before proceeding

## Output Template

```markdown
# Adversarial Review: [Feature/Fix Name]

**Date:** [timestamp]
**Reviewer:** adversarial-review skill
**Verdict:** PASS | CONTESTED | REJECT

## Intent
<what the author is trying to achieve>

## Verdict Summary
<one-line summary>

## Change Scope
| Metric | Value |
|--------|-------|
| Lines changed | X |
| Files changed | X |
| Size classification | Small/Medium/Large |
| Reviewers activated | Skeptic [+ Architect] [+ Minimalist] |
| Attack vectors applied | V1-V6 [+ V7] |

## Destructive Action Gate

**Gate Verdict:** CLEAR | BLOCKED

| Check | Status | Evidence |
|-------|--------|----------|
| Data Destruction (DAT) | CLEAR/HALT | [details or file:line] |
| Irreversible State (IRR) | CLEAR/HALT | [details or file:line] |
| Production Impact (PRD) | CLEAR/HALT | [details or file:line] |
| Permission Escalation (PRM) | CLEAR/HALT | [details or file:line] |
| Secret Operations (SEC) | CLEAR/HALT | [details or file:line] |

### HALT Findings
<DAG-XXX entries if any, or "None">

## Findings
<numbered list, ordered by severity: HALT -> high -> medium -> low>
<each finding tagged with Lens/Vector: e.g., Skeptic/V2>

### High

**AF-001** | Skeptic/V2 | `file:line`
**Issue:** [description]
**Recommendation:** [concrete action, not vague advice]

### Medium

**AF-002** | Architect/V7 | `file:line`
**Issue:** [description]
**Recommendation:** [concrete action]

### Low

**AF-003** | Minimalist/V7 | `file:line`
**Issue:** [description]
**Recommendation:** [concrete action]

## Vector Coverage
| Vector | Lens | Findings | Highest Severity |
|--------|------|----------|-----------------|
| V1: False Assumptions | Skeptic | 0 | -- |
| V2: Edge Cases | Skeptic | 0 | -- |
| V3: Failure Modes | Skeptic | 0 | -- |
| V4: Adversarial Input | Skeptic | 0 | -- |
| V5: Safety & Compliance | Skeptic | 0 | -- |
| V6: Grounding Audit | Skeptic | 0 | -- |
| V7: Dependencies | Architect | 0 | -- |

## What Went Well
<1-3 things the reviewers found no issue with>
```

## Verdict Actions

| Verdict | Meaning | What to Do |
|---------|---------|------------|
| **PASS** | No high-severity findings | Safe to proceed |
| **CONTESTED** | High-severity findings or single HALT | Review findings; decide whether to fix or accept risk |
| **REJECT** | Consensus high-severity findings or multiple HALTs | Must fix before proceeding |

## Severity Reference

| Severity | Impact | Examples |
|----------|--------|----------|
| **HALT** | Irreversible operation without safeguard | Destructive Action Gate only — `DROP TABLE`, `rm -rf`, `git push --force`, `chmod 777` |
| High | Breaks correctness, security, or core functionality | Unhandled error paths, race conditions, security holes, missing validation |
| Medium | Structural weakness or unnecessary complexity | Coupling issues, premature abstractions, responsibility leaks |
| Low | Minor observations or style preferences | Naming suggestions, minor simplifications |

## Integration with super-dev Workflow

When used within the super-dev workflow:
- Runs in **Phase 9** in parallel with code-reviewer
- Both reviews must pass (Code Review = Approved AND Adversarial = PASS) to proceed
- REJECT forces loop back to Phase 8 (Execution & QA)
- CONTESTED allows Team Lead to decide

When used standalone (outside super-dev):
- Run after implementation is complete
- Use verdict to decide whether to merge, fix, or accept risk
- Can be combined with any code review process
