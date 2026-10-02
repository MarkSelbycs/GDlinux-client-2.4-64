#!/bin/sh
# 打印目标平台与依赖情况，用来判断这个 ARM 版本能否真正跑起来
set -u

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$here"

echo "架构     : $(uname -m)"
echo "内核     : $(uname -sr)"

libc=$(ldd --version 2>/dev/null | head -1)
if [ -z "${libc:-}" ]; then
    libc="(没有 ldd —— 很可能是 musl / 静态系统)"
fi
echo "libc     : $libc"

musl=""
for candidate in /lib/ld-musl-*.so.1; do
    if [ -e "$candidate" ]; then
        musl="$candidate"
    fi
done
if [ -n "$musl" ]; then
    echo "          检测到 musl 运行时: $musl"
fi

echo
for lib in libxml2.so.2 libc.so.6 libdl.so.2; do
    found=""
    for dir in /lib /usr/lib /lib64 /usr/lib64 /usr/local/lib; do
        for candidate in "$dir/$lib" "$dir"/*/"$lib"; do
            if [ -e "$candidate" ]; then
                found="$candidate"
                break
            fi
        done
        if [ -n "$found" ]; then
            break
        fi
    done
    if [ -n "$found" ]; then
        echo "$lib : 已找到 ($found)"
    else
        echo "$lib : 缺失"
    fi
done

echo
if [ -f ./protect.so ]; then
    echo "protect.so: 已存在"
    file ./protect.so 2>/dev/null | sed 's/^/            /'
else
    echo "protect.so: 缺失 —— 这是 ARM 版本唯一缺的东西"
    echo "            它必须与本机架构匹配（原版只提供 x86-64）"
    echo "            临时替代方案: sh run-via-qemu.sh"
fi
