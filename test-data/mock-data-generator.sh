#!/usr/bin/env bash
#
# Mock Data Generator for glab-fzf Testing
#
# This script generates mock data that simulates the output of various glab commands
# to enable testing without requiring actual GitLab API access.
#

set -e

MOCK_DATA_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Generate mock issue list output
generate_mock_issues() {
    cat > "$MOCK_DATA_DIR/issues.txt" << 'EOF'
#42	A few minutes ago	Fix authentication bug in login module	john.doe	enhancement
#35	2 hours ago	Add dark mode toggle to user settings	jane.smith	feature
#28	1 day ago	Performance issue with large dataset queries	mike.wilson	bug,performance
#21	3 days ago	Update documentation for API endpoints	sarah.connor	documentation
#15	1 week ago	Implement user role permissions system	bob.johnson	feature,security
#8	2 weeks ago	Memory leak in background job processor	alice.brown	bug,critical
#3	1 month ago	Add integration tests for payment module	tom.anderson	testing
EOF
}

# Generate mock MR list output
generate_mock_mrs() {
    cat > "$MOCK_DATA_DIR/mrs.txt" << 'EOF'
!125	2 hours ago	feat: implement user authentication with OAuth2	john.doe	feature-oauth	ready
!118	1 day ago	fix: resolve memory leak in data processing	jane.smith	bugfix-memory	draft
!112	3 days ago	docs: update API documentation for v2.0	mike.wilson	docs-v2	ready
!105	1 week ago	refactor: optimize database queries	sarah.connor	perf-db	ready
!98	2 weeks ago	test: add comprehensive unit tests	bob.johnson	testing	ready
!91	1 month ago	ci: setup automated deployment pipeline	alice.brown	ci-setup	ready
EOF
}

# Generate mock pipeline list output
generate_mock_pipelines() {
    cat > "$MOCK_DATA_DIR/pipelines.txt" << 'EOF'
success	10 minutes ago	CI Pipeline	main	Deploy to production	push	12345678
running	30 minutes ago	Test Suite	feature-branch	Run automated tests	merge_request_event	12345677
failed	2 hours ago	Security Scan	main	Security vulnerability scan	schedule	12345676
success	1 day ago	Build & Test	develop	Build and test application	push	12345675
canceled	2 days ago	Deploy Staging	staging	Deploy to staging environment	push	12345674
success	3 days ago	Code Quality	main	Run code quality checks	merge_request_event	12345673
EOF
}

# Generate mock project/repository list output
generate_mock_projects() {
    cat > "$MOCK_DATA_DIR/projects.txt" << 'EOF'
user/awesome-web-app	A modern web application built with React and Node.js	https://gitlab.com/user/awesome-web-app
user/api-gateway	Microservices API gateway with authentication and rate limiting	https://gitlab.com/user/api-gateway
user/mobile-app	Cross-platform mobile application using React Native	https://gitlab.com/user/mobile-app
team/shared-library	Common utilities and components shared across projects	https://gitlab.com/team/shared-library
team/infrastructure	Infrastructure as code using Terraform and Ansible	https://gitlab.com/team/infrastructure
organization/public-api	Public REST API for third-party integrations	https://gitlab.com/organization/public-api
EOF
}

