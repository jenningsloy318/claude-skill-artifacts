"""
DeepWiki MCP HTTP Connector Scripts

Scripts for interacting with DeepWiki MCP server for GitHub repository documentation.

Available Scripts:
- deepwiki_structure.py: Get wiki structure for a repository
- deepwiki_contents.py: Get wiki contents for a repository
- deepwiki_ask.py: Ask questions about a repository

Requirements:
- DeepWiki MCP server configured in Claude Code with type: "http"
- mcp-use package (auto-installed)

Configuration:
Add to ~/.claude.json or .claude/settings.json:
{
  "mcpServers": {
    "deepwiki": {
      "type": "http",
      "url": "https://mcp.deepwiki.com/mcp",
      "headers": {}
    }
  }
}
"""
