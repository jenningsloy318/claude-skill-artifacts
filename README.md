# Claude Artifacts

A Claude Code plugin marketplace for context persistence and productivity tools.

**Repository**: https://github.com/jenningsloy318/claude-artifacts

## Plugins

| Plugin | Description | Version |
|--------|-------------|---------|
| [context-keeper](./context-keeper-plugin/) | Automatically summarize and persist conversation context before compaction | v1.0.0 |
| [dev-workflow](./dev-workflow-plugin/) | Comprehensive development workflow with structured phases for implementing features, fixing bugs, and refactoring | v1.0.0 |

## Getting Started

```bash
# 1. Add the marketplace
claude plugin marketplace add jenningsloy318/claude-artifacts

# 2. Install plugins
claude plugin install context-keeper@claude-artifacts
claude plugin install dev-workflow@claude-artifacts

# 3. (Optional) Set API key for LLM-based summaries in context-keeper
export CLAUDE_SUMMARY_API_KEY="your-api-key"
# Or use your existing Anthropic API key as fallback
export ANTHROPIC_API_KEY="your-api-key"

# 4. Use Claude Code normally - plugins are active!
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

### Context Keeper Plugin

Automatically saves context summaries before compaction and restores context on resume.

**Features:**
- PreCompact hook for automatic context summarization
- SessionStart hook for context restoration
- `/load-context` command for manual loading
- Context management skill for natural language queries
- LLM-based or structured extraction summaries

**Environment Variables:**

| Variable | Description | Required |
|----------|-------------|----------|
| `CLAUDE_SUMMARY_API_KEY` | API key for Claude LLM summarization | No (has fallback) |
| `ANTHROPIC_API_KEY` | Fallback API key | No |
| `CLAUDE_SUMMARY_API_URL` | Custom API base URL | No |

See [context-keeper-plugin/README.md](./context-keeper-plugin/README.md) for full documentation.

### Dev Workflow Plugin

A comprehensive 11-phase development workflow for implementing features, fixing bugs, and refactoring code.

**Features:**
- Structured specification and planning phases
- Research-driven implementation with multi-source search
- Specialized agents for each phase (requirements, research, debugging, coding)
- Built-in quality gates and code review
- `/fix-impl` command for quick task execution

**Key Agents:**
| Agent | Purpose |
|-------|---------|
| `requirements-clarifier` | Gather and document complete requirements |
| `research-agent` | Find best practices and documentation |
| `debug-analyzer` | Root cause analysis for bugs |
| `code-assessor` | Evaluate existing codebase |
| `spec-writer` | Create tech specs and implementation plans |
| `execution-coordinator` | Coordinate parallel implementation |

**Usage:**
```bash
/dev-workflow:fix-impl Fix the login button not responding on mobile
/dev-workflow:fix-impl Implement user profile page with avatar upload
```

See [dev-workflow-plugin/README.md](./dev-workflow-plugin/README.md) for full documentation.

## Repository Structure

```
claude-artifacts/
├── .claude-plugin/
│   └── marketplace.json           # Marketplace manifest
├── README.md                      # This file
├── context-keeper-plugin/         # Context persistence plugin
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── hooks/
│   ├── commands/
│   ├── skills/
│   └── README.md
├── dev-workflow-plugin/           # Development workflow plugin
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── agents/                    # Specialized workflow agents
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
