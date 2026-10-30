"""Run with: python3 modules/shared/programs/gpg/test_shell_init.py RENDERED_INIT.zsh"""

import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
import tempfile


source = Path(sys.argv[1]).read_text()
source = source[source.index("_personal_ssh_agent_socket=") :].split("\nbwlogin()", 1)[0]

with tempfile.TemporaryDirectory(prefix="ssh-shell-init-") as directory:
    root = Path(directory)
    stub = root / "ssh-add"
    stub.write_text(
        f"#!{sys.executable}\n"
        "import json, os, sys\n"
        "from pathlib import Path\n"
        "args = sys.argv[1:]\n"
        "require = os.environ.get('SSH_ASKPASS_REQUIRE')\n"
        "askpass = os.environ.get('SSH_ASKPASS')\n"
        "with Path(os.environ['TEST_LOG']).open('a') as log:\n"
        "    log.write(json.dumps(dict(args=args, require=require, askpass=askpass)) + '\\n')\n"
        "if args == ['-l']:\n"
        "    sys.exit(0)\n"
        "if args[0] == '-T':\n"
        "    sys.exit(0 if os.environ['TEST_CASE'] == 'loaded' else 1)\n"
        "if '--apple-use-keychain' in args:\n"
        "    if require == 'force' and askpass == '/usr/bin/false':\n"
        "        sys.exit(0 if os.environ['TEST_CASE'] == 'cached' else 1)\n"
        "    sys.exit(0)\n"
        "sys.exit(2)\n"
    )
    stub.chmod(0o700)
    source = re.sub(
        r"/(?:nix/store/[^\s]+/bin|usr/bin)/ssh-add", shlex.quote(str(stub)), source
    )
    socket = str(root / "agent.sock")
    source = re.sub(
        r"_personal_ssh_agent_socket='[^']*'",
        "_personal_ssh_agent_socket=" + shlex.quote(socket),
        source,
        count=1,
    )

    for case in ("loaded", "missing", "cached", "manual", "remote"):
        log = root / f"{case}.jsonl"
        env = dict(os.environ)
        for name in ("SSH_CONNECTION", "SSH_AUTH_SOCK", "SSH_ASKPASS", "SSH_ASKPASS_REQUIRE"):
            env.pop(name, None)
        env.update(TEST_LOG=str(log), TEST_CASE=case, SSH_AUTH_SOCK="forwarded.sock")
        if case == "remote":
            env["SSH_CONNECTION"] = "192.0.2.1 1234 192.0.2.2 22"
        expected_socket = "forwarded.sock" if case == "remote" else socket
        checks = (
            '\n[[ -z "${SSH_ASKPASS+x}" && -z "${SSH_ASKPASS_REQUIRE+x}" ]] || exit 90\n'
            f'[[ "$SSH_AUTH_SOCK" == {shlex.quote(expected_socket)} ]] || exit 91\n'
        )
        if case == "manual":
            checks += "ssh-personal-load\n"
        result = subprocess.run(
            ["/bin/zsh", "-f", "-c", source + checks],
            env=env,
            stdin=subprocess.DEVNULL,
            capture_output=True,
            text=True,
            timeout=10,
        )
        assert result.returncode == 0, (case, result.returncode, result.stderr)
        calls = [json.loads(line) for line in log.read_text().splitlines()] if log.exists() else []
        loads = [call for call in calls if "--apple-use-keychain" in call["args"]]
        if case in ("loaded", "remote"):
            assert not loads, (case, "unexpected key reload", loads)
            if case == "remote":
                assert not calls, calls
        else:
            assert len(loads) == (2 if case == "manual" else 1), (case, loads)
            assert loads[0]["require"] == "force", (case, loads)
            assert loads[0]["askpass"] == "/usr/bin/false", (case, loads)
            if case == "manual":
                assert loads[1]["require"] is None and loads[1]["askpass"] is None, loads
        print(f"PASS {case}")
