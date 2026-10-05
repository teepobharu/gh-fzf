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
