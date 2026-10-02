#!/bin/sh
# 注销脚本：发送 term.cgi 退出登录（工作区根目录版）
# 用法: sh test/logout.sh
set -eu

root_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root_dir"

if [ ! -x ./test/portal_login ]; then
    echo "未找到 ./test/portal_login，请先执行: bash test/build_offline.sh" >&2
    exit 1
fi

exec env GD_DEBUG="${GD_DEBUG:-1}" ./test/portal_login --logout test/work/protect-captured.so
