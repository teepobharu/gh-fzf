# Implementation Plan: Support Cloning Project/Fork and Useful Keys in Repo Search

**Branch**: `001-support-cloning-project` | **Date**: September 7, 2025 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-support-cloning-project/spec.md`

## Execution Flow (/plan command scope)
```
1. Load feature spec from Input path
   → If not found: ERROR "No feature spec at {path}"
2. Fill Technical Context (scan for NEEDS CLARIFICATION)
   → Detect Project Type from context (web=frontend+backend, mobile=app+api)
   → Set Structure Decision based on project type
3. Evaluate Constitution Check section below
   → If violations exist: Document in Complexity Tracking
   → If no justification possible: ERROR "Simplify approach first"
   → Update Progress Tracking: Initial Constitution Check
4. Execute Phase 0 → research.md
   → If NEEDS CLARIFICATION remain: ERROR "Resolve unknowns"
5. Execute Phase 1 → contracts, data-model.md, quickstart.md, agent-specific template file (e.g., `CLAUDE.md` for Claude Code, `.github/copilot-instructions.md` for GitHub Copilot, or `GEMINI.md` for Gemini CLI).
6. Re-evaluate Constitution Check section
   → If new violations: Refactor design, return to Phase 1
   → Update Progress Tracking: Post-Design Constitution Check
