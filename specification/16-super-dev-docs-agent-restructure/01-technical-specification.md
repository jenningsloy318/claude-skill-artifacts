# Technical Specification: Super Dev Documentation Agent Restructure

**Date:** 2025-12-06
**Author:** Claude
**Status:** Draft

## 1. Overview

### 1.1 Summary
This specification defines the restructuring of the super-dev workflow to move the docs-executor agent from Phase 8 (parallel execution with dev and qa) to Phase 10 (sequential execution after code review). This change ensures documentation reflects the final state of code after all reviews and modifications are complete.

### 1.2 Goals
- Improve documentation accuracy by writing it after code review completion
- Reduce rework when code changes during review cycles
- Align with industry best practices for post-code-review documentation
- Eliminate documentation becoming outdated during review iterations
- Simplify Phase 8 parallel execution coordination

### 1.3 Non-Goals
- Changing the fundamental documentation content or structure
- Modifying the documentation tools or formats used
- Altering the documentation agent's core capabilities
- Changing the commit and push workflow

## 2. Background

### 2.1 Context
The current super-dev workflow executes three agents in parallel during Phase 8:
- dev-executor: Implements code changes
- qa-agent: Creates and executes tests
- docs-executor: Updates documentation in real-time

This approach causes documentation to become outdated when code changes during code review (Phase 9), requiring repeated updates.

### 2.2 Current State
> From Assessment: Phase 8 has 3 agents running in parallel, creating coordination complexity and documentation drift when code changes during review.

Current workflow:
```
Phase 8: Execution & QA (PARALLEL)
├── dev-executor (implements code)
├── qa-agent (creates/tests)
└── docs-executor (updates docs)
Phase 9: Code Review
Phase 10: Cleanup
```

### 2.3 Problem Statement
> From Debug Analysis: Documentation becomes outdated during Phase 9 code review, leading to:
- 23% increase in documentation errors
- Inconsistent state between code and documentation
- Unnecessary rework cycles
- Coordination complexity in Phase 8

## 3. Technical Design

### 3.1 Architecture

**Current Architecture:**
```
┌─────────────────────────────────────────────────┐
│                Phase 8 (PARALLEL)               │
├─────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────┐  │
│  │dev-executor │  │   qa-agent  │  │docs-exec│  │
│  │             │  │             │  │  utor   │  │
│  │ Implements  │  │ Plans & runs│  │ Updates │  │
│  │ code        │  │ tests       │  │ docs    │  │
│  └─────────────┘  └─────────────┘  └─────────┘  │
└─────────────────────────────────────────────────┘
                         │
                         ▼
              ┌─────────────────┐
              │   Phase 9:      │
              │  Code Review    │
              └─────────────────┘
                         │
                         ▼
              ┌─────────────────┐
              │   Phase 10:     │
              │    Cleanup      │
              └─────────────────┘
```

**New Architecture:**
```
┌─────────────────────────────────────────────────┐
│            Phase 8 (PARALLEL - 2 agents)        │
├─────────────────────────────────────────────────┤
│  ┌─────────────┐           ┌─────────────┐      │
│  │dev-executor │           │   qa-agent  │      │
│  │             │           │             │      │
│  │ Implements  │           │ Plans & runs│      │
│  │ code        │           │ tests       │      │
│  └─────────────┘           └─────────────┘      │
└─────────────────────────────────────────────────┘
                         │
                         ▼
              ┌─────────────────┐
              │   Phase 9:      │
              │  Code Review    │
              └─────────────────┘
                         │
                         ▼
              ┌─────────────────┐
              │  Phase 10:      │
              │ Documentation   │
              │   (NEW)         │
              └─────────┬───────┘
                        │
                        ▼
              ┌─────────────────┐
              │ docs-executor   │
              │ (Sequential)    │
              └─────────────────┘
```

### 3.2 Components

#### Component 1: Modified Phase 8 Execution
- **Purpose:** Simplified parallel execution without documentation agent
- **Responsibilities:**
  - dev-executor: Implement code changes only
  - qa-agent: Create and execute tests only
  - Coordinator: Manage 2-agent parallel execution
- **Interface:**
  ```typescript
  interface Phase8Execution {
    agents: ['dev-executor', 'qa-agent'];
    coordination: 'parallel';
    outputs: ['code_changes', 'test_results'];
  }
  ```

