# State Management Reference

Super-dev uses `${CLAUDE_PLUGIN_DATA}` for persistent state that survives plugin upgrades. Data is organized per-project using the git repository basename as the directory key.

## Storage Location

```
${CLAUDE_PLUGIN_DATA}/
├── global/
│   └── stats.json               # Cross-project usage statistics
└── projects/
    └── [project-name]/           # Per-project data (basename of git root)
        ├── config.json           # Project config (first-run setup)
        ├── session-history.log   # Append-only session log
        └── patterns.json         # Learned patterns and conventions
```

## Project Data Path Derivation

```bash
# Derive project key from git root directory name
PROJECT_NAME="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")"
PROJECT_DATA="${CLAUDE_PLUGIN_DATA}/projects/${PROJECT_NAME}"
GLOBAL_DATA="${CLAUDE_PLUGIN_DATA}/global"
```

**Path verification:** Every `config.json` stores the full project path in `project.path`. On load, verify the stored path matches the current working directory's git root. If mismatched (name collision from different projects with the same basename), append a short hash suffix (first 6 chars of SHA-256 of the full path) to create a new directory.

## Session History Log

An append-only log of every super-dev workflow run, stored per-project.

### Format (one JSON line per session)

```jsonl
{"timestamp":"2026-03-24T10:00:00Z","spec":"01-user-auth","task":"Implement user authentication","stages_completed":[1,2,3,4,6,7,8,9,10,11,13],"duration_stages":13,"verdict":{"code_review":"Approved","adversarial":"PASS"},"files_changed":12,"language":"typescript","framework":"nextjs"}
```

### How to Write

```bash
# Append at end of Stage 13 (commit)
echo '{"timestamp":"...","spec":"...","task":"..."}' >> "${PROJECT_DATA}/session-history.log"
```

### How to Read

```bash
# Read last 5 sessions for context
tail -5 "${PROJECT_DATA}/session-history.log"

# Count total sessions
wc -l "${PROJECT_DATA}/session-history.log"
```

## Patterns File

Stores conventions and patterns discovered during development, per-project.

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

- After Stage 6 (Code Assessment): Record codebase conventions discovered
- After Stage 10 (Code Review): Record patterns flagged by reviewers
- After Stage 9 (Execution): Record successful patterns used

## Usage Statistics

Tracks which skills and agents are invoked for optimization. Stored globally (not per-project).

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
    "team-lead": 0,
    "dev-executor": 0,
    "qa-agent": 0,
    "code-reviewer": 0,
    "adversarial-reviewer": 0
  },
  "stage_durations_avg": {},
  "common_languages": {},
  "last_updated": ""
}
```

## Best Practices

- **Always append, never overwrite** the session-history.log
- **Read history at Stage 1** to inform the current session
- **Update patterns.json** only when confidence is high (seen 2+ times)
- **Update stats.json** (global) at the end of every workflow run
- **Never store secrets** in any state file
- **Graceful degradation**: If any file is missing or corrupt, skip silently and continue
- **Verify project path** on config load: if `config.json` `project.path` doesn't match current git root, create a new project directory with hash suffix
