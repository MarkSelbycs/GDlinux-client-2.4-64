#!/bin/sh
# 在 ARM 设备上用 qemu-user 运行工作区里现成的 x86-64 版本。
# 这是 ARM 上"立刻可用"的方案：不需要复刻 protect.so。
#
# 前提: 安装 qemu 用户态模拟器
#   Debian/Ubuntu/Armbian:  sudo apt install -y qemu-user-static
#   OpenWrt:                 opkg install qemu-x86_64   (若仓库提供)
#
# 用法:
#   sh run-via-qemu.sh                 # 登录（交互输入账号、密码）
#   sh run-via-qemu.sh --state         # 查询状态
#   sh run-via-qemu.sh --keep          # 登录并保活
#   sh run-via-qemu.sh --logout        # 注销
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
root=$(CDPATH= cd -- "$here/.." && pwd)
x86_dir="$root/final"
glibc_dir="$root/lib"

qemu=""
for candidate in qemu-x86_64 qemu-x86_64-static /usr/libexec/qemu-binfmt/x86_64-binfmt-P; do
    if command -v "$candidate" >/dev/null 2>&1; then
        qemu=$(command -v "$candidate")
        break
    fi
done
if [ -z "$qemu" ]; then
    echo "未找到 qemu-x86_64：请先安装 qemu-user-static" >&2
    exit 1
fi

if [ ! -x "$x86_dir/portal_login" ]; then
    echo "缺少 $x86_dir/portal_login，请先在 final/ 执行 sh build.sh" >&2
    exit 1
fi
if [ ! -d "$glibc_dir" ]; then
    echo "缺少 $glibc_dir（工作区自带的 glibc），无法运行 x86-64 二进制" >&2
    exit 1
fi

cd "$x86_dir"
echo "qemu     = $qemu"
echo "glibc    = $glibc_dir"
echo "程序     = $x86_dir/portal_login"
echo

exec "$qemu" -L "$glibc_dir" -E LD_LIBRARY_PATH="$glibc_dir" \
    ./portal_login ./protect.so "$@"
