# Super Dev AgentSkill

Agent-driven development workflow for implementing features, fixing bugs, and refactoring code. This is an [AgentSkill](https://agentskills.io/) compatible skill that works with any AgentSkill-compatible tool.

## Overview

Super Dev provides a systematic 13-phase development workflow orchestrated by specialized agent skills. Each phase is handled by a dedicated skill that can be loaded on demand.

## Installation

### For AgentSkill-Compatible Tools

1. Clone or copy this directory to your skills folder
2. The main skill is in `SKILL.md`
3. Sub-skills are in `skills/` directory

### Directory Structure

```
super-dev-agent-skill/
├── SKILL.md                    # Main orchestration skill (contains all phases)
├── README.md                   # This file
├── references/                 # Reference documentation (optional)
│   ├── WORKFLOW.md            # Complete workflow guide
│   ├── STANDARDS.md           # Coding standards
│   └── COMMANDS.md            # Command reference
└── scripts/                    # Utility scripts (optional)
    └── git-worktree.sh        # Git worktree helper
```

## Usage

### Starting a Development Task

Simply reference the skill and describe your task:

```
I'm using super-dev to implement: user authentication with JWT tokens
```

The skill will guide you through loading the coordinator skill and executing all phases.

### Using Specific Phases

The skill automatically guides you through all phases. You can also reference specific phases:

```
I'm using super-dev to research: JWT authentication best practices
```

```
I'm using super-dev to clarify requirements for: user authentication
```

## Workflow Phases

The super-dev workflow consists of 13 phases, all orchestrated by the main skill:

| Phase | Description | Purpose |
|-------|-------------|---------|
| 0 | Apply dev rules | Load coding standards |
| 1 | Specification setup | Create worktree & spec directory |
| 2 | Requirements clarification | Gather and document requirements |
| 3 | Research | Research best practices |
| 4 | Debug analysis | Root cause analysis (bugs only) |
| 5 | Code assessment | Evaluate existing codebase |
| 5.3 | Architecture design | Design system architecture |
| 5.5 | UI/UX design | Create design specifications |
| 6 | Specification writing | Write technical specs |
| 7 | Specification review | Validate specifications |
| 8 | Execution & QA | Implement and test (parallel) |
| 9 | Code review | Review implementation |
| 10 | Documentation | Update docs |
| 11-13 | Cleanup & merge | Finalize and merge |

## Available Capabilities

The main `super-dev` skill contains all necessary instructions for the complete workflow. Simply describe what you need:

```
I'm using super-dev to implement: [feature description]
I'm using super-dev to fix: [bug description]
I'm using super-dev to refactor: [code area]
```

The skill will automatically guide you through the appropriate phases.

## Key Concepts

### Git Worktree Requirement

All development work MUST be done in a git worktree:

```bash
# Create worktree
git worktree add .worktree/01-feature-name -b 01-feature-name

# Navigate to worktree
cd .worktree/01-feature-name
```

### Specification Directory

All specifications are stored in:

```
specification/
└── [index]-[name]/
    ├── [index]-requirements.md
    ├── [index]-research-report.md
    ├── [index]-debug-analysis.md
    ├── [index]-assessment.md
    ├── [index]-architecture.md
    ├── [index]-design-spec.md
    ├── [index]-specification.md
    ├── [index]-implementation-plan.md
    ├── [index]-task-list.md
    └── [index]-workflow-tracking.json
```

### Skill Loading

In AgentSkill-compatible tools, skills are loaded on demand:

```
Load skill: super-dev/coordinator
Task: Orchestrate development of user authentication
```

The loaded skill provides instructions that guide the agent's behavior.

## Integration with AgentSkill Tools

### For OpenCode

Add to your skills directory:

```bash
# Clone to skills directory
git clone https://github.com/jenningsloy318/super-skill-claude-artifacts.git ~/.config/opencode/skills/super-dev
```

### For Claude Code

Install as a plugin or add to CLAUDE.md:

```bash
# Add skills path to CLAUDE.md
/skills/super-dev-agent-skill
```

### For Other Tools

Follow your tool's skill installation instructions and point to this directory.

## Configuration

### Environment Variables

Some skills may use environment variables:

```bash
# Optional: API keys for research
export EXA_API_KEY="your-key"
export PERPLEXITY_API_KEY="your-key"

# Optional: Git configuration
export GIT_AUTHOR_NAME="Your Name"
export GIT_AUTHOR_EMAIL="your@email.com"
```

### Customization

You can customize the workflow by:

1. Modifying instructions in `SKILL.md`
2. Adding custom standards in `references/coding-standards.md`
3. Creating project-specific rules

## Best Practices

1. **Always use worktrees** - Never develop in main working directory
2. **Follow the phases** - Each phase has a purpose
3. **Delegate completely** - Let each skill do its job
4. **Document everything** - Specifications drive implementation
5. **Test continuously** - QA runs in parallel with development

## Troubleshooting

### Skill Not Found

Ensure the skill directory structure is correct:
- Each skill must have a `SKILL.md` file
- Directory names must match skill names
- Use lowercase with hyphens

### Worktree Issues

Use the provided helper script:

```bash
./scripts/git-worktree.sh create 01-feature-name
./scripts/git-worktree.sh list
./scripts/git-worktree.sh remove 01-feature-name
```

## References

- [AgentSkill Specification](https://agentskills.io/specification)
- [Architecture Patterns](references/architecture-patterns.md)
- [Backend Patterns](references/backend-patterns.md)
- [Coding Standards](references/coding-standards.md)
- [Debugging Patterns](references/debugging-patterns.md)
- [Frontend Patterns](references/frontend-patterns.md)
- [Research Methodology](references/research-methodology.md)
- [Specification Templates](references/specification-templates.md)
- [Testing Patterns](references/testing-patterns.md)
- [UI/UX Patterns](references/ui-ux-patterns.md)

## License

MIT License - See LICENSE file for details

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Credits

- Original concept: Jennings Liu
- AgentSkill standard: [agentskills.io](https://agentskills.io/)
