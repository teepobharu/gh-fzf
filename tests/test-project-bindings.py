#!/usr/bin/env python3
# Validate project bindings with mocked commands and tabbed selections.
from pathlib import Path
import os
import re
import shlex
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "gh-glab" / "gh-glab"
ENV = {key: value for key, value in os.environ.items() if not key.startswith(("FZF_", "GLAB_FZF_"))}


def project_function():
    text = SCRIPT.read_text()
    start = re.search(r"^project_cmd\(\) \{", text, re.M).start()
    tail = text[start:]
    end = re.search(r"^}[^\n]*(?:\n|$)", tail, re.M).end()
    return tail[:end].replace('script_path="${BASH_SOURCE[0]}"', 'script_path=mock_launcher')


def capture():
    program = project_function() + r'''
GLAB_FZF_DEFAULT_LIMIT=50
GLAB_FZF_OPEN_KEY=ctrl-o
GLAB_FZF_COPY_KEY=ctrl-y
GLAB_FZF_HELP_KEY=alt-?
GLAB_FZF_COPY_CMD=cat
fzf() { printf '%s\0' "$@"; }
project_cmd
'''
    run = subprocess.run(["bash", "--noprofile", "--norc"], input=program.encode(), capture_output=True, env=ENV, timeout=10)
    if run.returncode:
        raise AssertionError(run.stderr.decode())
    return [part.decode() for part in run.stdout.split(b"\0") if part]


def action_command(arg):
    if arg.startswith("--preview="):
        return arg[len("--preview="):]
    match = re.search(r":execute(?:-silent)?\((.*)\)\+refresh-preview$", arg, re.S)
    return match.group(1) if match else None


def run_action(command, selection):
    mocks = r'''
glab() { printf '%s\0' "$@" >&2; printf '%s\n' 'https://gitlab.example.com/example/project'; }
mock_launcher() { printf '%s\0' "$@" >&2; }
'''
    replaced = command.replace("{1}", shlex.quote(selection))
    run = subprocess.run(["bash", "--noprofile", "--norc"], input=(mocks + replaced + "\nwait\n").encode(), capture_output=True, env=ENV, timeout=10)
    return run.returncode, [part.decode() for part in run.stderr.split(b"\0") if part]


class ProjectBindings(unittest.TestCase):
    def test_fzf_argument_parsing(self):
        args = capture()
        run = subprocess.run([shutil.which("fzf") or "fzf", "--filter=unused", *args], input=b"", capture_output=True, env=ENV, timeout=10)
        self.assertIn(run.returncode, (0, 1), run.stderr.decode())

    def test_preview_handles_tabbed_and_nested_projects(self):
        command = next(action_command(arg) for arg in capture() if arg.startswith("--preview="))
        for path in ("example/project", "team/subgroup/project-name", "owner/repo"):
            for selection in (path, path + "\tDescription with spaces\thttps://gitlab.example.com/" + path):
                with self.subTest(selection=selection):
                    code, args = run_action(command, selection)
                    self.assertEqual(code, 0)
                    self.assertEqual(args, ["repo", "view", path])

    def test_project_actions_keep_repository_path(self):
        path = "team/subgroup/project-name"
        selection = path + "\tDescription\tgit@gitlab.example.com:" + path + ".git"
        tested = 0
        for arg in capture():
            command = action_command(arg)
            if not command or not arg.startswith("--bind="):
                continue
            with self.subTest(binding=arg):
                code, args = run_action(command, selection)
                self.assertEqual(code, 0)
                self.assertIn(path, args)
                self.assertNotIn(selection, args)
                tested += 1
        self.assertEqual(tested, 8)

    def test_launcher_forwards_arguments(self):
        with tempfile.TemporaryDirectory(prefix="glab-fzf-launcher-") as temp:
            root = Path(temp)
            wrapper = root / "glab-fzf"
            wrapper.write_bytes((ROOT / "glab-fzf").read_bytes())
            implementation = root / "gh-glab" / "gh-glab"
            implementation.parent.mkdir()
            implementation.write_text("#!/usr/bin/env bash\nprintf '%s\\0' \"$@\"\n")
            implementation.chmod(0o755)
            run = subprocess.run(["bash", str(wrapper), "mr", "--repo", "example/project"], capture_output=True, env=ENV, timeout=10)
            self.assertEqual(run.returncode, 0, run.stderr.decode())
            self.assertEqual(run.stdout.split(b"\0")[:-1], [b"mr", b"--repo", b"example/project"])

    def test_bash_syntax(self):
        for script in (SCRIPT, ROOT / "glab-fzf"):
            run = subprocess.run(["bash", "--noprofile", "--norc", "-n", str(script)], capture_output=True)
            self.assertEqual(run.returncode, 0, run.stderr.decode())


if __name__ == "__main__":
    unittest.main(verbosity=2)
