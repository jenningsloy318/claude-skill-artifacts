<meta>
  <name>execute</name>
  <type>command</type>
  <description>Execute development and QA in parallel using specialized agents</description>
</meta>

<purpose>Activate dev-executor and qa-agent in PARALLEL for Phase 8 implementation. Dev-executor implements code according to specifications. QA-agent writes and runs tests. Build queue managed for Rust/Go projects.</purpose>

<usage>/super-dev:execute [specification directory path]</usage>

<topic name="Parallel Execution">
  **Dev Executor**: Reads task-list for tasks, implements features per specs, invokes specialist agents (rust-developer, frontend-developer, etc.), follows established patterns. **QA Agent**: Creates unit tests, writes integration tests, verifies build success, tests against requirements. **Build Queue**: Rust/Go projects: one build at a time via coordinator. JS/Python: concurrent.
</topic>

<arguments>
  Path to specification directory, any specific implementation focus areas.
</arguments>

<output>
  <format>Implemented code files and test suites. Documentation updates handled separately in Phase 10.</format>
</output>
