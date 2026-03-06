# Workflow Phases - Detailed Reference

This document contains detailed phase-by-phase execution guidelines for the super-dev workflow.

## Phase 0: Apply Dev Rules

**Establish coding standards and guidelines at the start of any development task:**

### Time MCP Rules (MUST follow)
- In every prompt, add the current date and time as extra context

### Git Rules (MUST follow)
- Never create GitHub Actions when creating new projects or updating code
- If GitHub Actions already exist, don't add to git cache, don't commit, don't push
- When committing, only commit files you edited - ignore files not created/edited by you in this session
- Don't use `git add -A` - use `git add file1 file2` (only files you edited/created/deleted)
- Before committing, **ALWAYS** generate proper commit messages

### Rust Project Rules (MUST follow)

#### Workspace Structure
- **Always use Rust workspace** with multiple crates for any Rust project
- Never create single-crate Rust projects
- Workspace structure:
  ```
  project/
  ├── Cargo.toml          # Workspace manifest
  ├── Cargo.lock          # Lockfile (committed)
  ├── crates/
  │   ├── crate-a/       # Main application
  │   │   └── Cargo.toml
  │   ├── crate-b/       # Library
  │   │   └── Cargo.toml
  │   └── crate-c/       # Binary
  │       └── Cargo.toml
  └── ...
  ```

#### Crate Organization
- **Library crates** in `crates/[name]/` with `Cargo.toml`
- **Binary crates** in `crates/[name]/` with `Cargo.toml` and `src/main.rs`
- Use `members` in workspace `Cargo.toml` to include all crates
- Share dependencies in workspace `Cargo.toml` when appropriate

#### Key Principles
- Each crate should have a single, clear responsibility
- Use workspace `Cargo.toml` for shared configuration
- Keep `Cargo.lock` committed for binaries
- Use `cargo check --workspace` for validation
- Use `cargo test --workspace` for testing

---

## Phase 1: Specification Setup

**Executed by:** Coordinator (Team Lead)

1. **Define Spec Directory Name**: `[spec-index]-[spec-name]` (e.g., `01-user-auth`)
2. **Create Git Worktree**: `git worktree add .worktree/[spec-index]-[spec-name] -b [spec-index]-[spec-name]`
3. **Create Spec Directory**: `mkdir -p specification/[spec-index]-[spec-name]/`
4. **Initialize Workflow Tracking JSON**: Create workflow tracking file
5. **Setup Complete**: Verify all artifacts exist

**Branch Name Rule:** Git branch name MUST match worktree name.

---

## Phase 2: Requirements Clarification

**Agent:** `requirements-clarifier`

```
Task: Gather and document complete requirements for [feature/bug]
Output: specification/[spec-index]-[spec-name]/[doc-index]-requirements.md
```

### Requirements Clarifier Methodology

#### Process

**Step 1: Initial Analysis**

Analyze the task description and identify:
- What is being requested?
- What problem is being solved?
- Who are the stakeholders?
- What are the constraints?

**Step 2: Structured Questioning Techniques**

**Design Thinking Questions:**
- What is the user trying to achieve?
- What are their pain points?
- What does success look like?

**5 Whys Analysis:**
- Why is this feature needed?
- Why does that problem exist?
- Continue until root cause is identified

**Jobs-to-be-Done (JTBD):**
- What "job" is the user hiring this feature to do?
- What are the functional, emotional, and social dimensions?

**Step 3: Define Acceptance Criteria**

Create clear, testable acceptance criteria:

**Good Criteria:**
- "User can log in with email and password"
- "Login completes within 2 seconds"
- "Error message displays for invalid credentials"

**Poor Criteria:**
- "Login works well"
- "Fast login"

**Step 4: Identify Downstream Needs**

Consider what other work may be triggered:
- Database schema changes?
- API modifications?
- Frontend updates?
- Documentation updates?
- Testing requirements?

**Step 5: Define Quality Gates**

