
## To Do

1. ✅ **COMPLETED**: Move the documentation phase to follow code review and update the corresponding documents (specification, implementation plan, and summary).
   - docs-executor moved from Phase 8 to Phase 10
   - Sequential execution after code review
   - Implemented 2025-12-06

2. ✅ **COMPLETED**: Implement separate commands for each phase to allow them to be run independently.

3. ✅ **COMPLETED**: BDD (Behavior-Driven Development) integration into super-dev workflow.
   - New agent: `agents/bdd-scenario-writer.md`
   - New template: `templates/reference/bdd-patterns.md`
   - Mandatory Phase 2.5 between requirements (Phase 2) and research (Phase 3)
   - 100% BDD scenario coverage hard gate in Phase 9
   - V8 Behavior Coverage attack vector + D9 pre-check in adversarial reviewer
   - 7 files modified, 2 files created
   - Implemented 2026-03-15

4. [ ] **FOLLOW-UP**: Update out-of-scope "V1-V7" references to "V1-V8".
   - `commands/adversarial-review.md:22,45,102`
   - `skills/adversarial-review/SKILL.md:5`
   - Identified during adversarial review (AF-004)

5. ✅ **COMPLETED**: Add Gotchas sections to key skills (Anthropic best practices).
   - Added to: super-dev, dev-rules, tdd-workflow, adversarial-review, security-review
   - 39 gotchas total documenting common failure points
   - Implemented 2026-03-24

6. ✅ **COMPLETED**: Add config.json first-time setup pattern.
   - New template: `templates/config-template.json`
   - First-Run Configuration section in super-dev skill
   - Auto-detection of language, framework, package manager, test runner
   - `${CLAUDE_PLUGIN_DATA}/config.json` for persistence
   - Implemented 2026-03-24

7. ✅ **COMPLETED**: Add persistent state via `${CLAUDE_PLUGIN_DATA}`.
   - New reference: `templates/reference/state-management.md`
   - Session history log (append-only JSONL)
   - Pattern learning across sessions
   - Usage statistics tracking
   - State read at Phase 0, written at Phase 12
   - Implemented 2026-03-24

8. ✅ **COMPLETED**: Add session-scoped hook skills (/careful and /freeze).
   - New skill: `skills/careful/SKILL.md` — blocks destructive commands (rm -rf, DROP TABLE, force-push, etc.)
   - New skill: `skills/freeze/SKILL.md` — restricts file edits to a specific directory
   - Both session-scoped: activate on invocation, last until session ends
   - Implemented 2026-03-24

9. ✅ **COMPLETED**: Add usage analytics PreToolUse hook.
   - New hook: `hooks/hooks.json` — PreToolUse matcher on Skill|Agent
   - New script: `scripts/usage-tracker.sh` — logs to ${CLAUDE_PLUGIN_DATA}/usage.log and stats.json
   - New command: `commands/usage-report.md` — view usage statistics
   - Implemented 2026-03-24

10. ✅ **COMPLETED**: Add verification skill for output validation.
    - New skill: `skills/verify/SKILL.md` — drives interactive testing with screenshots and assertions
    - Playwright MCP detection (primary) with CLI fallback
    - 5-step verification process: plan → start app → execute checks → report → store evidence
    - Implemented 2026-03-24
