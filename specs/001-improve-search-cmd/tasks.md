# Tasks: Enhanced Repo Search Keybindings in search_cmd (Bash CLI Tools)

**Input**: Design documents from `/specs/001-improve-search-cmd/`
**Prerequisites**: plan.md (required), research.md, contracts/

## Execution Flow (main)

```md
1. Load plan.md from feature directory
2. Load optional design documents: research.md, contracts/, data-model.md, quickstart.md
3. Generate tasks by category: Setup, Core, Integration, Polish
4. Apply task rules: TDD, parallelization, dependencies
5. Number tasks sequentially (T001, T002...)
6. Validate task completeness
```
## Phase 3.1: Setup

- [x] T001 Create/verify directory structure for feature in `/specs/001-improve-search-cmd/`
- [x] T002 Ensure shellcheck and linting are configured for all scripts
- [x] T003 [P] Add/update .editorconfig for shell scripts
- [ ] T004 Set up initial test framework for CLI scripts in `src/`
- [ ] T005 Prepare sample data and mock responses for repo search

## Phase 3.3: Core Implementation

- [x] T006 Implement or update `search_cmd` in main CLI script (e.g., `gh-fzf`)
- [x] T007 Add/extend argument parsing for new keybindings in `search_cmd`
- [x] T008 Implement keybinding actions: clone, fork, open in browser, copy URL, filter, sort (repo search context)
- [x] T009 Implement real-time filtering and sorting logic for repo search results
- [x] T010 Implement user feedback for action success/failure in CLI
- [x] T011 Implement error handling for permission/network/empty result scenarios
- [x] T012 Update help/usage output for new keybindings in CLI

## Phase 3.4: Integration

- [x] T013 Integrate with GitHub CLI (`gh`) and fzf for repo search and actions
- [x] T014 Ensure environment variable support for all keybindings and actions
- [ ] T017 Implement preview functionality to display the `README.md` of the selected repository in the CLI interface
- [ ] T018 Ensure preview updates in real-time as user navigates repo search results
- [ ] T019 Handle cases where `README.md` is missing or not accessible

## Dependencies

- T004, T005, T017, T018, T019 can run in parallel ([P])
- T006 blocks T007-T012
- T013 depends on T006-T012
- T014, T015, T016 depend on T013
- Polish tasks after implementation/integration

## Validation Checklist

- [ ] All contracts have corresponding tests
- [ ] All commands have implementation tasks
- [ ] All tests come before implementation
- [ ] Parallel tasks truly independent
- [ ] Each task specifies exact file path
- [ ] No task modifies same script as another [P] task
