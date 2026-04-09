# writing-clone-starter

`writing-clone-starter` 是一个给 **Claude Code / 兼容 Agent** 用的写作 skill 仓库。

它解决的是一个很具体的问题：

你还没有自己的长期写作资产，没有成熟的个人 profile，也没有一堆可调用的人生素材，但你现在就想先写出一篇像样、可发、甚至带一点作者方向感的文章。

这个仓库把这件事拆成两层：

1. **写作主 skill 与维护工具链**
2. **统一素材库**

一句话说清楚：

> 这是一个“先写出来”的写作 starter。默认能写强文章，也能按内置作者方向写。普通用户可以直接拿来用，维护者也可以继续用它抓文章、拆素材、蒸馏 profile、验证 profile。

---

## 30 秒看懂

如果你很赶，只看这几句就够了：

1. 这个仓库不是教程，而是一套可安装的 skill + 素材库
2. 普通用户安装后，可以直接让 Agent 写强文章，或者按 6 个内置作者方向写
3. 维护者安装后，还可以继续用自然语言做 4 件事：抓文章、拆素材、distill profile、probe/profile 验证
4. 日常使用的核心是 `writing-clone-starter`
5. 维护链完整顺序是：`web-clipper -> content-goldmine-gemini -> profile-distillation -> profile-probe`

---

## 它适合谁

- 想先写出强文章，但自己还没有完整个人风格资产的人
- 想体验“像某个作者方向写”是什么感觉的人
- 正在用 Claude Code 或兼容 Agent 做内容创作的人
- 想把仓库链接直接丢给 Agent，让 Agent 帮自己安装的人
- 想维护作者 profile、继续迭代作者资产的人

不适合下面这类场景：

- 你已经有成熟的个人风格资产，只想继续“像自己写”
- 你要的是长期个人 clone 系统，而不是 starter

如果你属于后者，更接近的方向通常是 `writing-clone-profile`，不是这个仓库。

---

## 它能做什么

### 1. 强文章模式

这是默认模式。

你不给作者名，它会优先判断这篇文章更适合走哪种原型，然后组织正文。

当前内置 4 个强文章原型：

- 观点拆解型
- 方法教程型
- 案例复盘型
- 认知升级型

这个模式的目标不是“像谁”，而是让文章本身站得住、结构清楚、能直接发。

### 2. 高拟态模式

你明确指定作者后，它会进入对应作者方向。

当前内置作者：

- Dan Koe
- 粥左罗
- Justin Welsh
- 刘润
- 梁宁
- 薛辉

它不是无条件硬装像。

如果你的题目明显超出某个作者的原生议题带宽，skill 会自动降级回强文章模式，而不是硬凹一个假的作者稿。

### 3. 开发者 / 维护者能力

这个仓库不只是“给普通用户写文章”。

它还把两条维护能力一起带上了，而且这两条能力都可以通过自然语言调用：

- `profile-distillation/`：新增或更新一个作者 profile
- `profile-probe/`：做 blind probe、稳定性验证、评分、找薄层

你可以直接对 Agent 说：

- `帮我 distill 一个新的作者 profile`
- `帮我重测这个 profile，看它稳不稳`
- `帮我做一轮 blind probe`
- `帮我验证并优化这个 profile`

### 4. 相关工具链

如果你只是正常写文章，核心还是 `writing-clone-starter` 本身。

但如果你要走完整维护链，这个仓库还包含两条前置工具：

- `web-clipper`：先把网页文章、归档页、索引页抓下来
- `content-goldmine-gemini`：再把文章拆成可复用素材

完整维护链可以理解成：

```text
web-clipper
  -> content-goldmine-gemini
    -> profile-distillation
      -> profile-probe
```

普通用户不一定需要这两条前置工具。

维护者需要。

---

## 仓库里有什么

这个仓库现在收成两类：

- `.claude/skills/`：skill 本体和维护工具链
- `02_素材库/writing-clone-starter-material-library/`：starter 运行时真正读取的统一素材库

```text
.
├── .claude/
│   └── skills/
│       ├── writing-clone-starter/
│       ├── content-goldmine-gemini/
│       └── web-clipper/
├── 02_素材库/
│   └── writing-clone-starter-material-library/
├── AGENT_INSTALL_PROMPT.md
├── EXPORT_MANIFEST.md
├── LICENSE
└── README.md
```

你可以把它理解成：

- `writing-clone-starter` 是主入口
- `content-goldmine-gemini` 和 `web-clipper` 是维护者工具链
- `02_素材库/writing-clone-starter-material-library/` 是 starter 真正读取的材料层

---

## 运行时真正依赖什么

这一点很重要。

