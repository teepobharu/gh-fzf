# Quickstart: Support Cloning Project/Fork and Useful Keys in Repo Search

## Prerequisites
- gh-fzf installed and working
- GitHub CLI (`gh`) authenticated
- `fzf` available
- Git configured locally

## Basic Usage

### 1. Start Repository Search
```bash
gh fzf repo
```

### 2. Use New Keybindings

#### Clone a Repository
1. Navigate to desired repository in search results
2. Press `c` to clone
3. Repository will be cloned to current directory (or configured clone directory)
4. Confirmation message shows local path

#### Fork a Repository  
1. Navigate to desired repository in search results
2. Press `f` to fork
3. If you already have a fork, you'll be prompted to open existing fork
4. If no fork exists, new fork will be created
5. Confirmation message shows fork URL

#### Copy Repository URL
1. Navigate to desired repository in search results
2. Press `u` to copy URL to clipboard
3. Brief confirmation message appears

#### View Help
1. Press `?` or `h` to see all available keybindings
2. Help overlay shows current configuration
3. Press any key to dismiss help

### 3. Configuration (Optional)

Set default clone directory:
```bash
export GH_FZF_CLONE_DIR="$HOME/projects"
```

Customize keybindings:
```bash
export GH_FZF_CLONE_KEY="alt-c"
export GH_FZF_FORK_KEY="alt-f" 
export GH_FZF_COPY_URL_KEY="alt-u"
```

## Integration Test Scenarios

### Scenario 1: Clone Public Repository
1. Search for a public repository
2. Press `c` to clone
3. **Expected**: Repository cloned successfully, confirmation message shown
4. **Verify**: Local directory created with repository contents

### Scenario 2: Fork Repository (First Time)
1. Search for a repository you haven't forked
2. Press `f` to fork
3. **Expected**: Fork created, confirmation with fork URL
4. **Verify**: Fork exists in your GitHub account

### Scenario 3: Fork Repository (Already Exists)
1. Search for a repository you've already forked
2. Press `f` to fork
3. **Expected**: Message about existing fork with option to open
4. **Verify**: No duplicate fork created

### Scenario 4: Clone Private Repository (With Access)
1. Search for a private repository you have access to
2. Press `c` to clone
3. **Expected**: Repository cloned successfully using authentication
4. **Verify**: Local directory created with repository contents

### Scenario 5: Clone Private Repository (No Access)
1. Search for a private repository you don't have access to
2. Press `c` to clone
3. **Expected**: Clear error message about permissions
4. **Verify**: No directory created, helpful error message shown

### Scenario 6: Copy URL
1. Search for any repository
2. Press `u` to copy URL
3. **Expected**: URL copied to clipboard, confirmation shown
4. **Verify**: Clipboard contains correct repository URL

### Scenario 7: Help Display
1. Start repository search
2. Press `?` to show help
3. **Expected**: Help overlay with all keybindings and current config
4. **Verify**: Help is comprehensive and dismissible

### Scenario 8: Clone to Custom Directory
1. Set `GH_FZF_CLONE_DIR` environment variable
2. Search for repository and press `c`
3. **Expected**: Repository cloned to custom directory
4. **Verify**: Repository appears in configured location

## Error Handling Verification

- **Network issues**: Clear error message with retry suggestion
- **Permission denied**: Specific error with remediation steps
- **Directory conflicts**: Helpful message about existing directories
- **Authentication required**: Guidance to run `gh auth login`

## Performance Verification

- **Keybinding response**: Immediate (<100ms)
- **Clone operation**: Progress feedback shown
- **Fork operation**: Progress feedback shown
- **Help display**: Immediate rendering
