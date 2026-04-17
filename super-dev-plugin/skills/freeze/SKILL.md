<meta>
  <name>freeze</name>
  <type>skill</type>
  <description>Directory freeze guardrail that restricts file edits to a specific directory for the current session</description>
</meta>

<purpose>Session-scoped directory restriction that blocks file edits outside a specified directory. Activate when debugging to prevent accidentally "fixing" unrelated code.</purpose>

<triggers>Triggers on: "freeze mode", "lock directory", "restrict edits", "only edit in"</triggers>

<activation>Announce: "Freeze mode ACTIVATED. File edits restricted to: [directory]. Changes outside this directory will be blocked."</activation>

<constraints>
  <constraint>**Edit blocked** when `file_path` is outside freeze directory</constraint>
  <constraint>**Write blocked** when `file_path` is outside freeze directory</constraint>
  <constraint>**NotebookEdit blocked** when `notebook_path` is outside freeze directory</constraint>
  <constraint>**Bash redirects blocked** when command contains `>` or `>>` to path outside freeze directory</constraint>
</constraints>

<allowlist>
  <allowed>Reading any file (Read, Grep, Glob) — unrestricted</allowed>
  <allowed>Editing files inside the freeze directory — unrestricted</allowed>
  <allowed>Running commands that don't write outside the directory</allowed>
  <allowed>Creating new files inside the freeze directory</allowed>
</allowlist>

<workflow>
  **Setup**: 1) Auto-detect worktree path if in worktree. 2) Ask user: "Which directory to restrict to? (default: cwd)". 3) Store freeze directory for session.

  **When blocked edit detected**: 1) STOP — do not execute. 2) WARN — "BLOCKED by freeze mode: Cannot edit [path]. Only edits in [freeze_dir] allowed." 3) ASK — "Override for this specific file? (yes/no)".

  **Common use cases**: Debugging (add logs without fixing unrelated code), feature isolation (only touch feature dir), review mode (read anything, don't change outside PR scope), worktree safety.
</workflow>

<gotchas>
  <gotcha>Config files (package.json, tsconfig) may live outside feature directory — override when needed</gotcha>
  <gotcha>Tests may live in separate `tests/` directory — consider freezing at higher level</gotcha>
  <gotcha>Doesn't block build tools from writing outside — only blocks Claude's direct edits</gotcha>
</gotchas>
