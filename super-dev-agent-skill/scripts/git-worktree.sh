#!/bin/bash
#
# Git Worktree Helper Script
# Usage: ./scripts/git-worktree.sh [create|remove|list] [name]
#

set -e

WORKTREE_DIR=".worktree"
SPEC_DIR="specification"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

create_worktree() {
    local name=$1
    
    if [ -z "$name" ]; then
        log_error "Worktree name required"
        echo "Usage: $0 create <name>"
        exit 1
    fi
    
    # Validate name format
    if [[ ! $name =~ ^[0-9]+-[a-z0-9-]+$ ]]; then
        log_error "Invalid name format. Use: [index]-[kebab-case-name]"
        echo "Example: 01-user-authentication"
        exit 1
    fi
    
    # Check if worktree already exists
    if [ -d "$WORKTREE_DIR/$name" ]; then
        log_warn "Worktree $name already exists"
        echo "Use: cd $WORKTREE_DIR/$name"
        exit 0
    fi
    
    # Check if branch already exists
    if git branch --list | grep -q "^\s*${name}$"; then
        log_warn "Branch $name already exists"
        log_info "Creating worktree from existing branch..."
        git worktree add "$WORKTREE_DIR/$name" "$name"
    else
        log_info "Creating worktree and branch: $name"
        git worktree add "$WORKTREE_DIR/$name" -b "$name"
    fi
    
    # Create spec directory inside worktree
    mkdir -p "$WORKTREE_DIR/$name/$SPEC_DIR/$name"
    log_info "Created spec directory: $SPEC_DIR/$name/"
    
    # Initialize workflow tracking JSON
    cat > "$WORKTREE_DIR/$name/$SPEC_DIR/$name/${name}-workflow-tracking.json" <<EOF
{
  "featureName": "$name",
  "specDirectory": "$SPEC_DIR/$name",
  "worktreePath": "$WORKTREE_DIR/$name",
  "startedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "phases": [
    { "id": 1, "name": "Specification Setup", "status": "complete", "startedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)", "completedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)" }
  ],
  "iteration": { "loops": 0, "lastReviewVerdict": null },
  "team": { "name": "super-dev-$name", "teammates": [], "messages": [] },
  "status": { "allPhasesComplete": false, "allTasksComplete": false, "workflowDone": false }
}
EOF
    
    log_info "Created workflow tracking: $SPEC_DIR/$name/${name}-workflow-tracking.json"
    log_info "Worktree created successfully!"
    echo ""
    echo "Next steps:"
    echo "  cd $WORKTREE_DIR/$name"
    echo "  git branch --show-current  # Should show: $name"
}

remove_worktree() {
    local name=$1
    
    if [ -z "$name" ]; then
        log_error "Worktree name required"
        echo "Usage: $0 remove <name>"
        exit 1
    fi
    
    if [ ! -d "$WORKTREE_DIR/$name" ]; then
        log_error "Worktree $name does not exist"
        exit 1
    fi
    
    log_info "Removing worktree: $name"
    git worktree remove "$WORKTREE_DIR/$name"
    
    # Optionally remove branch
    read -p "Also delete branch $name? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git branch -d "$name" || log_warn "Could not delete branch (may not be fully merged)"
    fi
    
    log_info "Worktree removed"
}

list_worktrees() {
    log_info "Git worktrees:"
    git worktree list
    echo ""
    log_info "Local branches:"
    git branch
}

# Main command handler
case "${1:-}" in
    create)
        create_worktree "$2"
        ;;
    remove)
        remove_worktree "$2"
        ;;
    list)
        list_worktrees
        ;;
    *)
        echo "Git Worktree Helper for Super Dev"
        echo ""
        echo "Usage: $0 [command] [options]"
        echo ""
        echo "Commands:"
        echo "  create <name>    Create new worktree and branch"
        echo "                   Name format: [index]-[kebab-case]"
        echo "                   Example: 01-user-authentication"
        echo ""
        echo "  remove <name>    Remove worktree and optionally branch"
        echo ""
        echo "  list             List all worktrees and branches"
        echo ""
        echo "Examples:"
        echo "  $0 create 01-fix-login-bug"
        echo "  $0 remove 01-fix-login-bug"
        echo "  $0 list"
        exit 1
        ;;
esac
