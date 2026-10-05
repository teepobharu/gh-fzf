#!/usr/bin/env bash
#
# Test script to verify the MR navigation fix
#

set -e

echo "=== Testing MR Navigation Fix ==="
echo ""

# Test the field extraction with problematic input
echo "1. Testing field extraction with problematic input:"
echo ""

test_input="example/service-routing	Service routing microservice git@gitlab.example.com:example/service-routing.git	For contribution please fork and submit MR"
echo "Input: $test_input"
echo ""

# Test old behavior (what {1} would extract with default delimiter)
echo "Old behavior (fzf {1} with double-space delimiter):"
old_result=$(echo "$test_input" | awk -F'  +' '{print $1}')
echo "Result: '$old_result'"
echo ""

# Test new behavior (with cut command)
echo "New behavior (cut -d$'\t' -f1):"
new_result=$(echo "$test_input" | cut -d$'\t' -f1)
echo "Result: '$new_result'"
echo ""

# Verify the fix
if [[ "$new_result" == "example/service-routing" ]]; then
    echo "✅ SUCCESS: Field extraction correctly isolates repository path"
else
    echo "❌ FAILED: Field extraction returned: $new_result"
    exit 1
fi

echo ""
echo "2. Testing with various input formats:"
echo ""

# Test with tab-separated input
test_inputs=(
    "user/repo1	Description with spaces	https://gitlab.com/user/repo1"
    "team/project-name	Multi word description here	git@gitlab.com:team/project-name.git"
    "org/service	Service for handling requests	https://gitlab.example.com/org/service	Extra field"
)

for input in "${test_inputs[@]}"; do
    result=$(echo "$input" | cut -d$'\t' -f1)
    expected=$(echo "$input" | cut -d$'\t' -f1)
    echo "Input: $input"
    echo "Extracted: $result"
    if [[ "$result" =~ ^[a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+$ ]]; then
        echo "✅ Valid repository path format"
    else
        echo "⚠️  Warning: Unusual repository path format"
    fi
    echo ""
done

echo "3. Verifying the actual script changes:"
echo ""

# Check that the script has been updated
if grep -q "cut -d'\\\t' -f1" gh-glab/gh-glab; then
    echo "✅ Script contains the field extraction fix"
    echo "Updated bindings found:"
    grep "cut -d'\\\t' -f1" gh-glab/gh-glab | head -3
else
    echo "❌ Script does not contain the field extraction fix"
    exit 1
fi

echo ""
echo "=== Fix Verification Complete ==="
echo ""
echo "Summary:"
echo "- Repository path extraction now uses cut -d$'\t' -f1"
echo "- This ensures only the first tab-delimited field is used"
echo "- Prevents concatenation of description and URL fields"
echo "- Should resolve the MR navigation error described in checklist.md"