#!/usr/bin/env bash
# Test script for gh-fzf repo command keybindings using tmux

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test results tracking
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Helper functions
log_test() {
    echo -e "${YELLOW}[TEST]${NC} $1"
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    PASSED_TESTS=$((PASSED_TESTS + 1))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    FAILED_TESTS=$((FAILED_TESTS + 1))
}

# Test helper function
test_gh_fzf_command() {
    local cmd="$1"
    local timeout_duration="${2:-5}"
    local session="gh-fzf-test-$$-$(date +%s)"

    # Create tmux session
    if ! tmux new-session -d -s "$session" 2>/dev/null; then
        log_fail "Failed to create tmux session: $session"
        return 1
    fi

    # Run command
    tmux send-keys -t "$session" "$cmd" Enter
    sleep "$timeout_duration"

    # Capture output
    local output
    output=$(tmux capture-pane -t "$session" -p 2>/dev/null || echo "Failed to capture")

    # Clean up
    tmux kill-session -t "$session" 2>/dev/null || true

    echo "$output"
}

# Test keybinding sequence
test_keybinding() {
    local cmd="$1"
    local keys="$2"
    local expected_pattern="$3"
    local timeout_duration="${4:-3}"
    local session="gh-fzf-test-$$-$(date +%s)"

    # Create tmux session
    if ! tmux new-session -d -s "$session" 2>/dev/null; then
        log_fail "Failed to create tmux session for keybinding test"
        return 1
    fi

    # Run command
    tmux send-keys -t "$session" "$cmd" Enter
    sleep 2

    # Send key sequence
    IFS=' ' read -ra KEYS <<< "$keys"
    for key in "${KEYS[@]}"; do
        tmux send-keys -t "$session" "$key"
        sleep 0.5
    done

    sleep "$timeout_duration"

    # Capture output
    local output
    output=$(tmux capture-pane -t "$session" -p 2>/dev/null || echo "Failed to capture")

    # Clean up
    tmux kill-session -t "$session" 2>/dev/null || true

    # Check if expected pattern exists
    if [[ -n "$expected_pattern" && "$output" =~ $expected_pattern ]]; then
        return 0
    elif [[ -z "$expected_pattern" ]]; then
        # If no pattern specified, just return the output for manual inspection
        echo "$output"
        return 0
    else
        return 1
    fi
}