# Generate mock glab command outputs
generate_mock_commands() {
    mkdir -p "$MOCK_DATA_DIR/commands"

    # Mock issue view output
    cat > "$MOCK_DATA_DIR/commands/issue-view-42.txt" << 'EOF'
Fix authentication bug in login module (#42)
Open • john.doe opened 2 hours ago • 3 comments

Labels: enhancement
Assignees: jane.smith
Milestone: v2.1.0

Description:
The login module has an authentication bug that prevents users from logging in
with certain special characters in their passwords. This needs to be fixed
before the next release.

Steps to reproduce:
1. Create user with password containing @ symbol
2. Attempt to login
3. Login fails with generic error message

Expected behavior: Login should succeed
Actual behavior: Login fails

Comments:
jane.smith: I'll take a look at this
mike.wilson: This might be related to URL encoding
john.doe: Thanks for the quick response!

View this issue on GitLab: https://gitlab.com/user/project/-/issues/42
EOF

    # Mock MR view output
    cat > "$MOCK_DATA_DIR/commands/mr-view-125.txt" << 'EOF'
feat: implement user authentication with OAuth2 (!125)
Open • john.doe opened 2 hours ago • feature-oauth → main

Labels: feature
Assignees: jane.smith
Reviewers: mike.wilson, sarah.connor

Changes: +245 -67 (15 files changed)

Description:
Implement OAuth2 authentication to allow users to login with third-party
providers like Google, GitHub, and GitLab.

Features:
- OAuth2 provider configuration
- User profile synchronization
- Token refresh handling
- Security improvements

This MR includes:
- New OAuth2 service implementation
- Updated user model with provider fields
- Integration tests for all providers
- Documentation updates

View this merge request on GitLab: https://gitlab.com/user/project/-/merge_requests/125
EOF

    # Mock pipeline view output
    cat > "$MOCK_DATA_DIR/commands/pipeline-view-12345678.txt" << 'EOF'
Pipeline #12345678 • success • 10 minutes ago

Commit: a1b2c3d4 "Deploy to production"
Branch: main
Author: john.doe
Triggered by: push event

Jobs:
✓ build       (2m 15s)
✓ test        (5m 30s)
✓ security    (3m 45s)
✓ deploy      (8m 20s)

Duration: 19m 50s
Coverage: 87.5%

View this pipeline on GitLab: https://gitlab.com/user/project/-/pipelines/12345678
EOF

    # Mock project view output
    cat > "$MOCK_DATA_DIR/commands/project-view-user-awesome-web-app.txt" << 'EOF'
user/awesome-web-app

A modern web application built with React and Node.js

Repository: https://gitlab.com/user/awesome-web-app
Clone URL: git@gitlab.com:user/awesome-web-app.git

Statistics:
- Stars: 42
- Forks: 8
- Issues: 15 open, 127 closed
- Merge Requests: 3 open, 89 merged

Languages:
- JavaScript: 65.2%
- TypeScript: 22.8%
- CSS: 8.1%
- HTML: 3.9%

Last activity: 2 hours ago
Created: 8 months ago

View this project on GitLab: https://gitlab.com/user/awesome-web-app
EOF
}

# Generate mock environment configurations
generate_mock_env() {
    cat > "$MOCK_DATA_DIR/test-env.sh" << 'EOF'
#!/usr/bin/env bash
# Mock environment configuration for testing

# Override glab commands with mock data during testing
export GLAB_MOCK_MODE=1

# Mock glab command wrapper
glab() {
    local command="$1"
    local subcommand="$2"
    shift 2

    case "$command" in
        "issue")
            case "$subcommand" in
                "list")
                    cat "$MOCK_DATA_DIR/issues.txt"
                    ;;
                "view")
                    local issue_id="$1"
                    if [[ -f "$MOCK_DATA_DIR/commands/issue-view-${issue_id}.txt" ]]; then
                        cat "$MOCK_DATA_DIR/commands/issue-view-${issue_id}.txt"
                    else
                        echo "Issue #${issue_id} not found"
                    fi
                    ;;
                *)
                    echo "Mock: glab issue $subcommand $*"
                    ;;
            esac
            ;;
        "mr")
            case "$subcommand" in
                "list")
                    cat "$MOCK_DATA_DIR/mrs.txt"
                    ;;
                "view")
                    local mr_id="$1"
                    if [[ -f "$MOCK_DATA_DIR/commands/mr-view-${mr_id}.txt" ]]; then
                        cat "$MOCK_DATA_DIR/commands/mr-view-${mr_id}.txt"
                    else
                        echo "Merge request !${mr_id} not found"
                    fi
                    ;;
                *)
                    echo "Mock: glab mr $subcommand $*"
                    ;;
            esac
            ;;
        "pipeline")
            case "$subcommand" in
                "list")
                    cat "$MOCK_DATA_DIR/pipelines.txt"
                    ;;
                "view")
                    local pipeline_id="$1"
                    if [[ -f "$MOCK_DATA_DIR/commands/pipeline-view-${pipeline_id}.txt" ]]; then
                        cat "$MOCK_DATA_DIR/commands/pipeline-view-${pipeline_id}.txt"
                    else
                        echo "Pipeline ${pipeline_id} not found"
                    fi
                    ;;
                *)
                    echo "Mock: glab pipeline $subcommand $*"
                    ;;
            esac
            ;;
        "repo")
            case "$subcommand" in
                "list")
                    cat "$MOCK_DATA_DIR/projects.txt"
                    ;;
                "view")
                    local repo_path="$1"
                    local safe_path="${repo_path//\//-}"
                    if [[ -f "$MOCK_DATA_DIR/commands/project-view-${safe_path}.txt" ]]; then
                        cat "$MOCK_DATA_DIR/commands/project-view-${safe_path}.txt"
                    else
                        echo "Repository ${repo_path} not found"
                    fi
                    ;;
                *)
                    echo "Mock: glab repo $subcommand $*"
                    ;;
            esac
            ;;
        *)
            echo "Mock: glab $command $subcommand $*"
            ;;
    esac
}

