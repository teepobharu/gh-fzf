# GitHub CLI Integration Contracts

## Repository Clone Contract

**Command**: `gh repo clone {nameWithOwner}`
**Input**: Repository identifier (owner/name format)
**Output**: Local repository directory
**Success Criteria**:
- Directory created with repository name
- Git repository initialized and populated
- Remote 'origin' configured correctly
- Exit code 0

**Failure Modes**:
- Exit code 1: General error (repository not found, network issues)
- Exit code 2: Authentication required
- Exit code 3: Permission denied

## Repository Fork Contract

**Command**: `gh repo fork {nameWithOwner}`
**Input**: Repository identifier (owner/name format)  
**Output**: Forked repository URL
**Success Criteria**:
- Fork created in user's account
- Fork URL returned
- Proper upstream relationship established
- Exit code 0

**Failure Modes**:
- Exit code 1: Repository cannot be forked
- Exit code 2: Fork already exists
- Exit code 3: Permission denied

## Repository Information Contract

**Command**: `gh repo view {nameWithOwner} --json url,owner,name,private,fork`
**Input**: Repository identifier
**Output**: JSON object with repository metadata
**Success Criteria**:
- Valid JSON response
- Contains required fields: url, owner.login, name, private, fork
- Exit code 0

**Example Response**:
```json
{
  "url": "https://github.com/owner/repo",
  "owner": {"login": "owner"},
  "name": "repo", 
  "private": false,
  "fork": true
}
```

## User Fork Check Contract

**Command**: `gh api user/repos --jq '.[] | select(.name=="${repo_name}" and .fork==true and .parent.full_name=="${original_repo}") | .html_url'`
**Input**: Repository name and original repository full name
**Output**: Fork URL if exists, empty if not
**Success Criteria**:
- Returns fork URL if user has fork
- Returns empty string if no fork exists
- Exit code 0
