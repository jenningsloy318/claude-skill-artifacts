#!/usr/bin/env python3
"""
Exa Web Search Script: Execute web searches using Exa MCP server.

Uses mcp-use to automatically discover and connect to Exa MCP server
from Claude Code configuration.

Usage:
    python3 exa_search.py --query "search terms" [--type auto|fast|deep] [--results 8]

Output:
    JSON formatted search results to stdout
"""

import argparse
import asyncio
import json
import subprocess
import sys
from datetime import datetime
from pathlib import Path


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


def find_claude_config() -> Path | None:
    """Find Claude Code config file."""
    config_paths = [
        Path.home() / ".claude.json",
        Path.home() / ".claude" / "settings.json",
        Path.home() / ".claude" / "settings.local.json",
        Path.cwd() / ".claude" / "settings.json",
        Path.cwd() / ".claude" / "settings.local.json",
    ]
    for path in config_paths:
        if path.exists():
            return path
    return None


async def search_with_mcp(query: str, search_type: str, num_results: int, context_chars: int) -> dict:
    """Execute search using mcp-use client."""
    if not ensure_mcp_use_installed():
        return {
            "success": False,
            "error": "Failed to install mcp-use package",
            "error_type": "DependencyError"
        }

    try:
        from mcp_use import MCPClient
    except ImportError:
        return {
            "success": False,
            "error": "mcp-use import failed",
            "error_type": "DependencyError"
        }

    # Find Claude config file
    config_path = find_claude_config()
    if not config_path:
        return {
            "success": False,
            "error": "Claude Code config not found",
            "error_type": "ConfigurationError"
        }

    try:
        # Load client from Claude Code config
        client = MCPClient.from_config_file(str(config_path))
        await client.create_all_sessions()

        # Find Exa server and its tools
        exa_session = None
        exa_server_name = None

        for name in client.sessions.keys():
            if "exa" in name.lower():
                exa_session = client.get_session(name)
                exa_server_name = name
                break

        if not exa_session:
            # List available servers for error message
            available = list(client.sessions.keys()) if client.sessions else []
            return {
                "success": False,
                "error": f"Exa server not found. Available servers: {available}",
                "error_type": "ConfigurationError"
            }

        # List tools to find the search tool
        tools = await exa_session.list_tools()
        tool_names = [t.name for t in tools]

        # Find web search tool
        search_tool = None
        for name in ["web_search_exa", "search", "web_search"]:
            if name in tool_names:
                search_tool = name
                break

        if not search_tool:
            return {
                "success": False,
                "error": f"Search tool not found. Available tools: {tool_names}",
                "error_type": "ToolError"
            }

        # Call the search tool
        result = await exa_session.call_tool(
            name=search_tool,
            arguments={
                "query": query,
                "type": search_type,
                "numResults": num_results,
                "contextMaxCharacters": context_chars
            }
        )

        if getattr(result, "isError", False):
            return {
                "success": False,
                "error": str(result.content),
                "error_type": "ToolError"
            }

        if result.content:
            content_text = result.content[0].text if hasattr(result.content[0], 'text') else str(result.content[0])
            try:
                parsed = json.loads(content_text)
            except json.JSONDecodeError:
                parsed = content_text

            return {
                "success": True,
                "query": query,
                "results": parsed,
                "metadata": {
                    "tool": search_tool,
                    "server": exa_server_name,
                    "timestamp": datetime.utcnow().isoformat() + "Z"
                }
            }

        return {"success": True, "query": query, "results": []}

    except Exception as e:
        return {
            "success": False,
            "error": str(e),
            "error_type": type(e).__name__
        }
    finally:
        await client.close_all_sessions()


def main():
    parser = argparse.ArgumentParser(
        description="Web search using Exa MCP server (auto-discovers from Claude Code config)"
    )
    parser.add_argument("--query", "-q", required=True, help="Search query")
    parser.add_argument("--type", "-t", choices=["auto", "fast", "deep"], default="auto")
    parser.add_argument("--results", "-r", type=int, default=8)
    parser.add_argument("--context-chars", "-c", type=int, default=10000)

    args = parser.parse_args()
    result = asyncio.run(search_with_mcp(args.query, args.type, args.results, args.context_chars))
    print(json.dumps(result, indent=2))
    sys.exit(0 if result.get("success") else 1)


if __name__ == "__main__":
    main()
