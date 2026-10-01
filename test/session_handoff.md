# GDlinux-client reverse-engineering handoff

Date: 2026-10-01

## Goal

Analyze authorized ELF copies and build a clean-room, offline,
behavior-equivalent implementation. Do not claim to recover the original
source code.

## Safety boundaries

- Use a disposable VM or sandbox; do not run as root.
- Do not enter real accounts, passwords, tokens, private keys, or production data.
- Do not run `tyxy`.
- Do not run the original binaries from the project root: `ESurfingSvr` writes
  to `conf/conf.xml`, creates `Log/`, and creates a FIFO named `serverpipe`.
- Prefer local files and an offline mock service.

## Current state

- `ESurfingSvr` is x86-64, not stripped, and contains debug information.
- `client` is x86-64 and stripped.
- `AutoUpdate` is x86-64, not stripped, and contains debug information.
- `test/config_inspect.c`, `test/error_lookup.c`, and `test/elf_strings.c` build
  and run. `test/config_model.c` is the new offline default-value model.
- `lib/` contains an older bundled runtime. Do not put its library path around
  host tools such as `strace`; use the matching loader in a sandbox.

## Completed findings

`CPortalConn::InitPortalConf()` confirmed these mappings:

| Source | Observed destination |
| --- | ---: |
| `hostName` | `CAuthConfig + 0x130` |
| `clientId` | `CAuthConfig + 0xc0` |
| `version` | `CAuthConfig + 0x140` |
| `linux64` | `CAuthConfig + 0xf0` |
| `CCTP/Linux64/%s` | `CAuthConfig + 0xd0` |
| `redirect` | connection object `+0x98` |
| `redirectipv6` | connection object `+0xa8` |
| `plusInterval` via `atoi` | `CAuthConfig + 0x278` |
| `plusFlag` via `atoi` | `CAuthConfig + 0x27c` |
| `schoolId` | `CAuthConfig + 0x200` |
| `domain` | `CAuthConfig + 0x210` |
| `area` | `CAuthConfig + 0x220` |
| `wlanuserip` | `CAuthConfig + 0x230` |
| `wlanusermac` | `CAuthConfig + 0x240` |
| `wlanacip` | `CAuthConfig + 0x250` |
| `disasterUrl` | connection object `+0x120` |

`redirectipv6` is observed to default to `http://www.baidu.com/` when missing
or empty. `atoi` behavior is modeled as: invalid or missing text becomes `0`,
while negative values are preserved.

## Dynamic observation

Using the bundled loader in a controlled run showed that the program:

- opens `conf/conf.xml` with truncation and writes `clientId` and `PID`
- creates `Log/20261001_Info.log`
- creates and opens the `serverpipe` FIFO
- blocks on the FIFO before any observed `connect`

The original `conf/conf.xml` was restored from `test/work/conf-copy/conf.xml`.
Do not run the original binary from the project root again.

## Next safe step on Ubuntu

Use a sandbox copy:

```sh
mkdir -p test/work/runtime
cp samples/ESurfingSvr test/work/runtime/
cp -pr conf test/work/runtime/
cp -p lib/ld-linux-x86-64.so.2 test/work/runtime/
chmod +x test/work/runtime/ld-linux-x86-64.so.2
```

The next implementation target is an offline model for startup configuration
writes and FIFO state, not authentication.

## Build dependencies

```sh
sudo apt-get install -y pkgconf libxml2-dev
```

Build with:

```sh
gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
  test/config_inspect.c -o test/config_inspect \
  $(pkg-config --cflags --libs libxml-2.0)
gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
  test/config_model.c -o test/config_model \
  $(pkg-config --cflags --libs libxml-2.0)
```

## Continuing on Windows

Provide this file first, then say:

> Continue from this handoff. Keep the analysis offline and sandboxed. Tell me
> the next safe command, and do not ask me to run the original binary from the
> project root.

Do not upload passwords, tokens, private keys, or complete sensitive configs.