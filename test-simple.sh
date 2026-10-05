#!/usr/bin/env bash
# Simple test to debug key binding validation

set -e

SCRIPT_PATH="./gh-glab/gh-glab"

# Test one key binding
test_single_binding() {
    local command="issue"
    local key_name="GLAB_FZF_ISSUE_VIEW_KEY"
    local expected_pattern="glab issue view"

    echo "Testing $command command: $key_name"

    # Extract the bind statement for this key from the script
    local bind_statement
    bind_statement=$(grep -A 100 "${command}_cmd()" "$SCRIPT_PATH" | \
        grep -m 1 "\-\-bind.*$key_name" || true)

    echo "Found bind statement: $bind_statement"

    # Check if the bind statement contains expected pattern
    if [[ "$bind_statement" =~ $expected_pattern ]]; then
        echo "✓ PASS: Bind statement matches expected pattern"
        return 0
    else
        echo "✗ FAIL: Bind statement doesn't match pattern '$expected_pattern'"
        return 1
    fi
}

test_single_binding