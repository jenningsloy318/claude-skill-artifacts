---
name: careful
description: >
    Safety guardrail that blocks destructive commands for the current session.
    Activate when working with production systems, sensitive data, or critical infrastructure.
    Triggers on: "be careful", "careful mode", "production mode", "safety mode".
    Blocks: rm -rf, DROP TABLE, TRUNCATE, DELETE FROM (no WHERE), git push --force,
    git reset --hard, git branch -D, kubectl delete, chmod 777, npm unpublish.
    Deactivate by ending the session.
---

# Careful Mode

Session-scoped safety guardrail that blocks destructive commands. Activate when working near production systems or sensitive data.

**Announce at start:** "Careful mode ACTIVATED. Destructive commands will be blocked for this session."

## What Gets Blocked

| Category | Blocked Patterns | Why |
|----------|-----------------|-----|
| File Destruction | `rm -rf`, `rm -r /`, `find -delete` (recursive) | Irreversible data loss |
| Database Destruction | `DROP TABLE`, `DROP DATABASE`, `TRUNCATE`, `DELETE FROM` (without WHERE) | Irreversible data loss |
| Git Destruction | `git push --force`, `git push -f`, `git reset --hard`, `git branch -D`, `git clean -fd` | History/branch loss |
| Kubernetes | `kubectl delete namespace`, `kubectl delete pod --all` | Service disruption |
| Permissions | `chmod 777`, `chmod -R 777`, `chmod +s` | Security escalation |
| Package | `npm unpublish`, `cargo yank` | Distribution disruption |

## What Is Allowed

- `rm` on specific files (not recursive with -rf on root or broad paths)
- `DROP TABLE IF EXISTS` in migration files (detected by file context)
- `git push` (without --force)
- `git reset --soft`
- `kubectl delete pod [specific-pod]` (single pod, not --all)
- Normal file operations, builds, tests

## Behavior

When a blocked command is detected:
1. **STOP** — Do not execute the command
2. **WARN** — Display: "BLOCKED by careful mode: [command]. Reason: [category]"
3. **SUGGEST** — Offer a safer alternative if one exists
4. **ASK** — "Do you want to override careful mode for this specific command? (yes/no)"

## Safer Alternatives

| Blocked | Safer Alternative |
|---------|-------------------|
| `rm -rf dir/` | `mv dir/ /tmp/dir-backup-$(date +%s)` (move to tmp first) |
| `DROP TABLE x` | `ALTER TABLE x RENAME TO x_deprecated_$(date)` |
| `git push --force` | `git push --force-with-lease` |
| `git reset --hard` | `git stash push -m "before-reset"` then reset |
| `DELETE FROM x` | `SELECT COUNT(*) FROM x WHERE ...` first to verify scope |

## Deactivation

Careful mode lasts for the entire session. To deactivate:
- End the session and start a new one
- Or explicitly say "deactivate careful mode"

## Gotchas

- **Overzealous blocking**: Careful mode may block legitimate destructive operations in test/dev environments. Use the override prompt when needed.
- **Migration files**: DROP/TRUNCATE in migration files is common — careful mode will still warn but should note the migration context.
- **Not a replacement for backups**: Careful mode reduces accidental destruction but doesn't replace proper backup strategies.
