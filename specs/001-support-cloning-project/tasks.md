# Tasks: Support Cloning Project/Fork and Useful Keys in Repo Search

**Input**: Design documents from `/specs/001-support-cloning-project/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Execution Flow (main)
```
1. Load plan.md from feature directory
   → Tech stack: Bash, GitHub CLI, fzf, git
   → Project type: single (bash script enhancement)
2. Load design documents:
   → data-model.md: Repository, Repository Action, Operation Result entities
   → contracts/keybindings.md: Clone, Fork, Copy URL, Help contracts
   → contracts/gh-cli-integration.md: GitHub CLI integration contracts
   → quickstart.md: 8 integration test scenarios
3. Generate tasks by category:
   → Setup: environment variables, helper functions
   → Tests: integration tests for each keybinding scenario
   → Core: keybinding implementations, utility functions
   → Integration: error handling, user feedback
   → Polish: documentation updates, manual testing
4. Apply task rules:
   → Different functions = mark [P] for parallel
   → Same gh-fzf script = sequential (no [P] for overlapping changes)
   → Tests before implementation (TDD)
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Validate task completeness: All contracts tested, all scenarios covered
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different functions, no dependencies)
- Include exact file paths and function names

## Path Conventions
- **Main script**: `gh-fzf` at repository root
- **Test scenarios**: Integration tests using actual GitHub repositories
- All modifications enhance existing `repo_cmd()` function

## Phase 3.1: Setup
- [ ] T001 Add configuration variables for clone directory and keybindings to gh-fzf script
- [ ] T002 Create helper function `clone_repo()` in gh-fzf util section
- [ ] T003 [P] Create helper function `fork_repo()` in gh-fzf util section  
- [ ] T004 [P] Create helper function `copy_repo_url()` in gh-fzf util section
- [ ] T005 [P] Create helper function `show_repo_help()` in gh-fzf util section

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**
- [ ] T006 [P] Integration test: Clone public repository scenario in tests/integration/test_clone_public.sh
- [ ] T007 [P] Integration test: Fork repository (first time) scenario in tests/integration/test_fork_new.sh
- [ ] T008 [P] Integration test: Fork repository (already exists) scenario in tests/integration/test_fork_existing.sh
- [ ] T009 [P] Integration test: Clone private repository (with access) scenario in tests/integration/test_clone_private_access.sh
- [ ] T010 [P] Integration test: Clone private repository (no access) scenario in tests/integration/test_clone_private_denied.sh
- [ ] T011 [P] Integration test: Copy repository URL scenario in tests/integration/test_copy_url.sh
- [ ] T012 [P] Integration test: Help display scenario in tests/integration/test_help_display.sh
- [ ] T013 [P] Integration test: Clone to custom directory scenario in tests/integration/test_clone_custom_dir.sh

## Phase 3.3: Core Implementation (ONLY after tests are failing)
- [ ] T014 Implement clone keybinding ('c') in repo_cmd() function of gh-fzf script
- [ ] T015 Implement fork keybinding ('f') in repo_cmd() function of gh-fzf script
- [ ] T016 Implement copy URL keybinding ('u') in repo_cmd() function of gh-fzf script
- [ ] T017 Implement help keybinding ('?' and 'h') in repo_cmd() function of gh-fzf script
- [ ] T018 Update repo_header to include new keybinding descriptions in gh-fzf script
- [ ] T019 Implement clone_repo() helper function logic in gh-fzf script
- [ ] T020 Implement fork_repo() helper function logic in gh-fzf script
- [ ] T021 [P] Implement copy_repo_url() helper function logic in gh-fzf script
- [ ] T022 [P] Implement show_repo_help() helper function logic in gh-fzf script

## Phase 3.4: Integration  
- [ ] T023 Add error handling for network failures in all repository operations
- [ ] T024 Add error handling for permission denied scenarios in clone and fork operations
- [ ] T025 Add error handling for existing directory conflicts in clone operations
- [ ] T026 Add user feedback messages for successful operations
- [ ] T027 Add authentication check before repository operations
- [ ] T028 Add duplicate fork detection logic in fork operations

## Phase 3.5: Polish
- [ ] T029 [P] Add configuration documentation to README.md for new environment variables
- [ ] T030 [P] Update help command documentation with new keybindings
- [ ] T031 Run manual testing with quickstart.md scenarios
- [ ] T032 Test performance of keybinding response times (<100ms requirement)
- [ ] T033 Test backward compatibility with existing keybindings
- [ ] T034 [P] Update CHANGELOG.md with new features

## Dependencies
- Setup (T001-T005) before tests (T006-T013)
- Tests (T006-T013) before implementation (T014-T022)
- T014-T018 (keybinding implementation) before T019-T022 (helper functions)
- T019-T022 (helper functions) before T023-T028 (error handling)
- Core implementation (T014-T022) before integration (T023-T028)
- Implementation before polish (T029-T034)

## Parallel Example
```
# Launch T002-T005 together:
Task: "Create helper function clone_repo() in gh-fzf util section"
Task: "Create helper function fork_repo() in gh-fzf util section"  
Task: "Create helper function copy_repo_url() in gh-fzf util section"
Task: "Create helper function show_repo_help() in gh-fzf util section"

# Launch T006-T013 together:
Task: "Integration test: Clone public repository scenario"
Task: "Integration test: Fork repository (first time) scenario"
Task: "Integration test: Fork repository (already exists) scenario"
Task: "Integration test: Clone private repository scenarios"
# ... etc
```

## Notes
- [P] tasks = different functions or independent files, no dependencies
- All keybinding implementations modify the same repo_cmd() function, so must be sequential
- Helper functions can be implemented in parallel since they're separate function definitions
- Verify integration tests fail before implementing functionality
- Commit after each task completion
- Test with actual GitHub repositories for realistic scenarios

## Task Generation Rules Applied

1. **From Keybinding Contracts**:
   - Clone contract → T006, T014, T019 (test, keybinding, helper)
   - Fork contract → T007, T008, T015, T020 (tests, keybinding, helper)
   - Copy URL contract → T011, T016, T021 (test, keybinding, helper)
   - Help contract → T012, T017, T022 (test, keybinding, helper)

2. **From GitHub CLI Integration Contracts**:
   - Repository clone contract → T019 implementation, T023-T025 error handling
   - Repository fork contract → T020 implementation, T028 duplicate detection

3. **From Quickstart Scenarios**:
   - Each of 8 scenarios → corresponding integration test (T006-T013)
   - Configuration scenario → T001 environment variables
   - Performance verification → T032 performance testing

4. **From Data Model Entities**:
   - Repository entity → Configuration variables (T001)
   - Repository Action entity → Helper function structure (T002-T005)
   - Operation Result entity → Error handling and feedback (T023-T026)

## Validation Checklist
- [x] All keybinding contracts have corresponding tests (T006-T013)
- [x] All contracts have implementation tasks (T014-T022)
- [x] All quickstart scenarios have integration tests (T006-T013)
- [x] Tests come before implementation (Phase 3.2 before 3.3)
- [x] Parallel tasks are truly independent (different functions)
- [x] Each task specifies exact file path and function location
- [x] No task modifies same file section as another [P] task
