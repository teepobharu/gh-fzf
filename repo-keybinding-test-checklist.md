# Repo Command Keybinding Test Checklist

## Test Setup
- [ ] Link local gh-fzf version for testing
- [ ] Verify gh CLI is authenticated
- [ ] Ensure tmux is available for automated testing

## Basic Functionality Tests
- [ ] `gh fzf repo` - Command loads successfully
- [ ] Repository list displays correctly
- [ ] Preview window shows repo details
- [ ] Navigation with arrow keys works

## Action Keybindings (Direct Actions)
- [ ] `enter` - Edit selected repo settings (`gh repo edit`)
- [ ] `alt-C` - Clone selected repository (`gh repo clone`)
- [ ] `alt-F` - Fork selected repository (`gh repo fork`)
- [ ] `alt-i` - View issues for selected repo (`gh fzf issue --repo`)
- [ ] `alt-p` - View PRs for selected repo (`gh fzf pr --repo`)
- [ ] `alt-r` - View runs for selected repo (`gh fzf run --repo`)

## Filter Keybindings (List Modifications)
- [ ] `alt-c` - Filter to show private repos only
- [ ] `alt-o` - Filter to show public repos only
- [ ] `alt-s` - Filter to show source (non-forked) repos
- [ ] `alt-f` - Filter to show forked repos only

## Global Keybindings (Shared across all commands)
- [ ] `ctrl-o` - Open selected repo in browser
- [ ] `ctrl-y` - Copy selected repo URL to clipboard
- [ ] `ctrl-r` - Reload the repo list
- [ ] `alt-?` - Show help/documentation
- [ ] `alt-P` - Toggle preview window layout
- [ ] `alt-H` - Toggle header/hints visibility
- [ ] `alt-1` to `alt-9` - Change fetch limit (100-900 items)

## Search Repo Keybindings (gh fzf search repos)
### Basic Search Repo Functionality
- [ ] `gh fzf search repos` - Command loads successfully
- [ ] Search mode toggle works
- [ ] GitHub search syntax works in gh mode
- [ ] fzf search syntax works in fzf mode

### Search Repo Action Keybindings
- [ ] `alt-C` - Clone selected repository **[REPORTED ISSUE]**
- [ ] `alt-F` - Fork selected repository **[REPORTED ISSUE]**
- [ ] `alt-e` - Edit selected repository settings
- [ ] `alt-i` - View issues for selected repo
- [ ] `alt-p` - View PRs for selected repo
- [ ] `alt-r` - View runs for selected repo

### Search Repo Sort Keybindings
- [ ] `alt-s` - Sort by stars
- [ ] `alt-f` - Sort by forks
- [ ] `alt-u` - Sort by last updated
- [ ] `alt-c` - Sort by creation date

### Search Repo Global Keybindings
- [ ] `ctrl-o` - Open in browser **[REPORTED ISSUE]**
- [ ] `ctrl-y` - Copy URL **[REPORTED ISSUE]**
- [ ] `alt-/` - Toggle between gh/fzf search modes

## Error Conditions & Edge Cases
- [ ] No repositories available
- [ ] Network connectivity issues
- [ ] Invalid repository selection
- [ ] Permission denied scenarios
- [ ] Rate limiting scenarios

## Configuration Tests
- [ ] `GH_FZF_DEFAULT_LIMIT` environment variable respected
- [ ] Custom keybinding overrides work
- [ ] `GH_FZF_HIDE_HINTS` environment variable works
- [ ] `GH_FZF_TRUNCATE_FIELDS` environment variable works

## Integration Tests
- [ ] Works with different GitHub CLI configurations
- [ ] Works with different repository types (public/private)
- [ ] Works with organization repositories
- [ ] Keybindings don't conflict with fzf defaults

## Issues Identified
### Search Repo Command Issues
1. **Fork keybinding (alt-F)** - May not be working properly
2. **Open keybinding (ctrl-o)** - May not open in browser correctly
3. **Copy keybinding (ctrl-y)** - May not copy URL to clipboard correctly

## Test Results
_Results will be filled in during testing_

## Notes
- Use tmux for automated testing of interactive elements
- Test with actual repositories, not just mock data
- Verify actions actually perform the expected operations
- Check that keybindings are shown correctly in help text