对于普通写作使用来说，`writing-clone-starter` 的正式外部材料面已经收口到一个地方：

- `02_素材库/writing-clone-starter-material-library/`

这意味着：

- starter 不再依赖散落的 inbox、项目研究区、agent 辅助文件路径
- 你不需要再自己猜材料到底藏在哪儿
- 你拿到仓库后，只要 skill 和统一素材库都装对，starter 就有明确的取料面

`web-clipper` 和 `content-goldmine-gemini` 是维护链的上游工具，不是普通写作运行时的硬依赖。

---

## 你安装完以后，Agent 实际会读什么

如果你只是正常使用 starter，最关键的入口是这几个文件：

- `/.claude/skills/writing-clone-starter/SKILL.md`
- `/.claude/skills/writing-clone-starter/README.md`
- `/.claude/skills/writing-clone-starter/references/runtime-closure.md`
- `/.claude/skills/writing-clone-starter/references/evaluation/`
- `/.claude/skills/writing-clone-starter/references/content-archetypes/`
- `/.claude/skills/writing-clone-starter/references/built-in-profiles/`
- `/02_素材库/writing-clone-starter-material-library/README.md`

如果你是维护者，再继续看：

- `/.claude/skills/web-clipper/SKILL.md`
- `/.claude/skills/content-goldmine-gemini/SKILL.md`
- `/.claude/skills/writing-clone-starter/references/profile-distillation/`
- `/.claude/skills/writing-clone-starter/references/profile-probe/`

---

## 安装前提

开始前，你至少需要下面这两个条件：

1. 你有一个会被 Claude Code 或兼容 Agent 当作工作区的目录
2. 这个工作区允许你创建下面这些相对路径

```text
.claude/skills/
02_素材库/
```

最省心的安装方式，是**保持仓库里的相对路径原样**。

你当然可以自己改路径，但那会引入额外适配工作。这个仓库默认已经把路径收口好了，直接照着放，摩擦最低。

### 两种安装层级

你可以按下面两种方式安装：

#### 标准安装

适合普通用户。

安装这两块就够：

```text
.claude/skills/writing-clone-starter/
02_素材库/writing-clone-starter-material-library/
```

#### 维护者全量安装

适合你想继续蒸馏、验证、优化 profile 的场景。

除了上面两块，再加：

```text
.claude/skills/content-goldmine-gemini/
.claude/skills/web-clipper/
```

---

## 安装方式 A：自己手动安装

### 第 1 步：拉下仓库

```bash
git clone https://github.com/zjp1997720/writing-clone-starter.git
```

如果你不想用 git，也可以在 GitHub 页面直接下载 ZIP，然后手动解压。

### 第 2 步：把需要的内容复制到你的工作区

如果你只是普通用户，最小安装只要这两块：

```text
.claude/skills/writing-clone-starter/
02_素材库/writing-clone-starter-material-library/
```

如果你还要用维护者工具链，把这两块也一起带上：

```text
.claude/skills/content-goldmine-gemini/
.claude/skills/web-clipper/
```

### 第 3 步：确认目录结构

标准安装后，你的工作区至少应该长这样：

```text
<your-workspace>/
├── .claude/
│   └── skills/
│       └── writing-clone-starter/
└── 02_素材库/
    └── writing-clone-starter-material-library/
```

维护者全量安装后，会多两项：

```text
<your-workspace>/
├── .claude/
│   └── skills/
│       ├── writing-clone-starter/
│       ├── content-goldmine-gemini/
│       └── web-clipper/
└── 02_素材库/
    └── writing-clone-starter-material-library/
```

### 第 4 步：做最小验证

标准安装最少看这两个文件：

- `/.claude/skills/writing-clone-starter/SKILL.md`
- `/02_素材库/writing-clone-starter-material-library/README.md`

如果你装了维护者工具链，再多看两眼：

- `/.claude/skills/content-goldmine-gemini/SKILL.md`
- `/.claude/skills/web-clipper/SKILL.md`

### 第 5 步：做一次真正的试用

不要停在“目录存在”。

直接给你的 Agent 一句最小测试话术：

```text
帮我写一篇关于 AI 内容获客的文章
```

如果它能正确进入强文章模式，并开始围绕正文组织内容，说明 starter 已经真正接上了。

---

## 安装方式 B：把仓库链接直接丢给你的 Agent

这是更推荐的方式。

你可以直接把下面两样东西一起丢给 Agent：

1. 仓库链接
2. `AGENT_INSTALL_PROMPT.md`

仓库链接：

- `https://github.com/zjp1997720/writing-clone-starter`

如果你只想标准安装，直接让 Agent 按 README 操作也可以。

如果你要维护者全量安装，优先让 Agent 读取仓库根目录这个文件：

