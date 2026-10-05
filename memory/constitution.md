# gh-fzf Constitution

## Principles

### I. Library-First
- Implement features as reusable, testable shell functions or scripts using base `gh` commands.
- All code must serve a user-facing purpose.

### II. CLI Interface
- Expose all features via CLI with standard text I/O.
- Support human- and machine-readable output where practical.
- Provide `--help` and `--version` for major scripts.

### III. Simplicity
- Limit to three main scripts: core, CLI, tests.
- Avoid unnecessary patterns and over-engineering.
- Prefer simple shell idioms.

### IV. Observability
- Log key actions and errors to stderr.
- Support verbose/debug flags.
- Log performance metrics for long-running scripts.

### V. Versioning
- Use MAJOR.MINOR.BUILD versioning.
- Increment BUILD for any change; MAJOR/MINOR for breaking/features.
- Document breaking changes and migration steps.

### VI. Code Reusability and DRY
- Extract common functionality into shared functions to avoid duplication.
- Use extensible patterns for similar commands (e.g., base fzf command with context-specific extensions).
- Centralize environment variable definitions and keybinding patterns.
- Prefer composition over duplication when adding new features to existing commands.

## Constraints

- Use POSIX shell unless Bash is required.
- Pass `shellcheck` with no errors.
- Document environment variables and config options.
- Provide CLI usage examples.

## Patterns

### Command Extension Pattern
When adding context-specific functionality to existing commands:
1. Create a base command implementation with all common functionality
2. Define context-specific extensions as variables (bindings, preview, etc.)
3. Use conditional logic to build extensions based on context
4. Apply extensions to base command using `eval` or similar composition

### Shared Function Pattern
For common operations across multiple commands:
1. Define shared functions near the top of the file
2. Use consistent naming conventions (e.g., `shared_repo_action_*`)
3. Accept context parameters to customize behavior
4. Return reusable command strings or execute actions directly

### Environment Variable Centralization
- Group related environment variables together
- Use consistent prefixes (e.g., `GH_FZF_SEARCH_REPO_*`)
- Define defaults in one place per command context
- Document all variables in help text and constitution

## Workflow

- Review all changes for compliance.
- Tests must pass before merging.
- Use templates for specs, plans, and tasks.
- Update `/CLAUDE.md` and `llms.txt` for new conventions.

## Governance

- This constitution overrides other practices.
- Amendments require updating templates/docs.
- PRs/reviews must verify compliance.
- Justify complexity in plans/specs.

**Version**: 2.3.0 | **Ratified**: 2025-09-08 | **Last Amended**: 2025-09-15
