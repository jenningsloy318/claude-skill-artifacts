# Technical Specification: Adversarial Review Enhancement

**Date:** 2026-03-07
**Phase:** 6 - Specification
**Status:** Draft

---

## 1. Overview

Enhance the `adversarial-reviewer` agent with two capabilities:

1. **7 Structured Attack Vectors** -- systematic probing sub-checklists integrated within the existing 3-lens model
2. **Destructive Action Gate** -- an always-on, independent checkpoint that flags irreversible operations before verdict synthesis

**Approach:** Option A from the research report -- vectors as structured sub-checklists within each lens. All changes are additive; the existing lens structure is fully preserved.

**Explicitly excluded:** Agentic risk check (per user decision).

---

## 2. Scope

### Files Modified

| File | Type of Change |
|------|---------------|
| `super-dev-plugin/agents/adversarial-reviewer.md` | Primary -- add vectors, gate, updated template |
| `super-dev-plugin/commands/adversarial-review.md` | Secondary -- update docs, fix output naming |
| `super-dev-plugin/skills/super-dev/SKILL.md` | Secondary -- update Phase 10 section |

### What Changes

- New Step 2.5 (Attack Vectors) inserted between existing Steps 2 and 3
- New Step 3 (Destructive Action Gate) inserted before verdict synthesis
- Existing Step 3 renumbered to Step 4
- Output template extended with vector tags, gate section, and vector coverage table
- Verdict logic updated: HALT findings from gate force CONTESTED minimum
- Output file naming standardized across all three files
- Severity reference extended with HALT severity level

### What Does NOT Change

- Lens structure (Skeptic/Architect/Minimalist questions preserved exactly as-is)
- Lens activation thresholds (Small/Medium/Large)
- Core verdict model (PASS/CONTESTED/REJECT)
- Iteration behavior (Phase 8/9/10 loop)
- Finding format (AF-XXX with severity, file:line, recommendation)
- Core principles (verdict only, intent-aware, evidence-based, severity-ordered, lens-exclusive)

---

## 3. Enhanced Workflow

```
Step 1: Determine Scope and Intent                [UNCHANGED]
Step 2: Apply Reviewer Lenses                     [UNCHANGED structure, vectors added as sub-checklists]
Step 2.5: Apply Attack Vectors per Lens            [NEW]
Step 3: Destructive Action Gate                    [NEW]
Step 4: Synthesize Verdict                         [RENUMBERED from Step 3]
```

---

## 4. Attack Vectors Specification

### 4.1 The Seven Vectors

| ID | Vector Name | What It Probes |
|----|------------|----------------|
| V1 | False Assumptions Hunt | Every underlying assumption -- API availability, input validity, schema stability, env-var presence |
| V2 | Edge Case Injection | Extreme/unexpected inputs -- empty strings, null, boundary values (limit+1, limit-1), unicode, zero-length |
| V3 | Failure Mode Probing | External service failures -- database timeout, API 500, network partition, disk full, OOM |
| V4 | Adversarial Input Simulation | Malicious parsing -- long strings (10k+ chars), special chars (`<>"'& {}|\$`), injection payloads, unicode sequences |
| V5 | Safety & Compliance Verification | Security policy adherence -- PII leakage, unsafe actions, auth bypass, CORS misconfiguration |
| V6 | Grounding & Hallucination Audit | Factual accuracy -- fabricated references, hallucinated APIs, non-existent config options, wrong method signatures |
| V7 | Dependency & API Verification | External dependency fitness -- hallucinated packages, outdated methods, version incompatibilities, deprecated APIs |

### 4.2 Vector-to-Lens Mapping

Each lens runs only its relevant vectors. Vectors are NOT run independently -- they are sub-checklists within each lens's analysis.

| Vector | Skeptic | Architect | Minimalist |
|--------|:-------:|:---------:|:----------:|
| V1: False Assumptions Hunt | **Primary** | Secondary | -- |
| V2: Edge Case Injection | **Primary** | -- | -- |
| V3: Failure Mode Probing | **Primary** | Secondary | -- |
| V4: Adversarial Input Simulation | **Primary** | -- | -- |
| V5: Safety & Compliance | **Primary** | Secondary | -- |
| V6: Grounding & Hallucination Audit | **Primary** | -- | -- |
| V7: Dependency & API Verification | -- | **Primary** | Secondary |

**Summary:**
- **Skeptic** is primary for V1-V6 (correctness and security focus)
- **Architect** is primary for V7, secondary for V1, V3, V5 (structural and dependency focus)
- **Minimalist** is secondary for V7 only (questions dependency necessity)

