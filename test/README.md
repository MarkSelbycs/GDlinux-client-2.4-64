# 逆向学习练习 1：从 ELF 提取字符串

本目录中的 `elf_strings.c` 是一个独立的 C 练习程序。它不执行目标程序，只按字节读取 ELF 文件，把连续的可打印字符输出出来。

## 编译和运行

在项目根目录执行：

```sh
cc -std=c11 -Wall -Wextra -Wpedantic -O0 -g test/elf_strings.c -o test/elf_strings
./test/elf_strings ./ESurfingSvr 8
```

也可以分析 `./client`。输出里常见的库名、函数名、错误文本、URL 片段和配置键，是后续定位代码的线索，不等于完整源码。

## 本项目的推荐步骤

1. **建立副本和边界**：只在获得授权的副本、隔离的虚拟机中分析；不要输入真实账号密码，不要连接生产认证服务。
2. **识别文件**：使用 `file`、`readelf -h`、`readelf -l` 确认架构、入口和加载段。
3. **看依赖**：使用 `ldd` 和 `readelf -d`，记录 libcurl、加密库、GUI 库等外部边界。
4. **先看未 strip 文件**：`nm -C --defined-only ESurfingSvr` 可以看到 C++ 类和函数名；`client` 被 strip 后要依靠导入符号、字符串和反汇编。
5. **搜索线索**：运行本目录程序，再用 `grep` 筛选输出；对每条 URL、配置键或错误文本记录文件偏移。
6. **反汇编和交叉引用**：用 GDB、objdump 或 Ghidra 在隔离环境中查看某条字符串被哪些函数引用，先画出函数调用关系，再猜参数含义。
7. **动态验证**：优先用 `strace -f -e openat,connect,execve` 观察文件和连接行为；需要时在测试网络中使用 GDB 断点。动态验证只针对无账号的本地路径。
8. **行为重写**：根据观察到的输入、输出和错误行为，自己写一个小 C 程序；这叫 clean-room 的行为等价实现，不应宣称是原始源代码。
9. **逐项测试**：为每个观察到的输入建立测试，比较退出码、输出和边界条件；不要把未验证的猜测写成结论。

## 一键安装工具

当前环境是 Ubuntu 26.04。安装编译器、ELF 分析、调试、系统调用跟踪、内存检查和 Java：

```sh
chmod +x test/install-re-tools.sh
./test/install-re-tools.sh
```

脚本会安装 `gcc`、`gdb`、`binutils`、`strace`、`ltrace`、`valgrind`、`radare2`、`ghidra`（如果当前 Ubuntu 软件源提供）和 Java。它需要 sudo 权限，会执行 `apt-get update`；不会运行 `client` 或 `ESurfingSvr`。
## 下一步练习

先执行：

```sh
./test/elf_strings ./ESurfingSvr 8 > /tmp/esurfing-strings.txt
grep -Ei 'http|json|config|login|error|server|password' /tmp/esurfing-strings.txt
```

然后挑一条不含敏感数据的字符串，在 Ghidra 或 GDB 中查找引用。下一阶段可以做一个**本地配置解析器**，读取 `conf/conf.xml` 并打印键名；不会实现拨号、认证或绕过控制。

## 当前观察

- `ESurfingSvr` 是 x86-64 ELF，保留调试信息。
- `client` 是 x86-64 ELF，已 strip。
- `ESurfingSvr` 包含 cJSON、LZMA、libcurl 和 AES 相关符号或依赖线索。
- `tyxy` 是修改系统动态库配置的 shell 脚本，学习时不要直接以 root 执行。