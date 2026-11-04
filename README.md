# 蓝色大肥鱼 · 通用桌面宠物（免 DSH）

一只躺在你 Windows 桌面上的透明小桌宠：**不用安装 DeepSeek Harness，双击就能用**，右键菜单里有关闭选项，装好就是桌面快捷方式。

> 基于开源项目 [dsh-pet](https://github.com/PC2005-cloud/dsh-pet)（MIT）的「独立模式」封装：把原本跑在 DeepSeek Harness 里的桌宠抽出来成为一个通用桌面程序，并补上了**退出菜单**与**一键安装/快捷方式**。

---

## 特性

- **97 段手绘风透明动画**：待机呼吸、打瞌睡、玩魔方、写代码、吃火锅、放烟花……动画链永不停止，切换零空白帧
- **物理手感**：点击 Q 弹挤压回弹、拖拽弹簧跟手、用力甩出沿抛物线飞行、撞屏幕边缘反弹、落地摩擦减速、飞行中被点中爆分
- **屏幕漫游**：会自己朝朝向走，自动检查边界不走出屏幕；支持左右镜像朝向
- **多开**：同屏放多只，每只独立大小 / 位置 / 名字
- **右键菜单**：动作分类点播（待机 / 转向 / 拖拽 / 点击回应 / 移动 / 随机动作 / 余额档位）、回到初始位置、重载配置、**退出桌宠**
- **可换素材**：放自己的 `.webm` 动画、`.png` 表情包，甚至新增一整个「宠物种类」
- **透明置顶小窗**：不占任务栏、只有宠物身体可点，其余像素点击穿透到下层窗口
- **零云端依赖**：本地起一个 `127.0.0.1:3080` 的小服务驱动桌面窗口，不联网、不上传任何数据

## 快速上手（3 步）

1. **装 Node.js 22+**：<https://nodejs.org>（安装时一路下一步即可，装完重启一下终端）
2. **双击 `setup.cmd`**：自动安装依赖、打补丁、在桌面创建两个快捷方式
   - 首次会下载 Electron 运行时（约 100–200 MB，默认走 npmmirror 国内镜像），耐心等进度跑完
3. **双击桌面上的「蓝色大肥鱼」**：宠物出现在屏幕右下角
   - 关掉它：**右键宠物 → 退出桌宠**（或桌面上的「关闭蓝色大肥鱼」）

> 建议把本项目放在**路径不含空格**的目录里（例如 `D:\Apps\blue-fish-pet`）。

## 操作

| 操作 | 效果 |
| --- | --- |
| 双击/单击宠物 | 随机回应动画（开心 / 害羞 / 傲娇）+ Q 弹 |
| 按住拖动 | 弹簧跟手，松手轻轻放下 |
| 快速甩出 | 抛物线飞行，撞边反弹、落地摩擦停住，每次落地 Q 弹 |
| 飞行中点中 | 爆开粒子 + 积分（越快越小分越高） |
| 右键 | 菜单：打开网站 / 动作点播 / 回到初始位置 / 重载配置 / **退出桌宠** |
| 拖动到任意位置 | 会话内记住位置；「回到初始位置」回配置的角落 |

## 配置

- 模板在 `config\main-config.jsonc`；`setup.cmd` 首次运行时复制到
  `.dsh-home\dsh-pet\main-config.jsonc`
- **改配置要改 `.dsh-home` 里那份**（改完右键宠物 →「重载配置」即时生效）

常用字段：

| 字段 | 说明 |
| --- | --- |
| `name` | 名字（用在气泡/人设文本里） |
| `size` | 大小，像素（默认 462） |
| `display` | `desktop` = 只出桌面小窗（默认）；`web` = 只在网页里；`both`；`none` |
| `position` | `corner`（`bottom-right` / `bottom-left` / `top-right` / `top-left`）+ `marginX` / `marginY` |
| `pets` | 数组，放多只 = 多开；每只独立 `id` / `size` / `position` |
| `balanceEnabled` / `whisperEnabled` | 余额 / 碎碎念，**独立模式不可用**，默认关 |
| `animations` / `animationWeights` | 动画池与权重（idle 待机 / turn 转向 / move 漫游 / 随机动作分类） |
| `physics` | `gravity`、`restitution`、`groundFriction`、`ceilingBounce`、`throwPower`、`petCollision` |

`pets` 示例（多开）：

```jsonc
"pets": [
  { "id": "main", "name": "蓝色大肥鱼", "size": 462, "display": "desktop",
    "position": { "corner": "bottom-right", "marginX": 24, "marginY": 24 } },
  { "id": "pet2", "name": "小鱼二号", "size": 320, "display": "desktop",
    "position": { "corner": "bottom-left", "marginX": 24, "marginY": 24 } }
]
```

## 自定义素材

所有用户数据都在 `.dsh-home\dsh-pet\`（整个目录可以直接备份/搬走）：

| 放置位置 | 作用 |
| --- | --- |
| `main-animation\webm\xxx.webm` | 自定义动画（VP9 Alpha 编码），在 `animations` 池里写 `"xxx"` |
| `memes\xxx.png` | 自定义表情包，再在 `memes` 映射里写 `"xxx": "图的描述"` |
| `pet\<种类>-config.json` + `pet\<种类>-animation\` | 新增一个宠物种类（独立动画池），`pet\` 下自动发现 |
| `memory.json` | 预留的对话记忆（独立模式不会产生） |

## 常见问题

**Q：双击快捷方式没反应 / 宠物没出来？**
看 `logs\pet.log`。最常见是 Electron 还没下载完，或 Node 版本低于 22。

**Q：首次下载 Electron 很慢或失败？**
设置镜像环境变量后重跑 `setup.cmd`（或直接启动，等它下完）：

```bat
set DSH_PET_ELECTRON_MIRROR=https://npmmirror.com/mirrors/electron/
```

**Q：3080 端口被占用？**
服务会自动顺延端口，实际端口写在 `logs\pet.log`。也可手动指定：`start-pet.cmd --port 3100`。

**Q：宠物跑到屏幕外 / 位置不对？**
右键「回到初始位置」；或改配置里的 `position.corner` 与 `marginX`/`marginY`，再「重载配置」。

**Q：怎么彻底卸载？**
先 `stop-pet.cmd`，再双击 `uninstall.cmd` 删快捷方式，最后把整个项目文件夹删掉即可（配置、缓存、Electron 运行时都在文件夹内，不会残留）。

**Q：会不会联网上传数据？**
不会。它只在 `127.0.0.1:3080` 起本地服务给桌面窗口取素材；唯一的外网请求是首次下载 Electron。

## 目录结构

```
dsh_pet\
├─ setup.cmd / setup.ps1      首次安装（依赖 + 补丁 + 快捷方式 + Electron）
├─ start-pet.cmd              前台启动（带日志窗口，调试用）
├─ start-pet.vbs              静默启动（桌面「蓝色大肥鱼」快捷方式指向它）
├─ start-pet-hidden.cmd       静默启动的实际执行体（输出写 logs\pet.log）
├─ stop-pet.cmd / .ps1        强制关闭（宠物右键「退出桌宠」之外的另一条路）
├─ uninstall.cmd / .ps1       删除桌面快捷方式
├─ package.json               dsh-pet 依赖与脚本（npm start / npm run patch）
├─ config\
│  ├─ main-config.jsonc       默认配置模板
│  └─ names.json              快捷方式名称（可改成你喜欢的名字）
├─ patches\                   本地补丁（退出菜单等）+ 重放脚本
├─ assets\pet.ico             快捷方式图标（宠物本体形象）
├─ logs\                      运行日志（git 忽略）
└─ .dsh-home\                 运行时数据：配置 / 记忆 / 素材 / Electron（git 忽略）
   ├─ dsh-pet\main-config.jsonc
   └─ electron\electron.exe
```

## 原理（为什么不装 DSH 也能用）

上游 `dsh-pet` 是一个 DSH 插件：宿主（DSH）负责拉服务、开透明窗口、喂配置。
它同时提供 `lib/standalone.js`——把「插件宿主半边」跑在一个极小的伪上下文中，
自己起 HTTP 服务并拉起 Electron 小窗。本项目就是：

1. 用 `npm` 装上游包（素材与运行时都来自上游，保证动画是原版）
2. 打三个小补丁（见 `patches\README.md`）：加「退出桌宠」菜单 + 关窗不退出进程
3. 用 `DSH_HOME=<项目>\.dsh-home` 把配置/运行时全部收进项目目录，做到绿色便携
4. 提供一键安装与两个桌面快捷方式

独立模式下**不可用**的能力：余额、碎碎念、对话、系统通知（这些依赖 DSH 的账号/模型/会话）。其余全部可用。

## 升级上游

```sh
npm install dsh-pet@latest
npm run patch        # 重新打补丁
```

升级后如果上游改动了 `sprite.js` / `main.js`，请先 diff 再覆盖（见 `patches\README.md`）。

## 安全说明

- **只监听本机**：本地服务绑定 `127.0.0.1`（源码 `server.listen(port, "127.0.0.1")`），局域网访问不到；路由没有账号鉴权，但只对本机开放。
- **不上传数据、无遥测**：宠物不联网采集任何信息。整个项目的外网访问只有两处：`npm install` 拉取依赖、首次启动下载 Electron 运行时。
- **下载来源可控**：
  - 依赖来自 npm，`package-lock.json` 用官方 `registry.npmjs.org` 并带 `integrity` 校验；想换镜像可自己设 `npm config set registry`。
  - Electron 默认从 npmmirror 镜像下载（国内可达），可用环境变量 `DSH_PET_ELECTRON_MIRROR` 指定官方源或其它镜像。
- **不需要管理员权限**，安装只做三件事：装 npm 依赖、替换 `node_modules` 里 3 个运行时文件、在桌面建 2 个快捷方式。运行期写盘位置：
  - 项目内 `.dsh-home\`（配置 / 记忆 / 自定义素材 / Electron 运行时）
  - `%APPDATA%\dsh-pet-electron-helper\`（小窗的 Chromium 缓存）
  - `%LOCALAPPDATA%\electron\`（Electron 下载缓存）
- **补丁可自查**：只替换 `runtime/electron-helper/` 下 3 个文件，改动见 `patches/README.md`。自己核对：
  ```sh
  git diff --no-index node_modules/dsh-pet/runtime/electron-helper/sprite.js patches/sprite.js
  ```
- **渲染进程**沿用上游配置带 `--no-sandbox`（Electron 透明置顶小窗的常规做法），页面只加载本地文件与 `127.0.0.1` 资源。
- **杀毒软件拦截**：Electron 未签名，个别杀软会对首次运行弹窗，添加信任即可。

## 许可与致谢

- 本项目（封装脚本、补丁、文档）：MIT
- 上游 [`dsh-pet`](https://github.com/PC2005-cloud/dsh-pet)：代码 MIT；**动画/表情包等素材允许开源使用，禁止商用**
- 动画素材由上游作者用 AI 视频流程生成，请不要商用或二次售卖

---

## English quick start

A standalone transparent desktop pet for Windows — no DeepSeek Harness required.

1. Install **Node.js 22+** (<https://nodejs.org>)
2. Double-click **`setup.cmd`** (installs `dsh-pet`, applies the patches, creates desktop shortcuts; the first run also downloads an Electron runtime, ~100–200 MB)
3. Double-click the desktop shortcut **蓝色大肥鱼** → the pet appears bottom-right
4. **Quit:** right-click the pet → **退出桌宠**

Config lives in `.dsh-home\dsh-pet\main-config.jsonc` (size, position, multiple pets, animations).
Everything is local: the pet only talks to `127.0.0.1:3080`.
Licence: wrapper code MIT; upstream art assets are open-source-use only, **no commercial use**.
