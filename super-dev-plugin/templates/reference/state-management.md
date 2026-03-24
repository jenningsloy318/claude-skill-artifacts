# State Management Reference

Super-dev uses `${CLAUDE_PLUGIN_DATA}` for persistent state that survives plugin upgrades.

## Storage Location

All persistent data is stored in `${CLAUDE_PLUGIN_DATA}/`:

```
${CLAUDE_PLUGIN_DATA}/
├── config.json              # User configuration (first-run setup)
├── session-history.log      # Append-only session log
├── patterns.json            # Learned patterns and conventions
└── stats.json               # Skill usage statistics
```

## Session History Log

An append-only log of every super-dev workflow run.

### Format (one JSON line per session)

```jsonl
{"timestamp":"2026-03-24T10:00:00Z","spec":"01-user-auth","task":"Implement user authentication","phases_completed":[0,1,2,3,5,6,7,8,9,10,12],"duration_phases":13,"verdict":{"code_review":"Approved","adversarial":"PASS"},"files_changed":12,"language":"typescript","framework":"nextjs"}
```

### How to Write

```bash
# Append at end of Phase 12 (commit)
echo '{"timestamp":"...","spec":"...","task":"..."}' >> "${CLAUDE_PLUGIN_DATA}/session-history.log"
```

### How to Read

```bash
# Read last 5 sessions for context
tail -5 "${CLAUDE_PLUGIN_DATA}/session-history.log"

# Count total sessions
wc -l "${CLAUDE_PLUGIN_DATA}/session-history.log"
```

## Patterns File

Stores conventions and patterns discovered during development.

### Format

```json
{
  "version": "1.0.0",
  "patterns": [
    {
      "id": "P001",
      "category": "naming",
      "pattern": "Components use PascalCase with .tsx extension",
      "source": "spec-03-dashboard",
      "confidence": "high",
      "added": "2026-03-24"
    }
  ]
}
```

### When to Update

- After Phase 5 (Code Assessment): Record codebase conventions discovered
- After Phase 9 (Code Review): Record patterns flagged by reviewers
- After Phase 8 (Execution): Record successful patterns used

## Usage Statistics

Tracks which skills and agents are invoked for optimization.

### Format

```json
{
  "version": "1.0.0",
  "total_sessions": 0,
  "skill_invocations": {
    "super-dev": 0,
    "tdd-workflow": 0,
    "adversarial-review": 0,
    "security-review": 0,
    "dev-rules": 0
  },
  "agent_invocations": {
    "coordinator": 0,
    "dev-executor": 0,
    "qa-agent": 0,
    "code-reviewer": 0,
    "adversarial-reviewer": 0
  },
  "phase_durations_avg": {},
  "common_languages": {},
  "last_updated": ""
}
```

## Best Practices

- **Always append, never overwrite** the session-history.log
- **Read history at Phase 0** to inform the current session
- **Update patterns.json** only when confidence is high (seen 2+ times)
- **Update stats.json** at the end of every workflow run
- **Never store secrets** in any state file
- **Graceful degradation**: If any file is missing or corrupt, skip silently and continue
