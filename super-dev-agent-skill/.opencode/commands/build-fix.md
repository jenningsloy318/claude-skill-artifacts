---
description: Fix build and type errors
agent: build-error-resolver
---

Fix build errors and type errors:

1. Analyze error messages
2. Identify root causes
3. Apply minimal fixes
4. Verify build passes

Types of errors handled:
- TypeScript type errors
- Rust compilation errors
- Go build errors
- Python syntax/import errors
- JavaScript/Node.js errors
- Missing dependencies
- Configuration errors

Command output:
!`npm run build 2>&1 || cargo build 2>&1 || go build ./... 2>&1 || echo "No standard build command found"`

Fix all errors with minimal changes - no architectural edits, just get the build green.