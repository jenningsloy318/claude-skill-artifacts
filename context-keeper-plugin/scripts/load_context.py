#!/usr/bin/env python3
"""
Load Context Script: Load a specific context summary by session ID or timestamp.

Uses jq subprocess for efficient extraction, falls back to full JSON parsing.
"""

import sys
import json
import subprocess
from pathlib import Path


def get_summaries_dir() -> Path:
    """Get the summaries directory for the current project."""
    cwd = Path.cwd()
    return cwd / ".claude" / "summaries"


def load_latest_with_jq(index_path: Path) -> dict:
    """Load the latest summary entry using jq."""
    try:
        result = subprocess.run(
            ['jq', '-c', '.summaries[0]'],
            stdin=open(index_path, 'r'),
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0 and result.stdout.strip() and result.stdout.strip() != 'null':
            return json.loads(result.stdout)
    except (subprocess.TimeoutExpired, FileNotFoundError, subprocess.SubprocessError, json.JSONDecodeError):
        pass
    return None


def find_by_identifier_with_jq(index_path: Path, identifier: str) -> dict:
    """Find a summary by session_id or timestamp prefix using jq."""
    try:
        # Search by session_id prefix or timestamp
        jq_query = f'.summaries | map(select(.session_id | startswith("{identifier}")) // select(.timestamp | startswith("{identifier}"))) | .[0]'
        result = subprocess.run(
            ['jq', '-c', jq_query],
            stdin=open(index_path, 'r'),
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0 and result.stdout.strip() and result.stdout.strip() != 'null':
            return json.loads(result.stdout)
    except (subprocess.TimeoutExpired, FileNotFoundError, subprocess.SubprocessError, json.JSONDecodeError):
        pass
    return None


def load_index_fallback(index_path: Path) -> list:
    """Fallback: load full index.json."""
    try:
        index = json.loads(index_path.read_text(encoding='utf-8'))
        return index.get("summaries", [])
    except (json.JSONDecodeError, FileNotFoundError):
        return []


def format_timestamp(created_at: str) -> str:
    """Format ISO timestamp to readable format."""
    try:
        from datetime import datetime
        dt = datetime.fromisoformat(created_at.replace('Z', '+00:00'))
        return dt.strftime("%Y-%m-%d %H:%M:%S")
    except (ValueError, TypeError):
        return created_at[:19] if created_at else "unknown"


def main():
    summaries_dir = get_summaries_dir()
    index_path = summaries_dir / "index.json"

    if not summaries_dir.exists() or not index_path.exists():
        print("No context summaries found. Run `/compact` to create your first summary.")
        return

    # Get optional identifier from args
    identifier = sys.argv[1] if len(sys.argv) > 1 else None

    entry = None

    if identifier:
        # Try jq first
        entry = find_by_identifier_with_jq(index_path, identifier)
        if entry is None:
            # Fallback
            summaries = load_index_fallback(index_path)
            for s in summaries:
                if s.get("session_id", "").startswith(identifier) or s.get("timestamp", "").startswith(identifier):
                    entry = s
                    break
    else:
        # Load latest
        entry = load_latest_with_jq(index_path)
        if entry is None:
            summaries = load_index_fallback(index_path)
            entry = summaries[0] if summaries else None

    if not entry:
        if identifier:
            print(f"No context found for '{identifier}'.")
            print("\nAvailable contexts:")
            summaries = load_index_fallback(index_path)
            for s in summaries[:5]:
                sid = s.get("session_id", "unknown")[:8]
                ts = format_timestamp(s.get("created_at", ""))
                print(f"  - [{sid}...] {ts}")
        else:
            print("No context summaries found.")
        return

    # Load the actual summary file
    summary_path = summaries_dir / entry.get("summary_path", "")
    if not summary_path.exists():
        print(f"Summary file not found: {summary_path}")
        return

    summary_content = summary_path.read_text(encoding='utf-8')

    # Display the context
    print("## Context Summary Loaded\n")
    print(f"**Session ID:** {entry.get('session_id', 'unknown')}")
    print(f"**Created:** {format_timestamp(entry.get('created_at', ''))}")
    print(f"**Trigger:** {entry.get('trigger', '-')}")
    print(f"**Messages:** {entry.get('message_count', 0)}")
    print()
    print("---")
    print()
    print(summary_content)
    print()
    print("---")
    print("Would you like me to use this context for our conversation?")


if __name__ == "__main__":
    main()
