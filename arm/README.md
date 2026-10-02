# 天翼校园网 Linux 客户端 —— ARM 版本（arm）

本目录是 [`../final/`](../final/) 的 **ARM 移植版骨架**。源码与 x86-64 版完全一致，
差别只有一处：**编码模块 `protect.so` 没有 ARM 版本**。

---

## 1. 结论先说

| 目标平台 | 状态 |
|---|---|
| x86_64 Linux（原版） | ✅ `../final/` 已可用 |
| **ARM + glibc**（树莓派 / Armbian / Debian arm64） | ⚠️ **能编译，缺 `protect.so`（aarch64/armhf）** |
| **ARM + musl**（OpenWrt 等） | ⚠️ 需要 glibc 或静态链接，并且同样缺 `protect.so` |

本目录里能编译通过的只有我们自己写的 `src/portal_login.c`；
真正跑起来还差 `protect.so`（见 [第 4 节](#4-唯一的硬阻塞protectso)）。

---

## 2. 目录结构

```
arm/
├── src/portal_login.c   # 与 x86-64 版同一份源码（可移植 C11）
├── conf/conf.xml        # 运行配置（urls / clientId / schoolId / domain / area）
├── conf/code.xml        # 服务端错误码中文表
├── zxmAlogic.zxm        # 算法容器（纯数据，架构无关，可直接用）
├── build.sh             # 构建（自动挑交叉/本机编译器）
├── arch-check.sh        # 打印目标平台与依赖情况，判断能不能跑
├── run-via-qemu.sh      # 用 qemu-user 跑工作区里已有的 x86-64 版本
├── codec/README.md      # protect.so 的导出接口（移植时的实现约定）
└── README.md            # 本文件
```

> 本目录**不含** `protect.so`：x86-64 的那份在 ARM 上无法加载，放进来只会误导。

---

## 3. 怎么构建

```sh
cd arm
sh build.sh                 # 自动选择编译器
CC=aarch64-linux-gnu-gcc sh build.sh      # 指定交叉编译器
```

- 依赖：`gcc`（或交叉工具链）、`libxml2`（`-lxml2`）。
- 交叉编译时 `pkg-config` 通常找不到目标平台的 libxml2，用环境变量覆盖：

```sh
CC=aarch64-linux-gnu-gcc \
XML_CFLAGS="-I/path/to/arm64/include/libxml2" \
XML_LIBS="-L/path/to/arm64/lib -lxml2" \
sh build.sh
```

- 在 ARM 设备上原生编译最简单（`sh build.sh` 会用本机 `gcc`）。

先跑一次环境自检：

```sh
sh arch-check.sh
```

它会打印架构、libc（glibc/musl）、`libxml2` 是否存在、以及 `protect.so` 是否就位。

---

## 4. 唯一的硬阻塞：protect.so

`portal_login` 通过 `dlopen()` 加载编码模块，调用其中 5 个函数：

| 函数 | 作用 |
|---|---|
| `Prepare` | 初始化 |
| `Code` | 把请求 XML 编码成服务端接受的报文 |
| `DeCode` | 把响应报文解码回 XML |
| `Correct` | 校验/纠正 |
| `FreeResult` | 释放结果 |

原版只提供 **x86-64** 的 `protect.so`（ELF64, `NEEDED libc.so.6`），
内部符号已剥离，**没有源码**。ARM 上只有三条路：

| 方案 | 说明 | 代价 |
|---|---|---|
| A. 找到 ARM 版原客户端 | 厂商当前只发 x86-64，基本没有 | — |
| B. **逆向复刻编码算法**（纯 C 实现，替代 `protect.so`） | 可行：需先识别算法（`.text` 约 22KB，导出 5 个函数） | 中～大 |
| C. **qemu-user 跑 x86-64 版**（见下） | 立即可用，不需要复刻 | 需要 qemu，性能低（保活是低频操作，够用） |

方案 B 的接口约定见 [`codec/README.md`](codec/README.md)。

---

## 5. 方案 C：在 ARM 上用 qemu 跑现成的 x86-64 版本

```sh
sudo apt install -y qemu-user-static     # Debian/Ubuntu/Armbian
cd arm
sh run-via-qemu.sh                       # 等价于 final/ 里的 sh run_login.sh
sh run-via-qemu.sh --state
```

原理：用工作区根目录 `lib/` 里自带的那套 glibc（原版 `tyxy` 也是这么做的），
在 qemu 用户态模拟下运行 `../final/portal_login`。

---

## 6. 已经验证 / 未验证

- ✅ 源码本身是与架构无关的 C11，`-Wall -Wextra` 无警告（在 x86-64 上验证过）。
- ✅ `zxmAlogic.zxm`、`conf/*.xml` 都是纯数据，ARM 直接可用。
- ❌ **未在本机验证 ARM 构建**：当前工作区没有 ARM 交叉工具链，也没有 ARM 设备。
  请在目标机上执行 `sh build.sh && sh arch-check.sh` 后把输出发回。

---

## 7. 安全与合规

- 账号、密码只在本地终端输入，不保存、不回显、不打印。
- 本程序不含原版的共享检测（`CheckWiFiShare`）、网络状态机与自动探门户。
- 用路由器承载多台设备时，服务端看到的是**同一账号 + 多个 MAC/IP**，
  可能触发共享/多终端限制；这取决于你所在校区的策略，与本程序无关。
