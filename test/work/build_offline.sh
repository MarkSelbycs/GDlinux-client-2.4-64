#!/bin/sh
set -eu

root_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root_dir"

command -v gcc >/dev/null 2>&1 || {
    echo "缺少 gcc，请先安装 build-essential" >&2
    exit 1
}
command -v pkg-config >/dev/null 2>&1 || {
    echo "缺少 pkg-config，请先安装 pkg-config" >&2
    exit 1
}
pkg-config --exists libxml-2.0 || {
    echo "缺少 libxml2 开发包，请先安装 libxml2-dev" >&2
    exit 1
}

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/elf_strings.c -o test/elf_strings

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/config_inspect.c -o test/config_inspect \
    $(pkg-config --cflags --libs libxml-2.0)

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/config_model.c -o test/config_model \
    $(pkg-config --cflags --libs libxml-2.0)

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/error_lookup.c -o test/error_lookup

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/pipe_message_inspect.c -o test/pipe_message_inspect \
    $(pkg-config --cflags --libs libxml-2.0)

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/startup_model.c -o test/startup_model \
    $(pkg-config --cflags --libs libxml-2.0)

./test/config_inspect conf/conf.xml > test/work/config-inspect.out
./test/config_model conf/conf.xml > test/work/config-model.out
grep -q '^redirect=' test/work/config-model.out
grep -q '^redirectipv6=http://www.baidu.com/$' test/work/config-model.out
grep -q '^plusInterval=0$' test/work/config-model.out
grep -q '^plusFlag=0$' test/work/config-model.out

cp conf/conf.xml test/work/startup-model-conf.xml
./test/startup_model --config test/work/startup-model-conf.xml test-client 12345
grep -q '<clientId>test-client</clientId>' test/work/startup-model-conf.xml
grep -q '<PID>12345</PID>' test/work/startup-model-conf.xml

rm -f test/work/startup-model.pipe
./test/startup_model --fifo test/work/startup-model.pipe
test -p test/work/startup-model.pipe
rm -f test/work/startup-model.pipe

./test/error_lookup conf/code.xml 140000 > test/work/error-140000.out
./test/error_lookup conf/code.xml 170001.12 > test/work/error-170001.12.out

echo "离线构建和验收通过"
printf '%s\n' "配置模型: test/work/config-model.out"
printf '%s\n' "错误码: test/work/error-140000.out test/work/error-170001.12.out"
