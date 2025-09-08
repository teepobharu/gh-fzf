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

## Constraints

- Use POSIX shell unless Bash is required.
- Pass `shellcheck` with no errors.
- Document environment variables and config options.
- Provide CLI usage examples.

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

**Version**: 2.2.0 | **Ratified**: 2025-09-08 | **Last Amended**: 2025-09-08
