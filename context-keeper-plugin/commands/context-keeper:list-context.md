---
name: context-keeper:list-context
description: List all saved contexts across all sessions, or filter by session
argument-hint: "[session-id]"
---

# List Context Command

Display saved context summaries from the context-keeper plugin.

## Arguments

- `$ARGUMENTS` - Optional session ID to filter contexts. If omitted, lists ALL individual contexts across ALL sessions.

## Instructions

When this command is invoked, run the Python script located at `scripts/list_context.py` relative to the plugin directory.

```bash
python3 "$(dirname "$0")/../scripts/list_context.py" $ARGUMENTS
```

The script uses `jq` subprocess for efficient JSON extraction from index.json, with fallback to full JSON parsing if jq is unavailable.

## Output Format

### When listing all contexts (no argument):

```
## All Saved Contexts

| # | Session ID | Timestamp | Trigger | Messages |
|---|------------|-----------|---------|----------|
| 1 | abc123...  | 2025-11-24 19:04 | auto | 150 |
| 2 | abc123...  | 2025-11-24 15:30 | manual | 95 |
| 3 | def456...  | 2025-11-23 14:30 | auto | 45 |
| 4 | ghi789...  | 2025-11-22 10:15 | manual | 200 |

Total: 4 context summaries across 3 sessions

Use `/context-keeper:load-context <session-id>` to load a specific context.
Use `/context-keeper:list-context <session-id>` to see details for one session.
```

### When listing specific session:

```
## Context History for Session abc123...

### Compaction 1: 2025-11-24 19:04:48
- **Trigger:** manual
- **Messages:** 150
- **Summary Path:** abc123.../20251124_190448/summary.md

### Compaction 2: 2025-11-24 15:30:22
- **Trigger:** auto
- **Messages:** 95
- **Summary Path:** abc123.../20251124_153022/summary.md

Would you like me to load one of these contexts?
```

## Error Handling

- **No summaries directory**: "No context summaries found. Run `/compact` to create your first summary."
- **No index.json**: "Summary index not found. Context summaries will be created automatically during compaction."
- **Session not found**: "No contexts found for session '{id}'."

## Related Commands

- `/context-keeper:list-sessions` - List all stored sessions
- `/context-keeper:load-context` - Load a specific context summary
