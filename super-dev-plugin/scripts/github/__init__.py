"""
GitHub MCP HTTP Connector Scripts

Scripts for interacting with GitHub MCP server for repository operations.

Available Scripts:
- github_search_code.py: Search code across all GitHub repositories
- github_search_repos.py: Search for repositories by name/description
- github_file_contents.py: Get file or directory contents from a repository

Requirements:
- GitHub MCP server configured in Claude Code with type: "http"
- mcp-use package (auto-installed)
- GitHub authentication (via headers in config)

Configuration:
Add to ~/.claude.json or .claude/settings.json:
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer YOUR_GITHUB_TOKEN"
      }
    }
  }
}

Note: GitHub token is required for authenticated API access.
Get a token at: https://github.com/settings/tokens
"""
