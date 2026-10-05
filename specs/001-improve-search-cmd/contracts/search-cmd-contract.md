# CLI Contract: search_cmd (Enhanced Repo Search Keybindings)

## Command Syntax
```
search_cmd [QUERY] [--filter=FILTER] [--sort=SORT]
```

## Keybindings
- `enter`: View repository details
- `ctrl-o`: Open repository in browser
- `ctrl-y`: Copy repository URL
- `alt-c`: Clone repository
- `alt-f`: Fork repository
- `alt-1`: Filter cloned
- `alt-2`: Filter indexed
- `alt-3`: Show all
- `alt-n`: Sort by name
- `alt-d`: Sort by creation date

## Environment Variables
- SRC_FZF_COPY_CMD
- SRC_FZF_OPEN_CMD
- SRC_FZF_RELOAD_KEY
- SRC_FZF_REPO_CLONE_KEY
- SRC_FZF_REPO_FORK_KEY
- SRC_FZF_REPO_OPEN_KEY
- SRC_FZF_REPO_COPY_KEY

## Expected Output
- List of repositories matching the search query
- Real-time updates on filter/sort
- Success/failure messages for actions

## Exit Codes
- 0: Success
- 1: Error (action failed, invalid input, etc.)

## Stdout/Stderr
- Stdout: repository list, action results
- Stderr: errors, logs, debug info

---

Contract complete. See test file for usage scenarios.
