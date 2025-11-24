# Claude Artifacts

A Claude Code plugin marketplace for session management, context persistence, and productivity tools.

**Repository**: https://github.com/jenningsloy318/claude-artifacts

## Plugins

| Plugin | Description | Version |
|--------|-------------|---------|
| [session-persistence](./session-persistence-plugin/) | Automatically summarize and persist Claude Code sessions before context compaction | v1.0.0 |

## Installation

```bash
# Add the marketplace
claude plugin marketplace add jenningsloy318/claude-artifacts

# Install a plugin
claude plugin install session-persistence@claude-artifacts
```

## Quick Start: Session Persistence Plugin

```bash
# 1. Add marketplace and install plugin
claude plugin marketplace add jenningsloy318/claude-artifacts
claude plugin install session-persistence@claude-artifacts

# 2. (Optional) Set API key for LLM-based summaries
export CLAUDE_SUMMARY_API_KEY="your-api-key"

# 3. Use Claude Code normally - summaries are automatic!
```

## Marketplace Management

```bash
# Add this marketplace
claude plugin marketplace add jenningsloy318/claude-artifacts

# List all marketplaces
claude plugin marketplace list

# Update marketplace (fetch latest plugins)
claude plugin marketplace update claude-artifacts

# Remove marketplace
claude plugin marketplace remove claude-artifacts
```

## Plugins Overview

### Session Persistence Plugin

Automatically saves session summaries before context compaction and restores context on resume.

**Features:**
- PreCompact hook for automatic session summarization
- SessionStart hook for context restoration
- `/load-session` command for manual loading
- Session management skill for natural language queries
- LLM-based or structured extraction summaries

**Environment Variables:**

| Variable | Description | Required |
|----------|-------------|----------|
| `CLAUDE_SUMMARY_API_KEY` | API key for Claude LLM summarization | No (has fallback) |
| `ANTHROPIC_API_KEY` | Fallback API key | No |
| `CLAUDE_SUMMARY_API_URL` | Custom API base URL | No |

See [session-persistence-plugin/README.md](./session-persistence-plugin/README.md) for full documentation.

## Repository Structure

```
claude-artifacts/
├── .claude-plugin/
│   └── marketplace.json           # Marketplace manifest
├── README.md                      # This file
├── session-persistence-plugin/    # Session persistence plugin
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── hooks/
│   ├── commands/
│   ├── skills/
│   └── README.md
├── specification/                 # Design documents and specs
└── [future-plugins]/              # More plugins to come
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

**Issues**: https://github.com/jenningsloy318/claude-artifacts/issues

## License

MIT License - See individual plugin directories for specific licenses.
