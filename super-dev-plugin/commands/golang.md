---
name: golang
description: Invoke the Go development specialist for writing, reviewing, or refactoring Go code with modern Go 1.24+ best practices
---

<purpose>Spawn the golang-developer agent for Go-specific tasks. Enforces Go 1.24+ features (iterators, enhanced ServeMux, os.Root), idiomatic patterns (functional options, interface design, error wrapping), quality gates (golangci-lint v2, 80%+ coverage), and performance best practices.</purpose>

<usage>/super-dev:go-quality [task description]</usage>

<constraints>
  <constraint>Agent enforces Go 1.24+ features, idiomatic patterns, and quality gates</constraint>
  <constraint>Runs golangci-lint v2 with modernize before declaring complete</constraint>
</constraints>

<examples>
  <example>/super-dev:go-quality implement a REST API for user management with JWT auth</example>
  <example>/super-dev:go-quality review this handler for idiomatic Go patterns</example>
  <example>/super-dev:go-quality refactor the database layer to use repository pattern</example>
</examples>
