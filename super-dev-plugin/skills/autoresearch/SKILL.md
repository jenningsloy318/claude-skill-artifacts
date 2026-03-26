---
name: autoresearch
description: >
    Auto-improve any agent prompt using Karpathy's autoresearch method. Runs iterative
    test-measure-improve loops on agent prompts to systematically increase quality.
    Triggers on: "autoresearch", "auto-improve", "optimize agent", "tune prompt",
    "improve skill quality".
license: MIT
metadata:
  author: Jennings Liu
  version: "1.0.0"
  inspired_by: "Andrej Karpathy's autoresearch method"
  keywords:
    - autoresearch
    - prompt-optimization
    - iterative-improvement
    - quality-scoring
---

# Autoresearch: Auto-Improve Agent Prompts

Based on Andrej Karpathy's autoresearch method. Instead of manually improving agent prompts, let an AI agent do it in an iterative loop: try a small change, score the result, keep improvements, revert regressions.

## How It Works

```
┌─────────────────────────────────────────────────────┐
│                  AUTORESEARCH LOOP                   │
│                                                     │
│  1. Run agent on test input                          │
│  2. Score output against checklist (yes/no)          │
│  3. Record baseline score                            │
│  4. Analyze weakest checklist items                  │
│  5. Make ONE small change to the agent prompt         │
│  6. Re-run agent on same test input                  │
│  7. Score again                                      │
│  8. If score improved → KEEP change                  │
│     If score dropped → REVERT change                 │
│  9. Repeat from step 4 until target score reached    │
│                                                     │
│  Stop condition: 95%+ score 3 times in a row         │
│  OR max rounds reached (default: 10)                 │
└─────────────────────────────────────────────────────┘
```

## Usage

```
/super-dev:autoresearch

Arguments:
  --agent <agent-name>     Agent to optimize (e.g., "code-reviewer", "qa-agent")
  --test-input <prompt>    Test input to run the agent on
  --rounds <N>             Max improvement rounds (default: 10)
```

## Step-by-Step Process

### Step 1: Select the Agent to Optimize

User specifies which agent prompt to improve. Read the agent's markdown file from `agents/<name>.md`.

### Step 2: Define the Scoring Checklist

Ask the user (or auto-generate from the agent's existing quality gates) a set of 3-6 yes/no scoring questions. Each question checks one specific aspect of the agent's output.

**Good checklist questions (yes/no only):**
- "Does the code review identify at least one production-risk bug?"
- "Does the requirements doc include acceptance criteria?"
- "Does the test plan cover both happy and error paths?"
- "Is the architecture document under 500 lines?"
- "Does the research output cite at least 3 sources?"

**Bad checklist questions (avoid):**
- "Rate the quality 1-10" (subjective, inconsistent)
- "Is the output good?" (too vague)
- "Does it follow best practices?" (not measurable)

### Step 3: Establish Baseline

Run the agent on the test input 3 times. Score each run against the checklist. The average score is the baseline.

```
Baseline: 5/8 checks passing = 62.5%
```

### Step 4: Enter the Improvement Loop

For each round:

1. **Analyze** which checklist items are failing most often
2. **Hypothesize** one small change that could fix the weakest item
3. **Apply** the change to the agent prompt (save backup first)
4. **Test** by running the agent 3 times with the change
5. **Score** the average across runs
6. **Decision:**
   - Score improved → **KEEP** the change, log it
   - Score same or worse → **REVERT** the change, try different approach
7. **Log** the round: what changed, why, score before/after, kept/reverted

### Step 5: Output Results

When done (target reached or max rounds), produce:

```markdown
# Autoresearch Results: [agent-name]

## Summary
- **Baseline score:** 62.5% (5/8)
- **Final score:** 93.75% (7.5/8)
- **Rounds:** 6
- **Changes kept:** 4
- **Changes reverted:** 2

## Changelog

### Round 1: Added gotchas section ✓ KEPT
- **Score:** 62.5% → 75%
- **Change:** Added "Gotchas" section listing 6 common failures
- **Why:** Checklist item "identifies production-risk bugs" was failing
- **Effect:** Bug identification improved in 2/3 test runs

### Round 2: Added explicit timezone rule ✓ KEPT
- **Score:** 75% → 81.25%
- **Change:** Added rule "Always flag timezone-naive datetime operations"
- **Why:** Checklist item "catches time-related bugs" was failing

### Round 3: Reduced prompt verbosity ✗ REVERTED
- **Score:** 81.25% → 75%
- **Change:** Removed 3 paragraphs of explanation, kept only rules
- **Why:** Hypothesized less text = more focused output
- **Effect:** Quality dropped, model needed the context

[...]

## Files
- **Original:** agents/[name].md.backup
- **Improved:** agents/[name].md
- **Results log:** ${CLAUDE_PLUGIN_DATA}/autoresearch/[name]-results.json
```

### Data Storage

Store results in `${CLAUDE_PLUGIN_DATA}/autoresearch/`:

```
${CLAUDE_PLUGIN_DATA}/autoresearch/
├── code-reviewer-results.json
├── code-reviewer-changelog.md
├── qa-agent-results.json
└── qa-agent-changelog.md
```

## What Makes Good Changes

**Good changes (one at a time):**
- Add a specific gotcha for the most common failure
- Add a worked example showing what good output looks like
- Add a banned-patterns list (like banned buzzwords)
- Add a specific rule targeting the weakest checklist item
- Restructure output template to force a missing section

**Bad changes (avoid):**
- Rewriting the entire prompt (too many variables)
- Adding vague instructions ("be more thorough")
- Adding 5 rules at once (can't tell which one helped)
- Removing sections without testing first

## Integration with Super-Dev

The autoresearch skill is a meta-tool: it improves the tools that build your software. Run it periodically on agents that produce inconsistent results.

**Recommended schedule:**
- After every 5 super-dev sessions, run autoresearch on the agent that caused the most Phase 8/9 loops
- When a new gotcha is discovered manually, add it and run autoresearch to verify it helps

## Gotchas

- **Overfitting to test input**: If you only test with one input, the agent may optimize for that specific case. Use 2-3 diverse test inputs.
- **Checklist gaming**: If the checklist has too many items (>6), the agent may start gaming individual checks at the expense of overall quality.
- **Local optima**: Sometimes a change that drops the score short-term enables bigger gains later. If stuck, try a "creative round" where you make a structural change regardless of immediate score impact.
