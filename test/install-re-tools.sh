#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    exec sudo "$0" "$@"
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update

# Core C build and ELF inspection tools.
apt-get install -y \
    build-essential binutils gdb file \
    strace ltrace lsof valgrind \
    xxd tmux jq python3 python3-pip \
    openjdk-21-jdk pkgconf libxml2-dev

# These are useful when available in the enabled Ubuntu repositories.
for package in radare2 ghidra; do
    if apt-cache show "$package" >/dev/null 2>&1; then
        apt-get install -y "$package"
    else
        printf '跳过仓库中不可用的可选包: %s\n' "$package"
    fi
done

printf '\n工具安装完成。版本检查:\n'
gcc --version | head -1
gdb --version | head -1
readelf --version | head -1
strace --version | head -1
java -version 2>&1 | head -1