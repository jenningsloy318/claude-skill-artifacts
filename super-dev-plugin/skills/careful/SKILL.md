<meta>
  <name>careful</name>
  <type>skill</type>
  <description>Safety guardrail that blocks destructive commands for the current session</description>
</meta>

<purpose>Session-scoped safety guardrail that blocks destructive commands. Activate when working near production systems, sensitive data, or critical infrastructure.</purpose>

<triggers>Triggers on: "be careful", "careful mode", "production mode", "safety mode"</triggers>

<activation>Announce: "Careful mode ACTIVATED. Destructive commands will be blocked for this session."</activation>

<constraints>
  <constraint>**File Destruction blocked**: `rm -rf`, `rm -r /`, `find -delete` (recursive) — irreversible data loss</constraint>
  <constraint>**Database Destruction blocked**: `DROP TABLE`, `DROP DATABASE`, `TRUNCATE`, `DELETE FROM` (without WHERE) — irreversible data loss</constraint>
  <constraint>**Git Destruction blocked**: `git push --force`, `git push -f`, `git reset --hard`, `git branch -D`, `git clean -fd` — history/branch loss</constraint>
  <constraint>**Kubernetes blocked**: `kubectl delete namespace`, `kubectl delete pod --all` — service disruption</constraint>
  <constraint>**Permissions blocked**: `chmod 777`, `chmod -R 777`, `chmod +s` — security escalation</constraint>
  <constraint>**Package blocked**: `npm unpublish`, `cargo yank` — distribution disruption</constraint>
</constraints>

<allowlist>
  <allowed>`rm` on specific files (not recursive on broad paths)</allowed>
  <allowed>`DROP TABLE IF EXISTS` in migration files</allowed>
  <allowed>`git push` (without --force)</allowed>
  <allowed>`git reset --soft`</allowed>
  <allowed>`kubectl delete pod [specific-pod]` (not --all)</allowed>
  <allowed>Normal file operations, builds, tests</allowed>
</allowlist>

<workflow>
  When blocked command detected: 1) STOP — do not execute. 2) WARN — "BLOCKED by careful mode: [command]. Reason: [category]". 3) SUGGEST — offer safer alternative. 4) ASK — "Override for this specific command? (yes/no)".

  Safer alternatives: `rm -rf` → `mv to /tmp backup`, `DROP TABLE` → `ALTER TABLE RENAME TO deprecated`, `git push --force` → `--force-with-lease`, `git reset --hard` → `git stash push` first, `DELETE FROM` → `SELECT COUNT` first to verify scope.
</workflow>

<gotchas>
  <gotcha>May block legitimate destructive operations in test/dev environments — use override</gotcha>
  <gotcha>Migration files: DROP/TRUNCATE is common — still warns but notes migration context</gotcha>
  <gotcha>Not a replacement for backups</gotcha>
</gotchas>
