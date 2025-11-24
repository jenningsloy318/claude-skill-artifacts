---
name: load-session
description: Load a previous session summary into context for continuity
---

# Load Session Command

Load a previous session summary to restore context from before compaction.

## Arguments

- `$ARGUMENTS` - Optional session ID or timestamp to load. If omitted, loads the most recent summary.

## Instructions

When this command is invoked:

1. **Check for summaries directory** at `{project}/.claude/summaries/`
   - If it doesn't exist, inform the user no summaries are available

2. **If no argument provided** (load latest):
   - Read `.claude/summaries/index.json`
   - Get the most recent summary entry
   - Read the summary file from `{session_id}/{timestamp}/summary.md`

3. **If session ID or timestamp provided**:
   - Search for matching session in index
   - If found, load that specific summary
   - If not found, list available sessions

4. **Present the summary** to the user with:
   - Session metadata (ID, timestamp, trigger)
   - Full summary content
   - Option to inject into current context

5. **If user wants to inject**:
   - Wrap the summary in `<previous-session-context>` tags
   - Include it in the conversation

## Usage Examples

```
/load-session
# Loads the most recent session summary

/load-session abc123
# Loads summary for session starting with abc123

/load-session 20251123_190448
# Loads summary from specific timestamp
```

## Implementation

Use the Read tool to:
1. Read `.claude/summaries/index.json` for available sessions
2. Read the specific `summary.md` file
3. Present content to user

## Output Format

When listing sessions:
```
Available Sessions:
1. [abc123...] 2025-11-23 19:04 - 15 files modified (auto compact)
2. [def456...] 2025-11-22 14:30 - 3 files modified (manual compact)
```

When loading a session:
```
## Session Summary Loaded

**Session ID:** abc123...
**Created:** 2025-11-23 19:04:48
**Trigger:** auto

[Full summary content here]

---
Would you like me to use this context for our conversation?
```
