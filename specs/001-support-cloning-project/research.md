# Research: Support Cloning Project/Fork and Useful Keys in Repo Search

## Research Questions and Findings

### Clone Destination Directory Configuration

**Decision**: Use configurable clone destination with smart defaults  
**Rationale**: Provides flexibility while maintaining reasonable defaults  
**Alternatives considered**: 
- Fixed current directory (too restrictive)
- Always prompt (too intrusive)
- **Chosen**: Environment variable `GH_FZF_CLONE_DIR` with fallback to current directory

### Additional Useful Repository Actions

**Decision**: Implement clone, fork, copy URL, open in browser, view issues/PRs, and help  
**Rationale**: These are the most common repository operations developers need  
**Alternatives considered**:
- All possible GitHub operations (too complex)
- Only clone and fork (too limited)
- **Chosen**: Balanced set of essential operations

### Keybinding Strategy

**Decision**: Follow existing gh-fzf patterns with mnemonic keys  
**Rationale**: Maintains consistency and predictability for existing users  
**Alternatives considered**:
- Random available keys (poor UX)
- Conflicting with existing bindings (breaking change)
- **Chosen**: 
  - `c` for clone (mnemonic)
  - `f` for fork (mnemonic)
  - `u` for copy URL (mnemonic for URL)
  - `?` or `h` for help (standard)
  - Existing `ctrl-o` for open in browser
  - Existing `alt-i` and `alt-p` for issues/PRs

### Error Handling Patterns

**Decision**: Follow existing gh-fzf error handling with user-friendly messages  
**Rationale**: Consistency with existing codebase and good UX  
**Alternatives considered**:
- Silent failures (poor UX)
- Verbose technical errors (confusing)
- **Chosen**: Clear, actionable error messages with fallback strategies

### Permission and Authentication Handling

**Decision**: Leverage gh CLI's existing authentication and permission model  
**Rationale**: No need to reinvent authentication, rely on proven system  
**Alternatives considered**:
- Custom permission checking (unnecessary complexity)
- **Chosen**: Let gh CLI handle authentication and show appropriate errors

### Duplicate Fork Detection

**Decision**: Check if user already has fork before attempting to create one  
**Rationale**: Prevents errors and provides better user experience  
**Alternatives considered**:
- Always attempt fork (leads to errors)
- **Chosen**: Pre-check and provide appropriate action (visit existing fork or create new one)

## Technology Best Practices

### Bash Script Enhancement Patterns
- Use existing variable naming conventions (`GH_FZF_*`)
- Follow existing function structure and documentation style
- Maintain backward compatibility
- Use proper error handling with `error()` function

### FZF Integration Patterns
- Use `--bind` for keybindings
- Follow existing preview and header patterns
- Maintain consistent prompt styling
- Use `execute` for actions that modify state
- Use `execute-silent` for background operations

### GitHub CLI Integration
- Use `gh repo clone` for cloning operations
- Use `gh repo fork` for forking operations
- Leverage existing `gh repo view` patterns
- Use JSON output where possible for reliable parsing

## Implementation Approach

1. **Extend existing repo_cmd() function** with new keybindings
2. **Create helper functions** for clone and fork operations
3. **Add configuration variables** for clone directory
4. **Update help text** to include new keybindings
5. **Test with various repository types** (public, private, already forked)
