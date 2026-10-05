# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`gh-fzf` is an fzf wrapper around the GitHub CLI that provides fuzzy finding for GitHub resources (issues, PRs, runs, workflows, releases, labels, milestones, repos, gists) with interactive keybindings for common GitHub operations.

## Core Architecture

- **Main executable**: `gh-fzf` - A single bash script (~2000+ lines) that implements all functionality
- **GitHub CLI Extension**: Installed as `gh extension install benelan/gh-fzf` and used via `gh fzf <command>`
- **fzf Integration**: Uses fzf for fuzzy finding with custom keybindings and preview windows
- **Command Structure**: Each command (issue, pr, run, etc.) has its own function with specific keybindings and GitHub API interactions

## Development Workflow

### Local Development & Testing

```bash
# Link local version for testing
ln -s -f $(pwd)/gh-fzf ./gh-fzfll/gh-fzfll
cd gh-fzfll
gh extension remove gh-fzfll 2>/dev/null || true
gh extension install .
cd -
gh fzfll <command> [...args]
```

### Development Scripts

Located in `scripts/`:

- `scripts/common.sh` - Shared functions for feature branch management
- `scripts/setup-plan.sh` - Sets up feature planning
- `scripts/create-new-feature.sh` - Creates new feature branches
- `scripts/check-task-prerequisites.sh` - Validates feature readiness

## Key Implementation Details

### Command Structure

Each command follows this pattern in the main `gh-fzf` script:

1. Argument parsing and validation
2. GitHub CLI command construction
3. fzf configuration with keybindings
4. Preview window setup
5. Result processing

### Configuration

Environment variables control behavior:

- `GH_FZF_DEFAULT_LIMIT` - Number of items to fetch (default: 75)
- `GH_FZF_TRUNCATE_FIELDS` - Text truncation behavior
- `GH_FZF_HIDE_HINTS` - Hide keybinding hints
- Command-specific keybinding variables (e.g., `GH_FZF_ISSUE_EDIT_KEY`)

### Dependencies

- `gh` (GitHub CLI) - Core functionality
- `fzf` - Fuzzy finding interface
- Standard Unix tools (awk, sed, etc.)

## Code Organization

The single `gh-fzf` script is organized with vim foldmarkers:

- Usage info and internal functions
- Command implementations (issue, pr, run, etc.)
- Utility functions
- Main command dispatcher

## Testing

### Manual Testing

- Test commands locally using the development setup
- Feature contracts in `specs/<branch>/contracts/`
- Manual testing workflow documented in README.md

### Automated Testing with tmux and fzf

Since gh-fzf is an interactive fzf-based tool, automated testing requires simulating user input. Use tmux to create testable sessions:

```bash
# Create a tmux session for testing
tmux new-session -d -s gh-fzf-test

# Run gh-fzf command in the background
tmux send-keys -t gh-fzf-test "gh fzf issue" Enter

# Wait for fzf to load
sleep 2

# Send key sequences to test keybindings
tmux send-keys -t gh-fzf-test "test query" Enter  # Search for "test query"
tmux send-keys -t gh-fzf-test C-r                # Reload (ctrl-r)
tmux send-keys -t gh-fzf-test M-?                # Help (alt-?)
tmux send-keys -t gh-fzf-test M-a                # Filter assigned (alt-a)
tmux send-keys -t gh-fzf-test q                  # Quit

# Capture output for verification
tmux capture-pane -t gh-fzf-test -p

# Clean up
tmux kill-session -t gh-fzf-test
```

### Testing Strategy

1. **Basic Functionality**: Test that commands load and display results
2. **Keybinding Testing**: Use tmux send-keys to test all documented keybindings
3. **Error Handling**: Test with invalid inputs and network issues
4. **Configuration Testing**: Test environment variable overrides
5. **Integration Testing**: Test with different GitHub CLI configurations

### Test Helper Functions

```bash
# Test a specific command with tmux
test_gh_fzf_command() {
    local cmd="$1"
    local session="gh-fzf-test-$$"

    tmux new-session -d -s "$session"
    tmux send-keys -t "$session" "$cmd" Enter
    sleep 3  # Allow time for loading

    # Capture the output
    local output=$(tmux capture-pane -t "$session" -p)
    tmux kill-session -t "$session"

    echo "$output"
}

# Test keybinding sequence
test_keybinding() {
    local cmd="$1"
    local keys="$2"
    local session="gh-fzf-test-$$"

    tmux new-session -d -s "$session"
    tmux send-keys -t "$session" "$cmd" Enter
    sleep 2

    # Send the key sequence
    IFS=' ' read -ra KEYS <<< "$keys"
    for key in "${KEYS[@]}"; do
        tmux send-keys -t "$session" "$key"
        sleep 0.5
    done

    sleep 1
    local output=$(tmux capture-pane -t "$session" -p)
    tmux kill-session -t "$session"

    echo "$output"
}
```

## Important Notes

- All functionality is in a single bash script for simplicity of distribution as a GitHub CLI extension
- Heavy use of bash arrays and string manipulation for GitHub API response processing
- fzf keybindings are extensively customized for each command type
- Preview windows show relevant GitHub CLI output for selected items
