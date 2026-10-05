# Research: Enhanced Repo Search Keybindings in search_cmd

## Unknowns and Clarifications
- No [NEEDS CLARIFICATION] markers remain in the feature spec.
- All requirements are testable and unambiguous.

## Best Practices and Patterns
- Use POSIX shell or Bash as required (per constitution).
- Keybindings and CLI actions should be consistent with repo_cmd.
- Use fzf preview and reload for real-time filtering and sorting.
- Provide clear user feedback for all actions (success/failure).
- Log errors and actions to stderr for observability.

## Decisions
- Language: Bash (with POSIX shell compatibility where possible)
- Dependencies: fzf, Sourcegraph CLI (src), standard Unix tools
- No additional storage or frameworks required
- CLI interface only, no GUI or web components

## Rationale
- Bash/fzf is the project standard and matches existing gh-fzf architecture.
- Consistency with repo_cmd ensures a familiar user experience.
- Simplicity and observability are constitutional requirements.

## Alternatives Considered
- Implementing in Python or another scripting language: rejected for simplicity and consistency.
- Adding a GUI: rejected, CLI focus per constitution.

---

All research tasks for this phase are complete. Ready for Phase 1 design.