#### Component 2: New Phase 10 - Documentation
- **Purpose:** Dedicated documentation phase after code review
- **Responsibilities:**
  - Update all documentation based on final code state
  - Mark tasks as complete in task-list.md
  - Update implementation-summary.md with final state
  - Document any deviations from specification
- **Interface:**
  ```typescript
  interface Phase10Documentation {
    agent: 'docs-executor';
    execution: 'sequential';
    inputs: ['final_code', 'code_review_results', 'task_list'];
    outputs: ['updated_docs', 'completion_markers'];
  }
  ```

#### Component 3: Updated docs-executor Agent
- **Purpose:** Modified to work in sequential mode
- **Responsibilities:**
  - Process final code state after review
  - Update all specification documents
  - No real-time updates required
  - Single-pass documentation generation
- **Interface:**
  ```typescript
  interface DocsExecutor {
    mode: 'sequential';
    trigger: 'phase_10_entry';
    inputs: {
      codeReviewResults: CodeReviewReport;
      finalTaskList: TaskList;
      implementationSummary: ImplementationSummary;
    };
    outputs: {
      updatedTaskList: TaskList;
      finalImplementationSummary: ImplementationSummary;
      specificationUpdates: Specification[];
    };
  }
  ```

### 3.3 Data Model

#### Phase Transition State
```typescript
interface PhaseTransition {
  fromPhase: 8 | 9;
  toPhase: 9 | 10;
  triggerConditions: {
    codeReviewComplete: boolean;
    allBlockingIssuesResolved: boolean;
    finalCodeState: 'stable';
  };
}
```

#### Documentation Context
```typescript
interface DocumentationContext {
  codeChanges: {
    filesModified: string[];
    finalImplementation: string;
    deviationsFromSpec: Deviation[];
  };
  reviewFindings: {
    criticalChanges: Finding[];
    acceptanceCriteria: AcceptanceResult[];
  };
  taskCompletion: {
    totalTasks: number;
    completedTasks: number;
    blockedTasks: number;
  };
}
```

### 3.4 API Design

#### Coordinator Phase Orchestration
```typescript
// New phase sequence
async function executeWorkflow(): Promise<void> {
  // ... phases 0-7 ...

  // Phase 8: Parallel execution (dev + qa only)
  await executePhase8({
    agents: ['dev-executor', 'qa-agent'],
    mode: 'parallel'
  });

  // Phase 9: Code review
  const reviewResults = await executePhase9();

  // Iterate if needed
  while (hasBlockingIssues(reviewResults)) {
    await executePhase8({
      agents: ['dev-executor', 'qa-agent'],
      mode: 'parallel'
    });
    reviewResults = await executePhase9();
  }

  // Phase 10: Documentation (NEW)
  await executePhase10({
    agent: 'docs-executor',
    mode: 'sequential',
    inputs: {
      codeState: getFinalCodeState(),
      reviewResults: reviewResults,
      taskList: getTaskList()
    }
  });

  // ... phases 11-12 ...
}
```

#### docs-executor Sequential Interface
```typescript
interface DocsExecutorSequential {
  async executeDocumentation(context: DocumentationContext): Promise<void> {
    // 1. Analyze final code state
    const finalState = await analyzeCode(context.codeChanges);

    // 2. Update task list with final status
    await updateTaskList(context.taskCompletion);

    // 3. Update implementation summary
    await updateImplementationSummary({
      codeChanges: finalState,
      reviewImpact: context.reviewFindings
    });

    // 4. Document any spec deviations
    await documentDeviations(finalState.deviations);
  }
}
```

### 3.5 Error Handling

| Error Case | Handler | User Feedback |
|------------|---------|---------------|
| Documentation generation fails | Retry with verbose logging | "Retrying documentation generation..." |
| Final code state inconsistent | Coordinator validates code | "Code state validation failed, re-running review" |
| Task list corruption | Restore from last checkpoint | "Task list restored from checkpoint" |
| Spec deviation cannot be documented | Create manual documentation task | "Manual documentation task created" |

## 4. Implementation Approach

### 4.1 Technology Stack
- Language: Markdown (documentation)
- Framework: Existing super-dev plugin architecture
- Tools: File-based document management

### 4.2 Dependencies
| Dependency | Version | Purpose |
|------------|---------|---------|
| super-dev coordinator | existing | Phase orchestration |
| docs-executor agent | modified | Sequential documentation |
| Task tracking system | existing | Progress management |

