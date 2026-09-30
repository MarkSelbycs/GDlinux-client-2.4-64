# 逆向实施步骤

本文是本项目的协作式逆向计划。目标是从现有 ELF 程序中确认输入、输出、文件、错误码、状态变化和网络边界，最后编写一个行为等价的 C 实现。

## 先说清楚目标

“百分百实现一模一样”需要一个可重复的行为标准，而不是只看反汇编。我们要逐项对比：

- 相同输入是否产生相同输出和退出码
- 相同配置、文件权限和环境下是否访问相同文件
- 相同错误条件下是否返回相同错误
- 状态机、重试、超时和线程行为是否一致
- 协议字段、编码、加密和压缩结果是否一致

可以做到功能和可观察行为尽可能一致，但通常不能恢复原作者的变量名、注释和原始 C/C++ 文件。最终代码应标注为基于观察结果的独立重写，而不是声称是原始源码。

## 你需要提供的材料

请只提供你有权分析的副本和测试数据，不要提供真实账号、密码、令牌、私钥或生产服务器数据。需要的材料按优先级如下：

1. `ESurfingSvr`、`client`、`AutoUpdate` 的原始副本。
2. `conf/` 中不含密码和令牌的配置副本。
3. 你自己写的功能说明：启动参数、正常流程、失败流程、退出码和界面操作。
4. 可在虚拟机中重复的测试账号或离线模拟服务。优先使用假账号和本地服务。
5. 每个测试场景的“输入、实际输出、预期输出”。例如：无参数、错误参数、缺配置、权限不足、网络不可达。
6. 每次样本的 SHA-256，避免我们分析的不是同一个文件。

需要回传给我的内容应优先是命令输出、脱敏日志、反汇编片段和错误信息。敏感字符串可以替换成 `<redacted>`，但要保留长度、分隔符和字段位置。

## 工作规则

- 在虚拟机快照中进行，先创建一个干净快照。
- 不要以 root 运行目标程序；root 只用于安装软件。
- 不运行 `tyxy`，它会修改系统动态库配置。
- 初期不输入真实账号，不连接生产认证服务。
- 先静态分析，再在隔离网络做动态观察。
- 每个结论必须有证据：符号、字符串引用、系统调用、断点值或可重复测试。
- 不修改原始 ELF。复制到 `samples/` 后对副本操作。

## 阶段 0：固定样本

在项目根目录执行：

```sh
mkdir -p test/work samples
cp -p ESurfingSvr client AutoUpdate samples/
cp -pr conf test/work/conf-copy

sha256sum samples/ESurfingSvr samples/client samples/AutoUpdate
file samples/ESurfingSvr samples/client samples/AutoUpdate
uname -a
ldd --version | head -1
```

把上述输出发给我。不要发账号密码和未经脱敏的配置内容。

**通过标准：** 样本路径、架构、哈希和运行环境已经记录。

## 阶段 1：确认 ELF 结构

先分析没有 strip 的 `ESurfingSvr`：

```sh
readelf -h samples/ESurfingSvr
readelf -l samples/ESurfingSvr
readelf -d samples/ESurfingSvr
nm -C --defined-only samples/ESurfingSvr > test/work/ESurfingSvr.symbols.txt
grep -E '(^|::)(main|StartSingle|CPortalServer|CInfoCenter)' \
    test/work/ESurfingSvr.symbols.txt | head -80
```

然后确认导入函数：

```sh
readelf --dyn-syms --wide samples/ESurfingSvr | \
    grep -E 'curl|socket|connect|open|read|write|dlopen|pthread' | head -100
```

把 `grep` 的结果和 `readelf -d` 中的 `NEEDED` 行发给我。不要一次发送整个二进制或完整日志。

**我会完成：** 建立函数分类表，标记启动、配置、网络、日志、线程、加密和压缩入口。

## 阶段 2：提取字符串和配置线索

编译本目录的练习程序：

```sh
gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/elf_strings.c -o test/elf_strings

./test/elf_strings samples/ESurfingSvr 8 > test/work/ESurfingSvr.strings.txt
grep -Ein 'http|https|json|xml|config|login|auth|ticket|error|server|password' \
    test/work/ESurfingSvr.strings.txt | head -100
```

对有意义的字符串记录地址或文件偏移：

```sh
strings -a -t x samples/ESurfingSvr | \
    grep -Ei 'http|json|xml|ticket|error|server' | head -100
```

**注意：** 字符串只能说明程序包含某个文本，不能单独证明控制流程或协议含义。