Define measurable quality gates:
- Test coverage thresholds
- Performance benchmarks
- Security requirements
- Accessibility standards

---

## Phase 3: Research

**Agent:** `research-agent`

```
Task: Research best practices for [feature/technology]
Output: specification/[spec-index]-[spec-name]/[doc-index]-research-report.md with 3-5 options
```

**Coordinator presents options to user for selection.**

See `references/research-methodology.md` for detailed research methodology.

---

## Phase 4: Debug Analysis (Bugs Only)

**Agent:** `debug-analyzer`

```
Task: Perform root cause analysis for [bug]
Output: specification/[spec-index]-[spec-name]/[doc-index]-debug-analysis.md
```

See `references/debugging-patterns.md` for detailed debugging methodology.

---

## Phase 5: Code Assessment

**Agent:** `code-assessor`

```
Task: Assess existing codebase for [feature/area]
Output: specification/[spec-index]-[spec-name]/[doc-index]-assessment.md
```

### Code Assessment Areas

1. **Architecture Evaluation** - Design patterns, layer separation, module organization
2. **Technology Stack** - Languages, frameworks, libraries, build tools
3. **Code Patterns** - Error handling, state management, API design
4. **Style and Conventions** - Naming, file organization, documentation
5. **Quality Indicators** - Test coverage, type safety, complexity

---

## Phase 5.3: Architecture Design (Complex Features)

**Agent:** `architecture-agent`

```
Task: Design architecture for [feature]
Output: specification/[spec-index]-[spec-name]/[doc-index]-architecture.md
```

**Rust Project Reminder:** Ensure architecture considers workspace structure with multiple crates if applicable.

See `references/architecture-patterns.md` for detailed architecture patterns.

---

## Phase 5.5: UI/UX Design (UI Features)

**Agent:** `ui-ux-designer`

```
Task: Create UI/UX design specifications for [feature]
Output: specification/[spec-index]-[spec-name]/[doc-index]-design-spec.md
```

See `references/ui-ux-patterns.md` for detailed UI/UX patterns.

---

## Phase 5.3/5.5 Combined: Product Design (Full-Stack Features)

**Agent:** `product-designer`

When a feature requires BOTH architecture design AND UI/UX design:

```
Task: Coordinate architecture and UI/UX design for [feature]
Output:
  - specification/[spec-index]-[spec-name]/[doc-index]-architecture.md
  - specification/[spec-index]-[spec-name]/[doc-index]-design-spec.md
  - specification/[spec-index]-[spec-name]/[doc-index]-product-design-summary.md
```

The product-designer:
1. Classifies scope (ARCHITECTURE_ONLY, UI_ONLY, or FULL_STACK)
2. Invokes architecture-agent for technical design options
3. Invokes ui-ux-designer with architecture constraints
4. Presents unified architecture+UI options to user
5. Finalizes both documents after user selection
6. Creates cross-reference document with API→UI contracts

---

## Phase 6: Specification Writing

**Agent:** `spec-writer`

```
Task: Create comprehensive technical specification
Inputs: requirements.md, research-report.md, assessment.md, [architecture.md], [design-spec.md]
Output:
  - specification/[spec-index]-[spec-name]/[doc-index]-specification.md
  - specification/[spec-index]-[spec-name]/[doc-index]-implementation-plan.md
  - specification/[spec-index]-[spec-name]/[doc-index]-task-list.md
```

**Rust Project Reminder:** Ensure specification includes Cargo.toml workspace structure and crate dependencies.

See `references/specification-templates.md` for detailed specification templates.

---

## Phase 7: Specification Review

**Executed by:** Coordinator (no agent)

Validate all specification documents are complete and consistent.

---

## Phase 8: Execution & QA (PARALLEL)

**Agents:** `dev-executor` + `qa-agent` (run simultaneously)

```
Task: Implement code according to specification
Parallel with:
Task: Plan and execute tests
```

**Build Policy (Rust/Go):** Only ONE build at a time to prevent resource conflicts.