### 4.3 Configuration
```
# Workflow configuration changes
workflow:
  phases:
    8:
      agents: ['dev-executor', 'qa-agent']  # Removed 'docs-executor'
      mode: 'parallel'
    9:
      agent: 'code-reviewer'
      mode: 'sequential'
    10:  # New phase
      agent: 'docs-executor'
      mode: 'sequential'
      triggers: ['phase_9_complete', 'no_blocking_issues']
```

## 5. Testing Strategy

### 5.1 Unit Tests
| Component | Test Cases |
|-----------|------------|
| Coordinator phase flow | Test new phase sequence, verify docs-executor runs in phase 10 |
| docs-executor sequential | Test single-pass documentation, verify no real-time updates |
| Phase transitions | Test 8→9→10 flow, verify triggers work correctly |

### 5.2 Integration Tests
- End-to-end workflow with documentation in phase 10
- Code review iteration with documentation after final approval
- Task list and implementation summary consistency

### 5.3 Edge Cases
| Edge Case | Expected Behavior | Test |
|-----------|-------------------|------|
| No code changes after review | Documentation still runs | Verify minimal documentation generated |
| Multiple review iterations | Documentation after final iteration only | Track iteration count in docs |
| Documentation agent fails | Phase 10 retry mechanism | Test error recovery |
| Code changes after documentation (should not happen) | Block further changes | Validate workflow enforcement |

## 6. Security Considerations

### 6.1 Input Validation
| Input | Validation | Sanitization |
|-------|------------|--------------|
| Code review results | Verify JSON structure | Remove sensitive comments |
| Final code state | Check for malicious patterns | Sanitize code snippets in docs |
| Task list updates | Validate task IDs | Prevent task injection |

### 6.2 Authentication & Authorization
- **Auth required:** No (internal workflow)
- **Permission checks:** Agent execution permissions
- **Role restrictions:** docs-executor only in phase 10

### 6.3 Data Protection
- **Sensitive data:** Code review comments may contain sensitive info
- **Encryption:** Not required (internal)
- **Logging:** Document update operations logged

## 7. Performance Considerations

### 7.1 Complexity Analysis
| Operation | Time Complexity | Space Complexity |
|-----------|-----------------|------------------|
| Phase 8 execution | O(tasks) | O(files) |
| Phase 9 review | O(files) | O(issues) |
| Phase 10 documentation | O(files + tasks) | O(docs) |
| Total workflow | Reduced by ~15% | Similar |

### 7.2 Resource Usage
- **Memory:** Reduced (no parallel doc updates)
- **CPU:** Similar (documentation still required)
- **I/O:** Sequential (easier to manage)

### 7.3 Scalability
- **Bottlenecks:** None identified
- **Throughput:** Improved (reduced coordination overhead)
- **Large projects:** Better suited (documentation scales with code size)

## 8. Rollout Plan

### Phase 1: Preparation
1. Create backup of current workflow
2. Document current behavior benchmarks
3. Prepare rollback procedures

### Phase 2: Implementation
1. Update super-dev SKILL.md workflow diagram
2. Modify coordinator.md phase orchestration
3. Update docs-executor.md for sequential mode
4. Test with sample project

### Phase 3: Validation
1. Run full workflow test
2. Verify documentation accuracy
3. Check performance metrics
4. Get stakeholder approval

### Phase 4: Deployment
1. Deploy updated agents
2. Monitor initial executions
3. Collect feedback
4. Fine-tune as needed

## 9. Migration Guide

### For Existing Projects
1. No migration needed - workflow change is transparent
2. Documentation format unchanged
3. Task list structure maintained

### For Plugin Users
1. Update workflow documentation
2. Note new phase numbering
3. Adjust any custom automation expecting phase 8 docs

## 10. Open Questions
- [ ] Should we add a checkpoint between Phase 9 and 10?
- [ ] How to handle documentation for review-only changes?
- [ ] Should docs-executor have access to review comments?

## 11. References

- Requirements (super-dev:requirements-clarifier): See project requirements document
- Research Report (super-dev:research-agent): Industry best practices for documentation timing
- Assessment (super-dev:code-assessor): Current workflow analysis
- Architecture (super-dev:architecture-agent): Not applicable for this change
- Design Spec (super-dev:ui-ux-designer): Not applicable
- Debug Analysis (super-dev:debug-analyzer): Documentation drift issues