# Export the mock function
export -f glab

echo "Mock environment loaded. Use 'unset GLAB_MOCK_MODE' to disable."
EOF

    chmod +x "$MOCK_DATA_DIR/test-env.sh"
}

# Create interactive test data for fzf simulation
generate_fzf_test_data() {
    mkdir -p "$MOCK_DATA_DIR/fzf-tests"

    # Create test scenarios for each command
    cat > "$MOCK_DATA_DIR/fzf-tests/issue-selection.txt" << 'EOF'
# Test data for issue selection
# Format: issue_number|selected_line
42|#42	A few minutes ago	Fix authentication bug in login module	john.doe	enhancement
35|#35	2 hours ago	Add dark mode toggle to user settings	jane.smith	feature
28|#28	1 day ago	Performance issue with large dataset queries	mike.wilson	bug,performance
EOF

    cat > "$MOCK_DATA_DIR/fzf-tests/mr-selection.txt" << 'EOF'
# Test data for MR selection
# Format: mr_number|selected_line
125|!125	2 hours ago	feat: implement user authentication with OAuth2	john.doe	feature-oauth	ready
118|!118	1 day ago	fix: resolve memory leak in data processing	jane.smith	bugfix-memory	draft
112|!112	3 days ago	docs: update API documentation for v2.0	mike.wilson	docs-v2	ready
EOF

    cat > "$MOCK_DATA_DIR/fzf-tests/project-selection.txt" << 'EOF'
# Test data for project selection
# Format: project_path|selected_line
user/awesome-web-app|user/awesome-web-app	A modern web application built with React and Node.js	https://gitlab.com/user/awesome-web-app
user/api-gateway|user/api-gateway	Microservices API gateway with authentication and rate limiting	https://gitlab.com/user/api-gateway
team/shared-library|team/shared-library	Common utilities and components shared across projects	https://gitlab.com/team/shared-library
EOF
}

# Main function to generate all mock data
main() {
    echo "Generating mock data for glab-fzf testing..."

    # Create directory structure
    mkdir -p "$MOCK_DATA_DIR"

    # Generate all mock data files
    generate_mock_issues
    generate_mock_mrs
    generate_mock_pipelines
    generate_mock_projects
    generate_mock_commands
    generate_mock_env
    generate_fzf_test_data

    echo "Mock data generation complete!"
    echo "Files created in: $MOCK_DATA_DIR"
    echo ""
    echo "To use mock environment:"
    echo "  source $MOCK_DATA_DIR/test-env.sh"
    echo ""
    echo "Available mock data:"
    echo "  - Issues: $(wc -l < "$MOCK_DATA_DIR/issues.txt") items"
    echo "  - MRs: $(wc -l < "$MOCK_DATA_DIR/mrs.txt") items"
    echo "  - Pipelines: $(wc -l < "$MOCK_DATA_DIR/pipelines.txt") items"
    echo "  - Projects: $(wc -l < "$MOCK_DATA_DIR/projects.txt") items"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi