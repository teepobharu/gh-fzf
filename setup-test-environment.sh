#!/usr/bin/env bash
#
# Environment Setup and Validation Script for glab-fzf Testing
#
# This script sets up and validates the testing environment for glab-fzf
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
GLAB_FZF_SCRIPT="$SCRIPT_DIR/gh-glab/gh-glab"
TEST_DATA_DIR="$SCRIPT_DIR/test-data"

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check system dependencies
check_dependencies() {
    log_info "Checking system dependencies..."

    local deps=("bash" "fzf" "glab" "git" "awk" "cut" "grep")
    local missing=()
    local warnings=()

    for dep in "${deps[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            log_success "$dep is installed"
        else
            missing+=("$dep")
            log_error "$dep is not installed"
        fi
    done

    # Check fzf version
    if command -v fzf >/dev/null 2>&1; then
        local fzf_version
        fzf_version=$(fzf --version | awk '{print $1}')
        log_info "fzf version: $fzf_version"

        # Check minimum version (0.30.0 recommended)
        if printf '%s\n0.30.0\n' "$fzf_version" | sort -V | head -1 | grep -q "^0.30.0$"; then
            log_success "fzf version is compatible"
        else
            warnings+=("fzf version may be too old (recommended: >= 0.30.0)")
            log_warning "fzf version may be too old (recommended: >= 0.30.0)"
        fi
    fi

    # Check glab authentication
    if command -v glab >/dev/null 2>&1; then
        if glab auth status >/dev/null 2>&1; then
            log_success "glab is authenticated"
            log_info "glab user: $(glab api user -q .username || echo 'unknown')"
        else
            warnings+=("glab is not authenticated - run 'glab auth login'")
            log_warning "glab is not authenticated - run 'glab auth login'"
        fi
    fi

    # Return status
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        log_info "Please install missing dependencies before running tests"
        return 1
    fi

    if [[ ${#warnings[@]} -gt 0 ]]; then
        log_warning "Environment warnings detected but tests can proceed"
        return 2
    fi

    log_success "All dependencies satisfied"
    return 0
}

# Validate glab-fzf script
validate_script() {
    log_info "Validating glab-fzf script..."

    if [[ ! -f "$GLAB_FZF_SCRIPT" ]]; then
        log_error "glab-fzf script not found at: $GLAB_FZF_SCRIPT"
        return 1
    fi

    log_success "Script found: $GLAB_FZF_SCRIPT"

    # Check if script is executable
    if [[ -x "$GLAB_FZF_SCRIPT" ]]; then
        log_success "Script is executable"
    else
        log_warning "Script is not executable - making it executable"
        chmod +x "$GLAB_FZF_SCRIPT"
    fi

    # Basic syntax check
    if bash -n "$GLAB_FZF_SCRIPT"; then
        log_success "Script syntax is valid"
    else
        log_error "Script has syntax errors"
        return 1
    fi

    # Check for required functions
    local required_functions=("issue_cmd" "mr_cmd" "pipeline_cmd" "project_cmd")
    for func in "${required_functions[@]}"; do
        if grep -q "${func}()" "$GLAB_FZF_SCRIPT"; then
            log_success "Function $func found"
        else
            log_error "Required function $func not found"
            return 1
        fi
    done

    return 0
}

# Setup test data
setup_test_data() {
    log_info "Setting up test data..."

    if [[ -d "$TEST_DATA_DIR" ]]; then
        log_success "Test data directory exists"
    else
        log_info "Creating test data directory"
        mkdir -p "$TEST_DATA_DIR"
    fi

    # Generate mock data if it doesn't exist
    if [[ -f "$TEST_DATA_DIR/mock-data-generator.sh" ]]; then
        log_success "Mock data generator found"

        # Check if mock data files exist
        local mock_files=("issues.txt" "mrs.txt" "pipelines.txt" "projects.txt")
        local missing_files=()

        for file in "${mock_files[@]}"; do
            if [[ -f "$TEST_DATA_DIR/$file" ]]; then
                log_success "Mock data file: $file"
            else
                missing_files+=("$file")
            fi
        done

        if [[ ${#missing_files[@]} -gt 0 ]]; then
            log_info "Generating missing mock data files: ${missing_files[*]}"
            cd "$TEST_DATA_DIR" && ./mock-data-generator.sh
        fi
    else
        log_warning "Mock data generator not found - some tests may not work"
    fi

    return 0
}

# Validate GitLab environment
validate_gitlab_env() {
    log_info "Validating GitLab environment..."

    # Check if we're in a Git repository
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        log_success "Inside a Git repository"

        # Check for GitLab remote
        local remotes
        remotes=$(git remote -v 2>/dev/null || true)

        if echo "$remotes" | grep -q gitlab; then
            log_success "GitLab remote detected"
            log_info "GitLab remotes:"
            echo "$remotes" | grep gitlab | head -3 | while read -r line; do
                log_info "  $line"
            done
        else
            log_warning "No GitLab remotes found - some features may not work"
            log_info "Available remotes:"
            echo "$remotes" | head -3 | while read -r line; do
                log_info "  $line"
            done
        fi
    else
        log_warning "Not inside a Git repository - some features may not work"
    fi

    # Check glab configuration
    if command -v glab >/dev/null 2>&1; then
        local glab_host
        glab_host=$(glab config get host 2>/dev/null || echo "not configured")
        log_info "glab host: $glab_host"

        if [[ "$glab_host" != "not configured" ]]; then
            log_success "glab is configured for host: $glab_host"
        else
            log_warning "glab host not configured"
        fi
    fi

    return 0
}

# Run basic functionality test
test_basic_functionality() {
    log_info "Testing basic functionality..."

    # Test script help
    if "$GLAB_FZF_SCRIPT" --help >/dev/null 2>&1; then
        log_success "Help command works"
    else
        log_warning "Help command failed"
    fi

    # Test script version
    if "$GLAB_FZF_SCRIPT" --version >/dev/null 2>&1; then
        log_success "Version command works"
    else
        log_warning "Version command failed"
    fi

    return 0
}

# Create installation script
create_installation_guide() {
    log_info "Creating installation guide..."

    cat > "$SCRIPT_DIR/INSTALL.md" << 'EOF'
# glab-fzf Installation Guide

## Prerequisites

### Required Dependencies
- `bash` (version 4.0+)
- `fzf` (version 0.30.0+) - Install from: https://github.com/junegunn/fzf
- `glab` - GitLab CLI tool - Install from: https://gitlab.com/gitlab-org/cli
- `git` - Git version control
- Standard Unix tools: `awk`, `cut`, `grep`

### Installation Steps

1. **Install fzf**
   ```bash
   # macOS with Homebrew
   brew install fzf

   # Linux with package manager
   sudo apt install fzf  # Ubuntu/Debian
   sudo yum install fzf  # CentOS/RHEL

   # Or install from source
   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
   ~/.fzf/install
   ```

2. **Install glab**
   ```bash
   # macOS with Homebrew
   brew install glab

   # Linux - download from releases
   curl -s https://api.github.com/repos/gitlab-org/cli/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4 | wget -i -
   sudo tar -xzf glab_*_linux_amd64.tar.gz -C /usr/local/bin
   ```

3. **Authenticate glab**
   ```bash
   glab auth login
   ```

4. **Install glab-fzf**
   ```bash
   # Clone this repository
   git clone <repository-url> glab-fzf
   cd glab-fzf

   # Make script executable
   chmod +x gh-glab/gh-glab

   # Add to PATH (optional)
   echo 'export PATH="$PATH:$(pwd)/gh-glab"' >> ~/.bashrc
   source ~/.bashrc
   ```

## Verification

Run the setup script to verify installation:
```bash
./setup-test-environment.sh
```

## Usage

```bash
# Run directly
./gh-glab/gh-glab

# Or if added to PATH
gh-glab

# Specific commands
gh-glab issue      # Browse issues
gh-glab mr         # Browse merge requests
gh-glab pipeline   # Browse pipelines
gh-glab project    # Browse projects
```

## Key Bindings

### Global Keys
- `ctrl-r`: Reload
- `ctrl-o`: Open in browser
- `ctrl-y`: Copy URL
- `alt-?`: Help
- `alt-P`: Toggle preview
- `alt-H`: Toggle hints
- `alt-1` to `alt-9`: Change page size

### Command-Specific Keys
See help (`alt-?`) within each command for specific key bindings.

## Troubleshooting

1. **"Command not found" errors**
   - Ensure all dependencies are installed
   - Check PATH configuration

2. **Authentication issues**
   - Run `glab auth status` to check authentication
   - Re-authenticate with `glab auth login`

3. **No data displayed**
   - Ensure you're in a GitLab project directory
   - Check GitLab remote configuration with `git remote -v`

4. **Key bindings not working**
   - Ensure fzf version is 0.30.0 or higher
   - Check terminal compatibility

For more help, see the project documentation or create an issue.
EOF

    log_success "Installation guide created: $SCRIPT_DIR/INSTALL.md"
}

# Main execution
main() {
    echo "======================================"
    echo "glab-fzf Environment Setup & Validation"
    echo "======================================"
    echo ""

    local exit_code=0

    # Run all checks
    check_dependencies || exit_code=$?
    echo ""

    validate_script || exit_code=$?
    echo ""

    setup_test_data || exit_code=$?
    echo ""

    validate_gitlab_env || exit_code=$?
    echo ""

    test_basic_functionality || exit_code=$?
    echo ""

    create_installation_guide
    echo ""

    # Summary
    echo "======================================"
    echo "ENVIRONMENT VALIDATION SUMMARY"
    echo "======================================"

    case $exit_code in
        0)
            log_success "Environment is fully ready for testing"
            log_info "You can now run: ./run-all-tests.sh"
            ;;
        1)
            log_error "Critical issues found - please fix before testing"
            log_info "See error messages above for details"
            ;;
        2)
            log_warning "Environment has warnings but tests can proceed"
            log_info "You can run tests but some features may not work"
            ;;
    esac

    echo ""
    log_info "Next steps:"
    echo "  1. Run key binding tests: ./run-all-tests.sh"
    echo "  2. Test MR navigation fix: ./test-mr-fix.sh"
    echo "  3. Generate mock data: ./test-data/mock-data-generator.sh"
    echo "  4. Read installation guide: cat INSTALL.md"

    exit $exit_code
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi