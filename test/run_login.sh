#!/bin/sh
# 便捷入口：在仓库根目录运行离线登录程序。
# 用法: bash test/run_login.sh
set -eu

root_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root_dir"

if [ ! -x ./test/portal_login ]; then
    echo "未找到 ./test/portal_login，请先执行: bash test/build_offline.sh" >&2
    exit 1
fi

exec env GD_DEBUG=1 ./test/portal_login test/work/protect-captured.so
