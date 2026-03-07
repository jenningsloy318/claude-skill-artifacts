# Assessment: Current Adversarial-Reviewer Agent

**Date:** 2026-03-07
**Scope:** Files assessed for enhancement with 7 Attack Vectors + Destructive Action Gate

---

## 1. Current Lens Structure

### Three Lenses (Skeptic, Architect, Minimalist)

**Activation Thresholds** (based on diff size):

| Size       | Threshold                  | Reviewers Activated                  |
|------------|----------------------------|--------------------------------------|
| Small      | < 50 lines, 1-2 files      | 1 (Skeptic only)                     |
| Medium     | 50-200 lines, 3-5 files    | 2 (Skeptic + Architect)              |
| Large      | 200+ lines or 5+ files     | 3 (Skeptic + Architect + Minimalist) |

**Lens Questions (Current):**

**Skeptic** (correctness & completeness) -- 5 questions:
1. What inputs, states, or sequences will break this?
2. What error paths are unhandled or silently swallowed?
3. What race conditions or ordering dependencies exist?
4. What does the author believe is true that isn't proven?
5. Where is "it works on my machine" masquerading as verification?

**Architect** (structural fitness) -- 4 questions:
1. Does the design actually serve the stated goal?
2. Where are the coupling points that will hurt when requirements shift?
3. What boundary violations exist?
4. What implicit assumptions about scale, concurrency, or ordering will break first?

**Minimalist** (necessity & complexity) -- 5 questions:
1. What can be deleted without losing the stated goal?
2. Where is the author solving problems they don't have yet?
3. What abstractions exist for a single call site?
4. Where is configuration or flexibility added without a concrete second use case?
5. Is this the simplest possible path to the outcome?

### Verdict Model

Three verdicts: PASS / CONTESTED / REJECT
- PASS: no high-severity findings
- CONTESTED: high-severity findings but reviewers disagree
- REJECT: high-severity findings with reviewer consensus

### Iteration Behavior
- PASS -> Phase 11 (Documentation)
- CONTESTED -> Team Lead decides accept or loop to Phase 8
- REJECT -> MUST loop to Phase 8

---

## 2. Gaps for 7 Attack Vectors

The current lenses are **philosophical perspectives** (correctness, structure, necessity). They lack **targeted attack vectors** that systematically probe specific vulnerability categories. Here is where each vector maps:

| Attack Vector                        | Current Coverage | Gap |
|--------------------------------------|-----------------|-----|
| 1. Boundary & Edge Case Injection    | Partial (Skeptic Q1: "what inputs will break this?") | No systematic boundary enumeration (off-by-one, empty, max, unicode, null) |
| 2. Concurrency & Race Condition      | Partial (Skeptic Q3: "race conditions?") | No systematic TOCTOU, deadlock, shared-state analysis |
| 3. Error Propagation Chain           | Partial (Skeptic Q2: "unhandled error paths?") | No multi-layer cascade analysis, no silent-failure detection framework |
| 4. State Machine Violation           | None | Completely missing -- no analysis of impossible state transitions, orphaned states |
| 5. Resource & Lifecycle Leak         | None | Completely missing -- no file handle, connection, memory, goroutine leak checks |
| 6. Implicit Coupling & Hidden Deps   | Partial (Architect Q2-Q3: coupling, boundary violations) | No env-var dependency, init-order, import-side-effect analysis |
| 7. Destructive Action Safety         | None | Completely missing -- no irreversible operation analysis, no confirmation gate |

**Summary:** 3 partially covered, 4 completely missing. The current model provides *breadth* via lens perspectives but lacks *depth* via targeted attack probes.

### Recommended Integration Point

Attack vectors should be added as a **new Step 2.5** between "Apply Reviewer Lenses" (Step 2) and "Synthesize Verdict" (Step 3). This preserves the existing lens structure while adding systematic vector probing.

```
Current Flow:
  Step 1: Determine Scope and Intent
  Step 2: Apply Reviewer Lenses (Skeptic/Architect/Minimalist)
  Step 3: Synthesize Verdict

Enhanced Flow:
  Step 1: Determine Scope and Intent
  Step 2: Apply Reviewer Lenses (Skeptic/Architect/Minimalist)  [UNCHANGED]
  Step 2.5: Apply Attack Vectors (7 vectors, always all)          [NEW]
  Step 3: Destructive Action Gate                                  [NEW]
  Step 4: Synthesize Verdict                                       [RENUMBERED]
```

---

## 3. Output Template Analysis

### Current Template Sections

```
1. Header (Date, Reviewer, Verdict)
2. Intent
3. Verdict Summary
4. Change Scope (table: lines, files, size, reviewers)
5. Findings (High/Medium/Low with AF-XXX IDs, Lens tag, file:line)
6. What Went Well
7. Lead Judgment
```

### Required Additions for Enhancement

**A. Attack Vector Findings Section** (after Findings, or merged into Findings)

Two options:
- **Option A (Merged):** Add a `[Vector]` tag alongside `[Lens]` in existing Findings. Findings from vectors use same AF-XXX numbering.
  - Pro: Single findings list, easy to scan
  - Con: Mixes lens and vector findings

- **Option B (Separate):** New "Attack Vector Findings" section after lens Findings.
  - Pro: Clear separation of lens vs. vector analysis
  - Con: More verbose template

**Recommendation:** Option A (Merged). Findings are findings regardless of source. Tag format: `[Skeptic]`, `[Architect]`, `[Minimalist]`, `[Boundary]`, `[Concurrency]`, `[ErrorChain]`, `[StateMachine]`, `[ResourceLeak]`, `[Coupling]`, `[Destructive]`.

