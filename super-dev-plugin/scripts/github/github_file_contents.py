#!/usr/bin/env python3
"""
GitHub File Contents Script: Get file or directory contents from a GitHub repository.

Connects to the GitHub MCP HTTP server configured in Claude Code.
Retrieves the contents of a file or lists contents of a directory.

Usage:
    # Get file contents
    python3 github_file_contents.py --owner "facebook" --repo "react" --path "README.md"

    # List directory contents
    python3 github_file_contents.py --owner "facebook" --repo "react" --path "src/"

    # Get file from specific branch/commit
    python3 github_file_contents.py --owner "facebook" --repo "react" --path "README.md" --ref "main"

Output:
    JSON formatted file/directory contents to stdout
"""

import argparse
import asyncio
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

# ============================================================================
# CONFIGURATION
# ============================================================================

SERVER_PATTERN = "github"
TOOL_NAME = "get_file_contents"

# ============================================================================
# CORE FUNCTIONS
# ============================================================================


def ensure_mcp_use_installed():
    """Ensure mcp-use package is installed, install if missing."""
    try:
        import mcp_use
        return True
    except ImportError:
        print("Installing mcp-use package...", file=sys.stderr)
        try:
            subprocess.check_call(
                [sys.executable, "-m", "pip", "install", "mcp-use", "-q"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
            print("mcp-use installed successfully.", file=sys.stderr)
            return True
        except subprocess.CalledProcessError as e:
            print(f"Failed to install mcp-use: {e}", file=sys.stderr)
            return False


def find_mcp_config(server_pattern: str) -> dict | None:
    """Find MCP server config from Claude Code settings.

    Args:
        server_pattern: Lowercase pattern to match server name

    Returns:
        Dict with name, url, headers if found, None otherwise
    """
    config_paths = [
        Path.home() / ".claude.json",
        Path.home() / ".claude" / "settings.json",
        Path.home() / ".claude" / "settings.local.json",
        Path.cwd() / ".claude" / "settings.json",
        Path.cwd() / ".claude" / "settings.local.json",
    ]

    for path in config_paths:
        if path.exists():
            try:
                with open(path) as f:
                    config = json.load(f)

                mcp_servers = config.get("mcpServers", {})

                for name, server_config in mcp_servers.items():
                    if server_pattern in name.lower():
                        # MUST be HTTP type for external connection
                        if server_config.get("type") == "http":
                            return {
                                "name": name,
                                "url": server_config.get("url"),
                                "headers": server_config.get("headers", {})
                            }
            except (json.JSONDecodeError, IOError):
                continue

    return None


async def call_tool(arguments: dict) -> dict:
    """Call MCP tool via HttpConnector.

    Args:
        arguments: Tool arguments as dict

    Returns:
        Result dict with success, data, and metadata
    """
    if not ensure_mcp_use_installed():
        return {
            "success": False,
            "error": "Failed to install mcp-use package",
            "error_type": "DependencyError"
        }

    try:
        from mcp_use.client.connectors import HttpConnector
    except ImportError:
        return {
            "success": False,
            "error": "mcp-use HttpConnector import failed",
            "error_type": "DependencyError"
        }

    # Find server config
    mcp_config = find_mcp_config(SERVER_PATTERN)
    if not mcp_config:
        return {
            "success": False,
            "error": f"HTTP MCP server matching '{SERVER_PATTERN}' not found. "
                     "Ensure server is configured with type: 'http' in Claude Code.",
            "error_type": "ConfigurationError"
        }

    url = mcp_config.get("url")
    headers = mcp_config.get("headers", {})

    if not url:
        return {
            "success": False,
            "error": "MCP server URL not found in config",
            "error_type": "ConfigurationError"
        }

    connector = None
    try:
        # Create HttpConnector and connect
        connector = HttpConnector(base_url=url, headers=headers)
        await connector.connect()

        # List available tools (useful for debugging)
        tools = await connector.list_tools()
        tool_names = [t.name for t in tools]

        if TOOL_NAME not in tool_names:
            return {
                "success": False,
                "error": f"Tool '{TOOL_NAME}' not found. Available: {tool_names}",
                "error_type": "ToolError"
            }

        # Call the tool
        result = await connector.call_tool(name=TOOL_NAME, arguments=arguments)

        if getattr(result, "isError", False):
            return {
                "success": False,
                "error": str(result.content),
                "error_type": "ToolError"
            }

        # Extract content
        if result.content:
            content_text = (
                result.content[0].text
                if hasattr(result.content[0], 'text')
                else str(result.content[0])
            )
            try:
                parsed = json.loads(content_text)
            except json.JSONDecodeError:
                parsed = content_text

            return {
                "success": True,
                "data": parsed,
                "metadata": {
                    "tool": TOOL_NAME,
                    "server": mcp_config.get("name"),
                    "url": url,
                    "timestamp": datetime.now(timezone.utc).isoformat()
                }
            }

        return {"success": True, "data": None, "metadata": {}}

    except Exception as e:
        return {
            "success": False,
            "error": str(e),
            "error_type": type(e).__name__
        }
    finally:
        if connector:
            try:
                await connector.disconnect()
            except Exception:
                pass


# ============================================================================
# CLI
# ============================================================================


def main():
    parser = argparse.ArgumentParser(
        description=f"Get file or directory contents from a GitHub repository",
        epilog="Note: Directories must end with a slash '/'\n",
        formatter_class=argparse.RawDescriptionHelpFormatter
    )

    parser.add_argument(
        "--owner", "-o",
        required=True,
        help="Repository owner (username or organization)"
    )
    parser.add_argument(
        "--repo", "-r",
        required=True,
        help="Repository name"
    )
    parser.add_argument(
        "--path", "-p",
        default="/",
        help="Path to file or directory (directories must end with '/'. Default: '/')"
    )
    parser.add_argument(
        "--ref",
        help="Git ref such as 'refs/tags/v1.0.0', 'refs/heads/main', or 'refs/pull/123/head'"
    )
    parser.add_argument(
        "--sha",
        help="Commit SHA (if specified, used instead of ref)"
    )

    # Parse arguments
    args = parser.parse_args()

    # Map to tool parameters
    tool_arguments = {
        "owner": args.owner,
        "repo": args.repo,
        "path": args.path
    }

    # Add optional parameters
    if args.ref:
        tool_arguments["ref"] = args.ref
    if args.sha:
        tool_arguments["sha"] = args.sha

    # Call the tool
    result = asyncio.run(call_tool(tool_arguments))

    # Output result as JSON
    print(json.dumps(result, indent=2))
    sys.exit(0 if result.get("success") else 1)


if __name__ == "__main__":
    main()
