<meta>
  <name>documentation</name>
  <type>command</type>
  <description>Update documentation sequentially after code review and approval</description>
</meta>

<purpose>Activate the docs-executor agent to update all documentation after successful code review. Updates task list, implementation summary, specifications, and generates user/developer documentation.</purpose>

<usage>/super-dev:documentation [specification directory path]</usage>

<topic name="Documentation Updates">
  Task List: Mark completed tasks, add new tasks discovered, update status. Implementation Summary: Record technical decisions, challenges, solutions, deviations. Specification: Update with `[UPDATED: YYYY-MM-DD]` marker for implementation differences. User Documentation: README updates, usage examples, configuration guides, troubleshooting. Developer Documentation: API docs, integration guides, development setup, contribution guidelines.
</topic>

<arguments>
  Path to specification directory, optional documentation focus type, special requirements.
</arguments>

<quality-gates>
  <gate>All implemented features documented</gate>
  <gate>Task list reflects actual completion state</gate>
  <gate>Implementation summary is current</gate>
  <gate>Specification changes documented</gate>
  <gate>User documentation clear and accurate</gate>
  <gate>Developer documentation complete</gate>
</quality-gates>

<constraints>
  <constraint>Must be completed before final commit</constraint>
  <constraint>Ensures documentation matches implementation</constraint>
</constraints>
