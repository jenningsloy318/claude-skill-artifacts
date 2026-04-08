---
description: Rust workspace structure, build commands, and crate conventions for all Rust projects.
globs: ["**/Cargo.toml", "**/*.rs"]
---

# Rust Project Rules

## Workspace Structure

For all Rust projects, ALWAYS use a workspace structure:

```toml
[workspace]
members = [
    "crate1",
    "crate2",
    "binaries/my-binary",
]
```

## Build & Test Commands

Always run from workspace root:
```bash
cargo check                        # Fast check (prefer over build)
cargo build -p crate-name          # Build specific crate
cargo test --workspace             # Test everything
cargo test -p crate-name           # Test specific crate
cargo fmt && cargo clippy           # Format + lint
```

## Guidelines

1. **Error Handling**: `thiserror` for error types, `anyhow` for context
2. **Async**: `tokio` runtime, avoid `spawn_blocking` unless necessary
3. **Testing**: `#[test]` attributes, organize tests in `tests/`
4. **Documentation**: `///` doc comments, verify with `cargo doc`
5. **Logging**: `tracing` for structured logging with spans
6. **No `unsafe`**: Avoid unless absolutely necessary and documented

## Common Crates

| Use Case | Crate |
|----------|-------|
| Async runtime | `tokio` |
| Error handling | `thiserror`, `anyhow` |
| Serialization | `serde`, `serde_json` |
| HTTP client | `reqwest` |
| HTTP server | `axum` |
| CLI | `clap` |
| Logging | `tracing`, `tracing-subscriber` |
| Configuration | `config`, `serde_yaml` |