**B. Destructive Action Gate Section** (new section before Verdict)

```markdown
## Destructive Action Gate

| Check | Status | Evidence |
|-------|--------|----------|
| Irreversible operations identified | Yes/No | [file:line] |
| Confirmation/undo mechanism present | Yes/No | [file:line] |
| Data loss potential | None/Low/High | [details] |
| Rollback capability | Yes/No/Partial | [details] |

**Gate Verdict:** CLEAR / BLOCKED
```

If Gate Verdict = BLOCKED, the overall verdict MUST be REJECT regardless of other findings.

**C. Change Scope Table Extension**

Add row: `| Attack vectors applied | 7 |`

**D. Vector Coverage Summary** (optional, lightweight)

```markdown
## Vector Coverage
| Vector | Findings | Highest Severity |
|--------|----------|-----------------|
| Boundary & Edge Case | 0 | - |
| Concurrency & Race | 1 | Medium |
| ... | ... | ... |
```

---

## 4. Destructive Action Gate Integration

### Where It Fits

The Destructive Action Gate should be a **mandatory pre-verdict checkpoint** (new Step 3, before verdict synthesis). It is NOT a lens and NOT a vector -- it is a **gate** that can override the verdict to REJECT.

### Gate Logic

```
IF any destructive operation found (delete, drop, truncate, rm, force-push, overwrite):
  IF no confirmation/undo mechanism exists:
    Gate = BLOCKED → Verdict forced to REJECT
  ELSE:
    Gate = CLEAR (with note)
ELSE:
  Gate = CLEAR (no destructive operations)
```

### What Counts as Destructive

- Database: DROP, TRUNCATE, DELETE without WHERE, schema migration down
- Filesystem: rm -rf, unlink, overwrite without backup
- Git: force-push, reset --hard, branch -D
- API: DELETE endpoints without soft-delete
- Config: Removing env vars, changing auth keys
- Data: Irreversible transforms, encryption without key backup

### Relationship to Vector 7 (Destructive Action Safety)

Vector 7 produces **findings** about destructive operations. The Gate **aggregates** those findings into a pass/fail decision. They work together:
- Vector 7 identifies issues (findings with severity)
- Gate decides if any are blocking (binary CLEAR/BLOCKED)

---

## 5. Consistency Check: Agent / Command / SKILL.md

### Cross-Reference Table

| Aspect | Agent (adversarial-reviewer.md) | Command (adversarial-review.md) | SKILL.md Phase 10 |
|--------|-------------------------------|-------------------------------|-------------------|
| Lenses listed | Skeptic, Architect, Minimalist (with questions) | Skeptic, Architect, Minimalist (summary only) | Skeptic, Architect, Minimalist |
| Activation thresholds | Table (Small/Med/Large) | Listed (always/50+/200+) | Not specified |
| Verdicts | PASS/CONTESTED/REJECT with logic | PASS/CONTESTED/REJECT with action table | PASS/CONTESTED/REJECT with actions |
| Output file | `[spec-index]-[spec-name]-adversarial-review-report.md` | `[doc-index]-adversarial-review-report.md` | `[spec-index]-[spec-name]-adversarial-review-report.md` |
| Iteration behavior | Detailed (PASS->11, CONTESTED->Lead, REJECT->8) | Brief table | Brief (PASS->11, CONTESTED->Lead, REJECT->8) |
| Attack vectors | None | None | None |
| Destructive gate | None | None | None |

### Sync Issues Found

1. **Output file naming mismatch:** Command uses `[doc-index]-adversarial-review-report.md`, Agent and SKILL.md use `[spec-index]-[spec-name]-adversarial-review-report.md`. Should standardize to Agent/SKILL.md pattern.

2. **Threshold detail varies:** Agent has full table, Command has inline thresholds, SKILL.md has no thresholds. All three should reference the same thresholds.

3. **No vector or gate references anywhere** -- all three files need updating.

### Files to Modify for Enhancement

| File | Changes Needed |
|------|---------------|
| `agents/adversarial-reviewer.md` | Add Step 2.5 (Attack Vectors), Step 3 (Destructive Action Gate), update Output Template, update verdict logic |
| `commands/adversarial-review.md` | Add vector and gate descriptions, fix output file naming, add examples |
| `skills/super-dev/SKILL.md` | Update Phase 10 section with vector/gate summary, add iteration rule for gate BLOCKED |

---

## 6. Summary of Required Changes

### Additive Changes (preserving existing lens model)

1. **New Step 2.5: Attack Vectors** -- 7 vectors with specific probe questions, always all applied
2. **New Step 3: Destructive Action Gate** -- binary CLEAR/BLOCKED gate with override to REJECT
3. **Extended Output Template** -- merged findings with vector tags, gate section, vector coverage summary
4. **Updated Verdict Logic** -- gate BLOCKED forces REJECT
5. **Cross-file sync** -- all 3 files updated consistently
6. **Fix output naming** -- standardize command file to match agent/SKILL.md pattern

### What Does NOT Change

- Lens structure (Skeptic/Architect/Minimalist questions preserved exactly)
- Lens activation thresholds (Small/Medium/Large)
- Core verdict model (PASS/CONTESTED/REJECT)
- Iteration behavior (Phase 8/9/10 loop)
- Finding format (AF-XXX with severity, file:line, recommendation)
- Core principles (verdict only, intent-aware, evidence-based, severity-ordered)
- No agentic risk check (explicitly excluded)