### 4.3 Vector Sub-Checklist Format

Each vector becomes a structured checklist appended to its parent lens. The reviewer MUST address each assigned vector explicitly. Format within the lens section:

```markdown
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
```

```markdown
#### Architect — Challenge structural fitness

Ask:
- Does the design actually serve the stated goal?
- Where are the coupling points that will hurt when requirements shift?
- What boundary violations exist?
- What implicit assumptions about scale, concurrency, or ordering will break first?

**Attack Vector Sub-Checks:**

- [ ] **V1 False Assumptions:** Which architectural assumptions (about load, data shape, deployment topology) are unvalidated?
- [ ] **V3 Failure Modes:** Does the architecture degrade gracefully? Are there circuit breakers, fallbacks, or bulkheads?
- [ ] **V5 Safety & Compliance:** Are security boundaries (auth, authz, trust zones) architecturally enforced, not just code-enforced?
- [ ] **V7 Dependencies:** Are external dependencies justified? Are there version conflicts? Is the dependency actively maintained?
```

```markdown
#### Minimalist — Challenge necessity and complexity

Ask:
- What can be deleted without losing the stated goal?
- Where is the author solving problems they don't have yet?
- What abstractions exist for a single call site?
- Where is configuration or flexibility added without a concrete second use case?
- Is this the simplest possible path to the outcome?

**Attack Vector Sub-Checks:**

- [ ] **V7 Dependencies:** Is each dependency necessary? Could a simpler alternative or stdlib replace it? Is the dependency scope appropriate (dev vs prod)?
```

### 4.4 Finding Tags

Findings from vector sub-checks use a combined tag format:

```
AF-001 | Skeptic/V2 | `file:line`
AF-002 | Architect/V7 | `file:line`
```

The tag includes both the lens and the vector that produced it. This maintains backward compatibility (lens is still primary) while adding traceability to the specific attack vector.

---

## 5. Destructive Action Gate Specification

### 5.1 Purpose

An always-on, independent checkpoint that scans the diff for irreversible operations. It runs after lens+vector analysis and before verdict synthesis. It is NOT a lens and NOT a vector -- it is a **gate**.

### 5.2 Gate Trigger

The gate runs on **every review**, regardless of change size or lens count. It scans all files in the diff.

### 5.3 Destructive Action Categories

| Category | ID | Pattern Examples |
|----------|-----|-----------------|
| Data Destruction | `DAT` | `DROP TABLE`, `DELETE FROM` (no WHERE), `TRUNCATE`, `rm -rf`, `unlink` (recursive), `fs.rm`, cloud `destroy`/`terminate-instances` |
| Irreversible State | `IRR` | `git push --force`, `git reset --hard`, `git branch -D`, `DROP COLUMN`, `npm unpublish`, migration `down()` without `up()` |
| Production Impact | `PRD` | Deploy targeting prod/production/live, DB migration on non-dev env, DNS/SSL changes, load balancer config changes |
| Permission Escalation | `PRM` | `chmod 777`, `chmod +s`, adding admin/root roles, disabling auth/authz, CORS wildcard `*`, security header removal |
| Secret Operations | `SEC` | Deleting/rotating all API keys, revoking certs, clearing credential stores, hardcoded secrets in source |

### 5.4 Gate Logic

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

### 5.5 HALT Severity Level

A new severity level above High:

| Severity | Impact | When Used |
|----------|--------|-----------|
| **HALT** | Irreversible operation without safeguard | Destructive Action Gate only |
| High | Breaks correctness, security, or core functionality | Lens/vector findings |
| Medium | Structural weakness or unnecessary complexity | Lens/vector findings |
| Low | Minor observations or style preferences | Lens/vector findings |

HALT findings:
- Cannot be downgraded by the reviewer
- Force the overall verdict to CONTESTED minimum (single HALT) or REJECT (multiple HALTs)
- Require explicit Team Lead acknowledgment
- Are listed in a dedicated section before the standard findings

### 5.6 Gate Output Format

