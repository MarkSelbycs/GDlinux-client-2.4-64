#!/bin/sh
# ARM 构建脚本：在本机 ARM 或交叉编译环境构建 portal_login
# 用法:
#   sh build.sh                                # 自动选择编译器
#   CC=aarch64-linux-gnu-gcc sh build.sh       # 指定交叉编译器
#   XML_CFLAGS=... XML_LIBS=... sh build.sh    # 交叉编译时指定 libxml2
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$here"

if [ -n "${CC:-}" ]; then
    cc="$CC"
elif command -v aarch64-linux-gnu-gcc >/dev/null 2>&1; then
    cc=aarch64-linux-gnu-gcc
elif command -v arm-linux-gnueabihf-gcc >/dev/null 2>&1; then
    cc=arm-linux-gnueabihf-gcc
else
    cc=gcc
fi

if [ -n "${XML_CFLAGS:-}" ] || [ -n "${XML_LIBS:-}" ]; then
    xml_cflags="${XML_CFLAGS:-}"
    xml_libs="${XML_LIBS:-}"
elif pkg-config --exists libxml-2.0 2>/dev/null; then
    xml_cflags=$(pkg-config --cflags libxml-2.0)
    xml_libs=$(pkg-config --libs libxml-2.0)
else
    xml_cflags=""
    xml_libs="-lxml2"
fi

target=$("$cc" -dumpmachine 2>/dev/null || echo unknown)
echo "CC  = $cc"
echo "目标 = $target"

# shellcheck disable=SC2086
"$cc" -std=c11 -O2 -Wall -Wextra -o portal_login src/portal_login.c \
    $xml_cflags $xml_libs -ldl

echo "构建完成: $here/portal_login"
if command -v file >/dev/null 2>&1; then
    file portal_login
fi
echo
echo "注意: 运行时还需要与目标架构匹配的 protect.so（见 README 第 4 节）。"
