# protect.so 的接口约定（ARM 移植要点）

原版编码模块只提供 **x86-64** 版本，ARM 上无法加载。
如果要在 ARM 上原生运行（而不是用 qemu 模拟），必须**自己实现这个模块**，
导出同样的 5 个函数、保持同样的调用约定。

`portal_login` 通过 `dlopen()` + `dlsym()` 解析下面这些符号（见 `src/portal_login.c`
里的 `load_codec()`）：

| 导出符号 | 说明 |
|---|---|
| `Prepare` | 初始化（原版会在此时读取本机信息） |
| `Code` | 入参：请求 XML 字符串；返回：编码后的报文（服务端接受的形式） |
| `DeCode` | 入参：响应报文；返回：解码后的 XML 字符串 |
| `Correct` | 校验/纠错 |
| `FreeResult` | 释放 `Code`/`DeCode` 返回的缓冲区 |

## 编码规律（已实测）

- 请求报文：`Code(请求XML)` → `POST` 到 `*.cgi`，请求头里带
  `CDC-Checksum: md5(编码后报文的十六进制小写)`。
- 响应报文：服务端返回 **chunked**，去分块后把 body 交给 `DeCode()` 得到 XML。
- 这两步与架构无关，是**算法本身**决定的；只要算法复刻正确，ARM 版就能直接对接服务端。

## 用探针实测到的行为（在 x86-64 上直接调用原版 protect.so）

| 输入 | `Code()` 输出 |
|---|---|
| 非 XML（例如 500 个 `A`） | 固定 **192** 个十六进制字符（等同空 request） |
| `<request><a>1</a></request>` | **224** 个十六进制字符，`DeCode` 原样还原 |
| 完整 ticket 请求（328 字节） | **928** 个十六进制字符 |

要点：

- `Code` 会**先解析 XML**，只保留它认识的元素；不是合法 XML 的输入会被当作空 request。
- 输出是**大写十六进制**文本；长度随输入增长但不是线性（每个字段有固定开销）。
- `Code` / `DeCode` **可逆**（round-trip 输入输出一致）→ 复刻在原理上可行。
- 输出开头有一段固定前缀 `436B233A4F56456252612F505F77557A21`（ASCII 为
  `Ck#:OVEbRa/P_wUz!`），疑似包头/密钥材料，需要进一步分析。
- `Prepare` 在 `.so` 里是遍历 `.init_array` 的初始化收集器；调用方**不调用它也能工作**
  （实测如此），所以复刻时可以先忽略。

## 逆向入口（现有工作区）

- 目标文件：`../final/protect.so`（ELF64，`.text` 约 22KB，符号已剥离）
- 已知导出：`Prepare` / `Code` / `DeCode` / `Correct` / `FreeResult`
- 现成工具：`objdump -d`、`readelf`、`gdb`，以及 `../test/` 下已有的逆向笔记
  （`test/work/*-disasm.txt`、`test/work/protect-captured.so`）

## 验证方法

复刻出 `codec.so`（或直接静态实现）后，用同一组输入对比：

```sh
# x86-64 原版拿到编码结果
GD_DEBUG=1 ../final/portal_login --state        # 观察 error=0 / 错误码

# ARM 版用复刻的实现跑同一流程，看服务端返回是否一致
sh build.sh && sh arch-check.sh
```

判据：服务端 `Error-Code: 0`（票/认证成功），否则说明编码不匹配。
