<meta>
  <name>rust-project</name>
  <type>rule</type>
  <description>Rust workspace structure, build commands, and crate conventions for all Rust projects</description>
</meta>

<purpose>Enforce workspace structure, standard build commands, and crate conventions for all Rust projects.</purpose>

<directives>
  <directive severity="critical">**ALWAYS use workspace structure** with `[workspace]` and `members` in root `Cargo.toml`. Monolithic single-crate structure is BLOCKING.</directive>
  <directive severity="high">**Build from workspace root**: `cargo check` (fast check, prefer over build), `cargo build -p crate-name` (specific crate), `cargo test --workspace` (test everything), `cargo fmt && cargo clippy` (format + lint)</directive>
  <directive severity="high">**Error handling**: `thiserror` for error types, `anyhow` for context</directive>
  <directive severity="high">**Async**: `tokio` runtime, avoid `spawn_blocking` unless necessary</directive>
  <directive severity="high">**No `unsafe`**: Avoid unless absolutely necessary and documented with `// SAFETY:` comment</directive>
  <directive severity="medium">**Logging**: `tracing` for structured logging with spans</directive>
  <directive severity="medium">**Documentation**: `///` doc comments, verify with `cargo doc`</directive>
</directives>

<topic name="Common Crates">
  Async: `tokio`. Errors: `thiserror`, `anyhow`. Serialization: `serde`, `serde_json`. HTTP client: `reqwest`. HTTP server: `axum`. CLI: `clap`. Logging: `tracing`, `tracing-subscriber`. Config: `config`, `serde_yaml`.
</topic>
