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
    test/update_info_model.c -o test/update_info_model \
    $(pkg-config --cflags --libs libxml-2.0)

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/update_record_model.c -o test/update_record_model \
    $(pkg-config --cflags --libs libxml-2.0)

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/update_copy_model.c -o test/update_copy_model

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/algoid_update_model.c -o test/algoid_update_model

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/unknown_net_model.c -o test/unknown_net_model

gcc -std=c11 -Wall -Wextra -Wpedantic -fPIC -shared -O0 -g \
    test/capture_protect.c -o test/libcapture_protect.so -ldl

gcc -std=c11 -Wall -Wextra -Wpedantic -fPIC -shared -O0 -g \
    test/capture_http.c -o test/libcapture_http.so -ldl

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/zsm_codec_model.c -o test/zsm_codec_model -ldl

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/portal_auth_model.c -o test/portal_auth_model \
    $(pkg-config --cflags --libs libxml-2.0)

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/portal_login.c -o test/portal_login \
    $(pkg-config --cflags --libs libxml-2.0) -ldl

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/error_lookup.c -o test/error_lookup

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/pipe_message_inspect.c -o test/pipe_message_inspect \
    $(pkg-config --cflags --libs libxml-2.0)

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/startup_model.c -o test/startup_model \
    $(pkg-config --cflags --libs libxml-2.0)

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/portal_message_model.c -o test/portal_message_model \
    $(pkg-config --cflags --libs libxml-2.0)

./test/config_inspect conf/conf.xml > test/work/config-inspect.out
./test/config_model conf/conf.xml > test/work/config-model.out
grep -q '^redirect=' test/work/config-model.out
grep -q '^redirectipv6=http://www.baidu.com/$' test/work/config-model.out
grep -q '^plusInterval=0$' test/work/config-model.out
grep -q '^plusFlag=0$' test/work/config-model.out

cat > test/work/update-param.xml <<'EOF'
<conf>
    <version>2.4.64</version>
    <updateInstId>test-installer</updateInstId>
    <decompressDir>/tmp/gd-decompress</decompressDir>
    <updateDir>/tmp/gd-update</updateDir>
    <mainProgram>client</mainProgram>
    <mainProgramWnd>GDClient</mainProgramWnd>
    <mainProgramId>gdlinux-client</mainProgramId>
    <backupPath>/tmp/gd-backup</backupPath>
    <recordFile>/tmp/gd-record.xml</recordFile>
    <updateType>3</updateType>
    <downloadDir>/tmp/gd-download</downloadDir>
    <imgDir>/tmp/gd-images</imgDir>
</conf>
EOF
./test/update_info_model test/work/update-param.xml \
        > test/work/update-info-model.out
grep -q '^version=2.4.64$' test/work/update-info-model.out
grep -q '^updateInstId=test-installer$' test/work/update-info-model.out
grep -q '^updateType=3$' test/work/update-info-model.out

rm -f test/work/Install-model.xml
./test/update_record_model record test/work/Install-model.xml \
    2.4.64 client 2026-10-02T00:00:00 1
./test/update_record_model is-updated test/work/Install-model.xml \
    2.4.64 client > test/work/update-record-model.out
grep -q '^is-updated=1$' test/work/update-record-model.out
./test/update_record_model record test/work/Install-model.xml \
    2.4.64 client 2026-10-02T01:00:00 2
test "$(grep -c '<pack ' test/work/Install-model.xml)" -eq 1
grep -q 'time="2026-10-02T01:00:00"' test/work/Install-model.xml
grep -q 'state="2"' test/work/Install-model.xml

rm -rf test/work/update-copy
mkdir -p test/work/update-copy/update test/work/update-copy/decompress \
    test/work/update-copy/backup
printf 'decompressed-dll' > test/work/update-copy/decompress/AutoUpdate.dll
./test/update_copy_model copy \
    test/work/update-copy/update \
    test/work/update-copy/decompress \
    test/work/update-copy/backup > test/work/update-copy-model.out
