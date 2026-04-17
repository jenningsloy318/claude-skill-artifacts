<meta>
  <name>testing-patterns</name>
  <type>template</type>
  <description>Comprehensive testing methodology covering CLI, Desktop UI, and Web applications with test planning, execution strategies, coverage tracking, and quality gates</description>
</meta>

<purpose>Reference for systematic quality assurance across multiple application modalities during Phase 8 (Implementation) of the super-dev workflow. Covers test planning, CLI testing, desktop UI testing, web app testing, static analysis, coverage tracking, and failure handling.</purpose>

<principles>
  <principle>**Specification-First Testing**: Derive all test plans and cases from requirements and acceptance criteria — no testing without documented specifications</principle>
  <principle>**Deterministic Execution**: Ensure reproducible test execution with isolated environments, stable data, and trace recording</principle>
  <principle>**Clear Oracles**: Use explicit assertions: values, diffs, screenshots, accessibility/performance budgets</principle>
  <principle>**Actionable Feedback**: Include evidence, reproduction steps, and expected vs actual for all defects</principle>
  <principle>**Modality-Aware Testing**: Apply quality gates consistently across CLI, Desktop UI, and Web applications</principle>
</principles>

<topic name="Test Planning">
  Every test plan must include: application name, modality (CLI/Desktop UI/Web App), version, date, risk assessment table (area, probability, impact, mitigation), and coverage targets (happy path, boundary conditions, error handling, edge cases, security, accessibility).

  **Test Authoring Strategy**: Unit tests cover core logic and edge/boundary conditions with mocked external dependencies. Integration tests verify component interactions with real databases and test transaction boundaries. **Coverage targets**: Overall ≥ 80%, new/changed code ≥ 90%, critical paths 100%.
</topic>

<process>
  <step n="1" name="Receive DEV_COMPLETE">Receive DEV_COMPLETE signal with files_changed list</step>
  <step n="2" name="Author Tests">Author/update unit and integration tests for changed code and impacted areas</step>
  <step n="3" name="Build and Run">Rust/Go: request build slot, then `cargo test` / `go test ./...`. JS/Python: run `npm|pnpm test` / `pytest` concurrently.</step>
  <step n="4" name="Report">Report status (pass/fail, failing test names with errors) and coverage (overall and new/changed code delta)</step>
  <step n="5" name="Handle Failures">Max 3 attempts. Classify: code bug → notify dev; test bug → fix tests; flaky → stabilize; env → document/workaround. If unresolved → emit TEST_BLOCKED with evidence.</step>
</process>

<topic name="CLI Testing">
  **Command Enumeration**: Parse help output to discover all commands, flags (short/long), required/optional arguments, defaults, and environment variables.

  **Value Matrix**: For each parameter test valid values, boundary values, and malformed values.

  **Sandbox Execution**: Create isolated temp directory, copy fixtures, execute with timeout, capture stdout/stderr/exit code, cleanup.

  **Assertions**: Exit code assertions (0 success, 1 invalid args, 2 file not found, 126 permission denied, 127 command not found, 124 timeout). Stdout regex assertions for output format verification. Stderr trap assertions for meaningful error messages and no stack traces in production. Golden-file diff for known-good output comparison.
</topic>

<topic name="Desktop UI Testing">
  **Platform Tools**: Linux uses AT-SPI with `accerciser`/`python-atspi`. macOS uses Accessibility API with `Accessibility Inspector`/`pyatom`. Windows uses UI Automation with `inspect.exe`/`pywinauto`.

  **Application Launch**: Use isolated environments — Xvfb on Linux, tart/UTM VM on macOS, Windows Sandbox/VM on Windows.

  **Control Tree Discovery**: Enumerate all accessible controls per platform API — role, name, states, actions (Linux), AXRole/AXTitle/AXIdentifier (macOS), control_type/name/automation_id (Windows).

  **Interaction Sequences**: Menu navigation (click menu → submenu → item → verify action/state). Dialog interactions (trigger → verify appears → fill inputs → OK/Cancel → verify applied/reverted). Keyboard shortcuts (verify shortcut triggers action matching menu equivalent, test with focus in different areas).

  **Assertions**: Pixel-perfect screenshot comparison using perceptual hashing (phash) with configurable threshold. Accessibility tree hash for deterministic control tree verification.
</topic>

