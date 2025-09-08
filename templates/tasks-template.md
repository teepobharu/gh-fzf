# Tasks: [FEATURE NAME] (Bash CLI Tools)

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), research.md, contracts/

## Execution Flow (main)
```
1. Load plan.md from feature directory
    → If not found: ERROR "No implementation plan found"
    → Extract: tool structure, commands, dependencies
2. Load optional design documents:
    → research.md: Extract decisions → setup tasks
    → contracts/: Extract CLI specs → test tasks
3. Generate tasks by category:
    → Setup: directory structure, shellcheck, Makefile
    → Core: scripts, command logic, argument parsing
    → Integration: external tools, logging, error handling
    → Polish: tests, performance, docs
4. Apply task rules:
    → Different scripts = mark [P] for parallel
    → Same script = sequential (no [P])
    → Tests before implementation (TDD)
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Create parallel execution examples
8. Validate task completeness:
    → All contracts have tests?
    → All commands implemented?
    → All scripts linted?
9. Return: SUCCESS (tasks ready for execution)
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different scripts, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- **Single tool**: `bin/`, `tests/` at repository root
- **Multi-tool**: `tools/[tool-name]/bin/`, `tools/[tool-name]/tests/`
- Paths shown below assume single tool - adjust based on plan.md structure

## Phase 3.1: Setup
- [ ] T001 Create directory structure per implementation plan
- [ ] T002 Initialize Makefile and setup shellcheck
- [ ] T003 [P] Configure .editorconfig and linting

## Phase 3.3: Core Implementation 
- [ ] T008 [P] Implement main CLI script in bin/[tool].sh
- [ ] T009 [P] Add command: [command-name] in bin/[tool]-[command].sh
- [ ] T010 [P] Argument parsing in bin/[tool].sh
- [ ] T011 Implement help and usage output
- [ ] T012 Implement error handling
- [ ] T013 Input validation
- [ ] T014 Logging to logs/[tool].log

## Phase 3.4: Integration
- [ ] T015 Integrate with external tool (e.g., curl, jq)
- [ ] T016 Environment variable support
- [ ] T017 Output formatting (JSON, table)
- [ ] T018 Shell completion scripts

## Phase 3.5: Polish
- [ ] T019 [P] Unit tests for argument parsing in tests/unit/test_args.sh
- [ ] T020 Performance tests (<200ms per command)
- [ ] T021 [P] Update docs/cli.md
- [ ] T022 Remove duplication
- [ ] T023 Run manual-testing.md

## Dependencies
- Tests (T004-T007) before implementation (T008-T014)
- T008 blocks T009, T015
- T016 blocks T018
- Implementation before polish (T019-T023)

## Parallel Example
```
# Launch T004-T007 together:
Task: "Contract test for main CLI in tests/contract/test_main.sh"
Task: "Contract test for [command-name] in tests/contract/test_[command].sh"
Task: "Integration test for external tool in tests/integration/test_external.sh"
Task: "Integration test for argument parsing in tests/integration/test_args.sh"
```

## Notes
- [P] tasks = different scripts, no dependencies
- Verify tests fail before implementing
- Commit after each task
- Avoid: vague tasks, same script conflicts

## Task Generation Rules
*Applied during main() execution*

1. **From Contracts**:
    - Each contract file → contract test task [P]
    - Each CLI command → implementation task

2. **From Research**:
    - Each decision → setup or integration task

3. **From User Stories**:
    - Each story → integration test [P]
    - Quickstart scenarios → validation tasks

4. **Ordering**:
    - Setup → Tests → Scripts → Commands → Polish
    - Dependencies block parallel execution

## Validation Checklist
*GATE: Checked by main() before returning*

- [ ] All contracts have corresponding tests
- [ ] All commands have implementation tasks
- [ ] All tests come before implementation
- [ ] Parallel tasks truly independent
- [ ] Each task specifies exact file path
- [ ] No task modifies same script as another [P] task