## 阶段 3：从 main 建立调用链

不启动程序，先看 `main`：

```sh
objdump -d --demangle --disassemble=main samples/ESurfingSvr | \
    tee test/work/main.asm.txt | head -160
```

用 GDB 查看符号和源文件信息：

```sh
gdb -q -batch \
    -ex 'file samples/ESurfingSvr' \
    -ex 'info address main' \
    -ex 'info functions CPortalServer' \
    -ex 'info sources'
```

把 `main` 中调用的第一个本地函数名和 `CPortalServer` 的相关函数列表发给我。下一步我会选择一个最小功能，例如读取配置或打印版本，而不是一开始分析全部拨号流程。

## 阶段 4：建立离线行为基线

先只测试无账号场景：错误参数、无参数、缺少配置、不存在文件和帮助信息。每个场景保存退出码和输出：

```sh
set +e
samples/ESurfingSvr > test/work/no-args.stdout 2> test/work/no-args.stderr
printf 'exit=%s\n' "$?"
set -e

wc -c test/work/no-args.stdout test/work/no-args.stderr
```

如果程序会等待网络或启动拨号，立即停止，不要继续使用真实参数。动态观察只使用本地隔离网络：

```sh
timeout 10s strace -f -o test/work/no-args.strace \
    -e trace=file,network,process samples/ESurfingSvr
```

把 `openat`、`connect`、`execve`、退出信号和错误码行发给我，路径中的用户名和敏感字段先脱敏。

**我会完成：** 将系统调用整理成“输入文件、输出文件、网络边界、进程边界”表。

## 阶段 5：选择第一个可重写功能

第一个重写目标必须满足：

- 可以离线测试
- 有明确输入和输出
- 不依赖真实认证
- 可以用 C 标准库或项目已有的公开依赖实现

候选顺序：

1. 配置文件读取和默认值
2. 命令行参数解析
3. 版本或状态输出
4. 本地日志格式
5. JSON 请求和响应的结构处理
6. 网络连接和重试逻辑

我会在 `test/` 中逐步增加独立 C 文件和测试数据，每完成一个功能就用原程序和重写程序做对照测试。

本轮已经选择并实现第一个离线目标：`test/config_inspect.c`。它对应已确认的 `CXMLOpt::LoadFile`、`GetValue` 和 `GetIntValue` 线索，只读取 `<conf>` 根节点下的 `redirect`、`version`、`disasterUrl`，不发起网络请求。

安装 XML 开发头文件并编译：

```sh
sudo apt-get install -y pkgconf libxml2-dev
gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/config_inspect.c -o test/config_inspect \
    $(pkg-config --cflags --libs libxml-2.0)
./test/config_inspect conf/conf.xml
```

预期会输出三个键值。然后用临时错误输入验证失败路径：

```sh
printf '<wrong></wrong>\n' > test/work/wrong.xml
./test/config_inspect test/work/wrong.xml
printf 'exit=%s\n' "$?"
```

`code.xml` 不能直接交给标准 XML 解析器：部分 value 中含有未转义的 `<`，且部分条目使用了 `id="编号':'提示"` 的历史格式。针对这个已确认的数据格式，新增了 `test/error_lookup.c`，只扫描 `<err>` 条目，不修改原文件，也不执行网络操作：

```sh
gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/error_lookup.c -o test/error_lookup
./test/error_lookup conf/code.xml 140000
./test/error_lookup conf/code.xml 170001.12
```

验收标准是两个错误码都能输出对应文本；如果原程序对异常条目的行为不同，我们会用 GDB 和调用结果继续校正。

## 当前静态分析结果

通过 `CPortalConn::InitPortalConf()` 的反汇编已经确认以下映射。偏移是 `CAuthConfig` 对象内的偏移，不是文件偏移：

| 来源 | 目标偏移 | 证据 |
| --- | ---: | --- |
| `CInfoCenter::GetValue("hostName")` | `0x130` | 随后调用 `CAutoString::operator=` |
| `CInfoCenter::GetValue("clientId")` | `0xc0` | 随后调用 `CAutoString::operator=` |
| `CInfoCenter::GetValue("version")` | `0x140` | 读取后写入版本字符串 |
| 常量 `linux64` | `0xf0` | `CAutoString::operator=` |
| `CCTP/Linux64/%s` | `0xd0` | `CAutoString::Format` |
| `CInfoCenter::GetLocalValue("redirect")` | `0x98` | 空值时不覆盖 |
| `CInfoCenter::GetLocalValue("redirectipv6")` | `0xa8` | 空值时使用 `http://www.baidu.com/` |

