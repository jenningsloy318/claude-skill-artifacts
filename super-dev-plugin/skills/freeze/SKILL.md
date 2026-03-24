---
name: freeze
description: >
    Directory freeze guardrail that restricts file edits to a specific directory for the current session.
    Activate when debugging or investigating to prevent accidental changes to unrelated code.
    Triggers on: "freeze mode", "lock directory", "restrict edits", "only edit in".
    Blocks Edit/Write operations outside the specified directory.
    Deactivate by ending the session.
---

# Freeze Mode

Session-scoped directory restriction that blocks file edits outside a specified directory. Activate when debugging to prevent accidentally "fixing" unrelated code.

**Announce at start:** "Freeze mode ACTIVATED. File edits restricted to: [directory]. Changes outside this directory will be blocked."

## Setup

When invoked, ask the user which directory to restrict to:

1. **Auto-detect**: If in a worktree, suggest the worktree path
2. **Ask user**: "Which directory should I restrict edits to? (default: current working directory)"
3. **Store**: Save the freeze directory for the session

## What Gets Blocked

Any `Edit`, `Write`, or `NotebookEdit` tool call where the target file path is NOT under the frozen directory.

| Tool | Blocked When |
|------|-------------|
| `Edit` | `file_path` is outside freeze directory |
| `Write` | `file_path` is outside freeze directory |
| `NotebookEdit` | `notebook_path` is outside freeze directory |
| `Bash` with redirect | Command contains `>` or `>>` to a path outside freeze directory |

## What Is Allowed

- **Reading** any file (Read, Grep, Glob) — unrestricted
- **Editing** files inside the freeze directory — unrestricted
- **Running** commands that don't write outside the directory
- **Creating** new files inside the freeze directory

## Behavior

When a blocked edit is detected:
1. **STOP** — Do not execute the edit
2. **WARN** — Display: "BLOCKED by freeze mode: Cannot edit [file_path]. Only edits in [freeze_directory] are allowed."
3. **ASK** — "Do you want to override freeze mode for this specific file? (yes/no)"

## Common Use Cases

- **Debugging**: "I want to add logs but keep accidentally 'fixing' unrelated code"
- **Feature isolation**: "Only touch files in src/feature-x/"
- **Review mode**: "Read anything, but don't change code outside my PR's scope"
- **Worktree safety**: "Only edit inside the current worktree"

## Gotchas

- **Config files**: Freeze mode may block edits to config files (package.json, tsconfig.json) that live outside the feature directory. Override when needed.
- **Test files**: Tests may live in a separate `tests/` directory. Consider freezing at a higher level or overriding for test files.
- **Build artifacts**: Freeze mode doesn't block build tools from writing outside the directory — it only blocks Claude's direct edits.

## Deactivation

Freeze mode lasts for the entire session. To deactivate:
- End the session and start a new one
- Or explicitly say "deactivate freeze mode" or "unfreeze"