**Rust Project Reminder:** Use `cargo build` or `cargo check` from workspace root. Run tests with `cargo test --workspace`.

---

## Phase 9: Code Review

**Agent:** `code-reviewer`

```
Task: Review implementation against specification
```

**Iteration:** If issues found, return to Phase 8.

### Issue Severity Classification

| Severity | Definition | Action Required |
|----------|------------|-----------------|
| **Critical** | Security vulnerability, data loss, crash | Must fix before merge |
| **High** | Significant bug, performance issue | Must fix before merge |
| **Medium** | Code quality, minor bug | Should fix, can defer |
| **Low** | Style, nitpick | Fix if time permits |

---

## Phase 9.5: Quality Assurance

**Agent:** `qa-agent`

```
Task: Execute comprehensive testing for [feature]
```

---

## Phase 10: Adversarial Review

**Agent:** `adversarial-reviewer`

```
Task: Challenge implementation from distinct critical lenses
Output: specification/[spec-index]-[spec-name]/[doc-index]-adversarial-review-report.md
```

**Hard constraint:** The adversarial review MUST produce a verdict, NOT code modifications.

### Step 1 — Determine Scope and Intent

Identify what to review from the Phase 8/9 output (recent diffs, implementation files, spec).

State the **intent** explicitly — what the author is trying to achieve. Reviewers challenge whether the work *achieves the intent well*, not whether the intent is correct.

Assess change size to determine reviewer count:

| Size | Threshold | Reviewers |
|------|-----------|-----------|
| Small | < 50 lines, 1-2 files | 1 (Skeptic) |
| Medium | 50-200 lines, 3-5 files | 2 (Skeptic + Architect) |
| Large | 200+ lines or 5+ files | 3 (Skeptic + Architect + Minimalist) |

### Step 2 — Apply Reviewer Lenses

Each reviewer adopts one lens exclusively:

**Skeptic — Challenge correctness and completeness:**
- What inputs, states, or sequences will break this?
- What error paths are unhandled or silently swallowed?
- What race conditions or ordering dependencies exist?
- What does the author believe is true that isn't proven?

**Architect — Challenge structural fitness:**
- Does the design actually serve the stated goal, or a goal the author assumed?
- Where are the coupling points that will hurt when requirements shift?
- What boundary violations exist? Where does responsibility leak between components?

**Minimalist — Challenge necessity and complexity:**
- What can be deleted without losing the stated goal?
- Where is the author solving problems they don't have yet?
- What abstractions exist for a single call site?
- Is this the simplest possible path to the outcome?

### Step 3 — Synthesize Verdict

**Verdict logic:**
- **PASS** — no high-severity findings → proceed to Phase 11
- **CONTESTED** — high-severity findings but reviewers disagree → Team Lead decides
- **REJECT** — high-severity findings with reviewer consensus → loop back to Phase 8

**Iteration:** If REJECT, YOU MUST return to Phase 8 with findings as input for dev-executor to fix.

---

## Phase 11: Documentation Update

**Agent:** `docs-executor`

```
Task: Update documentation for [feature]
```

---

## Phase 12: Cleanup

**Executed by:** Coordinator

- Remove temporary files
- Update codemaps if applicable
- Verify no orphaned processes

---

## Phase 13: Commit & Merge

**Executed by:** Coordinator

### Commit Message Format (Full Workflow)
When working within a spec workflow, use: `spec-[spec-index]-[spec-name] <type>: <description>`

```bash
# Stage only the files that were modified/created
git add file1 file2 file3

# Commit with spec-prefixed message
git commit -m "spec-[spec-index]-[spec-name] feat: [description]"

# Merge to main
git checkout main
git merge [spec-index]-[spec-name]
```

Example:
```bash
git commit -m "spec-01-user-auth feat: implement JWT authentication"
```

---

## Phase 14: Final Verification

**Executed by:** Coordinator

- Verify all acceptance criteria met
- Verify all files committed
- Cleanup team resources