grep -q '^copy-update=1$' test/work/update-copy-model.out
grep -q '^decompressed-dll$' test/work/update-copy/backup/AutoUpdate.dll
printf 'updated-dll' > test/work/update-copy/update/AutoUpdate.dll
./test/update_copy_model copy \
    test/work/update-copy/update \
    test/work/update-copy/decompress \
    test/work/update-copy/backup > test/work/update-copy-preferred.out
grep -q '^copy-update=1$' test/work/update-copy-preferred.out
grep -q '^updated-dll$' test/work/update-copy/backup/AutoUpdate.dll

rm -f test/work/algoid-update.zsm
./test/algoid_update_model test/work/algoid-update.zsm response-bytes 1 \
    > test/work/algoid-update-model.out
grep -q '^update-result=1$' test/work/algoid-update-model.out
grep -q '^response-bytes$' test/work/algoid-update.zsm
./test/algoid_update_model test/work/algoid-update.zsm ignored 0 \
    > test/work/algoid-update-null.out
grep -q '^update-result=0$' test/work/algoid-update-null.out

if ./test/algoid_update_model test/work/missing/algoid.zsm payload 1 \
    > test/work/algoid-update-fail.out 2>/dev/null; then
    echo "应拒绝写入不存在的目录" >&2
    exit 1
fi

./test/unknown_net_model 1 1 0 599 > test/work/unknown-net-before-check.out
grep -q '^active=1$' test/work/unknown-net-before-check.out
./test/unknown_net_model 1 1 1 601 > test/work/unknown-net-success.out
grep -q '^active=0$' test/work/unknown-net-success.out
./test/unknown_net_model 1 1 0 601 > test/work/unknown-net-retry.out
grep -q '^active=1$' test/work/unknown-net-retry.out
./test/unknown_net_model 1 0 1 1 > test/work/unknown-net-no-connection.out
grep -q '^active=0$' test/work/unknown-net-no-connection.out

if test -f test/work/protect-captured.so; then
    ./test/portal_auth_model fixture-agent fixture-client fixture-user \
        'fixture-pass' fixture-ticket > test/work/portal-auth-model.xml
    grep -q '<user-agent>fixture-agent</user-agent>' \
        test/work/portal-auth-model.xml
    grep -q '<passwd>fixture-pass</passwd>' test/work/portal-auth-model.xml
    ./test/zsm_codec_model test/work/protect-captured.so code \
        '<request><user>fixture</user></request>' \
        > test/work/zsm-code-model.out
    test -s test/work/zsm-code-model.out
fi

cp conf/conf.xml test/work/startup-model-conf.xml
./test/startup_model --config test/work/startup-model-conf.xml test-client 12345
grep -q '<clientId>test-client</clientId>' test/work/startup-model-conf.xml
grep -q '<PID>12345</PID>' test/work/startup-model-conf.xml

rm -f test/work/startup-model.pipe
./test/startup_model --fifo test/work/startup-model.pipe
test -p test/work/startup-model.pipe
rm -f test/work/startup-model.pipe

./test/portal_message_model ClientStart 1 test-user test-password \
    > test/work/portal-connect.xml
printf '%s\0' "$(cat test/work/portal-connect.xml)" \
    > test/work/portal-connect.messages
./test/pipe_message_inspect test/work/portal-connect.messages \
    > test/work/portal-connect.inspect
grep -q 'OpC=PortalConnect' test/work/portal-connect.inspect
grep -q '<user>test-user</user>' test/work/portal-connect.xml
grep -q '<password>test-password</password>' test/work/portal-connect.xml

./test/error_lookup conf/code.xml 140000 > test/work/error-140000.out
./test/error_lookup conf/code.xml 170001.12 > test/work/error-170001.12.out

echo "离线构建和验收通过"
printf '%s\n' "配置模型: test/work/config-model.out"
printf '%s\n' "错误码: test/work/error-140000.out test/work/error-170001.12.out"
