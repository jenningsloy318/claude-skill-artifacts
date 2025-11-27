# Research Report: Coordinator-Driven Architecture

**Date:** 2025-11-27
**Author:** Claude
**Status:** Complete

## 1. Executive Summary

This research explores multi-agent orchestration patterns for implementing a dedicated Coordinator Agent architecture in the dev-workflow plugin.

## 2. Multi-Agent Orchestration Patterns

### 2.1 Supervisor Agent Pattern (Amazon Bedrock)

**Source:** AWS Solutions Library (2025)

Key characteristics:
- Supervisor agent orchestrates multiple specialized sub-agents
- Automatic task delegation and response aggregation
- Native collaboration feature for comprehensive business scenarios

**Relevance:** This is the primary pattern we'll adopt - a central Coordinator that delegates all work.

### 2.2 Agent Squad Microservices Pattern

**Source:** AWS Agent Squad (2025)

Key characteristics:
- Microservices architecture for agent coordination
- Each agent is a separate service
- Central orchestrator routes requests

**Relevance:** Good for understanding agent isolation and communication patterns.

### 2.3 LangGraph Workflow Orchestration

**Source:** AIMultiple Benchmark (2025)

Key characteristics:
- State machine-based workflow
- Explicit transitions between agents
- 2.2x faster than CrewAI in benchmarks
- Efficient token usage

**Relevance:** Informs our phase transition design and performance considerations.

### 2.4 Goal-Based Orchestration (Orpheus)

**Source:** AAAI Conference (2025)

Key characteristics:
- Internal logic organized by goals rather than message reactions
- Decentralized multiagent systems
- Information protocols between agents

**Relevance:** Validates goal-oriented task assignment approach.

## 3. Best Practices Identified

### 3.1 Central Coordinator Responsibilities

1. **Task Assignment**: Route tasks to appropriate specialist agents
2. **Progress Monitoring**: Track all sub-agent work to completion
3. **State Management**: Maintain workflow state across phases
4. **Error Handling**: Catch and handle sub-agent failures
5. **Quality Gates**: Verify outputs before proceeding

### 3.2 Parallel Execution Patterns

From research benchmarks:
- Parallel agents 2-5x faster than sequential
- Token efficiency varies by framework (8-9x differences)
- State synchronization critical for parallel work

**Recommendation:** For execution phase, run dev/QA/docs agents in parallel with coordination points.

### 3.3 Build Serialization

For Rust/Go projects:
- Only one build at a time prevents resource conflicts
- Build queue managed by Coordinator
- Development agent requests build slot
- QA agent waits for build completion

### 3.4 Time-Aware Research

For keeping information current:
- Always include current date/time in research context
- Prefer recent sources (< 1 year old)
- Filter out deprecated/outdated information
- Use Time MCP for timestamp injection

## 4. Claude Code Plugin Architecture Constraints

### 4.1 Current Plugin Structure

```
dev-workflow-plugin/
├── .claude-plugin/
│   └── plugin.json       # Plugin metadata
├── skills/
│   ├── dev-workflow/     # Main skill (SKILL.md)
│   └── dev-rules/        # Rules skill
├── agents/
│   └── *.md              # Agent definitions
└── commands/
    └── fix-impl.md       # Slash command
```

### 4.2 Agent Invocation

Agents are invoked via:
```
Task(
  prompt: "...",
  subagent_type: "plugin-name:agent-name"
)
```

### 4.3 Skill Activation

Skills are activated by:
- Direct invocation: `Skill(skill: "plugin-name:skill-name")`
- User request matching skill description

## 5. Recommended Architecture

### 5.1 New Plugin Structure

```
super-dev-plugin/                    # Renamed from dev-workflow-plugin
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── super-dev/                   # Main entry skill
│   │   └── SKILL.md
│   └── dev-rules/                   # Keep existing
│       └── SKILL.md
├── agents/
│   ├── coordinator.md               # NEW: Central Coordinator Agent
│   ├── requirements-clarifier.md    # Existing (unchanged)
│   ├── research-agent.md            # Updated for time MCP
│   ├── search-agent.md              # Existing (unchanged)
│   ├── debug-analyzer.md            # Updated for grep/ast-grep
│   ├── code-assessor.md             # Updated for grep/ast-grep
│   ├── spec-writer.md               # Existing (unchanged)
│   ├── execution-coordinator.md     # Renamed to dev-executor.md
│   ├── qa-executor.md               # NEW: Dedicated QA executor
│   ├── docs-executor.md             # NEW: Dedicated docs executor
│   └── [developer agents]           # Existing (unchanged)
└── commands/
    └── fix-impl.md                  # Updated for new skill name
```

### 5.2 Coordinator Agent Flow

```
                    ┌─────────────────┐
                    │  User Request   │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   Coordinator   │ ◄── Central Orchestrator
                    │     Agent       │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
   ┌─────────┐         ┌─────────┐         ┌─────────┐
   │ Phase 1 │────────▶│ Phase N │────────▶│  Final  │
   │ Agent   │         │ Agent   │         │  Phase  │
   └─────────┘         └─────────┘         └─────────┘
```

### 5.3 Execution Phase Parallel Flow

```
                    ┌─────────────────┐
                    │   Coordinator   │
                    └────────┬────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
   ┌───────────┐      ┌───────────┐      ┌───────────┐
   │  Dev      │      │    QA     │      │   Docs    │
   │ Executor  │      │ Executor  │      │ Executor  │
   └─────┬─────┘      └─────┬─────┘      └─────┬─────┘
         │                   │                   │
         │    [Build Queue - One at a time]     │
         │           for Rust/Go                │
         └───────────────────┼───────────────────┘
                             │
                    ┌────────▼────────┐
                    │ Task Complete   │
                    │ → Commit/Stash  │
                    │ → Next Task     │
                    └─────────────────┘
```

## 6. Plugin Naming Options

| Option | Pros | Cons |
|--------|------|------|
| `super-dev` | Short, memorable | Generic |
| `orchestrated-dev` | Descriptive | Long |
| `coordinator-workflow` | Accurate | Long |
| `superdev` | Very short | May seem unprofessional |
| `dev-orchestrator` | Descriptive | Long |

**Recommendation:** `super-dev` - Short, memorable, indicates enhanced capabilities.

## 7. Conclusion

The research supports implementing a dedicated Coordinator Agent using the Supervisor Agent pattern. Key elements:

1. **Central Authority**: Single Coordinator orchestrates all phases
2. **Parallel Execution**: Dev/QA/Docs run concurrently in execution phase
3. **Build Serialization**: One build at a time for Rust/Go
4. **Time-Aware Research**: Always include current timestamp
5. **Comprehensive Search**: Use grep/ast-grep for code analysis
6. **Plugin Rename**: Suggest `super-dev` for new plugin name
