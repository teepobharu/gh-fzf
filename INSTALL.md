# glab-fzf installation

Install Bash, Git, glab and fzf using your package manager. Python 3 is required
only for the offline regression checks. Authenticate using `glab auth login`
before interactive use.

## Standalone launcher

```bash
git clone --branch codex/glab-fzf-wip https://github.com/teepobharu/gh-fzf.git glab-fzf
cd glab-fzf
./glab-fzf project
```

The root launcher forwards arguments to `gh-glab/gh-glab`. Run either
entrypoint from a GitLab project checkout, or supply the relevant glab repository
flags. You can add the clone directory to PATH to use `glab-fzf` elsewhere.

## Optional local GitHub CLI extension

To use `gh glab`, install from the implementation directory:

```bash
cd gh-glab
gh extension install .
gh glab project
```

This is a local extension, so retain its checkout. It continues to call glab for
GitLab operations.

## Offline checks

```bash
python3 tests/test-project-bindings.py
```

The checks validate fzf binding arguments, project selection parsing and launcher
argument forwarding. They use synthetic examples and mocked command execution;
they do not prove live GitLab action compatibility.
