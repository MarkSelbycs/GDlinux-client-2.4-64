#!/usr/bin/env python3
"""Run portal_login under a pseudo-terminal feeding a throwaway password.

This exists only so the interactive getpass() prompt can be satisfied during
offline verification. The password is a fixture and is never real.
"""
import os
import pty
import select
import subprocess
import sys
import time

command = sys.argv[1:]
if not command:
    command = ["./test/portal_login", "test/work/protect-captured.so", "fixtureuser"]

master, slave = pty.openpty()
environment = dict(os.environ)
environment["GD_DEBUG"] = environment.get("GD_DEBUG", "1")
process = subprocess.Popen(command, stdin=slave, stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE, env=environment, close_fds=True)
os.close(slave)
sent = False
output = b""
deadline = time.time() + 45
while time.time() < deadline:
    ready, _, _ = select.select([master, process.stdout, process.stderr], [], [], 0.5)
    for stream in ready:
        if stream is master:
            try:
                data = os.read(master, 4096)
            except OSError:
                data = b""
        else:
            data = stream.read1(4096) if hasattr(stream, "read1") else stream.read(4096)
        output += data
    if not sent and b"assword" in output:
        os.write(master, b"fixturepass\n")
        sent = True
    if process.poll() is not None:
        break
remainder = process.communicate(timeout=5)[0] or b""
output += remainder or b""
os.close(master)
text = output.decode("utf-8", "replace")
for line in text.splitlines():
    if line.startswith(("debug=", "state=", "detail=")) or "assword" in line:
        print(line)
print("exit=%d" % process.returncode)
