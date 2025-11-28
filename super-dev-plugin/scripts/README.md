# MCP HTTP Connector Scripts

Scripts for connecting to HTTP-based MCP servers configured in Claude Code.

## Quick Start

```bash
# Web search with Exa
python3 scripts/exa/exa_search.py --query "Next.js 15 best practices" --results 5

# Code context with Exa
python3 scripts/exa/exa_code.py --query "React hooks patterns" --tokens 5000

# Get repo documentation structure with DeepWiki
python3 scripts/deepwiki/deepwiki_structure.py --repo "facebook/react"

# Resolve library ID with Context7
python3 scripts/context7/context7_resolve.py --library "react"

# Search code on GitHub
python3 scripts/github/github_search_code.py --query "HttpConnector language:python"
```

## How It Works

These scripts use `mcp-use` library's `HttpConnector` to connect to HTTP MCP servers:

```
Agent (Bash) ──► Script ──► HttpConnector ──► MCP HTTP Server
                   │
                   ▼
             ~/.claude.json (reads config)
```

**Key Requirement:** Only works with **HTTP-based** MCP servers (`type: "http"`), not stdio servers.

## Available Scripts

### Exa Scripts

| Script | Description | Tool |
|--------|-------------|------|
| `exa/exa_search.py` | Web search | `web_search_exa` |
| `exa/exa_code.py` | Code context search | `get_code_context_exa` |

### DeepWiki Scripts

| Script | Description | Tool |
|--------|-------------|------|
| `deepwiki/deepwiki_structure.py` | Get repo docs structure | `read_wiki_structure` |
| `deepwiki/deepwiki_contents.py` | Get repo docs contents | `read_wiki_contents` |
| `deepwiki/deepwiki_ask.py` | Ask questions about a repo | `ask_question` |

### Context7 Scripts

| Script | Description | Tool |
|--------|-------------|------|
| `context7/context7_resolve.py` | Resolve library ID | `resolve-library-id` |
| `context7/context7_docs.py` | Get library documentation | `get-library-docs` |

### GitHub Scripts

| Script | Description | Tool |
|--------|-------------|------|
| `github/github_search_code.py` | Search code across repos | `search_code` |
| `github/github_search_repos.py` | Search for repositories | `search_repositories` |
| `github/github_file_contents.py` | Get file/directory contents | `get_file_contents` |

### Usage Examples

```bash
# Exa web search
python3 scripts/exa/exa_search.py \
  --query "React 19 new features" \
  --type deep \
  --results 10 \
  --context-chars 15000

# Exa code context
python3 scripts/exa/exa_code.py \
  --query "Next.js app router middleware" \
  --tokens 10000

# DeepWiki - Get documentation structure
python3 scripts/deepwiki/deepwiki_structure.py \
  --repo "vercel/next.js"

# DeepWiki - Get documentation contents
python3 scripts/deepwiki/deepwiki_contents.py \
  --repo "vercel/next.js"

# DeepWiki - Ask a question
python3 scripts/deepwiki/deepwiki_ask.py \
  --repo "vercel/next.js" \
  --question "How do I use the App Router?"

# Context7 - Resolve library ID
python3 scripts/context7/context7_resolve.py \
  --library "next.js"

# Context7 - Get library documentation
python3 scripts/context7/context7_docs.py \
  --library-id "/vercel/next.js" \
  --mode code \
  --topic "routing" \
  --page 1

# GitHub - Search code
python3 scripts/github/github_search_code.py \
  --query "HttpConnector language:python repo:modelcontextprotocol/python-sdk" \
  --per-page 10

# GitHub - Search repositories
python3 scripts/github/github_search_repos.py \
  --query "topic:mcp stars:>100" \
  --sort stars \
  --order desc

# GitHub - Get file contents
python3 scripts/github/github_file_contents.py \
  --owner "modelcontextprotocol" \
  --repo "python-sdk" \
  --path "src/mcp/client/"
```

## Creating New Scripts

1. **Copy the template:**
   ```bash
   mkdir scripts/new_server
   cp specification/11-mcp-http-connector/template_connector.py scripts/new_server/new_tool.py
   ```

2. **Customize the script:**
   - Update `SERVER_PATTERN` to match your MCP server name
   - Update `TOOL_NAME` to the target tool
   - Modify CLI arguments as needed
   - Map arguments to tool parameters

3. **Test:**
   ```bash
   python3 scripts/new_server/new_tool.py --query "test"
   ```

See [MCP HTTP Connector Specification](../../specification/11-mcp-http-connector/01-specification.md) for detailed specification.

## Output Format

All scripts output JSON:

```json
{
  "success": true,
  "data": { ... },
  "metadata": {
    "tool": "tool_name",
    "server": "server_name",
    "url": "https://...",
    "timestamp": "2025-11-28T03:30:00+00:00"
  }
}
```

On error:
```json
{
  "success": false,
  "error": "Error message",
  "error_type": "ErrorClassName"
}
```

## Configuration

Scripts auto-discover MCP config from:
1. `~/.claude.json`
2. `~/.claude/settings.json`
3. `~/.claude/settings.local.json`
4. `.claude/settings.json` (project)
5. `.claude/settings.local.json` (project)

Expected config structure:
```json
{
  "mcpServers": {
    "server-name": {
      "type": "http",
      "url": "https://mcp.example.com/mcp",
      "headers": {
        "API_KEY": "your-key"
      }
    }
  }
}
```

## Supported HTTP MCP Servers

| Server | Config Pattern | Common Tools |
|--------|---------------|--------------|
| Exa | `exa` | `web_search_exa`, `get_code_context_exa` |
| DeepWiki | `deepwiki` | `read_wiki_structure`, `read_wiki_contents` |
| Context7 | `context7` | `resolve-library-id`, `get-library-docs` |
| GitHub | `github` | Various repository tools |

## Dependencies

- Python 3.10+
- `mcp-use` (auto-installed on first run)

## Troubleshooting

### "HTTP MCP server not found"

Ensure your server is configured with `type: "http"`:
```json
{
  "mcpServers": {
    "exa": {
      "type": "http",  // <-- Must be "http", not "stdio"
      "url": "https://..."
    }
  }
}
```

### "Tool not found"

The tool name might differ. Check available tools:
```python
# Add debug print in script
print(f"Available tools: {tool_names}", file=sys.stderr)
```

### Connection errors

1. Check MCP server URL is correct
2. Verify API keys/headers in config
3. Test server connectivity: `curl -I <url>`
