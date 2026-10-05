#!/usr/bin/env bash
#
# Diagnostic tool for MR navigation issue
#
# This script analyzes the repository path parsing problem described in checklist.md
#

set -e

SCRIPT_PATH="./gh-glab/gh-glab"

echo "=== MR Navigation Issue Diagnosis ==="
echo ""

# 1. Analyze the current MR binding
echo "1. Current MR binding in project command:"
grep -A 1 "GLAB_FZF_PROJECT_MRS_KEY" "$SCRIPT_PATH" | grep "bind"
echo ""

# 2. Show what {1} field extraction would produce with different input formats
echo "2. Field extraction analysis with different project list formats:"
echo ""

# Test with our mock data format
echo "Mock data format (tab-separated):"
echo "user/awesome-web-app	A modern web application built with React and Node.js	https://gitlab.com/user/awesome-web-app"
echo "Field {1} would extract: user/awesome-web-app"
echo ""

# Test with a potentially problematic format (space-separated with Git URL)
echo "Potentially problematic format (if glab outputs more fields):"
echo "user/awesome-web-app A modern web application git@gitlab.com:user/awesome-web-app.git"
echo "Field {1} would extract: user/awesome-web-app"
echo ""

# Test with URL concatenation issue from checklist
echo "Error format from checklist.md:"
echo "example/service-routinggit@gitlab.example.com:example/service-routing.gitFor contribution please for.."
echo "This suggests the issue is concatenation, not field extraction"
echo ""

# 3. Analyze potential solutions
echo "3. Analysis of the issue:"
echo ""
echo "The error suggests that multiple elements are being concatenated:"
echo "  - Repository path: example/service-routing"
echo "  - Git URL: git@gitlab.example.com:example/service-routing.git"
echo "  - Description text: For contribution please for.."
echo ""
echo "This indicates the issue is likely NOT with {1} field extraction,"
echo "but with how the selected line is being processed."
echo ""

# 4. Check for field delimiter configuration
echo "4. Field delimiter configuration:"
grep "delimiter" "$SCRIPT_PATH" || echo "No delimiter configuration found"
echo ""

# 5. Proposed fixes
echo "5. Proposed fixes:"
echo ""
echo "Option 1: Ensure proper field extraction by using awk to get first field"
echo "  Current:  \$script_path mr --repo {1}"
echo "  Fixed:    \$script_path mr --repo \$(echo {1} | awk '{print \$1}')"
echo ""
echo "Option 2: Use different field extraction approach"
echo "  Current:  {1}"
echo "  Fixed:    {1} (but ensure proper tab delimiter parsing)"
echo ""
echo "Option 3: Extract repository path more carefully"
echo "  Use cut command to extract first field: cut -d$'\t' -f1"
echo ""

# 6. Create test cases
echo "6. Creating test scenarios:"

# Create test input that might cause the issue
cat > test-problematic-input.txt << 'EOF'
example/service-routing	Service routing microservice	git@gitlab.example.com:example/service-routing.git	For contribution please fork and submit MR
user/another-repo	Another repository description	https://gitlab.com/user/another-repo	Some more description text
team/shared-lib	Shared library for team projects	git@gitlab.com:team/shared-lib.git	Library documentation available
EOF

echo "Created test-problematic-input.txt with potentially problematic input format"
echo ""
echo "To test field extraction:"
echo "  echo 'example/service-routing	Service routing...' | awk '{print \$1}'"
echo "  Result: $(echo 'example/service-routing	Service routing microservice	git@gitlab.example.com:example/service-routing.git	For contribution please fork' | awk '{print $1}')"
echo ""

# 7. Recommend the fix
echo "7. Recommended fix:"
echo ""
echo "The issue appears to be that fzf's {1} might be extracting more than expected"
echo "when the delimiter isn't properly configured or when the input format changes."
echo ""
echo "Fix: Wrap the repository path extraction in a shell command to ensure"
echo "only the first field is used:"
echo ""
echo "  --bind=\"\$GLAB_FZF_PROJECT_MRS_KEY:execute(\$script_path mr --repo \\\$(echo {1} | cut -d'\t' -f1))+refresh-preview\""
echo ""

# Clean up
rm -f test-problematic-input.txt