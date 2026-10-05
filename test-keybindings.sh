#!/usr/bin/env bash
#
# Key Binding Test Framework for ghfzf/glab-fzf
#
# This script provides comprehensive testing for all key bindings in the glab-fzf tool
# to ensure they correctly trigger the appropriate glab commands.
#

set -e

# Test framework configuration
TEST_DIR="$(dirname "${BASH_SOURCE[0]}")"
SCRIPT_PATH="$TEST_DIR/gh-glab/gh-glab"
MOCK_DATA_DIR="$TEST_DIR/test-data"
TEST_RESULTS_FILE="$TEST_DIR/test-results.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test statistics
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$TEST_RESULTS_FILE"
}

log_success() {
    echo -e "${GREEN}[PASS]${NC} $1" | tee -a "$TEST_RESULTS_FILE"
    ((PASSED_TESTS++))
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1" | tee -a "$TEST_RESULTS_FILE"
    ((FAILED_TESTS++))
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$TEST_RESULTS_FILE"
}

# Initialize test environment
setup_test_environment() {
    log_info "Setting up test environment..."

    # Create mock data directory
    mkdir -p "$MOCK_DATA_DIR"

    # Clear previous test results
    > "$TEST_RESULTS_FILE"

    # Check if script exists
    if [[ ! -f "$SCRIPT_PATH" ]]; then
        log_error "glab-fzf script not found at $SCRIPT_PATH"
        exit 1
    fi

    # Check dependencies
    check_dependencies

    log_info "Test environment setup complete"
}

# Check required dependencies
check_dependencies() {
    local deps=("fzf" "glab" "bash")
    local missing=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing+=("$dep")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        log_info "Install missing dependencies to run tests"
        exit 1
    fi

    log_info "All dependencies found: ${deps[*]}"
}

# Extract key bindings from script
extract_key_bindings() {
    local command="$1"
    log_info "Extracting key bindings for $command command..."

    # Parse the script to find key binding definitions
    # This looks for export statements that define key bindings
    grep -A 20 "${command}_cmd()" "$SCRIPT_PATH" | \
        grep "export.*_KEY=" | \
        sed 's/export //; s/=.*:-/ /; s/}.*/ /' | \
        while read -r var default_key; do
            echo "$var:$default_key"
        done
}

# Test individual key binding
test_key_binding() {
    local command="$1"
    local key_name="$2"
    local key_combination="$3"
    local expected_pattern="$4"
    local test_input="$5"

    ((TOTAL_TESTS++))

    log_info "Testing $command command: $key_name ($key_combination)"

    # Extract the bind statement for this key from the script
    local bind_statement
    bind_statement=$(grep -A 100 "${command}_cmd()" "$SCRIPT_PATH" | \
        grep -m 1 "\-\-bind.*$key_name" || true)

    if [[ -z "$bind_statement" ]]; then
        log_error "$command/$key_name: No bind statement found"
        return 1
    fi

    # Check if the bind statement contains expected pattern
    if [[ "$bind_statement" =~ $expected_pattern ]]; then
        log_success "$command/$key_name: Bind statement matches expected pattern"
        return 0
    else
        log_error "$command/$key_name: Bind statement doesn't match pattern '$expected_pattern'"
        log_info "Found: $bind_statement"
        return 1
    fi
}

# Test issue command key bindings
test_issue_keybindings() {
    log_info "Testing Issue command key bindings..."

    # Action keys
    test_key_binding "issue" "GLAB_FZF_ISSUE_VIEW_KEY" "enter" "glab issue view" "123"
    test_key_binding "issue" "GLAB_FZF_ISSUE_EDIT_KEY" "alt-e" "glab issue update" "123"
    test_key_binding "issue" "GLAB_FZF_ISSUE_CLOSE_KEY" "alt-c" "glab issue close" "123"
    test_key_binding "issue" "GLAB_FZF_ISSUE_REOPEN_KEY" "alt-o" "glab issue reopen" "123"
    test_key_binding "issue" "GLAB_FZF_ISSUE_ASSIGN_KEY" "alt-a" "glab issue update.*assignee" "123"
    test_key_binding "issue" "GLAB_FZF_ISSUE_SUBSCRIBE_KEY" "alt-s" "glab issue subscribe" "123"

    # Filter keys
    test_key_binding "issue" "GLAB_FZF_ISSUE_STATE_FILTER_KEY" "alt-S" "state all" ""
    test_key_binding "issue" "GLAB_FZF_ISSUE_ASSIGNEE_FILTER_KEY" "alt-A" "assignee @me" ""
    test_key_binding "issue" "GLAB_FZF_ISSUE_AUTHOR_FILTER_KEY" "alt-U" "author @me" ""
}