7. Plan Phase 2 → Describe task generation approach (DO NOT create tasks.md)
8. STOP - Ready for /tasks command
```

**IMPORTANT**: The /plan command STOPS at step 7. Phases 2-4 are executed by other commands:
- Phase 2: /tasks command creates tasks.md
- Phase 3-4: Implementation execution (manual or via tools)

## Summary
Enhanced repository search functionality with keyboard shortcuts for cloning repositories, forking them, and performing other useful repository operations directly from the fzf interface. The feature extends the existing repo command with additional keybindings for common GitHub operations, improving developer workflow efficiency.

## Technical Context
**Language/Version**: Bash (with GitHub CLI and fzf dependencies)  
**Primary Dependencies**: gh (GitHub CLI), fzf (fuzzy finder), git  
**Storage**: N/A (stateless operations)  
**Testing**: Manual testing with various repository types and permissions  
**Target Platform**: Unix-like systems (Linux, macOS) where gh-fzf is installed  
**Project Type**: single (bash script enhancement)  
**Performance Goals**: Fast keyboard response (<100ms for keybinding recognition)  
**Constraints**: Must maintain backward compatibility with existing keybindings, follow existing gh-fzf patterns  
**Scale/Scope**: Single bash script modification, ~10-15 additional keybindings and functions

**User-provided details**: support cloning project / fork and other useful keys that could be done inside search > repo

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Simplicity**:
- Projects: 1 (single bash script enhancement)
- Using framework directly? (yes - direct bash, fzf, gh CLI integration)
- Single data model? (N/A - stateless operations)
- Avoiding patterns? (no complex patterns needed, following existing gh-fzf patterns)

**Architecture**:
- EVERY feature as library? (N/A - script enhancement)
- Libraries listed: [existing gh-fzf as base utility]
- CLI per library: [gh fzf repo with new keybindings]
- Library docs: extending existing gh-fzf documentation

**Testing (NON-NEGOTIABLE)**:
- RED-GREEN-Refactor cycle enforced? (manual verification approach for bash script)
- Git commits show tests before implementation? (test scenarios defined first)
- Order: Contract→Integration→E2E→Unit strictly followed? (integration testing approach)
- Real dependencies used? (actual GitHub repos, gh CLI, fzf)
- Integration tests for: new keybindings, repo operations, error handling
- FORBIDDEN: Implementation before test, skipping RED phase

**Observability**:
- Structured logging included? (using existing gh-fzf error handling patterns)
- Frontend logs → backend? (console output for user feedback)
- Error context sufficient? (clear error messages for failed operations)

**Versioning**:
- Version number assigned? (inherits from gh-fzf version)
- BUILD increments on every change? (follows gh-fzf versioning)
- Breaking changes handled? (backward compatible enhancement)

## Project Structure

### Documentation (this feature)
```
specs/[###-feature]/
├── plan.md              # This file (/plan command output)
├── research.md          # Phase 0 output (/plan command)
├── data-model.md        # Phase 1 output (/plan command)
├── quickstart.md        # Phase 1 output (/plan command)
├── contracts/           # Phase 1 output (/plan command)
└── tasks.md             # Phase 2 output (/tasks command - NOT created by /plan)
```

### Source Code (repository root)
```
# Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure]
```

**Structure Decision**: [DEFAULT to Option 1 unless Technical Context indicates web/mobile app]

## Phase 0: Outline & Research
1. **Extract unknowns from Technical Context** above:
   - For each NEEDS CLARIFICATION → research task
   - For each dependency → best practices task
   - For each integration → patterns task

2. **Generate and dispatch research agents**:
   ```
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **Consolidate findings** in `research.md` using format:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: research.md with all NEEDS CLARIFICATION resolved

## Phase 1: Design & Contracts
*Prerequisites: research.md complete*

1. **Extract entities from feature spec** → `data-model.md`:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable

2. **Generate API contracts** from functional requirements:
   - For each user action → endpoint
   - Use standard REST/GraphQL patterns
   - Output OpenAPI/GraphQL schema to `/contracts/`

3. **Generate contract tests** from contracts:
   - One test file per endpoint
   - Assert request/response schemas
   - Tests must fail (no implementation yet)

4. **Extract test scenarios** from user stories:
   - Each story → integration test scenario
   - Quickstart test = story validation steps

5. **Update agent file incrementally** (O(1) operation):
   - Run `/scripts/update-agent-context.sh [claude|gemini|copilot]` for your AI assistant
   - If exists: Add only NEW tech from current plan
   - Preserve manual additions between markers
   - Update recent changes (keep last 3)
   - Keep under 150 lines for token efficiency
   - Output to repository root

**Output**: data-model.md, /contracts/*, failing tests, quickstart.md, agent-specific file

## Phase 2: Task Planning Approach
*This section describes what the /tasks command will do - DO NOT execute during /plan*

**Task Generation Strategy**:
- Load `/templates/tasks-template.md` as base
- Generate tasks from Phase 1 design docs (contracts, data model, quickstart)
- Create tasks for each keybinding implementation
- Create tasks for helper function development
- Create tasks for configuration variable addition
- Create tasks for error handling enhancement
- Create integration test tasks for each scenario in quickstart
- Implementation tasks to make features functional

**Ordering Strategy**:
- TDD order: Integration test scenarios before implementation
- Dependency order: Configuration → Helper functions → Keybindings → Error handling
- Mark [P] for parallel execution (independent keybinding implementations)

**Estimated Output**: 15-20 numbered, ordered tasks in tasks.md

**IMPORTANT**: This phase is executed by the /tasks command, NOT by /plan

## Phase 3+: Future Implementation
*These phases are beyond the scope of the /plan command*

**Phase 3**: Task execution (/tasks command creates tasks.md)  
**Phase 4**: Implementation (execute tasks.md following constitutional principles)  
**Phase 5**: Validation (run tests, execute quickstart.md, performance validation)

## Complexity Tracking
*Fill ONLY if Constitution Check has violations that must be justified*

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |


## Progress Tracking
*This checklist is updated during execution flow*

**Phase Status**:
- [x] Phase 0: Research complete (/plan command)
- [x] Phase 1: Design complete (/plan command)
- [x] Phase 2: Task planning complete (/plan command - describe approach only)
- [ ] Phase 3: Tasks generated (/tasks command)
- [ ] Phase 4: Implementation complete
- [ ] Phase 5: Validation passed

**Gate Status**:
- [x] Initial Constitution Check: PASS
- [x] Post-Design Constitution Check: PASS
- [x] All NEEDS CLARIFICATION resolved
- [x] Complexity deviations documented

---
*Based on Constitution v2.1.1 - See `/memory/constitution.md`*