<topic name="Web App Testing">
  **Environment Setup**: Kill existing dev servers on common ports (3000, 3001, 5173, 8080). Start dev server and wait for ready. Use pristine browser context with isolated cookies/storage/cache.

  **Monitoring**: Console error monitoring (capture console.error/warn, flag uncaught exceptions). Network status monitoring (track XHR/Fetch, verify no 4xx/5xx, check timing and CORS). Accessibility violations via axe-core. Performance metrics via DevTools traces (LCP, FID, CLS, TTI).

  **Route Crawling**: Discover routes from sitemap.xml, manifest/router config, and link discovery. For each route: navigate, wait for network idle, capture snapshot, check console for errors, verify no broken images/links, record trace.

  **Form Testing**: Auto-fill forms with test data. Exercise happy paths (valid data → submit → verify success) and error paths (invalid data → verify validation messages, empty submit → verify required messages, test field interdependencies).

  **Trace Recording**: Record trace.zip per test including timeline, network waterfall, screenshots, JavaScript profile, layout/paint events.
</topic>

<topic name="Static Code Analysis">
  **CodeRabbit CLI**: Run `coderabbit --prompt-only` proactively in background starting as soon as dev agent begins implementation. Do NOT wait for implementation to complete.

  **When to run**: All new features, bug fixes, refactoring, any code changes beyond trivial. Start as soon as first files are created/modified.

  **Issue handling**: Parse severity/file/line/description from output. Report critical/high issues to dev agent. After fixes, re-run to verify resolution. Report final PASSED status with issue counts.
</topic>

<quality-gates>
  <gate>**Before Testing**: Test plan generated from requirements, oracle strategies defined, sandbox/isolated environment prepared</gate>
  <gate>**During Testing**: CodeRabbit CLI review passed (no critical/high), MCP test frameworks enforced (Playwright, Chrome DevTools), all traces recorded, console errors captured, network monitored, accessibility audit passed (WCAG AA), performance within budget</gate>
  <gate>**After Testing**: Coverage targets met (≥80% overall, ≥90% new code), test report generated with defects, feedback artifacts ready, traces/screenshots archived</gate>
</quality-gates>

<topic name="Coverage Tracking">
  **Targets**: Overall 80% minimum (85%+ preferred), new/changed code 90% minimum (95%+ preferred), critical paths 100%.

  **Measurement per language**: JavaScript/TypeScript via c8/nyc with `--coverage`. Python via pytest-cov. Rust via tarpaulin. Go via `go test -coverprofile`.

  **Enforcement**: Fail build if coverage drops below threshold using `nyc --check-coverage` (JS), `pytest --cov-fail-under` (Python), `cargo tarpaulin --fail-under` (Rust).
</topic>

<topic name="Failure Handling">
  **Classification**: Code Bug (implementation error → report to dev), Test Bug (flawed test → fix immediately), Flaky Test (intermittent → stabilize with isolation/mock/retry), Environment (infrastructure → document workaround).

  **Retry strategy**: Classify root cause. If code bug → notify dev-executor. If test bug → fix immediately. If flaky → max 3 retries with stabilization. If env → document and emit TEST_BLOCKED.

  **TEST_BLOCKED emission**: After max retries, emit with full evidence: test case ID, attempt count, classification, error messages, logs, screenshots, traces.
</topic>

<constraints>
  <constraint>Write tests before implementation (TDD)</constraint>
  <constraint>Use isolated environments for each test</constraint>
  <constraint>Record traces for all test executions</constraint>
  <constraint>Verify accessibility (WCAG AA) for all UI tests</constraint>
  <constraint>Monitor console errors in web tests</constraint>
  <constraint>Test boundary conditions and edge cases</constraint>
  <constraint>Maintain ≥80% test coverage</constraint>
  <constraint>Use deterministic data (no randomness)</constraint>
</constraints>

<anti-patterns>
  <anti-pattern>Skipping testing for "trivial" changes</anti-pattern>
  <anti-pattern>Using production databases for tests</anti-pattern>
  <anti-pattern>Ignoring flaky tests — stabilize them</anti-pattern>
  <anti-pattern>Testing without assertions (oracles)</anti-pattern>
  <anti-pattern>Skipping accessibility testing for UI</anti-pattern>
  <anti-pattern>Using shared state between tests</anti-pattern>
  <anti-pattern>Exceeding timeout thresholds without investigation</anti-pattern>
  <anti-pattern>Committing code without running tests</anti-pattern>
</anti-patterns>

<references>
  <ref>Extracted from `super-dev:qa-agent` agent. For full agent behavior during Phase 8, invoke with subagent_type "super-dev:qa-agent".</ref>
  <ref>Uses Playwright MCP and Chrome DevTools MCP for web testing</ref>
</references>
