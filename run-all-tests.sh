#!/usr/bin/env bash
#
# Comprehensive Key Binding Test Runner for glab-fzf
#

set -e

SCRIPT_PATH="./gh-glab/gh-glab"
RESULTS_FILE="./test-results-comprehensive.log"

# Initialize results
echo "=== GLAB-FZF KEY BINDING TEST RESULTS ===" > "$RESULTS_FILE"
echo "Date: $(date)" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test a key binding
test_binding() {
    local command="$1"
    local key_var="$2"
    local expected_pattern="$3"
    local description="$4"

    ((TOTAL_TESTS++))

    echo -n "Testing $command/$key_var: "

    # Extract bind statement (may span multiple lines)
    local bind_statement
    bind_statement=$(grep -A 100 "${command}_cmd()" "$SCRIPT_PATH" | \
        grep -A 5 "\-\-bind.*$key_var" | tr '\n' ' ' || true)

    if [[ -z "$bind_statement" ]]; then
        echo -e "${RED}FAIL${NC} - No bind statement found"
        echo "FAIL: $command/$key_var - No bind statement found" >> "$RESULTS_FILE"
        ((FAILED_TESTS++))
        return 1
    fi

    if [[ "$bind_statement" =~ $expected_pattern ]]; then
        echo -e "${GREEN}PASS${NC} - $description"
        echo "PASS: $command/$key_var - $description" >> "$RESULTS_FILE"
        ((PASSED_TESTS++))
        return 0
    else
        echo -e "${RED}FAIL${NC} - Pattern not found: $expected_pattern"
        echo "FAIL: $command/$key_var - Pattern not found: $expected_pattern" >> "$RESULTS_FILE"
        echo "  Found: $bind_statement" >> "$RESULTS_FILE"
        ((FAILED_TESTS++))
        return 1
    fi
}

echo -e "${BLUE}Testing Issue Command Key Bindings${NC}"
echo "=== ISSUE COMMAND ===" >> "$RESULTS_FILE"

test_binding "issue" "GLAB_FZF_ISSUE_VIEW_KEY" "glab issue view" "View issue details"
test_binding "issue" "GLAB_FZF_ISSUE_EDIT_KEY" "glab issue update" "Edit issue"
test_binding "issue" "GLAB_FZF_ISSUE_CLOSE_KEY" "glab issue close" "Close issue"
test_binding "issue" "GLAB_FZF_ISSUE_REOPEN_KEY" "glab issue reopen" "Reopen issue"
test_binding "issue" "GLAB_FZF_ISSUE_ASSIGN_KEY" "glab issue update.*assignee" "Assign issue"
test_binding "issue" "GLAB_FZF_ISSUE_SUBSCRIBE_KEY" "glab issue subscribe" "Subscribe to issue"
test_binding "issue" "GLAB_FZF_ISSUE_STATE_FILTER_KEY" "state all" "Filter by state"
test_binding "issue" "GLAB_FZF_ISSUE_ASSIGNEE_FILTER_KEY" "assignee @me" "Filter by assignee"
test_binding "issue" "GLAB_FZF_ISSUE_AUTHOR_FILTER_KEY" "author @me" "Filter by author"

echo "" >> "$RESULTS_FILE"
echo -e "${BLUE}Testing MR Command Key Bindings${NC}"
echo "=== MR COMMAND ===" >> "$RESULTS_FILE"

test_binding "mr" "GLAB_FZF_MR_VIEW_KEY" "glab mr view" "View MR details"
test_binding "mr" "GLAB_FZF_MR_CHECKOUT_KEY" "glab mr checkout" "Checkout MR branch"
test_binding "mr" "GLAB_FZF_MR_EDIT_KEY" "glab mr update" "Edit MR"
test_binding "mr" "GLAB_FZF_MR_DIFF_KEY" "glab mr diff" "View MR diff"
test_binding "mr" "GLAB_FZF_MR_APPROVE_KEY" "glab mr approve" "Approve MR"
test_binding "mr" "GLAB_FZF_MR_MERGE_KEY" "glab mr merge" "Merge MR"
test_binding "mr" "GLAB_FZF_MR_CLOSE_KEY" "glab mr close" "Close MR"
test_binding "mr" "GLAB_FZF_MR_REOPEN_KEY" "glab mr reopen" "Reopen MR"
test_binding "mr" "GLAB_FZF_MR_STATE_FILTER_KEY" "state all" "Filter by state"
test_binding "mr" "GLAB_FZF_MR_ASSIGNEE_FILTER_KEY" "assignee @me" "Filter by assignee"
test_binding "mr" "GLAB_FZF_MR_AUTHOR_FILTER_KEY" "author @me" "Filter by author"
test_binding "mr" "GLAB_FZF_MR_DRAFT_FILTER_KEY" "draft" "Filter drafts"

