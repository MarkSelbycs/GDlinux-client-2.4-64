# PROMPT.md — 提问模板与关键词速查

面向"逆向工程 / 功能完善 / 打包交付"的提问模板。照抄改一下即可。
（用于你自己的软件/已授权目标。）

---

## 0. 万能公式（最重要）

> **【任务类型】** 工作区 `<路径>`。
> **目标**：`<一句话>`。
> **约束**：只允许改 `<目录>`；不要动 `<其它>`。
> **已知线索**：`<地址 / 字符串 / 接口 / 日志>`。
> **验收**：每步改完必须跑 `<构建命令>`；期望输出 `<...>`。
> **产物**：`<源码 / 可运行程序 / 打包目录 + README>`。

一句话版：

```
工作区 /path。逆向 samples/App 的 <功能>；只改 test/；
每步跑 bash test/build_offline.sh；最后打包到 final/ 并写 README.md。
```

---

## 1. 逆向工程：分阶段模板

### 1) 侦察（先弄清是什么）
关键词：`侦察` `file` `readelf` `nm` `strings` `是否 strip` `调试信息` `DWARF`

```
对 <文件> 做侦察：
- file / readelf -h -S，判断架构、是否含调试信息/strip；
- 列出与 <功能> 相关的导出符号及地址；
- 在 .rodata 里找与 <关键词> 相关的字符串及地址。
```

### 2) 定位（找到是哪个函数）
关键词：`定位` `调用者` `xref` `vtable` `字符串引用` `符号地址` `objdump -d --start-address`

```
谁调用了 <函数名/地址>？列出调用者。
<某字符串地址> 被哪些函数引用？
```

### 3) 还原逻辑（看懂并说清）
关键词：`反汇编` `控制流` `参数映射` `System V ABI 寄存器约定` `结构体偏移` `魔数/常量表` `判据`

```
反汇编 <符号地址>，说明：
入参/出参、字段顺序、关键常量、按顺序调用了哪些函数、成功/失败判据。
```

### 4) 复刻实现（写成能跑的代码）
关键词：`复刻` `行为等价` `最小复刻` `单文件 C` `离线可编译` `不依赖原程序` `保留诊断`

```
把 <功能> 复刻成 C：行为等价、失败可定位、无敏感信息输出；
每步跑 <构建命令>。
```

### 5) 验证（证明真的对）
关键词：`验证` `抓包` `真机验证` `错误码对照` `日志对比` `回放` `fixture`

```
用真实环境验证 <命令>，返回 error/state/detail；
若返回码不是 0，分析可能是哪一步。
```

### 6) 动态分析（可选）
关键词：`strace` `ltrace` `gdb 断点` `LD_PRELOAD 拦截` `tcpdump 抓包`

---

## 2. 功能完善：模板

关键词：`新增子命令/开关` `保持现有行为` `向后兼容` `错误码` `诊断输出` `默认值` `env 覆盖` `组合使用`

```
在 <程序> 加 <功能>（如 --xxx / 子命令 xxx / 定时任务 / 状态查询）：
- 不影响现有功能；
- 默认值合理，可用环境变量覆盖；
- 输出 debug= 诊断（状态/错误码，不含敏感信息）；
- 改完跑 <构建命令>，并给出验证步骤。
```

---

## 3. 打包交付：模板

关键词：`打包` `源码+依赖+运行步骤` `建一个文件夹` `写 README.md` `tar.gz`

```
把 <功能> 的源码 + 运行依赖 + 运行脚本 打包到 <文件夹>：
目录：src/ 源码、依赖文件、build.sh、run_*.sh、README.md；
README 写清：目录结构、依赖、运行步骤、原理、常见问题；
再打一个 <name>.tar.gz。
```

---

## 4. 提供上下文清单（贴这些最省事）

| 项 | 示例 |
|---|---|
| 工作区路径 | `/home/x/proj` |
| 原始程序 | `samples/App`（带调试信息 / 已 strip） |
| 目标（一句话） | 复刻登录 / 加保活 / 修某错误 |
| 已知线索 | `http://…:7001/ticket.cgi`、`Error-Code`、日志行 |
| 约束 | 只改 `test/`；别动 `conf/ lib/ samples/` |
| 验收 | `bash test/build_offline.sh` 通过；`state=online` |
| 敏感信息 | 不要提供账号/密码/密钥（用 fixture 验证即可） |

---

## 5. 关键词速查表（中 → 用途）

| 想做 | 关键词 |
|---|---|
| 摸清文件 | `侦察` `file/readelf/nm/strings` `是否 strip` `调试信息` |
| 找函数 | `定位` `符号地址` `调用者` `xref` `vtable` |
| 看懂逻辑 | `反汇编` `参数映射` `结构体偏移` `控制流` `判据` |
| 写代码 | `复刻` `行为等价` `单文件 C` `离线可编译` |
| 证明正确 | `验证` `抓包` `错误码` `回放` `fixture` |
| 加功能 | `新增子命令` `开关` `兼容` `默认值` `诊断` |
| 动态跟踪 | `strace` `gdb 断点` `LD_PRELOAD` `tcpdump` |
| 交付 | `打包` `README.md` `tar.gz` `运行步骤` |
| 约束 | `只改 test/` `不要动 samples/` `每步构建` |

---

## 6. 小建议

1. **一次一个目标**，比一次十条更稳、返工少。
2. 明确写"**每步改完必须跑 `<构建命令>`**"——会边做边验证，不停在建议。
3. 给"**已知线索**"（地址/字符串/接口/日志）能大幅加速。
4. 要"**可交付包**"就直接说：源码+依赖+运行步骤 → 文件夹 + `README.md`。
5. **别发敏感信息**（账号/密码/密钥/认证 XML）。
6. 只在**自己拥有或已授权**的软件上做逆向。

---

## 7. 本仓库（GD 天翼校园客户端）续做模板

> 复制下面这段开启新会话即可继续本项目。

```text
工作区 /home/gcc/GDlinux-client-2.4-64。

目标：<在此写这次要做的事，例如：加 --xxx 功能 / 修某错误 / 打包重建>。

约束：
- 原始程序：samples/ESurfingSvr（带调试信息未 strip），只读分析，不要修改。
- 只允许改动 test/（以及已存在的 final/ 交付目录）。
- 不要修改 client / ESurfingSvr / AutoUpdate / conf/ / lib/ / samples/ 原始文件。
- 每步修改后必须运行 bash test/build_offline.sh。

已知事实（逆向已验证）：
- 门户：配置探测 detect.html、取票 ticket.cgi、认证 auth.cgi、注销 term.cgi、保活 keep.cgi、状态 state.cgi（服务器 14.146.227.141:7001）。
- 请求均为 POST 编码体（protect.so 的 Code），请求头：User-Agent / Algo-ID / Client-ID / CDC-Checksum(md5 小写) / CDC-SchoolId / CDC-Domain / CDC-Area。
- 响应 chunked → DeCode → 解析 XML；成功看响应头 Error-Code==0。
- Algo-ID 来自 zxmAlogic.zxm；wlanuserip/clientip 必须等于本机源 IP。
- 动态取配置：GET <redirect 主机>/index.cgi 的 <config>（ServerIPs + ticket/auth/state-url）。
- 命名管道 IPC：clientpipe/serverpipe，NUL 结尾 XML，OpC=PortalConnect/PortalDisConnect，应答 PortalState。

交付物：final/（源码 src/portal_login.c + protect.so + zxmAlogic.zxm + conf/conf.xml + 各 run_*.sh + README.md），另打 final-*.tar.gz。

若需账号登录，请不要索要账号密码；提示我在终端自行输入。
```
