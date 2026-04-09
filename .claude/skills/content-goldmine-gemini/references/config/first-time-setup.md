# content-goldmine-gemini 首次使用说明

这份说明只解决第一次使用最容易卡住的地方。

你先记住一句话：

以后统一运行：

```bash
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" ...
```

不要直接运行：

```bash
python3 process_goldmine.py
```

因为前者会先帮你检查环境，后者不会。

## 第一次怎么跑

先进入你的项目根目录，再执行：

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" --help
```

这一步会顺手做 6 件事：

1. 检查 Python 3
2. 检查 Gemini CLI
3. 缺失时优先尝试自动安装
4. 检查素材库目录是否存在
5. 在当前项目里生成 `.content-goldmine-gemini/EXTEND.md`
6. 检查 Gemini CLI 是否已经完成认证

注意：

- `EXTEND.md` 会在项目根目录检查通过后写入
- 如果 Gemini CLI 还没完成登录或认证，这一步最后仍会停下来提示你先去登录

## 如果提示没装 Gemini CLI

这个 skill 的核心依赖不是 API SDK，而是 **Gemini CLI**。

优先推荐这两种安装方式：

### macOS / Linux（Homebrew）

```bash
brew install gemini-cli
```

### 通用方式（npm）

```bash
npm install -g @google/gemini-cli
```

如果自动安装失败，就手动执行上面这两条里的其中一条。

## 装完 Gemini CLI 之后，怎么登录

推荐默认路径：**Google 账号直接登录**。

执行：

```bash
gemini
```

然后：

1. 选择 `Sign in with Google`
2. 浏览器会打开登录页
3. 完成授权
4. 回到终端

登录完成后，再重新运行这个 skill。

如果你已经设置了 `GEMINI_API_KEY`，bootstrap 也不会直接当作“已经通过”。

它会顺手跑一次最小请求，确认这个 Key 真能用。

## 如果打不开浏览器

你可以先这样：

```bash
export NO_BROWSER=true
gemini
```

这时 Gemini CLI 会给你一个登录 URL。

你在浏览器里完成授权，再把验证码贴回终端就行。

## 如果你更想用 API Key

也可以。

先去这里拿 Key：

- `https://aistudio.google.com/app/apikey`

然后设置环境变量：

### macOS / Linux

```bash
export GEMINI_API_KEY="YOUR_GEMINI_API_KEY"
```

### Windows PowerShell

```powershell
$env:GEMINI_API_KEY="YOUR_GEMINI_API_KEY"
```

设置后，重新运行：

```bash
gemini
```

然后选择 `Use Gemini API key`。

## 怎么验证自己已经装通

### 第 1 步：看版本

```bash
gemini --version
```

### 第 2 步：跑最小请求

```bash
gemini -p "Reply with OK" --output-format json
```

如果这一步能成功返回 JSON，说明 Gemini CLI 已经可用。

### 第 3 步：重新运行 skill 帮助

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" --help
```

只要这一步能顺利过 bootstrap，后面就可以正式跑文章拆解了。

这里再记住一个执行规则：

- 推荐就在项目根目录执行命令
- 如果你不在项目根目录，就先设置 `CONTENT_GOLDMINE_PROJECT_ROOT`
- 这个 skill 会按那个项目根目录去解析相对输入路径和输出路径

## 正式跑一篇文章

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" \
  --input "00_收件箱/Clippings/Dan Koe/example.md"
```

## 第一次运行后会多出什么文件

当前项目里会新增：

```text
.content-goldmine-gemini/EXTEND.md
```

这是正常的。

它用来记录：

- 当前项目根目录
- 默认模型
- 各类素材的默认输出目录
- 是否自动安装依赖
- 默认认证偏好
