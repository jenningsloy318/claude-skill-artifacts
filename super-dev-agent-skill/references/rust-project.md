---
name: rust-project
description: Rust workspace structure, build commands, and crate conventions for all Rust projects
---

<purpose>Enforce workspace structure, standard build commands, and crate conventions for all Rust projects.</purpose>

<directives>
  <directive severity="critical" name="ALWAYS use workspace structure">With `[workspace]` and `members` in root `Cargo.toml`. Monolithic single-crate structure is BLOCKING.</directive>
  <directive severity="high" name="Build from workspace root">`cargo check` (fast check, prefer over build), `cargo build -p crate-name` (specific crate), `cargo test --workspace` (test everything), `cargo fmt && cargo clippy` (format + lint)</directive>
  <directive severity="high" name="Error handling">`thiserror` for error types, `anyhow` for context</directive>
  <directive severity="high" name="Async">`tokio` runtime, avoid `spawn_blocking` unless necessary</directive>
  <directive severity="high" name="No unsafe">Avoid unless absolutely necessary and documented with `// SAFETY:` comment</directive>
  <directive severity="medium" name="Logging">`tracing` for structured logging with spans</directive>
  <directive severity="medium" name="Documentation">`///` doc comments, verify with `cargo doc`</directive>
</directives>

<reference name="Common Crates">
  Async: `tokio`. Errors: `thiserror`, `anyhow`. Serialization: `serde`, `serde_json`. HTTP client: `reqwest`. HTTP server: `axum`. CLI: `clap`. Logging: `tracing`, `tracing-subscriber`. Config: `config`, `serde_yaml`.
</reference>