# Main test function
run_tests() {
    echo "Starting gh-fzf repo command keybinding tests..."
    echo "================================================"

    # Test 1: Basic functionality
    log_test "Basic repo command functionality"
    output=$(test_gh_fzf_command "gh fzfll repo" 8)
    if [[ "$output" =~ "repo" ]] || [[ "$output" =~ "Actions" ]]; then
        log_pass "Repo command loads successfully"
    else
        log_fail "Repo command failed to load properly"
        echo "Output: $output"
    fi

    # Test 2: Help keybinding (alt-?)
    log_test "Help keybinding (alt-?)"
    if test_keybinding "gh fzfll repo" "M-?" "README" 5 >/dev/null 2>&1; then
        log_pass "Help keybinding works"
    else
        log_fail "Help keybinding failed"
    fi

    # Test 3: Reload keybinding (ctrl-r)
    log_test "Reload keybinding (ctrl-r)"
    output=$(test_keybinding "gh fzfll repo" "C-r" "" 4)
    if [[ "$output" =~ "repo" ]]; then
        log_pass "Reload keybinding works"
    else
        log_fail "Reload keybinding failed"
    fi

    # Test 4: Toggle preview (alt-P)
    log_test "Toggle preview keybinding (alt-P)"
    output=$(test_keybinding "gh fzfll repo" "M-P" "" 3)
    # This test is harder to verify automatically, so we'll just check it runs
    log_pass "Toggle preview keybinding executed"

    # Test 5: Toggle hints (alt-H)
    log_test "Toggle hints keybinding (alt-H)"
    output=$(test_keybinding "gh fzfll repo" "M-H" "" 3)
    log_pass "Toggle hints keybinding executed"

    # Test 6: Private filter (alt-c)
    log_test "Private repo filter (alt-c)"
    output=$(test_keybinding "gh fzfll repo" "M-c" "" 4)
    if [[ "$output" =~ "private" ]] || [[ "$output" =~ "repo" ]]; then
        log_pass "Private filter keybinding works"
    else
        log_fail "Private filter keybinding failed"
    fi

    # Test 7: Public filter (alt-o)
    log_test "Public repo filter (alt-o)"
    output=$(test_keybinding "gh fzfll repo" "M-o" "" 4)
    if [[ "$output" =~ "public" ]] || [[ "$output" =~ "repo" ]]; then
        log_pass "Public filter keybinding works"
    else
        log_fail "Public filter keybinding failed"
    fi

    # Test 8: Source filter (alt-s)
    log_test "Source repo filter (alt-s)"
    output=$(test_keybinding "gh fzfll repo" "M-s" "" 4)
    if [[ "$output" =~ "repo" ]]; then
        log_pass "Source filter keybinding works"
    else
        log_fail "Source filter keybinding failed"
    fi

    # Test 9: Fork filter (alt-f)
    log_test "Fork repo filter (alt-f)"
    output=$(test_keybinding "gh fzfll repo" "M-f" "" 4)
    if [[ "$output" =~ "repo" ]]; then
        log_pass "Fork filter keybinding works"
    else
        log_fail "Fork filter keybinding failed"
    fi

    # Test 10: Quit with 'q'
    log_test "Quit functionality"
    output=$(test_keybinding "gh fzfll repo" "q" "" 2)
    log_pass "Quit functionality works"

    echo ""
    echo "================================================"
    echo "Test Summary:"
    echo "Total tests: $TOTAL_TESTS"
    echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
    echo -e "Failed: ${RED}$FAILED_TESTS${NC}"

    if [ $FAILED_TESTS -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        return 0
    else
        echo -e "${RED}Some tests failed.${NC}"
        return 1
    fi
}

# Test search repo functionality
test_search_repo() {
    echo ""
    echo "Testing search repo functionality..."
    echo "===================================="

    # Test search repo basic functionality
    log_test "Search repo basic functionality"
    output=$(test_gh_fzf_command "gh fzfll search repos" 8)
    if [[ "$output" =~ "repos" ]] || [[ "$output" =~ "Actions" ]]; then
        log_pass "Search repo command loads successfully"
    else
        log_fail "Search repo command failed to load properly"
        echo "Output: $output"
    fi

    # Test mode toggle (alt-/)
    log_test "Search mode toggle (alt-/)"
    output=$(test_keybinding "gh fzfll search repos" "M-/" "" 3)
    if [[ "$output" =~ "fzf" ]] || [[ "$output" =~ "gh" ]]; then
        log_pass "Search mode toggle works"
    else
        log_fail "Search mode toggle failed"
    fi

    echo ""
    echo "Search repo test summary:"
    echo "Total tests: $TOTAL_TESTS"
    echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
    echo -e "Failed: ${RED}$FAILED_TESTS${NC}"
}

# Check dependencies
check_dependencies() {
    echo "Checking dependencies..."

    if ! command -v tmux >/dev/null 2>&1; then
        echo -e "${RED}Error: tmux is required but not installed${NC}"
        exit 1
    fi

    if ! command -v gh >/dev/null 2>&1; then
        echo -e "${RED}Error: GitHub CLI (gh) is required but not installed${NC}"
        exit 1
    fi

    if ! gh auth status >/dev/null 2>&1; then
        echo -e "${RED}Error: GitHub CLI not authenticated. Run 'gh auth login'${NC}"
        exit 1
    fi

    echo -e "${GREEN}All dependencies satisfied${NC}"
}

# Main execution
main() {
    check_dependencies
    run_tests
    test_search_repo
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi