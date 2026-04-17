<meta>
  <name>git-workflow</name>
  <type>rule</type>
  <description>Git commit message format, PR workflow, and feature implementation workflow</description>
</meta>

<purpose>Define git commit conventions, PR workflow, and feature implementation workflow including TDD approach and code review.</purpose>

<directives>
  <directive severity="high" name="Spec workflow commit format">`spec-[spec-index]-[spec-name] <type>: <description>` with optional body</directive>
  <directive severity="high" name="Direct change commit format">`<type>: <description>` with optional body. Types: feat, fix, refactor, docs, test, chore, perf, ci</directive>
  <directive severity="high" name="PR workflow">Analyze full commit history (not just latest), use `git diff [base-branch]...HEAD`, draft comprehensive summary, include test plan, push with `-u` flag for new branches</directive>
  <directive severity="medium" name="Feature workflow">1) Plan first (planner agent), 2) TDD approach (tdd-guide agent: RED → GREEN → IMPROVE → 80%+ coverage), 3) Code review (code-reviewer agent), 4) Commit with detailed messages</directive>
</directives>