尾部还确认了两类不同对象的字段：

| 来源 | 目标偏移 | 归属 |
| --- | ---: | --- |
| `plusInterval`，经过 `atoi` | `0x278` | `CAuthConfig` |
| `plusFlag`，经过 `atoi` | `0x27c` | `CAuthConfig` |
| `schoolId` | `0x200` | `CAuthConfig` |
| `domain` | `0x210` | `CAuthConfig` |
| `area` | `0x220` | `CAuthConfig` |
| `wlanuserip` | `0x230` | `CAuthConfig` |
| `wlanusermac` | `0x240` | `CAuthConfig` |
| `wlanacip` | `0x250` | `CAuthConfig` |
| `disasterUrl` | `0x120` | `CPortalConn` |

`redirect`、`redirectipv6`、`termUrl` 和 `keepUrl` 的部分写入属于 `CPortalConn` 自身，且存在条件分支；它们暂时标记为待确认，避免把同一偏移误判成多个永久字段。

还确认了本地字段 `termUrl`、`keepUrl`、`plusInterval`、`plusFlag` 和 `disasterUrl` 的读取调用。下一步是继续配对它们的目标偏移，并在 C 配置结构体中实现默认值；目前不应把这些字段猜成认证协议字段。

### 本地配置路径规则

`CInfoCenter::GetInst()` 的调试信息和反汇编已经确认：程序先调用 `CSimpleFile::GetModulePath()`，再拼接字符串 `/conf/conf.xml`，最后调用 `LoadLocalValue()` 和 `CXMLOpt::LoadFile()`。因此配置路径相对于可执行文件所在目录，而不是相对于当前 shell 目录：

```text
<模块目录>/conf/conf.xml
```

C 重写程序应显式接收模块目录或配置路径，不能依赖当前工作目录。这个结论已经可以用 `config_inspect.c` 的显式路径参数进行离线测试。

## 阶段 6：对照测试

每个已知场景都记录：

```text
场景：缺少配置文件
输入：参数、环境变量、文件权限
原程序退出码：
原程序 stdout：
原程序 stderr：
重写程序退出码：
重写程序 stdout：
重写程序 stderr：
差异和解释：
```

只有当差异被解释或修复，才能把该功能标为完成。无法观察到的内部实现不应伪装成已经还原。

## 编译完成后怎么做

当前不要启动认证或拨号。编译完成后的实际顺序如下：

### 1. 编译三个离线工具

```sh
gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/elf_strings.c -o test/elf_strings

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/config_inspect.c -o test/config_inspect \
    $(pkg-config --cflags --libs libxml-2.0)

gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/error_lookup.c -o test/error_lookup
```

### 2. 验收离线重写

```sh
./test/config_inspect conf/conf.xml
./test/error_lookup conf/code.xml 140000
./test/error_lookup conf/code.xml 170001.12
```

预期结果是：配置工具输出 `redirect`、`version`、`disasterUrl` 三项；错误码工具分别输出对应提示文本。到这里说明本地配置和错误码两个功能已经可以离线工作。

### 3. 保存静态证据

```sh
mkdir -p test/work
nm -C --defined-only samples/ESurfingSvr > test/work/ESurfingSvr.symbols.txt
objdump -d --demangle \
    --start-address=0x4188f4 \
    --stop-address=0x4192c0 \
    samples/ESurfingSvr > test/work/InitPortalConf.asm
```

接下来我会继续完成 `InfoCenter`、`CAuthConfig`、运行时配置和本地 mock 服务。你只需要把编译错误或验收输出发给我，不需要自行猜下一条逆向命令。

### 4. 什么时候才拨号

只有当本地重写和 mock 服务完成，并且我明确写出“进入动态验证”后，才启动原程序。拨号阶段用于验证真实认证请求、ticket、状态变化、超时和下线行为；它不是当前编译完成后的下一步。

## 现在执行的第一组命令

你已经安装了 GCC、GDB、radare2 和 strace。现在先执行阶段 0 的命令，再执行：

```sh
gcc -std=c11 -Wall -Wextra -Wpedantic -O0 -g \
    test/elf_strings.c -o test/elf_strings
./test/elf_strings samples/ESurfingSvr 8 | head -30
```

这些基础信息已经完成并记录。现在请优先执行“编译完成后怎么做”中的第 1、2 步；后续分析会基于实际输出继续推进。