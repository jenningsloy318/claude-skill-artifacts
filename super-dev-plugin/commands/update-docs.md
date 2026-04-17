<meta>
  <name>update-docs</name>
  <type>command</type>
  <description>Sync documentation from source-of-truth (package.json and .env.example)</description>
</meta>

<purpose>Read package.json scripts and .env.example to generate docs/CONTRIB.md (development workflow, scripts, environment setup, testing) and docs/RUNBOOK.md (deployment, monitoring, common issues, rollback). Identify obsolete documentation not modified in 90+ days.</purpose>

<process>
  <step n="1" name="Extract">Read package.json scripts section. Read .env.example for environment variables.</step>
  <step n="2" name="Generate CONTRIB">Development workflow, available scripts, environment setup, testing procedures.</step>
  <step n="3" name="Generate RUNBOOK">Deployment procedures, monitoring and alerts, common issues and fixes, rollback procedures.</step>
  <step n="4" name="Audit">Find docs not modified in 90+ days. List for manual review. Show diff summary.</step>
</process>

<constraints>
  <constraint>Single source of truth: package.json and .env.example</constraint>
</constraints>
