# Keybinding Contracts

## Clone Repository Action

**Trigger**: User presses 'c' key while repository is selected
**Input**: Selected repository nameWithOwner
**Expected Behavior**: 
- Check if destination directory exists and is writable
- Execute `gh repo clone {nameWithOwner}` in configured clone directory
- Display progress feedback to user
- On success: Show confirmation with local path
- On failure: Show error message with suggested remediation

**Error Cases**:
- Permission denied: "Cannot clone {repo}. Check repository access permissions."
- Directory exists: "Directory {name} already exists. Choose different location or remove existing directory."
- Network failure: "Failed to clone {repo}. Check internet connection and try again."

## Fork Repository Action

**Trigger**: User presses 'f' key while repository is selected
**Input**: Selected repository nameWithOwner
**Expected Behavior**:
- Check if user already has a fork of this repository
- If fork exists: Ask user if they want to clone existing fork or view it
- If no fork: Execute `gh repo fork {nameWithOwner}`
- Display progress feedback to user
- On success: Show confirmation with fork URL
- On failure: Show error message with suggested remediation

**Error Cases**:
- Already forked: "You already have a fork at {fork_url}. Press 'o' to open it."
- Cannot fork: "Cannot fork {repo}. Repository may not allow forking or you may lack permissions."
- Network failure: "Failed to fork {repo}. Check internet connection and try again."

## Copy URL Action

**Trigger**: User presses 'u' key while repository is selected
**Input**: Selected repository nameWithOwner
**Expected Behavior**:
- Get repository web URL using `gh repo view {nameWithOwner} --json url`
- Copy URL to system clipboard using configured copy command
- Display brief confirmation message

**Error Cases**:
- No clipboard: "Cannot copy URL. Clipboard not available."
- Repository not found: "Cannot get URL for {repo}. Repository may be private or deleted."

## Help Action

**Trigger**: User presses '?' or 'h' key
**Input**: Current context (repo search)
**Expected Behavior**:
- Display overlay showing all available keybindings
- Include descriptions for each action
- Show current configuration (clone directory, etc.)
- Allow user to dismiss with any key

**Format**:
```
Repository Actions:
  c     Clone repository to local directory
  f     Fork repository to your account
  u     Copy repository URL to clipboard
  ctrl-o Open repository in browser
  alt-i  View repository issues  
  alt-p  View repository pull requests
  ?     Show this help
```
