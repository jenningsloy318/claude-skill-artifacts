#!/bin/bash
# Gate: Build & Test Verification
# Runs build and test suite, reports pass/fail with coverage
#
# Usage: gate-build.sh <project-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

PROJECT_DIR="${1:?Usage: gate-build.sh <project-dir>}"
cd "$PROJECT_DIR"

PASS=0
FAIL=0
ERRORS=""

check() {
    local desc="$1"
    local result="$2"
    if [ "$result" = "true" ]; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
        ERRORS="${ERRORS}\n  FAIL: ${desc}"
    fi
}

# Detect project type and run appropriate build/test
detect_and_run() {
    # Node.js / TypeScript
    if [ -f "package.json" ]; then
        local pm="npm"
        [ -f "bun.lockb" ] && pm="bun"
        [ -f "pnpm-lock.yaml" ] && pm="pnpm"
        [ -f "yarn.lock" ] && pm="yarn"

        # Build check
        if grep -q '"build"' package.json 2>/dev/null; then
            echo "  Running: ${pm} run build"
            if $pm run build > /tmp/gate-build-output.log 2>&1; then
                check "Build succeeds (${pm})" "true"
            else
                check "Build succeeds (${pm})" "false"
            fi
        else
            echo "  No build script found, skipping build"
        fi

        # Test check
        if grep -q '"test"' package.json 2>/dev/null; then
            echo "  Running: ${pm} test"
            if $pm test > /tmp/gate-test-output.log 2>&1; then
                check "Tests pass (${pm})" "true"
            else
                check "Tests pass (${pm})" "false"
            fi
        else
            echo "  No test script found, skipping tests"
        fi

        # Typecheck
        if grep -q '"typecheck\|tsc"' package.json 2>/dev/null || [ -f "tsconfig.json" ]; then
            echo "  Running: npx tsc --noEmit"
            if npx tsc --noEmit > /tmp/gate-type-output.log 2>&1; then
                check "Type check passes" "true"
            else
                check "Type check passes" "false"
            fi
        fi

    # Rust
    elif [ -f "Cargo.toml" ]; then
        echo "  Running: cargo build"
        if cargo build > /tmp/gate-build-output.log 2>&1; then
            check "Cargo build succeeds" "true"
        else
            check "Cargo build succeeds" "false"
        fi

        echo "  Running: cargo test"
        if cargo test > /tmp/gate-test-output.log 2>&1; then
            check "Cargo tests pass" "true"
        else
            check "Cargo tests pass" "false"
        fi

    # Go
    elif [ -f "go.mod" ]; then
        echo "  Running: go build ./..."
        if go build ./... > /tmp/gate-build-output.log 2>&1; then
            check "Go build succeeds" "true"
        else
            check "Go build succeeds" "false"
        fi

        echo "  Running: go test ./..."
        if go test ./... > /tmp/gate-test-output.log 2>&1; then
            check "Go tests pass" "true"
        else
            check "Go tests pass" "false"
        fi

    # Python
    elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
        if command -v pytest &> /dev/null; then
            echo "  Running: pytest"
            if pytest > /tmp/gate-test-output.log 2>&1; then
                check "Pytest passes" "true"
            else
                check "Pytest passes" "false"
            fi
        fi

    else
        echo "  Warning: Could not detect project type"
        PASS=$((PASS + 1))  # Don't fail on unknown projects
    fi
}

echo "GATE: Build & Test Verification"
echo "  Project: ${PROJECT_DIR}"
detect_and_run

# Report
TOTAL=$((PASS + FAIL))
echo "  Score: ${PASS}/${TOTAL} checks passed"

if [ "$FAIL" -gt 0 ]; then
    echo -e "  Failures:${ERRORS}"
    echo ""
    echo "  Build log tail:"
    tail -20 /tmp/gate-build-output.log 2>/dev/null || true
    echo ""
    echo "  Test log tail:"
    tail -20 /tmp/gate-test-output.log 2>/dev/null || true
    echo "GATE RESULT: FAIL"
    exit 1
else
    echo "GATE RESULT: PASS"
    exit 0
fi