- `AGENT_INSTALL_PROMPT.md`

这个文件里已经区分了：

- 标准安装
- 维护者全量安装

---

## 安装完成后怎么用

### 默认用法：强文章模式

你直接说：

```text
帮我写一篇关于 AI 内容获客的文章
```

或者：

```text
写一篇文章，主题是为什么很多人做内容很努力，最后却没有业务闭环
```

这时 starter 会优先按**强文章模式**理解，然后在 4 个原型里做路由。

### 指定作者：高拟态模式

你可以这样说：

```text
像 Dan Koe 那样写一篇关于一人公司内容策略的文章
```

```text
按粥左罗的方向写一篇关于普通人做内容获客的文章
```

```text
用刘润的方向写一篇关于小老板交易结构的文章
```

### 如果主题超出作者带宽会发生什么

它不会硬装像。

它会提醒你这个题已经超出该作者的原生带宽，然后自动回到强文章模式。

### 第一次使用时，推荐这样试

建议你按这个顺序试：

1. 先试强文章模式
2. 再试高拟态模式
3. 最后再试一个明显超出作者带宽的边界题

这样你能最快看懂这套 skill 的行为边界。

---

## 维护者怎么用

如果你不是普通用户，而是要继续做作者 profile 维护，那你现在有 4 步可以直接用自然语言调用：

### 1. 抓文章

```text
帮我抓这个作者主页最近 20 篇文章，保存到本地
```

对应工具：`web-clipper`

### 2. 拆素材

```text
把这批 clipping 拆成标题、开头、金句、结构，沉淀到素材库
```

对应工具：`content-goldmine-gemini`

### 3. Distill 一个新的 profile

```text
帮我 distill 一个新的作者 profile
```

或者更完整一点：

```text
帮我先抓这位作者的公开文章，再拆成素材，然后 distill 一个新的 profile
```

对应工具：`writing-clone-starter` 内的 `profile-distillation/`

### 4. 验证并优化这个 profile

```text
帮我做一轮 blind probe，看看这个 profile 稳不稳
```

```text
帮我验证并优化这个 profile
```

对应工具：`writing-clone-starter` 内的 `profile-probe/`

---

## 你大概会得到什么输出

普通写作模式下，最重要的交付是：

- `response.md`：正文成品

说明性材料通常会放在：

- `run_summary.md`：模式选择、带宽判断、降级原因等辅助说明

维护者路径下，还可能额外产出：

- `evaluator_score.md`
- `round_log.md`
- `source-ledger.md`
- profile 更新后的作者资产

---

## 成熟度说明

当前 6 个内置作者的成熟度并不完全相同：

- **Dan Koe、粥左罗**：更成熟
- **Justin Welsh**：已经到可试用 draft 水位
- **刘润、梁宁、薛辉**：在各自核心带宽内可用，但更窄

这不影响你安装和使用，只影响你对“像到什么程度”的预期。

---

## 常见安装错误

### 1. 只复制了 starter，没有复制统一素材库

结果就是规则在，材料不全，高拟态相关内容会明显变弱。

### 2. 自作主张改目录名

比如把：

- `.claude/skills/writing-clone-starter/`
- `02_素材库/writing-clone-starter-material-library/`

改成别的名字。

这会直接增加路径适配成本。

### 3. 想用维护者功能，但没装工具链

如果你要做抓取、拆素材、distill、probe，就别只装 starter。

至少还要把下面两块一起带上：

- `.claude/skills/web-clipper/`
- `.claude/skills/content-goldmine-gemini/`

### 4. 把维护者模块当成普通用户入口

普通用户先走主入口，不要一上来就钻 `profile-distillation/` 或 `profile-probe/`。

---

## 更新这个仓库时怎么做

如果后面这个仓库有新版本，你的更新方式也很简单：

1. 拉取仓库最新版本
2. 用新版覆盖你当前工作区里对应目录
3. 再跑一次最小验证

如果你是让 Agent 帮你更新，最稳的方式也是复用 `AGENT_INSTALL_PROMPT.md`，只是在 prompt 里把“安装”改成“更新”。

---

## 最后你该先看哪 4 个文件

如果你刚拿到仓库，只看这 4 个文件就够了：

1. `/.claude/skills/writing-clone-starter/SKILL.md`
2. `/.claude/skills/writing-clone-starter/README.md`
3. `/02_素材库/writing-clone-starter-material-library/README.md`
4. `/AGENT_INSTALL_PROMPT.md`

看完这四个，你就会知道：

- 这是什么
- 它怎么工作
- 它从哪儿取料
- 你该怎么安装
- 你该怎么开始用

---

## License

MIT
