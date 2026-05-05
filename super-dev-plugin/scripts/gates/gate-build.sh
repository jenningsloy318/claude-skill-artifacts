#!/bin/bash
# Gate: Build & Test Verification
#
# Usage: gate-build.sh <project-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

PROJECT_DIR="${1:?Usage: gate-build.sh <project-dir>}"
source "$(dirname "$0")/gate-lib.sh"
cd "$PROJECT_DIR"

BUILD_LOG=$(mktemp)
TEST_LOG=$(mktemp)
TYPE_LOG=$(mktemp)
trap 'rm -f "$BUILD_LOG" "$TEST_LOG" "$TYPE_LOG"' EXIT

detect_and_run() {
    if [ -f "package.json" ]; then
        local pm="npm"
        [ -f "bun.lockb" ] && pm="bun"
        [ -f "pnpm-lock.yaml" ] && pm="pnpm"
        [ -f "yarn.lock" ] && pm="yarn"

        if grep -q '"build"' package.json 2>/dev/null; then
            echo "  Running: ${pm} run build"
            if $pm run build > $BUILD_LOG 2>&1; then
                check "Build succeeds (${pm})" "true"
            else
                check "Build succeeds (${pm})" "false"
            fi
        fi

        if grep -q '"test"' package.json 2>/dev/null; then
            echo "  Running: ${pm} test"
            if $pm test > $TEST_LOG 2>&1; then
                check "Tests pass (${pm})" "true"
            else
                check "Tests pass (${pm})" "false"
            fi
        fi

        if grep -q '"typecheck\|tsc"' package.json 2>/dev/null || [ -f "tsconfig.json" ]; then
            echo "  Running: npx tsc --noEmit"
            if npx tsc --noEmit > $TYPE_LOG 2>&1; then
                check "Type check passes" "true"
            else
                check "Type check passes" "false"
            fi
        fi

    elif [ -f "Cargo.toml" ]; then
        echo "  Running: cargo build"
        if cargo build > $BUILD_LOG 2>&1; then
            check "Cargo build succeeds" "true"
        else
            check "Cargo build succeeds" "false"
        fi
        echo "  Running: cargo test"
        if cargo test > $TEST_LOG 2>&1; then
            check "Cargo tests pass" "true"
        else
            check "Cargo tests pass" "false"
        fi

    elif [ -f "go.mod" ]; then
        echo "  Running: go build ./..."
        if go build ./... > $BUILD_LOG 2>&1; then
            check "Go build succeeds" "true"
        else
            check "Go build succeeds" "false"
        fi
        echo "  Running: go test ./..."
        if go test ./... > $TEST_LOG 2>&1; then
            check "Go tests pass" "true"
        else
            check "Go tests pass" "false"
        fi

    elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
        if command -v pytest &> /dev/null; then
            echo "  Running: pytest"
            if pytest > $TEST_LOG 2>&1; then
                check "Pytest passes" "true"
            else
                check "Pytest passes" "false"
            fi
        fi

    else
        echo "  Warning: Could not detect project type"
        PASS=$((PASS + 1))
    fi
}

echo "GATE: Build & Test Verification"
echo "  Project: ${PROJECT_DIR}"
detect_and_run

if [ "$FAIL" -gt 0 ]; then
    echo "  Build log tail:"
    tail -20 "$BUILD_LOG" 2>/dev/null || true
    echo "  Test log tail:"
    tail -20 "$TEST_LOG" 2>/dev/null || true
fi

gate_report "Build & Test Verification"
