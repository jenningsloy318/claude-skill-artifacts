#!/usr/bin/env bash
# Hook #5: Require passing tests before creating a PR
# PreToolUse hook for mcp__github__create_pull_request
# Exit 2 blocks PR creation, 0 allows
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

PROJECT_ROOT=$(find_project_root "$PWD")
cd "$PROJECT_ROOT" 2>/dev/null || exit 0

# Detect and run test suite
run_tests() {
  if [ -f "package.json" ]; then
    if jq -e '.scripts.test' package.json &>/dev/null; then
      npm run test --silent 2>&1
      return $?
    fi
  elif [ -f "Cargo.toml" ]; then
    cargo test 2>&1
    return $?
  elif [ -f "go.mod" ]; then
    go test ./... 2>&1
    return $?
  elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    if command -v pytest &>/dev/null; then
      pytest --tb=short -q 2>&1
      return $?
    fi
  elif [ -f "Makefile" ] && grep -q "^test:" Makefile 2>/dev/null; then
    make test 2>&1
    return $?
  fi
  # No test runner found — allow PR (don't block projects without tests)
  return 0
}

if ! run_tests; then
  echo "BLOCKED: Tests are failing. Fix all test failures before creating a PR." >&2
  echo "Run tests manually to see full output." >&2
  exit 2
fi

exit 0
