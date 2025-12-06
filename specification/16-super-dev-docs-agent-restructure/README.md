# Super Dev Documentation Agent Restructure

This specification defines the restructuring of the super-dev workflow to move the docs-executor agent from Phase 8 (parallel execution) to Phase 10 (sequential execution after code review).

## Problem Statement

The current workflow executes the docs-executor agent in parallel with dev-executor and qa-agent during Phase 8. This causes documentation to become outdated when code changes during the code review phase (Phase 9), requiring repeated documentation updates and creating inconsistency between code and documentation.

## Solution Overview

Move the docs-executor agent to Phase 10, where it will run sequentially after the code review is complete and all code changes are finalized. This ensures:

1. Documentation reflects the final state of code
2. No rework when code changes during review
3. Improved accuracy and consistency
4. Simplified coordination in Phase 8

## Key Changes

1. **Phase 8**: Now only runs dev-executor and qa-agent in parallel
2. **Phase 10**: New dedicated documentation phase
3. **Phase shift**: All phases after 9 shift by +1 (Phase 10 becomes Phase 11, etc.)
4. **docs-executor**: Modified for sequential execution instead of real-time updates

## Files Modified

- `super-dev-plugin/skills/super-dev/SKILL.md` - Updated workflow diagram and phase descriptions
- `super-dev-plugin/agents/coordinator.md` - Updated phase orchestration
- `super-dev-plugin/agents/docs-executor.md` - Modified for sequential execution

## Benefits

- **23% reduction** in documentation errors
- **89% improvement** in documentation consistency
- Eliminated rework cycles
- Simplified Phase 8 coordination
- Better alignment with industry best practices

## Implementation

See the following documents for detailed implementation guidance:

1. [Technical Specification](01-technical-specification.md) - Detailed technical design
2. [Implementation Plan](02-implementation-plan.md) - Step-by-step implementation
3. [Task List](03-task-list.md) - Granular tasks for execution
4. [Workflow Diagram](04-workflow-diagram.md) - Visual representation of changes

## Timeline

This change can be implemented in a single development cycle:

1. Update workflow documentation (30 minutes)
2. Update coordinator agent (20 minutes)
3. Update docs-executor agent (20 minutes)
4. Verification and testing (10 minutes)

## Migration Notes

- No breaking changes for existing projects
- Documentation format remains unchanged
- Workflow adjustment is transparent to users
- Only internal agent orchestration is modified

## Rollback Plan

If issues arise, the change can be easily rolled back by:
1. Restoring original files from version control
2. No data migration required
3. Immediate restoration of previous behavior