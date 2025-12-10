#!/usr/bin/env python3
"""
Load Memory Script: Load session memories either automatically or manually.

This script can operate in two modes:
1. Automatic mode: When triggered by SessionStart hook, loads recent context automatically
2. Manual mode: When invoked by user with optional session ID/timestamp, displays memory for user approval

Usage:
- Automatic: Script reads JSON from stdin (hook mode)
- Manual: python3 load_memory.py [session-id-or-timestamp]

Output:
- Automatic mode: Outputs formatted context to stdout (injected into Claude)
- Manual mode: Displays memory content and asks for user confirmation
"""

import sys
import json
import subprocess
from pathlib import Path
from datetime import datetime





def get_memories_dir(project_path: str = None) -> Path:
    """Get the memories directory for the project."""
    if project_path:
        return Path(project_path) / ".claude" / "memories"
    cwd = Path.cwd()
    return cwd / ".claude" / "memories"


def load_latest_memory(project_path: str, session_id: str = None) -> tuple[str, dict]:
    """
    Load the most recent memory for context injection.

    Returns:
        tuple: (memory_content, metadata) or (None, None) if not found
    """
    memories_dir = get_memories_dir(project_path)

    if not memories_dir.exists():
        return None, None

    # Try to load from specific session if provided
    if session_id:
        session_dir = memories_dir / session_id
        if session_dir.exists():
            latest_link = session_dir / "latest"
            if latest_link.exists():
                # Resolve symlink
                if latest_link.is_symlink():
                    target = session_dir / latest_link.resolve().name
                else:
                    target = latest_link

                memory_path = target / "memory.json" if target.is_dir() else None
                metadata_path = target / "metadata.json" if target.is_dir() else None

                if memory_path and memory_path.exists():
                    try:
                        memory_data = json.loads(memory_path.read_text(encoding='utf-8'))
                        memory = memory_data.get('content', '')
                    except json.JSONDecodeError:
                        # Fallback for old .md files
                        memory_path_old = target / "memory.md"
                        if memory_path_old.exists():
                            memory = memory_path_old.read_text(encoding='utf-8')
                        else:
                            memory = ""
                    metadata = {}
                    if metadata_path and metadata_path.exists():
                        try:
                            metadata = json.loads(metadata_path.read_text(encoding='utf-8'))
                        except json.JSONDecodeError:
                            pass
                    return memory, metadata

    # Fallback: Load from index (most recent across all sessions)
    index_path = memories_dir / "index.json"
    if not index_path.exists():
        return None, None

    # Try using jq for efficient extraction (only reads first entry)
    latest = None
    try:
        result = subprocess.run(
            ['jq', '-r', '.memories[0]'],
            stdin=open(index_path, 'r'),
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0 and result.stdout.strip() and result.stdout.strip() != 'null':
            latest = json.loads(result.stdout)
    except (subprocess.TimeoutExpired, FileNotFoundError, subprocess.SubprocessError):
        # jq not available or failed, fall back to full JSON parsing
        pass

    # Fallback: Read full JSON if jq failed
    if latest is None:
        try:
            index = json.loads(index_path.read_text(encoding='utf-8'))
            memories = index.get("memories", [])
            if not memories:
                return None, None
            latest = memories[0]
        except (json.JSONDecodeError, KeyError, FileNotFoundError) as e:
            print(f"[context-keeper] Error: Failed to load from index: {e}", file=sys.stderr)
            return None, None

    try:
        memory_path = memories_dir / latest["memory_path"]
        if memory_path.exists():
            # Read memory as JSON
            try:
                memory_data = json.loads(memory_path.read_text(encoding='utf-8'))
                memory = memory_data.get('content', '')
            except json.JSONDecodeError:
                # Fallback for old .md files
                memory = memory_path.read_text(encoding='utf-8')
            return memory, latest
    except (KeyError, TypeError) as e:
        print(f"[context-keeper] Error: Invalid index entry: {e}", file=sys.stderr)

    return None, None


def find_memory_by_identifier(identifier: str) -> tuple[str, dict]:
    """Find a memory by session_id or timestamp prefix."""
    memories_dir = get_memories_dir()
    index_path = memories_dir / "index.json"

    if not index_path.exists():
        return None, None

    # Try jq first for efficiency
    try:
        jq_query = f'.memories | map(select(.session_id | startswith("{identifier}")) // select(.timestamp | startswith("{identifier}"))) | .[0]'
        result = subprocess.run(
            ['jq', '-c', jq_query],
            stdin=open(index_path, 'r'),
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0 and result.stdout.strip() and result.stdout.strip() != 'null':
            entry = json.loads(result.stdout)
            memory_path = memories_dir / entry.get("memory_path", "")
            if memory_path.exists():
                try:
                    memory_data = json.loads(memory_path.read_text(encoding='utf-8'))
                    memory = memory_data.get('content', '')
                except json.JSONDecodeError:
                    memory = memory_path.read_text(encoding='utf-8')
                return memory, entry
    except (subprocess.TimeoutExpired, FileNotFoundError, subprocess.SubprocessError, json.JSONDecodeError):
        pass

    # Fallback: Full JSON parsing
    try:
        index = json.loads(index_path.read_text(encoding='utf-8'))
        memories = index.get("memories", [])
        for entry in memories:
            if entry.get("session_id", "").startswith(identifier) or entry.get("timestamp", "").startswith(identifier):
                memory_path = memories_dir / entry.get("memory_path", "")
                if memory_path.exists():
                    try:
                        memory_data = json.loads(memory_path.read_text(encoding='utf-8'))
                        memory = memory_data.get('content', '')
                    except json.JSONDecodeError:
                        memory = memory_path.read_text(encoding='utf-8')
                    return memory, entry
    except (json.JSONDecodeError, FileNotFoundError):
        pass

    return None, None


def format_context(memory: str, metadata: dict, source: str, permission_mode: str = "default") -> str:
    """Format memory for context injection (automatic mode)."""

    timestamp = metadata.get('timestamp', metadata.get('created_at', 'unknown'))
    session_id = metadata.get('session_id', 'unknown')
    trigger = metadata.get('trigger', 'unknown')
    message_count = metadata.get('message_count', 0)

    # Create context wrapper
    context = f"""<previous-session-context>
## Session Continuity Notice

This context was automatically loaded from a previous session memory.
- **Previous Session ID:** {session_id[:16]}...
- **Summary Created:** {timestamp}
- **Compaction Trigger:** {trigger}
- **Message Count:** {message_count}
- **Reload Source:** {source}
- **Permission Mode:** {permission_mode}

---

{memory}

---

*Use this context to maintain continuity with the previous conversation. The above memory captures what was discussed and accomplished before context compaction.*
</previous-session-context>"""

    return context


def format_timestamp(created_at: str) -> str:
    """Format ISO timestamp to readable format."""
    try:
        dt = datetime.fromisoformat(created_at.replace('Z', '+00:00'))
        return dt.strftime("%Y-%m-%d %H:%M:%S")
    except (ValueError, TypeError):
        return created_at[:19] if created_at else "unknown"


def automatic_mode():
    """Run in automatic mode (triggered by SessionStart hook)."""
    # Print visible banner to stderr
    print("\n" + "=" * 60, file=sys.stderr)
    print("🔄 [context-keeper] Session Start Hook Running...", file=sys.stderr)
    print("=" * 60, file=sys.stderr)

    try:
        # Read input from Claude Code
        hook_input = json.loads(sys.stdin.read())

        # Extract session information (all available fields)
        session_id = hook_input.get("session_id", "")
        transcript_path = hook_input.get("transcript_path", "")
        permission_mode = hook_input.get("permission_mode", "default")
        hook_event_name = hook_input.get("hook_event_name", "SessionStart")
        source = hook_input.get("source", "unknown")  # startup, resume, clear, compact
        cwd = hook_input.get("cwd", "")

        print(f"📋 [context-keeper] Source: {source}, Permission: {permission_mode}", file=sys.stderr)

        # Only inject context on resume (after compaction) or compact
        # Skip if this is a clear event (user explicitly cleared)
        if source == "clear":
            print("ℹ️  [context-keeper] Skipping context injection (clear event)", file=sys.stderr)
            print("=" * 60 + "\n", file=sys.stderr)
            sys.exit(0)

        # Skip on fresh startup - only load context on resume/compact
        if source == "startup":
            print("ℹ️  [context-keeper] Skipping context injection (fresh startup)", file=sys.stderr)
            print("=" * 60 + "\n", file=sys.stderr)
            sys.exit(0)

        if not cwd:
            print("ℹ️  [context-keeper] Skipping context injection (no cwd)", file=sys.stderr)
            print("=" * 60 + "\n", file=sys.stderr)
            sys.exit(0)

        # Load latest memory
        print("📂 [context-keeper] Searching for previous session context...", file=sys.stderr)
        memory, metadata = load_latest_memory(cwd, session_id)

        if not memory:
            # No memory available - this is fine, just exit cleanly
            print("ℹ️  [context-keeper] No previous session context found", file=sys.stderr)
            print("=" * 60 + "\n", file=sys.stderr)
            sys.exit(0)

        print(f"📄 [context-keeper] Found context for session {session_id[:8] if session_id else 'unknown'}...", file=sys.stderr)

        # Check if this memory is recent enough to be relevant
        # Skip if the memory is from a very old session (>24 hours)
        try:
            created_at = metadata.get('timestamp', metadata.get('created_at', ''))
            if created_at:
                # Parse ISO format
                memory_time = datetime.fromisoformat(created_at.replace('Z', '+00:00'))
                now = datetime.now(memory_time.tzinfo) if memory_time.tzinfo else datetime.now()
                age_hours = (now - memory_time.replace(tzinfo=None)).total_seconds() / 3600

                if age_hours > 24:
                    # Summary is old, skip injection but don't error
                    print(f"ℹ️  [context-keeper] Context is {age_hours:.1f}h old, skipping (>24h)", file=sys.stderr)
                    print("=" * 60 + "\n", file=sys.stderr)
                    sys.exit(0)
        except (ValueError, TypeError):
            # Can't parse date, continue anyway
            pass

        # Format and output context
        print("📥 [context-keeper] Loading context into session...", file=sys.stderr)
        context = format_context(memory, metadata or {}, source, permission_mode)
        print(context)

        # Print visible completion message
        print("✅ [context-keeper] Previous session context loaded successfully!", file=sys.stderr)
        print("=" * 60 + "\n", file=sys.stderr)

        sys.exit(0)

    except Exception as e:
        print(f"❌ [context-keeper] Error: {e}", file=sys.stderr)
        print("=" * 60 + "\n", file=sys.stderr)
        sys.exit(1)


def manual_mode(identifier=None):
    """Run in manual mode (user-invoked command)."""
    memories_dir = get_memories_dir()
    index_path = memories_dir / "index.json"

    if not memories_dir.exists() or not index_path.exists():
        print("No context memories found. Run `/compact` to create your first memory.")
        return

    memory_content = None
    entry = None

    if identifier:
        # Find specific memory
        memory_content, entry = find_memory_by_identifier(identifier)
        if not memory_content:
            print(f"No context found for '{identifier}'.")
            print("\nAvailable contexts:")
            try:
                index = json.loads(index_path.read_text(encoding='utf-8'))
                memories = index.get("memories", [])
                for s in memories[:5]:
                    sid = s.get("session_id", "unknown")[:8]
                    ts = format_timestamp(s.get("created_at", ""))
                    print(f"  - [{sid}...] {ts}")
            except (json.JSONDecodeError, FileNotFoundError):
                pass
            return
    else:
        # Load latest memory
        memory_content, entry = load_latest_memory(str(memories_dir.parent))
        if not memory_content:
            print("No context memories found.")
            return

    # Display the context
    print("## Context Memory Loaded\n")
    print(f"**Session ID:** {entry.get('session_id', 'unknown')}")
    print(f"**Created:** {format_timestamp(entry.get('created_at', ''))}")
    print(f"**Trigger:** {entry.get('trigger', '-')}")
    print(f"**Messages:** {entry.get('message_count', 0)}")
    print()
    print("---")
    print()
    print(memory_content)
    print()
    print("---")
    print("Would you like me to use this context for our conversation?")


def main():
    # Determine mode: if stdin has data, it's automatic mode; otherwise manual
    import select

    # Check if stdin has data (automatic mode)
    if select.select([sys.stdin], [], [], 0.0)[0]:
        # stdin has data - automatic hook mode
        automatic_mode()
    else:
        # No stdin data - manual command mode
        identifier = sys.argv[1] if len(sys.argv) > 1 else None
        manual_mode(identifier)


if __name__ == "__main__":
    main()