# Test MR command key bindings
test_mr_keybindings() {
    log_info "Testing MR command key bindings..."

    # Action keys
    test_key_binding "mr" "GLAB_FZF_MR_VIEW_KEY" "enter" "glab mr view" "123"
    test_key_binding "mr" "GLAB_FZF_MR_CHECKOUT_KEY" "alt-o" "glab mr checkout" "123"
    test_key_binding "mr" "GLAB_FZF_MR_EDIT_KEY" "alt-e" "glab mr update" "123"
    test_key_binding "mr" "GLAB_FZF_MR_DIFF_KEY" "alt-d" "glab mr diff" "123"
    test_key_binding "mr" "GLAB_FZF_MR_APPROVE_KEY" "alt-a" "glab mr approve" "123"
    test_key_binding "mr" "GLAB_FZF_MR_MERGE_KEY" "alt-m" "glab mr merge" "123"
    test_key_binding "mr" "GLAB_FZF_MR_CLOSE_KEY" "alt-c" "glab mr close" "123"
    test_key_binding "mr" "GLAB_FZF_MR_REOPEN_KEY" "alt-r" "glab mr reopen" "123"

    # Filter keys
    test_key_binding "mr" "GLAB_FZF_MR_STATE_FILTER_KEY" "alt-S" "state all" ""
    test_key_binding "mr" "GLAB_FZF_MR_ASSIGNEE_FILTER_KEY" "alt-A" "assignee @me" ""
    test_key_binding "mr" "GLAB_FZF_MR_AUTHOR_FILTER_KEY" "alt-U" "author @me" ""
    test_key_binding "mr" "GLAB_FZF_MR_DRAFT_FILTER_KEY" "alt-D" "draft" ""
}

# Test pipeline command key bindings
test_pipeline_keybindings() {
    log_info "Testing Pipeline command key bindings..."

    # Action keys
    test_key_binding "pipeline" "GLAB_FZF_PIPELINE_VIEW_KEY" "enter" "glab pipeline view" "123"
    test_key_binding "pipeline" "GLAB_FZF_PIPELINE_RETRY_KEY" "alt-r" "glab pipeline retry" "123"
    test_key_binding "pipeline" "GLAB_FZF_PIPELINE_CANCEL_KEY" "alt-c" "glab pipeline cancel" "123"
    test_key_binding "pipeline" "GLAB_FZF_PIPELINE_DELETE_KEY" "alt-d" "glab pipeline delete" "123"

    # Filter keys
    test_key_binding "pipeline" "GLAB_FZF_PIPELINE_STATUS_FILTER_KEY" "alt-s" "status" ""
    test_key_binding "pipeline" "GLAB_FZF_PIPELINE_BRANCH_FILTER_KEY" "alt-b" "git symbolic-ref.*HEAD" ""
}

# Test project command key bindings
test_project_keybindings() {
    log_info "Testing Project command key bindings..."

    # Action keys
    test_key_binding "project" "GLAB_FZF_PROJECT_VIEW_KEY" "enter" "glab repo view" "user/repo"
    test_key_binding "project" "GLAB_FZF_PROJECT_CLONE_KEY" "alt-c" "glab repo clone" "user/repo"
    test_key_binding "project" "GLAB_FZF_PROJECT_FORK_KEY" "alt-f" "glab repo fork" "user/repo"
    test_key_binding "project" "GLAB_FZF_PROJECT_ISSUES_KEY" "alt-i" "issue.*repo" "user/repo"
    test_key_binding "project" "GLAB_FZF_PROJECT_MRS_KEY" "alt-m" "mr.*repo" "user/repo"
    test_key_binding "project" "GLAB_FZF_PROJECT_PIPELINES_KEY" "alt-p" "pipeline.*repo" "user/repo"

    # Filter keys
    test_key_binding "project" "GLAB_FZF_PROJECT_OWNED_FILTER_KEY" "alt-o" "mine" ""
    test_key_binding "project" "GLAB_FZF_PROJECT_MEMBER_FILTER_KEY" "alt-M" "member" ""
}

