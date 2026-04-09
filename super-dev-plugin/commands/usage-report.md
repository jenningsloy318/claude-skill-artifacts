---
name: super-dev:usage-report
description: View skill and agent usage statistics for the super-dev plugin
---

# Usage Report

View usage statistics for the super-dev plugin.

## Usage

```
/super-dev:usage-report
```

## What This Command Does

Reads `${CLAUDE_PLUGIN_DATA}/global/stats.json` and `${CLAUDE_PLUGIN_DATA}/global/usage.log` to display:

1. **Total invocations** — How many times skills and agents have been used
2. **Top skills** — Most frequently used skills, sorted by count
3. **Top agents** — Most frequently used agents, sorted by count
4. **Recent activity** — Last 10 invocations from usage.log

## How to Read

```bash
# View stats summary
cat "${CLAUDE_PLUGIN_DATA}/global/stats.json" | jq .

# View recent usage
tail -10 "${CLAUDE_PLUGIN_DATA}/global/usage.log"

# Count by type
grep '"type":"skill"' "${CLAUDE_PLUGIN_DATA}/global/usage.log" | jq -r '.name' | sort | uniq -c | sort -rn

# Count by agent
grep '"type":"agent"' "${CLAUDE_PLUGIN_DATA}/global/usage.log" | jq -r '.name' | sort | uniq -c | sort -rn
```

## Report Format

```
# Super Dev Usage Report

**Total invocations:** [count]
**Last updated:** [timestamp]

## Top Skills
| Skill | Count |
|-------|-------|
| super-dev | XX |
| tdd-workflow | XX |
| ...   | ...   |

## Top Agents
| Agent | Count |
|-------|-------|
| super-dev:dev-executor | XX |
| super-dev:code-reviewer | XX |
| ... | ... |

## Recent Activity (Last 10)
| Timestamp | Type | Name |
|-----------|------|------|
| ... | skill | ... |
| ... | agent | ... |
```

## Notes

- Usage data is stored in `${CLAUDE_PLUGIN_DATA}/global/` and persists across sessions and projects
- Stats are updated automatically via PreToolUse hook
- No sensitive data is collected — only tool names and timestamps
