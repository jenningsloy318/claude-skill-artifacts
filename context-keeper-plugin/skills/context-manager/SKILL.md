---
name: context-manager
description: Manage saved context summaries. Use when user wants to list, load, search, or manage saved context summaries. Triggers on phrases like "list contexts", "show summaries", "load context", "what contexts", "previous work", "context history", "what did we work on".
---

# Context Manager Skill

Manage context summaries created by the PreCompact hook.

## When to Activate

Use this skill when user:
- Asks about previous work ("what did we work on?", "show my contexts")
- Wants to list saved summaries ("list contexts", "context history")
- Needs to load specific context ("load the auth context", "restore previous work")
- Wants to search summaries ("find context about database")
- Asks about context management ("how many summaries", "delete old contexts")

## Directory Structure

Context summaries are stored in the project's `.claude/summaries/` directory:

```
.claude/summaries/
├── index.json                      # Global index of all summaries
└── {context_id}/
    ├── {timestamp}/
    │   ├── summary.md              # Human-readable summary
    │   └── metadata.json           # Machine-readable metadata
    └── latest -> {timestamp}       # Symlink to most recent
```

## Available Actions

### 1. List Contexts

Read `.claude/summaries/index.json` and present available contexts.

**Output format:**
```
## Available Context Summaries

| # | Context ID | Date | Trigger | Files Modified |
|---|------------|------|---------|----------------|
| 1 | abc123... | 2025-11-23 19:04 | auto | 15 |
| 2 | def456... | 2025-11-22 14:30 | manual | 3 |

Total: 2 contexts stored
```

### 2. Load Context

Load a specific context summary and optionally inject into conversation.

**Steps:**
1. Read summary from `.claude/summaries/{id}/{timestamp}/summary.md`
2. Read metadata from `.claude/summaries/{id}/{timestamp}/metadata.json`
3. Present to user
4. Ask if they want it injected into current conversation

**Context injection format:**
```xml
<previous-context>
[Summary content here]
</previous-context>
```

### 3. Search Contexts

Search through summaries by keyword or topic.

**Steps:**
1. Read index.json for context list
2. For each context, read summary.md
3. Search for matching keywords
4. Return ranked results

### 4. Context Statistics

Provide overview of stored contexts.

**Output:**
```
## Context Summary Statistics

- Total contexts: 15
- Total compactions: 23
- Most active project: /path/to/project
- Most common topics: #api, #authentication, #bugfix
- Storage used: ~2.3 MB
```

## Tool Usage

Use these tools to implement actions:

- **Read** - Read index.json and summary files
- **Glob** - Find summary files: `.claude/summaries/**/*.md`
- **Grep** - Search within summaries for keywords

## Response Guidelines

1. **Be concise** - Show tables/lists, not walls of text
2. **Show recent first** - Most recent contexts at top
3. **Truncate IDs** - Show first 8 chars of context IDs
4. **Include dates** - Always show human-readable dates
5. **Offer actions** - After listing, offer to load specific context

## Error Handling

- **No summaries directory**: "No context summaries found. Summaries are created automatically when context is compacted."
- **No index.json**: "Summary index not found. Run `/compact` to create your first summary."
- **Context not found**: "Context '{id}' not found. Available contexts: [list]"

## Integration with PreCompact Hook

This skill reads data created by the PreCompact hook, which is automatically registered when the plugin is installed. No manual configuration required.

**Index.json structure:**
```json
{
  "summaries": [
    {
      "context_id": "abc123...",
      "timestamp": "20251123_190448",
      "created_at": "2025-11-23T19:04:48Z",
      "trigger": "auto",
      "project": "/path/to/project",
      "files_modified": ["file1.py", "file2.ts"],
      "message_count": 150,
      "summary_path": "abc123.../20251123_190448/summary.md"
    }
  ],
  "last_context": "abc123..."
}
```

## Example Interactions

**User:** "What contexts do I have?"
**Response:** [List contexts table]

**User:** "Load the most recent context"
**Response:** [Show summary, ask about context injection]

**User:** "Find contexts about authentication"
**Response:** [Search and show matching contexts]

**User:** "How many summaries are stored?"
**Response:** [Show statistics]
