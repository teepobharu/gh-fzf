# Data Model: Support Cloning Project/Fork and Useful Keys in Repo Search

## Entities

### Repository
Represents a GitHub repository accessible through the search interface.

**Fields:**
- `nameWithOwner`: Full repository name (owner/repo-name)
- `visibility`: public, private, or internal
- `viewerPermission`: user's permission level (read, write, admin)
- `cloneUrl`: HTTPS clone URL for the repository
- `sshUrl`: SSH clone URL for the repository
- `forkable`: boolean indicating if repository can be forked
- `isUserFork`: boolean indicating if current user already has a fork

**Relationships:**
- Has many available actions based on permissions
- Can have associated issues and pull requests
- May have upstream repository if it's a fork

### Repository Action
Represents an available action that can be performed on a repository.

**Fields:**
- `key`: keyboard shortcut (e.g., 'c', 'f', 'ctrl-o')
- `name`: human-readable action name
- `description`: detailed description for help
- `requiresAuth`: boolean indicating if action requires authentication
- `requiresPermission`: minimum permission level required
- `commandTemplate`: gh CLI command template to execute

**Relationships:**
- Belongs to a repository
- May depend on repository state (e.g., fork availability)

### Operation Result
Represents the outcome of a repository operation.

**Fields:**
- `success`: boolean indicating operation success
- `errorMessage`: error description if operation failed
- `resultPath`: local path if operation created files/directories
- `resultUrl`: web URL if operation created web resources
- `userMessage`: friendly message to display to user

**State Transitions:**
- Pending → Success/Failure
- Can be retried for certain failure types

## Validation Rules

### Repository Operations
- Clone: Repository must be accessible, destination directory must be writable
- Fork: Repository must be forkable, user must not already have a fork
- URL Copy: Repository must have accessible web URL
- View Issues/PRs: Repository must allow issue/PR access

### Error Handling
- Network failures: Retry with exponential backoff
- Permission failures: Display clear error with suggested remediation
- Already exists failures: Offer alternative actions (e.g., open existing fork)

## Configuration

### Environment Variables
- `GH_FZF_CLONE_DIR`: Default directory for cloning repositories
- `GH_FZF_CLONE_KEY`: Keyboard shortcut for clone action (default: 'c')
- `GH_FZF_FORK_KEY`: Keyboard shortcut for fork action (default: 'f')
- `GH_FZF_COPY_URL_KEY`: Keyboard shortcut for copy URL action (default: 'u')

### Default Values
- Clone directory: Current working directory
- Clone method: HTTPS (follows gh CLI default)
- Error timeout: 30 seconds for network operations
