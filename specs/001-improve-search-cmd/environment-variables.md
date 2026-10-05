# Environment Variables: Enhanced Repo Search Keybindings

## Repository Action Keybindings

| Variable | Default | Description |
|----------|---------|-------------|
| `GH_FZF_REPO_EDIT_KEY` | `alt-e` | Edit repository settings |
| `GH_FZF_REPO_VIEW_ISSUES_KEY` | `alt-i` | View repository issues |
| `GH_FZF_REPO_VIEW_PRS_KEY` | `alt-p` | View repository pull requests |
| `GH_FZF_REPO_VIEW_RUNS_KEY` | `alt-r` | View repository workflow runs |
| `GH_FZF_REPO_CLONE_KEY` | `alt-C` | Clone repository |
| `GH_FZF_REPO_FORK_KEY` | `alt-F` | Fork repository |

## Repository Filter Keybindings

| Variable | Default | Description |
|----------|---------|-------------|
| `GH_FZF_REPO_PRIVATE_FILTER_KEY` | `alt-c` | Filter private repositories |
| `GH_FZF_REPO_PUBLIC_FILTER_KEY` | `alt-o` | Filter public repositories |
| `GH_FZF_REPO_SOURCE_FILTER_KEY` | `alt-s` | Filter source repositories |
| `GH_FZF_REPO_FORK_FILTER_KEY` | `alt-f` | Filter forked repositories |

## Repository Sorting Keybindings

| Variable | Default | Description |
|----------|---------|-------------|
| `GH_FZF_REPO_SORT_UPDATED_KEY` | `alt-u` | Sort by last updated |
| `GH_FZF_REPO_SORT_STARS_KEY` | `alt-S` | Sort by star count |
| `GH_FZF_REPO_SORT_FORKS_KEY` | `alt-k` | Sort by fork count |

## Global Search Keybindings

| Variable | Default | Description |
|----------|---------|-------------|
| `GH_FZF_SEARCH_TOGGLE_MODE_KEY` | `alt-/` | Toggle search mode (fzf/gh) |
| `GH_FZF_OPEN_KEY` | `ctrl-o` | Open in browser |
| `GH_FZF_COPY_KEY` | `ctrl-y` | Copy URL to clipboard |
| `GH_FZF_RELOAD_KEY` | `ctrl-r` | Reload results |
| `GH_FZF_HELP_KEY` | `ctrl-h` | Show help |

## Usage Example

```bash
# Customize keybindings
export GH_FZF_REPO_CLONE_KEY="ctrl-c"
export GH_FZF_REPO_FORK_KEY="ctrl-f"
export GH_FZF_REPO_PRIVATE_FILTER_KEY="alt-P"

# Use enhanced search
gh fzf search repos "javascript framework"
```

## Validation

All environment variables are:
- ✅ Exported with fallback defaults
- ✅ Used consistently in keybinding definitions
- ✅ Documented with descriptions
- ✅ Non-conflicting default assignments
- ✅ Compatible with existing gh-fzf patterns
