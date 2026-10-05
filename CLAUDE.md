# Claude Instructions for glab-fzf Development

## Automatic Checklist Updates

When making any changes to the codebase, you MUST automatically update `checklist.md` with a new section documenting what was done. Follow this format:

### Update Format

Add a new section at the top of the checklist (descending chronological order) with the following structure:

```markdown
## Changes - 2025-10-03

### What was changed:
- Created comprehensive test framework for key binding validation (test-keybindings.sh, run-all-tests.sh)
- Built mock data generation utilities for testing without GitLab API (test-data/mock-data-generator.sh)
- Implemented repository path parsing fix using `cut -d'\t' -f1` to prevent field concatenation
- Modified project command bindings to properly extract repository paths from fzf output (gh-glab/gh-glab:354,358-366)
- Added environment setup and validation scripts (setup-test-environment.sh)
- Created installation guide (INSTALL.md)

### Status after changes:
- Moved MR navigation from "Not Working Features" to "Working Features"
- `alt-m` key now properly loads MR list without path concatenation errors
- All 46 key bindings tested and verified working (Issue: 9, MR: 12, Pipeline: 6, Project: 8, Global: 11)
- Enhanced all project command actions with proper field extraction
- Added comprehensive testing infrastructure that works without GitLab API access

---

## Changes - [YYYY-MM-DD]

### What was changed:
- Brief description of changes made
- List specific files modified
- Describe functionality added/fixed/removed

### Status after changes:
- Update relevant sections (✅ Working Features, ❌ Not Working Features, 🔧 Issues to Fix)
- Move items between sections as appropriate
- Add new issues discovered during implementation

---
```

### Required Actions After Making Changes

1. **Update checklist.md** - Add new dated section with changes
2. **Reinstall extension** - Run the following command to ensure user can test changes:
   ```bash
   npm install -g .
   ```

## Examples

When fixing MR navigation error:

```markdown
## Changes - 2025-01-15

### What was changed:
- Fixed repository path parsing in MR navigation (gh-glab:145)
- Modified project path extraction to handle GitLab URLs correctly
- Updated error handling for repository path concatenation

### Status after changes:
- Moved MR navigation from "Not Working Features" to "Working Features"
- `alt-m` key now properly loads MR list without path concatenation errors

---
```

## Critical Requirements

- **ALWAYS** update checklist.md when making changes
- **ALWAYS** reinstall extension after changes: `npm install -g .`
- Keep change history in descending order (newest first)
- Be specific about what files were modified and what functionality changed
- Update the appropriate status sections based on what was fixed/broken