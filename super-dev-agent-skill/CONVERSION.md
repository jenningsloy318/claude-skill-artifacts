# AgentSkill Conversion Summary

This document summarizes the conversion of the super-dev Claude Code plugin to the AgentSkill format.

## What Changed

### From Claude Code Plugin to AgentSkill

| Aspect | Claude Code Plugin | AgentSkill |
|--------|-------------------|------------|
| **Structure** | `.claude-plugin/` directory with `plugin.json` | Root `SKILL.md` with YAML frontmatter |
| **Agents** | Defined in `agents/*.md` | Separate skills in `skills/*/SKILL.md` |
| **Commands** | Slash commands in `commands/` | Natural language triggers in main `SKILL.md` |
| **Loading** | Plugin marketplace | Skill loading via natural language |
| **Invocation** | `/super-dev:run` or `@super-dev` | "Load skill: super-dev" or "I'm using super-dev to..." |

## Directory Structure

```
super-dev-agent-skill/
├── SKILL.md                      # Main orchestration skill
│   └── Contains: Workflow phases, agent loading instructions
├── README.md                     # User documentation
│   └── Contains: Installation, usage, examples
├── skills/                       # Sub-skills (formerly agents)
│   ├── coordinator/
│   │   └── SKILL.md             # Team Lead orchestrator
│   ├── requirements-clarifier/
│   │   └── SKILL.md             # Phase 2 skill
│   ├── research-agent/
│   │   └── SKILL.md             # Phase 3 skill
│   ├── debug-analyzer/
│   │   └── SKILL.md             # Phase 4 skill
│   ├── code-assessor/
│   │   └── SKILL.md             # Phase 5 skill
│   ├── architecture-agent/
│   │   └── SKILL.md             # Phase 5.3 skill
│   ├── ui-ux-designer/
│   │   └── SKILL.md             # Phase 5.5 skill
│   ├── spec-writer/
│   │   └── SKILL.md             # Phase 6 skill
│   ├── dev-executor/
│   │   └── SKILL.md             # Phase 8 skill
│   ├── qa-agent/
│   │   └── SKILL.md             # Phase 8/9.5 skill
│   └── code-reviewer/
│       └── SKILL.md             # Phase 9 skill
├── references/                   # Supporting documentation
│   ├── WORKFLOW.md              # Complete workflow reference
│   ├── STANDARDS.md             # Coding standards
│   └── COMMANDS.md              # Command/skill reference
└── scripts/                      # Utility scripts
    └── git-worktree.sh          # Git worktree helper
```

## How to Use

### 1. Complete Workflow

Start the full 13-phase workflow:

```
I'm using super-dev to implement: user authentication with JWT tokens
```

The main skill will guide you through:
1. Loading the coordinator skill
2. Setting up the worktree
3. Executing all phases
4. Merging the results

### 2. Individual Skills

Load specific skills for focused tasks:

```
Load skill: super-dev/requirements-clarifier
Task: Clarify requirements for the payment system
```

```
Load skill: super-dev/research-agent  
Task: Research best practices for payment processing
```

```
Load skill: super-dev/dev-executor
Task: Implement the payment API endpoints according to spec
```

### 3. Skill Loading Syntax

Different tools may use different syntax:

**OpenCode:**
```
/skill load super-dev/coordinator
```

**Claude Code:**
```
Load skill: super-dev/coordinator
```

**Natural Language (universal):**
```
I'm using the super-dev coordinator skill to orchestrate this task
```

## Key Differences from Plugin

### 1. No Plugin Manifest

Instead of `plugin.json`, the main `SKILL.md` contains:
- YAML frontmatter with metadata
- Instructions for orchestration
- References to sub-skills

### 2. Skills vs Agents

In AgentSkill format:
- **Skill** = A package of instructions in `SKILL.md`
- **Sub-skills** = Separate skills loaded on demand
- **No explicit "agent" concept** - the tool's agent loads and follows skill instructions

### 3. Progressive Disclosure

AgentSkill format supports progressive disclosure:
1. **Metadata** (~100 tokens) - Loaded at startup
2. **Instructions** (<5000 tokens) - Loaded when skill activated
3. **Resources** - Loaded on demand from `references/`

### 4. Natural Language Commands

Instead of slash commands:
- Plugin: `/plan [task]`
- AgentSkill: "Load skill: super-dev/planner" or "Plan this implementation"

## Migration Guide

### For Plugin Users

If you were using the super-dev plugin:

1. **Install the AgentSkill** to your tool's skills directory
2. **Update your workflow**:
   - Old: `/super-dev:run Fix the login bug`
   - New: "I'm using super-dev to fix the login bug"
3. **Sub-skills load automatically** during workflow

### For Tool Developers

To integrate this AgentSkill:

1. **Support the AgentSkill format**:
   - Parse YAML frontmatter
   - Load SKILL.md content
   - Support relative references

2. **Implement skill loading**:
   ```python
   def load_skill(skill_path):
       skill_md = read_file(f"{skill_path}/SKILL.md")
       metadata = parse_yaml_frontmatter(skill_md)
       instructions = parse_markdown_body(skill_md)
       return Skill(metadata, instructions)
   ```

3. **Support sub-skill loading**:
   - When main skill references `super-dev/coordinator`
   - Resolve to `skills/coordinator/SKILL.md`
   - Load and apply instructions

## Workflow Execution

### Phase-by-Phase Skill Loading

```
Phase 0:  super-dev (main skill) - Load dev rules
Phase 1:  super-dev (main skill) - Setup worktree
Phase 2:  Load skill: super-dev/requirements-clarifier
Phase 3:  Load skill: super-dev/research-agent
Phase 4:  Load skill: super-dev/debug-analyzer
Phase 5:  Load skill: super-dev/code-assessor
Phase 5.3: Load skill: super-dev/architecture-agent
Phase 5.5: Load skill: super-dev/ui-ux-designer
Phase 6:  Load skill: super-dev/spec-writer
Phase 8:  Load skill: super-dev/dev-executor + super-dev/qa-agent
Phase 9:  Load skill: super-dev/code-reviewer
Phase 9.5: Load skill: super-dev/qa-agent
Phase 10: Load skill: super-dev/docs-executor
Phase 12: super-dev (main skill) - Commit & merge
```

## Benefits of AgentSkill Format

1. **Tool Agnostic** - Works with any AgentSkill-compatible tool
2. **Progressive Loading** - Efficient context usage
3. **Modular** - Use only the skills you need
4. **Standardized** - Follows open standard
5. **Portable** - Easy to share across tools

## Validation

To validate the AgentSkill format:

1. **Check YAML frontmatter**:
   - Required: `name`, `description`
   - Optional: `license`, `metadata`, `compatibility`

2. **Verify directory structure**:
   - Main `SKILL.md` in root
   - Sub-skills in `skills/{name}/SKILL.md`
   - References in `references/`

3. **Test skill loading**:
   - Load main skill
   - Verify instructions are clear
   - Load sub-skills
   - Verify workflow executes

## References

- [AgentSkill Specification](https://agentskills.io/specification)
- [Anthropic Skills Examples](https://github.com/anthropics/skills)
- [AgentSkill GitHub](https://github.com/agentskills/agentskills)

## Support

For issues or questions:
- AgentSkill format: https://agentskills.io/
- This skill: See README.md
