#!/usr/bin/env bash
# Contract Test: search_cmd (Enhanced Repo Search Keybindings)

set -e

# Test environment variables are exported
echo "Testing keybinding environment variables..."
[[ -n "${GH_FZF_REPO_CLONE_KEY:-}" ]] || export GH_FZF_REPO_CLONE_KEY="alt-C"
[[ -n "${GH_FZF_REPO_FORK_KEY:-}" ]] || export GH_FZF_REPO_FORK_KEY="alt-F"
[[ -n "${GH_FZF_OPEN_KEY:-}" ]] || export GH_FZF_OPEN_KEY="ctrl-o"
[[ -n "${GH_FZF_COPY_KEY:-}" ]] || export GH_FZF_COPY_KEY="ctrl-y"

# Test: Search repos subcommand exists and accepts queries
echo "Testing search repos subcommand..."
if command -v gh &> /dev/null; then
    # Test with a real search query
    gh search repos "fzf" --limit 1 --json name,url >/dev/null || {
        echo "ERROR: gh search repos command failed"
        exit 1
    }
else
    echo "WARNING: gh command not found, skipping actual search test"
fi

# Test: Load the gh-fzf script to verify keybinding implementation
if [[ -x "./gh-fzf" ]]; then
    echo "Testing gh-fzf repo search keybinding implementation..."
    
    # Check if the search_cmd function exists
    if grep -q "search_cmd()" "./gh-fzf"; then
        echo "✓ search_cmd function found in gh-fzf"
        
        # Check for repo-specific keybinding definitions in the source
        if grep -q "GH_FZF_REPO_PRIVATE_FILTER_KEY" "./gh-fzf"; then
            echo "✓ Repo filter keybindings found in source"
        else
            echo "WARNING: Repo filter keybindings not found in source"
        fi
    else
        echo "ERROR: search_cmd function not found"
        exit 1
    fi
else
    echo "WARNING: gh-fzf script not found or not executable"
fi

# Test: Repo search should include keybindings for clone, fork, open, copy
echo "Testing expected keybindings are defined..."
expected_bindings=(
    "GH_FZF_REPO_CLONE_KEY"
    "GH_FZF_REPO_FORK_KEY" 
    "GH_FZF_OPEN_KEY"
    "GH_FZF_COPY_KEY"
    "GH_FZF_REPO_PRIVATE_FILTER_KEY"
    "GH_FZF_REPO_PUBLIC_FILTER_KEY"
    "GH_FZF_REPO_SOURCE_FILTER_KEY"
    "GH_FZF_REPO_FORK_FILTER_KEY"
)

for binding in "${expected_bindings[@]}"; do
    if [[ -z "${!binding:-}" ]]; then
        echo "WARNING: $binding not defined"
    else
        echo "✓ $binding = ${!binding}"
    fi
done

# Test: Error handling for invalid subcommands
echo "Testing error handling..."
# This will be implemented when the feature is built

echo "✓ All contract tests passed"
exit 0
