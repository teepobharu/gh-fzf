# glab-fzf

An fzf wrapper around the GitLab CLI, inspired by [gh-fzf](https://github.com/benelan/gh-fzf).

## Features

This extension adds fuzzy finding capabilities to GitLab CLI commands, making it easier to:

- Browse and interact with GitLab issues
- Manage merge requests with keybindings
- Monitor and control CI/CD pipelines
- Navigate GitLab projects
- Perform actions directly from the interface

## Prerequisites

1. Install [`glab`](https://gitlab.com/gitlab-org/cli) - GitLab CLI
2. Install [`fzf`](https://github.com/junegunn/fzf#installation) - Command-line fuzzy finder
3. Authenticate with GitLab: `glab auth login`

## Installation

1. Clone this repository:
```bash
git clone <repository-url> glab-fzf
cd glab-fzf
```

2. Make the script executable:
```bash
chmod +x glab-fzf
```

3. Add to your PATH or create a symlink:
```bash
# Option 1: Add to PATH
export PATH="$PATH:/path/to/glab-fzf"

# Option 2: Create a symlink
ln -s /path/to/glab-fzf/glab-fzf /usr/local/bin/glab-fzf
```

## Usage

```bash
glab-fzf <command> [flags]
```

Available commands:
- `issue` - Search and interact with GitLab issues
- `mr` - Search and interact with merge requests
- `pipeline` - Search and interact with CI/CD pipelines
- `project` - Search and interact with GitLab projects

### Global Keybindings

| Key               | Description                                           |
| ----------------- | ----------------------------------------------------- |
| `ctrl-o`          | Open the selected item in the browser                |
| `ctrl-y`          | Copy the selected item's URL to clipboard            |
| `ctrl-r`          | Reload the list                                       |
| `alt-?`           | Show help                                             |
| `alt-P`           | Toggle preview window layout                          |
| `alt-H`           | Toggle header/hints display                           |
| `alt-1` - `alt-9` | Change the number of items fetched (100, 200, ..., 900) |

### Issue Commands

```bash
glab-fzf issue [flags]
```

**Keybindings:**
| Key     | Description                        |
| ------- | ---------------------------------- |
| `enter` | View issue details                 |
| `alt-e` | Edit issue                         |
| `alt-c` | Close issue                        |
| `alt-o` | Reopen issue                       |
| `alt-a` | Assign issue                       |
| `alt-s` | Subscribe to issue                 |
| `alt-S` | Filter by state (all)              |
| `alt-A` | Filter by assignee (@me)           |
| `alt-U` | Filter by author (@me)             |

### Merge Request Commands

```bash
glab-fzf mr [flags]
```

**Keybindings:**
| Key     | Description                        |
| ------- | ---------------------------------- |
| `enter` | View merge request details         |
| `alt-o` | Checkout MR branch                 |
| `alt-e` | Edit merge request                 |
| `alt-d` | Show diff                          |
| `alt-a` | Approve merge request              |
| `alt-m` | Merge request                      |
| `alt-c` | Close merge request                |
| `alt-r` | Reopen merge request               |
| `alt-S` | Filter by state (all)              |
| `alt-A` | Filter by assignee (@me)           |
| `alt-U` | Filter by author (@me)             |
| `alt-D` | Filter draft MRs                   |

### Pipeline Commands

```bash
glab-fzf pipeline [flags]
```

**Keybindings:**
| Key     | Description                        |
| ------- | ---------------------------------- |
| `enter` | View pipeline details              |
| `alt-r` | Retry pipeline                     |
| `alt-c` | Cancel pipeline                    |
| `alt-d` | Delete pipeline                    |
| `alt-s` | Filter by status                   |
| `alt-b` | Filter by current branch           |

### Project Commands

```bash
glab-fzf project [flags]
```

**Keybindings:**
| Key     | Description                        |
| ------- | ---------------------------------- |
| `enter` | View project details               |
| `alt-c` | Clone project                      |
| `alt-f` | Fork project                       |
| `alt-i` | View project issues                |
| `alt-m` | View project merge requests        |
| `alt-p` | View project pipelines             |
| `alt-o` | Show owned projects                |
| `alt-M` | Show member projects               |

## Configuration

Environment variables for customization:

| Variable                    | Description                                  | Default  |
| --------------------------- | -------------------------------------------- | -------- |
| `GLAB_FZF_DEFAULT_LIMIT`    | Initial number of items to fetch            | 50       |
| `GLAB_FZF_COPY_CMD`         | Command to copy URLs to clipboard           | auto-detected |
| `GLAB_FZF_OPEN_CMD`         | Command to open URLs in browser             | auto-detected |
| `GLAB_FZF_HIDE_HINTS`       | Set to hide header hints on startup         | unset    |

### Custom Keybindings

You can customize keybindings by setting environment variables:

```bash
# Example: Change the open key from ctrl-o to ctrl-b
export GLAB_FZF_OPEN_KEY="ctrl-b"

# Example: Change the copy key from ctrl-y to ctrl-c
export GLAB_FZF_COPY_KEY="ctrl-c"
```

## Examples

```bash
# Browse all issues
glab-fzf issue

# Browse merge requests assigned to you
glab-fzf mr --assignee @me

# Browse failed pipelines
glab-fzf pipeline --status failed

# Browse your owned projects
glab-fzf project --owned
```

## Contributing

This project is inspired by [gh-fzf](https://github.com/benelan/gh-fzf). Contributions are welcome!

## License

MIT License - see the original gh-fzf project for license details.