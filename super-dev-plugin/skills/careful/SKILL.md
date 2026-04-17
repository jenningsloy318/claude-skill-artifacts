<meta>
  <name>careful</name>
  <type>skill</type>
  <description>Safety guardrail that blocks destructive commands for the current session</description>
</meta>

<purpose>Session-scoped safety guardrail that blocks destructive commands. Activate when working near production systems, sensitive data, or critical infrastructure.</purpose>

<triggers>Triggers on: "be careful", "careful mode", "production mode", "safety mode"</triggers>

<activation>Announce: "Careful mode ACTIVATED. Destructive commands will be blocked for this session."</activation>

<constraints>
  <constraint name="File Destruction blocked">`rm -rf`, `rm -r /`, `find -delete` (recursive) — irreversible data loss</constraint>
  <constraint name="Database Destruction blocked">`DROP TABLE`, `DROP DATABASE`, `TRUNCATE`, `DELETE FROM` (without WHERE) — irreversible data loss</constraint>
  <constraint name="Git Destruction blocked">`git push --force`, `git push -f`, `git reset --hard`, `git branch -D`, `git clean -fd` — history/branch loss</constraint>
  <constraint name="Kubernetes blocked">`kubectl delete namespace`, `kubectl delete pod --all` — service disruption</constraint>
  <constraint name="Permissions blocked">`chmod 777`, `chmod -R 777`, `chmod +s` — security escalation</constraint>
  <constraint name="Package blocked">`npm unpublish`, `cargo yank` — distribution disruption</constraint>
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
  <step n="1" name="Blocked Command Detection">STOP — do not execute.</step>
  <step n="2" name="Warn">BLOCKED by careful mode: [command]. Reason: [category].</step>
  <step n="3" name="Suggest">Offer safer alternative.</step>
  <step n="4" name="Ask">Override for this specific command? (yes/no).</step>

  <alternatives>
    <alt blocked="rm -rf" safer="mv to /tmp backup" />
    <alt blocked="DROP TABLE" safer="ALTER TABLE RENAME TO deprecated" />
    <alt blocked="git push --force" safer="--force-with-lease" />
    <alt blocked="git reset --hard" safer="git stash push first" />
    <alt blocked="DELETE FROM" safer="SELECT COUNT first to verify scope" />
  </alternatives>
</workflow>

<gotchas>
  <gotcha>May block legitimate destructive operations in test/dev environments — use override</gotcha>
  <gotcha>Migration files: DROP/TRUNCATE is common — still warns but notes migration context</gotcha>
  <gotcha>Not a replacement for backups</gotcha>
</gotchas>
