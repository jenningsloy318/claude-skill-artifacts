---
name: super-dev:go-quality
description: Invoke the Go development specialist for writing, reviewing, or refactoring Go code with modern Go 1.24+ best practices.
---

# /super-dev:go-quality — Go Development

Invoke the **golang-developer** agent for Go-specific tasks.

## Usage

```
/super-dev:go-quality <task description>
```

## What It Does

Spawns the `super-dev:golang-developer` agent with your task. The agent enforces:

- **Go 1.24+** features: iterators (`iter.Seq`), enhanced ServeMux routing, `os.Root`, Swiss Table maps, `omitzero`, tool directives
- **Idiomatic patterns**: functional options, interface design, error wrapping, graceful shutdown, errgroup
- **Quality gates**: `golangci-lint` v2 with `modernize`, ≥80% test coverage, `go vet`, table-driven tests
- **Performance**: preallocate slices, `sync.Pool`, `b.Loop()` benchmarks, pprof profiling

## Examples

```
/super-dev:go-quality implement a REST API for user management with JWT auth
/super-dev:go-quality review this handler for idiomatic Go patterns
/super-dev:go-quality refactor the database layer to use repository pattern
/super-dev:go-quality add table-driven tests for the auth service
```

## Execution

```yaml
agent: super-dev:golang-developer
mode: bypassPermissions
input: |
  Task: $ARGUMENTS

  Apply all Go 1.24+ best practices. Use enhanced ServeMux for routing,
  structured logging (slog), explicit error handling with wrapping,
  and table-driven tests. Run golangci-lint v2 before declaring complete.
```
