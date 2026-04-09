# content-goldmine-gemini 学员分发包说明

这份说明是给第一次拿到 `content-goldmine-gemini` 的学员看的。

目标很简单：

- 让你把收藏文章拆成可复用的中文素材资产
- 第一次使用时自动检查环境
- 缺少依赖时优先自动安装
- 安装不了时，明确告诉你下一步怎么做

## 这个分发包里有什么

你拿到的压缩包里，至少会有这些文件：

- `SKILL.md`
- `scripts/bootstrap.sh`
- `scripts/run_content_goldmine.sh`
- `scripts/process_goldmine.py`
- `references/config/first-time-setup.md`
- `README-学员分发包.md`

你不需要手动研究所有文件。

你只要知道：

- `run_content_goldmine.sh` 是统一入口
- 不要直接运行 `process_goldmine.py`

## 这个 skill 能做什么

它会把文章拆成 5 类素材：

1. 标题
2. 开头
3. 金句
4. 结构公式
5. 完整解构稿（可选）

最后这些内容会自动写进你的素材库目录。

## 你第一次使用前，只要确认 2 件事

### 1. 把压缩包解压到你的项目里

推荐做法：

1. 打开你的目标 vault 或项目目录
2. 把 `content-goldmine-gemini` 整个文件夹放进去
3. 后续命令都在这个项目根目录执行

### 2. 你的电脑最好已经有这些基础环境

- Python 3
- Gemini CLI

如果没有，也没关系。

这个分发包第一次运行时会先检查。

## 第一次怎么跑

先进入你的项目根目录，再执行：

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" --help
```

这一步不是单纯看帮助。

它会顺手做这些事：

1. 检查 Python 3
2. 检查 Gemini CLI
3. 缺失时优先尝试自动安装
4. 检查素材库目标目录
5. 检查 Gemini CLI 是否已经登录
6. 在当前项目里生成 `.content-goldmine-gemini/EXTEND.md`

注意：

- `EXTEND.md` 会在项目根目录检查通过后生成
- 如果 Gemini CLI 还没完成登录或认证，bootstrap 最后还是会停下来提示你先去登录

## 最重要的一步：登录 Gemini CLI

这个 skill 真正调用的是 **Gemini CLI**。

所以你光安装还不够。

你还需要完成一次登录授权。

最推荐的方式是：

```bash
gemini
```

然后按提示：

1. 选择 `Sign in with Google`
2. 浏览器完成授权
3. 回到终端

做完这一步，再回来运行这个 skill，就基本通了。

如果你已经设置了 `GEMINI_API_KEY`，这个版本也不会直接把你判定成“已通过”。

它会顺手跑一次最小请求，确认这个 Key 真的可用。

## 如果没装 Gemini CLI，会怎么处理

这个版本会优先尝试自动安装。

常见安装方式是：

### 方式 1：Homebrew

```bash
brew install gemini-cli
```

### 方式 2：npm

```bash
npm install -g @google/gemini-cli
```

如果脚本自动装不上，你就手动执行其中一条。

## 如果浏览器打不开怎么办

先这样：

```bash
export NO_BROWSER=true
gemini
```

Gemini CLI 会给你一个登录 URL。

你在浏览器里完成登录，再把验证码贴回终端即可。

## 如果你不想走 Google 登录，也可以走 API Key

先去这里拿 Key：

- `https://aistudio.google.com/app/apikey`

然后设置：

### macOS / Linux

```bash
export GEMINI_API_KEY="YOUR_GEMINI_API_KEY"
```

### Windows PowerShell

```powershell
$env:GEMINI_API_KEY="YOUR_GEMINI_API_KEY"
```

之后执行：

```bash
gemini
```

再选择 `Use Gemini API key`。

## 正式处理一篇文章

### 单篇文章

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" \
  --input "00_收件箱/Clippings/Dan Koe/example.md"
```

### 批量处理目录

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" \
  --dir "00_收件箱/Clippings/Dan Koe" \
  --count 10
```

### 保存完整解构稿

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" \
  --input "00_收件箱/Clippings/Dan Koe/example.md" \
  --save-full-analysis
```

## 它会把文件写到哪里

默认会写到当前项目里的这些目录：

- `02_素材库/灵感素材/标题`
- `02_素材库/灵感素材/开头`
- `02_素材库/灵感素材/金句`
- `02_素材库/灵感素材/结构`
- `02_素材库/高表现内容/长文`
- `02_素材库/高表现内容/短图文`

也就是说，这个版本默认就是为你当前项目服务的。

不会再像老版本那样写死到别人的电脑路径。

这里还有一个执行规则：

- 推荐就在项目根目录执行命令
- 如果你不在项目根目录，就先设置 `CONTENT_GOLDMINE_PROJECT_ROOT`
- 这个 skill 会按那个项目根目录去解析相对输入路径和输出路径

## 第一次运行后会多出什么文件

当前项目里会新增：

```text
.content-goldmine-gemini/EXTEND.md
```

这是正常的。

它主要记录：

- 当前项目根目录
- 默认模型
- 默认输出目录约定
- 是否允许自动安装
- 默认认证偏好

## 最小验收流程

### 第 1 步：确认 Gemini CLI 在

```bash
gemini --version
```

### 第 2 步：确认 Gemini CLI 已登录

```bash
gemini -p "Reply with OK" --output-format json
```

### 第 3 步：跑 skill 帮助

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" --help
```

### 第 4 步：正式拆一篇文章

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" \
  --input "00_收件箱/Clippings/Dan Koe/example.md"
```

只要第 4 步能成功把素材写进 `02_素材库/`，说明这个分发包就已经装通了。

## 你只需要记住一句话

以后统一运行：

```bash
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" ...
```

不要直接运行：

```bash
python3 process_goldmine.py
```

前者会先帮你检查环境和登录状态。

后者不会。