# Test global key bindings
test_global_keybindings() {
    log_info "Testing global key bindings..."

    # Extract global bindings from the configuration section
    local global_binds=(
        "GLAB_FZF_RELOAD_KEY:ctrl-r:reload"
        "GLAB_FZF_OPEN_KEY:ctrl-o:execute-silent"
        "GLAB_FZF_COPY_KEY:ctrl-y:execute-silent"
        "GLAB_FZF_HELP_KEY:alt-?:execute"
        "GLAB_FZF_TOGGLE_HINTS_KEY:alt-H:toggle-header"
        "GLAB_FZF_TOGGLE_PREVIEW_KEY:alt-P:change-preview-window"
    )

    for bind in "${global_binds[@]}"; do
        IFS=':' read -r key_var key_combo action <<< "$bind"
        ((TOTAL_TESTS++))

        # Check if global binding exists in FZF_DEFAULT_OPTS
        if grep -q "\$${key_var}.*${action}" "$SCRIPT_PATH"; then
            log_success "Global/$key_var: Found global binding for $key_combo"
        else
            log_error "Global/$key_var: Missing global binding for $key_combo"
        fi
    done

    # Test pagination keys (alt-1 through alt-9)
    for i in {1..9}; do
        ((TOTAL_TESTS++))
        if grep -q "alt-${i}:reload.*per-page.*${i}00" "$SCRIPT_PATH"; then
            log_success "Global/alt-${i}: Found pagination binding"
        else
            log_error "Global/alt-${i}: Missing pagination binding"
        fi
    done
}

# Analyze MR navigation issue
analyze_mr_navigation_issue() {
    log_info "Analyzing MR navigation issue..."

    # Check the problematic bind statement for alt-m in project command
    local mr_bind
    mr_bind=$(grep -A 50 "project_cmd()" "$SCRIPT_PATH" | \
        grep "GLAB_FZF_PROJECT_MRS_KEY" | head -1)

    if [[ -n "$mr_bind" ]]; then
        log_info "Found MR bind statement: $mr_bind"

        # Check if it uses {1} for repository path extraction
        if [[ "$mr_bind" =~ \{1\} ]]; then
            log_warning "MR binding uses {1} - this may cause repository path concatenation issues"
            log_info "Issue: Repository path parsing may include extra content from fzf output"
            log_info "Recommendation: Ensure {1} extracts only the repository path, not full line"
        else
            log_info "MR binding doesn't use {1} field extraction"
        fi
    else
        log_error "Could not find MR bind statement in project command"
    fi
}

# Generate test report
generate_report() {
    log_info "Generating test report..."

    echo "" | tee -a "$TEST_RESULTS_FILE"
    echo "=================================" | tee -a "$TEST_RESULTS_FILE"
    echo "KEY BINDING TEST SUMMARY" | tee -a "$TEST_RESULTS_FILE"
    echo "=================================" | tee -a "$TEST_RESULTS_FILE"
    echo "Total Tests: $TOTAL_TESTS" | tee -a "$TEST_RESULTS_FILE"
    echo "Passed: $PASSED_TESTS" | tee -a "$TEST_RESULTS_FILE"
    echo "Failed: $FAILED_TESTS" | tee -a "$TEST_RESULTS_FILE"

    if [[ $FAILED_TESTS -eq 0 ]]; then
        echo -e "${GREEN}All tests passed!${NC}" | tee -a "$TEST_RESULTS_FILE"
        exit 0
    else
        echo -e "${RED}$FAILED_TESTS test(s) failed${NC}" | tee -a "$TEST_RESULTS_FILE"
        exit 1
    fi
}

# Main test execution
main() {
    log_info "Starting key binding tests for glab-fzf..."

    setup_test_environment

    # Run all test suites
    test_issue_keybindings
    test_mr_keybindings
    test_pipeline_keybindings
    test_project_keybindings
    test_global_keybindings

    # Analyze known issues
    analyze_mr_navigation_issue

    # Generate final report
    generate_report
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi