#!/usr/bin/env bash
# Shared hook utilities — sourced by hook scripts

find_project_root() {
  local start="${1:-$PWD}"
  local dir="$start"
  while [ "$dir" != "/" ]; do
    for marker in package.json Cargo.toml go.mod pyproject.toml setup.py .git; do
      [ -e "$dir/$marker" ] && echo "$dir" && return
    done
    dir="$(dirname "$dir")"
  done
  echo "$start"
}
