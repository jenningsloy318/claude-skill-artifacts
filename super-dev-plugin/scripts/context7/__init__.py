"""
Context7 MCP HTTP Connector Scripts

Scripts for interacting with Context7 MCP server for library documentation.

Available Scripts:
- context7_resolve.py: Resolve library name to Context7-compatible library ID
- context7_docs.py: Get library documentation with optional topic filtering

Requirements:
- Context7 MCP server configured in Claude Code with type: "http"
- mcp-use package (auto-installed)

Configuration:
Add to ~/.claude.json or .claude/settings.json:
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {}
    }
  }
}

Typical Workflow:
1. Use context7_resolve.py to find the library ID for a package
2. Use context7_docs.py with the resolved ID to get documentation
"""
