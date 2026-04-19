# Web Clipper 学员分发包说明

这份说明是给第一次使用 `Web Clipper` 的学员看的。

目标很简单：

- 把网页文章保存到本地 Markdown
- 第一次使用时自动检查环境
- 缺少运行环境时，优先自动安装
- 安装不了时，告诉你下一步该怎么做

## 这个分发包里有什么

你拿到的压缩包里，至少会有这些文件：

- `SKILL.md`
- `scripts/bootstrap.sh`
- `scripts/run_web_clipper.sh`
- `scripts/clip_articles.py`
- `references/config/first-time-setup.md`

你不用手动研究这些文件。

你只要知道：

- `run_web_clipper.sh` 是统一入口
- 不要直接运行 `clip_articles.py`

## 你能用它做什么

它主要做两件事：

1. 收藏单篇文章
2. 批量保存某个 archive / 索引页里的多篇文章

输出结果都是本地 Markdown 文件，适合放进 Obsidian 或你的资料库。

## 第一次使用前，你只要确认 1 件事

把这个压缩包解压到你的项目里。

推荐做法：

1. 先打开你的目标 vault 或项目目录
2. 把 `web-clipper` 整个文件夹放进去
3. 后续命令都在这个项目根目录执行

注意：

不要在子目录里随手运行命令。

因为这个工具会把”你当前执行命令的目录”当成项目根目录。

## 配置 Metaso Reader API（推荐）

这个工具默认只能抓取公开网页。如果你想抓取微信公众号、163 等有反爬的站点，需要配置 Metaso Reader API：

1. 去 [metaso.cn](https://metaso.cn) 注册账号，获取 API Key
2. 设置环境变量：

### macOS / Linux

在你的 `~/.zshrc` 或 `~/.bashrc` 里加一行：

```bash
export METASO_API_KEY=”mk-你的API密钥”
```

加完后执行 `source ~/.zshrc` 让它生效。

### Windows

```powershell
setx METASO_API_KEY “mk-你的API密钥”
```

### Claude Code 项目级配置

如果你用 Claude Code，也可以在项目的 `.claude/settings.json` 里配置：

```json
{
  “env”: {
    “METASO_API_KEY”: “mk-你的API密钥”
  }
}
```

配置完成后，工具会在静态抓取失败时自动走 Metaso API fallback，不需要额外操作。

没有配置也不影响基础功能，只是遇到反爬站点时会失败。

## 第一次使用怎么跑

先进入你的项目根目录，然后执行：

```bash
WEB_CLIPPER_ROOT="<你的 web-clipper 目录>"
bash "$WEB_CLIPPER_ROOT/scripts/run_web_clipper.sh" --help
```

这一步不是单纯看帮助。

它会顺手做这些事：

1. 检查你的机器有没有 Python 3
2. 如果没有，尝试自动安装
3. 检查主脚本是否完整
4. 自动创建默认保存目录
5. 在当前项目里生成 `.web-clipper/EXTEND.md`

如果你看到帮助信息成功打印出来，说明环境基本就通了。

## 收藏单篇文章

在项目根目录执行：

```bash
WEB_CLIPPER_ROOT="<你的 web-clipper 目录>"
bash "$WEB_CLIPPER_ROOT/scripts/run_web_clipper.sh" \
  --url "https://example.com/article" \
  --mode single \
  --output-dir "00_收件箱/Clippings"
```

说明：

- `--mode single` 表示抓 1 篇
- `--output-dir` 必须是当前项目里的相对路径
- 推荐默认目录：`00_收件箱/Clippings`

## 批量保存 archive 页文章

```bash
WEB_CLIPPER_ROOT="<你的 web-clipper 目录>"
bash "$WEB_CLIPPER_ROOT/scripts/run_web_clipper.sh" \
  --url "https://example.com/archive" \
  --mode batch \
  --count 10 \
  --output-dir "00_收件箱/Clippings"
```

说明：

- `--mode batch` 表示批量抓取
- `--count 10` 表示最多抓 10 篇

## 默认保存目录是什么

如果你没有显式传 `--output-dir`，工具会按这个顺序自动决定：

1. 当前项目 `.web-clipper/EXTEND.md` 里保存的 `default_output_dir`
2. 当前项目下的 `00_收件箱/Clippings`
3. 当前项目下的 `Clippings`

## 第一次运行后会多出什么文件

第一次成功运行后，当前项目里会多一个文件：

```text
.web-clipper/EXTEND.md
```

这是正常的。

它是这个工具的本地配置文件，用来记录：

- 默认输出目录
- 当前项目根目录
- 是否允许自动安装 Python
- 是否开启浏览器补链路能力

## 如果提示缺少 Python 3

工具会先尝试自动安装。

如果自动安装失败，你会看到明确提示。常见情况是：

- 电脑没有可用的包管理器
- 当前环境没有管理员权限
- 系统不允许无交互安装

这时按你的系统手动装就行：

### macOS

```bash
brew install python
```

### Windows

```bash
winget install -e --id Python.Python.3.12
```

### Linux

用你系统自己的包管理器安装 `python3`。

装完之后：

1. 关掉当前终端
2. 重新打开终端
3. 再跑一次 `run_web_clipper.sh`

## 如果提示输出目录不合法

现在这个版本故意做了限制：

只能把文件保存到当前项目里面。

所以这些写法会被拒绝：

- `../outside`
- `/Users/xxx/Desktop`
- `~/Downloads`

正确写法要像这样：

- `00_收件箱/Clippings`
- `02_素材库/网页收藏`
- `Clippings`

## 如果文章抓取失败，先看是哪一层失败

不要一看到失败就慌。

先判断卡在哪一层：

1. 环境检查失败
2. 网页链接收集失败
3. 正文提取失败
4. 文件写入失败

最常见的处理顺序：

1. 先跑一次 `run_web_clipper.sh --help`
2. 确认 Python 3 已安装
3. 确认输出目录是项目内相对路径
4. 再执行正式抓取命令

## 一分钟验收

你可以用下面这套最小流程确认自己已经装通：

### 第 1 步：跑帮助

```bash
WEB_CLIPPER_ROOT="<你的 web-clipper 目录>"
bash "$WEB_CLIPPER_ROOT/scripts/run_web_clipper.sh" --help
```

### 第 2 步：确认项目里出现配置文件

```text
.web-clipper/EXTEND.md
```

### 第 3 步：抓一篇公开网页

```bash
WEB_CLIPPER_ROOT="<你的 web-clipper 目录>"
bash "$WEB_CLIPPER_ROOT/scripts/run_web_clipper.sh" \
  --url "https://example.com/article" \
  --mode single \
  --output-dir "00_收件箱/Clippings"
```

### 第 4 步：确认输出目录里多了 Markdown 文件

只要这一步成功，说明这个分发包已经能正常用。

## 你只需要记住一句话

以后用这个工具，统一跑：

```bash
bash "$WEB_CLIPPER_ROOT/scripts/run_web_clipper.sh" ...
```

不要直接跑：

```bash
python3 clip_articles.py
```

前者会帮你先检查环境。

后者不会。
