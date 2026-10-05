#!/usr/bin/env python3
"""Exercise actual fzf argument parsing without running keybinding actions."""
from pathlib import Path
import os
import re
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "gh-fzf"


def function(text, name):
    match = re.search(r"^" + re.escape(name) + r"\(\) \{", text, re.M)
    assert match, name
    tail = text[match.start():]
    end = re.search(r"^}[^\n]*(?:\n|$)", tail, re.M)
    return tail[:end.end()]


class Bindings(unittest.TestCase):
    def capture(self, command, overrides=""):
        text = SCRIPT.read_text()
        names = ["setup_repo_keybindings", "get_repo_action_bindings", "get_repo_sort_bindings", "repo_cmd", "search_cmd"]
        definitions = "\n".join(function(text, name) for name in names)
        defaults = """
GH_COLUMNS=80
GH_FZF_DEFAULT_LIMIT=50
GH_FZF_OPEN_KEY=ctrl-o
GH_FZF_COPY_KEY=ctrl-y
GH_FZF_RELOAD_KEY=ctrl-r
GH_FZF_HELP_KEY=alt-?
GH_FZF_COPY_CMD=cat
requires_fzf_version() { :; }
fzf() { printf '%s\\0' "$@"; }
"""
        env = {key: value for key, value in os.environ.items() if not key.startswith(("FZF_", "GH_FZF_"))}
        with tempfile.TemporaryDirectory(prefix="gh-fzf-bindings-") as temp:
            env["TMPDIR"] = temp
            run = subprocess.run(["bash", "--noprofile", "--norc"], input=(definitions + defaults + overrides + "\n" + command + "\n").encode(), capture_output=True, env=env, timeout=10)
        self.assertEqual(run.returncode, 0, run.stderr.decode())
        args = [item.decode() for item in run.stdout.split(b"\0") if item]
        self.assertTrue(args)
        parsed = subprocess.run([shutil.which("fzf") or "fzf", "--filter=unused", *args], input=b"", capture_output=True, env=env, timeout=10)
        self.assertIn(parsed.returncode, (0, 1), parsed.stderr.decode())
        return args

    def test_repo_actions(self):
        args = self.capture("repo_cmd")
        self.assertTrue(any(arg.startswith("--bind=alt-C:execute(") and "gh repo clone {1}" in arg for arg in args))
        self.assertTrue(any(arg.startswith("--bind=enter:execute(") and "gh repo edit {1}" in arg for arg in args))

    def test_repo_search_actions_and_query(self):
        args = self.capture('search_cmd repos "query with spaces"')
        self.assertIn("--query=query with spaces", args)
        self.assertTrue(any(arg.startswith("--bind=alt-C:execute(") and "gh repo clone {1}" in arg for arg in args))
        self.assertTrue(any(arg.startswith("--bind=alt-s:reload-sync(") and "gh search repos" in arg and "--sort=stars" in arg for arg in args))

    def test_custom_repo_keys(self):
        args = self.capture("repo_cmd", "GH_FZF_REPO_CLONE_KEY=ctrl-k")
        self.assertTrue(any(arg.startswith("--bind=ctrl-k:execute(") for arg in args))

    def test_other_search_commands(self):
        for command in ("issues", "prs", "commits", "code"):
            with self.subTest(command=command):
                self.capture("search_cmd " + command + " example")

    def test_bash_syntax(self):
        parsed = subprocess.run(["bash", "--noprofile", "--norc", "-n", str(SCRIPT)], capture_output=True)
        self.assertEqual(parsed.returncode, 0, parsed.stderr.decode())


if __name__ == "__main__":
    unittest.main(verbosity=2)