```markdown
## Destructive Action Gate

**Gate Verdict:** CLEAR | BLOCKED

| Check | Status | Evidence |
|-------|--------|----------|
| Data Destruction (DAT) | CLEAR/HALT | [details or file:line] |
| Irreversible State (IRR) | CLEAR/HALT | [details or file:line] |
| Production Impact (PRD) | CLEAR/HALT | [details or file:line] |
| Permission Escalation (PRM) | CLEAR/HALT | [details or file:line] |
| Secret Operations (SEC) | CLEAR/HALT | [details or file:line] |

### HALT Findings (if any)

**DAG-001** | Gate/DAT | `migrations/002_drop_users.sql:5`
**Category:** Data Destruction
**Operation:** `DROP TABLE users` in migration script
**Reversibility:** IRREVERSIBLE -- no corresponding rollback migration
**Blast Radius:** All user records in target database
**Safeguard Required:** Add rollback migration with `CREATE TABLE` + data restore, or convert to soft-delete

**DAG-002** | Gate/IRR | `deploy.sh:12`
**Category:** Irreversible State
**Operation:** `git push --force origin main`
**Reversibility:** IRREVERSIBLE -- overwrites remote history
**Blast Radius:** All collaborators' local branches become orphaned
**Safeguard Required:** Use `--force-with-lease` or remove force push entirely
```

---

## 6. Updated Output Template

```markdown
# Adversarial Review: [Feature/Fix Name]

**Date:** [timestamp]
**Reviewer:** super-dev:adversarial-reviewer
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
| Data Destruction (DAT) | CLEAR/HALT | [details] |
| Irreversible State (IRR) | CLEAR/HALT | [details] |
| Production Impact (PRD) | CLEAR/HALT | [details] |
| Permission Escalation (PRM) | CLEAR/HALT | [details] |
| Secret Operations (SEC) | CLEAR/HALT | [details] |

### HALT Findings
<DAG-XXX entries if any, or "None">

## Findings
<numbered list, ordered by severity: high -> medium -> low>
<each finding tagged with Lens/Vector: e.g., Skeptic/V2>

### High

**AF-001** | Skeptic/V2 | `file:line`
**Issue:** [description]
**Recommendation:** [concrete action]

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
| V2: Edge Cases | Skeptic | 1 | High |
| V3: Failure Modes | Skeptic | 0 | -- |
| V4: Adversarial Input | Skeptic | 0 | -- |
| V5: Safety & Compliance | Skeptic | 0 | -- |
| V6: Grounding Audit | Skeptic | 0 | -- |
| V7: Dependencies | Architect | 1 | Medium |

## What Went Well
<1-3 things the reviewers found no issue with>

## Lead Judgment
<for each finding: accept or reject with one-line rationale>
```

---

## 7. Updated Verdict Logic

```
IF Gate Verdict == BLOCKED (any HALT findings):
  IF multiple HALT findings:
    Verdict = REJECT
  ELSE:
    Verdict = CONTESTED (minimum, can still be REJECT based on other findings)
ELSE:
  Original logic applies:
    PASS    -- no high-severity findings
    CONTESTED -- high-severity findings but reviewers disagree
    REJECT  -- high-severity findings with reviewer consensus
```

---

## 8. Output File Naming Fix

**Current inconsistency:**
- Agent: `[spec-index]-[spec-name]-adversarial-review-report.md`
- Command: `[doc-index]-adversarial-review-report.md`
- SKILL.md: `[spec-index]-[spec-name]-adversarial-review-report.md`

**Standardized to (all three files):**
```
specification/[spec-index]-[spec-name]/[spec-index]-[spec-name]-adversarial-review-report.md
```

The command file will be updated to match the agent and SKILL.md pattern.

---

## 9. Command File Updates

The `adversarial-review.md` command file needs:

1. **Updated "What This Command Does" section** -- add steps for attack vectors and destructive action gate
2. **New "Attack Vectors" section** -- brief description of the 7 vectors
3. **New "Destructive Action Gate" section** -- brief description of the gate and HALT severity
4. **Fixed output file naming** -- change `[doc-index]` to `[spec-index]-[spec-name]`
5. **Updated verdicts table** -- add note about HALT findings forcing CONTESTED/REJECT
6. **Updated notes** -- mention vectors and gate

---

## 10. SKILL.md Phase 10 Updates

The Phase 10 section in SKILL.md needs:

1. **Add attack vectors mention** -- "Each lens applies structured attack vector sub-checklists (V1-V7)"
2. **Add destructive action gate mention** -- "An always-on Destructive Action Gate scans for irreversible operations"
3. **Updated verdict logic** -- "HALT findings from the gate force CONTESTED minimum or REJECT"
4. **Updated iteration rule** -- Gate BLOCKED verdict forces loop back to Phase 8

---

## 11. Constraints

- All changes are markdown file edits -- no code, no tests, no build steps
- Changes are additive to preserve backward compatibility
- Existing lens questions are preserved verbatim
- The reviewer still produces a verdict, NOT code modifications
- HALT severity is exclusive to the Destructive Action Gate (not used in lens findings)
- Vector sub-checklists are guidance for the reviewer, not automated checks