echo "" >> "$RESULTS_FILE"
echo -e "${BLUE}Testing Pipeline Command Key Bindings${NC}"
echo "=== PIPELINE COMMAND ===" >> "$RESULTS_FILE"

test_binding "pipeline" "GLAB_FZF_PIPELINE_VIEW_KEY" "glab pipeline view" "View pipeline"
test_binding "pipeline" "GLAB_FZF_PIPELINE_RETRY_KEY" "glab pipeline retry" "Retry pipeline"
test_binding "pipeline" "GLAB_FZF_PIPELINE_CANCEL_KEY" "glab pipeline cancel" "Cancel pipeline"
test_binding "pipeline" "GLAB_FZF_PIPELINE_DELETE_KEY" "glab pipeline delete" "Delete pipeline"
test_binding "pipeline" "GLAB_FZF_PIPELINE_STATUS_FILTER_KEY" "status" "Filter by status"
test_binding "pipeline" "GLAB_FZF_PIPELINE_BRANCH_FILTER_KEY" "git symbolic-ref.*HEAD" "Filter by branch"

echo "" >> "$RESULTS_FILE"
echo -e "${BLUE}Testing Project Command Key Bindings${NC}"
echo "=== PROJECT COMMAND ===" >> "$RESULTS_FILE"

test_binding "project" "GLAB_FZF_PROJECT_VIEW_KEY" "glab repo view" "View project"
test_binding "project" "GLAB_FZF_PROJECT_CLONE_KEY" "glab repo clone" "Clone project"
test_binding "project" "GLAB_FZF_PROJECT_FORK_KEY" "glab repo fork" "Fork project"
test_binding "project" "GLAB_FZF_PROJECT_ISSUES_KEY" "issue.*repo" "View project issues"
test_binding "project" "GLAB_FZF_PROJECT_MRS_KEY" "mr.*repo" "View project MRs"
test_binding "project" "GLAB_FZF_PROJECT_PIPELINES_KEY" "pipeline.*repo" "View project pipelines"
test_binding "project" "GLAB_FZF_PROJECT_OWNED_FILTER_KEY" "mine" "Filter owned projects"
test_binding "project" "GLAB_FZF_PROJECT_MEMBER_FILTER_KEY" "member" "Filter member projects"

echo "" >> "$RESULTS_FILE"
echo -e "${BLUE}Testing Global Key Bindings${NC}"
echo "=== GLOBAL BINDINGS ===" >> "$RESULTS_FILE"

# Test global bindings
((TOTAL_TESTS++))
if grep -q "GLAB_FZF_RELOAD_KEY.*reload" "$SCRIPT_PATH"; then
    echo -e "${GREEN}PASS${NC} - Global reload key binding"
    echo "PASS: Global reload key binding" >> "$RESULTS_FILE"
    ((PASSED_TESTS++))
else
    echo -e "${RED}FAIL${NC} - Global reload key binding"
    echo "FAIL: Global reload key binding" >> "$RESULTS_FILE"
    ((FAILED_TESTS++))
fi

((TOTAL_TESTS++))
if grep -q "GLAB_FZF_OPEN_KEY.*execute-silent" "$SCRIPT_PATH"; then
    echo -e "${GREEN}PASS${NC} - Global open key binding"
    echo "PASS: Global open key binding" >> "$RESULTS_FILE"
    ((PASSED_TESTS++))
else
    echo -e "${RED}FAIL${NC} - Global open key binding"
    echo "FAIL: Global open key binding" >> "$RESULTS_FILE"
    ((FAILED_TESTS++))
fi

# Test pagination keys
for i in {1..9}; do
    ((TOTAL_TESTS++))
    if grep -q "alt-${i}:reload.*per-page.*${i}00" "$SCRIPT_PATH"; then
        echo -e "${GREEN}PASS${NC} - Pagination key alt-${i}"
        echo "PASS: Pagination key alt-${i}" >> "$RESULTS_FILE"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}FAIL${NC} - Pagination key alt-${i}"
        echo "FAIL: Pagination key alt-${i}" >> "$RESULTS_FILE"
        ((FAILED_TESTS++))
    fi
done

echo "" >> "$RESULTS_FILE"
echo "=== SUMMARY ===" >> "$RESULTS_FILE"
echo "Total Tests: $TOTAL_TESTS" >> "$RESULTS_FILE"
echo "Passed: $PASSED_TESTS" >> "$RESULTS_FILE"
echo "Failed: $FAILED_TESTS" >> "$RESULTS_FILE"

echo ""
echo "================================="
echo "TEST SUMMARY"
echo "================================="
echo "Total Tests: $TOTAL_TESTS"
echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
echo -e "Failed: ${RED}$FAILED_TESTS${NC}"

if [[ $FAILED_TESTS -eq 0 ]]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}$FAILED_TESTS test(s) failed${NC}"
    echo "Check $RESULTS_FILE for details"
    exit 1
fi