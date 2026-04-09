# writing-clone-starter

`writing-clone-starter` 是一个给 **Claude Code / 兼容 Agent** 用的写作 skill。

它解决的是一个很具体的问题：

你还没有自己的长期写作资产、没有成熟的个人 profile，也没有一堆可调用的人生素材，但你现在就想先写出一篇像样、可发、甚至带一点作者方向感的文章。

这个仓库把这件事拆成了两部分：

1. **skill 本体**：负责模式判断、原型路由、作者拟态、输出协议
2. **统一素材库**：负责给 skill 提供它真正会读取的作者材料、证据、验证集和 provenance 账本

如果你只想知道一句话，这个仓库就是：

> **一个“先写出来”的写作 starter。默认能写强文章，也能按内置作者方向写；仓库拿到手后，用户和 Agent 都能直接安装。**

---

## 30 秒看懂

如果你现在很赶，只看这 4 句就够了：

1. 这个仓库不是写作教程，而是一个可安装的写作 skill
2. 它默认能写强文章，也能按 6 个内置作者方向写
3. 你安装时只需要放对两块内容：`skill` + `统一素材库`
4. 如果你懒得手动装，直接把仓库链接和 `AGENT_INSTALL_PROMPT.md` 丢给 Agent

---

## 它适合谁

- 想先写出强文章，但自己还没有完整个人风格资产的人
- 想体验“像某个作者方向写”是什么感觉的人
- 正在用 Claude Code 或兼容 Agent 做内容创作的人
- 想把 skill 和素材库一起交给 Agent 安装的人

不适合下面这类场景：

- 你已经有成熟的个人风格资产，只想继续“像自己写”
- 你要的是长期个人 clone 系统，而不是 starter

如果你属于后者，更接近的方向通常是 `writing-clone-profile`，不是这个仓库。

---

## 你拿到这个仓库后，应该怎么理解它

不要把它想成一个“大而全的写作系统”。

更准确的理解是：

- **它是一个 starter**，不是你的最终个人 clone
- **它的优势是起步快**，不是人格资产最深
- **它已经把外部依赖收口好了**，你不需要再到别的目录找材料

你只需要记住两件事：

- `.claude/skills/writing-clone-starter/` 负责“怎么写”
- `02_素材库/writing-clone-starter-material-library/` 负责“拿什么写”

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

### 3. 维护者模块

这个仓库还带了两组维护者用的模块：

- `profile-distillation/`：新增或更新作者 profile
- `profile-probe/`：做 blind probe、稳定性验证、评分

普通用户不需要先理解这两块。它们主要服务维护和迭代。

---

## 仓库里有什么

这个仓库现在故意只保留两大块，避免你拿到手以后看到一堆分散路径发懵。

```text
.
├── .claude/
│   └── skills/
│       └── writing-clone-starter/
│           ├── SKILL.md
│           ├── README.md
│           ├── evals/
│           └── references/
│               ├── runtime-closure.md
│               ├── archetype-router.md
│               ├── archetype-anti-bleed.md
│               ├── archetype-evals.md
│               ├── library-first-retrieval.md
│               ├── evaluation/
│               ├── content-archetypes/
│               ├── built-in-profiles/
│               ├── profile-distillation/
│               └── profile-probe/
└── 02_素材库/
    └── writing-clone-starter-material-library/
        ├── README.md
        └── authors/
            ├── dankoe/
            ├── zhouzuoluo/
            ├── justinwelsh/
            ├── liurun/
            ├── liangning/
            └── xuehui/
```

你可以把它理解成：

- `.claude/skills/writing-clone-starter/` 是大脑
- `02_素材库/writing-clone-starter-material-library/` 是它会真正读取的材料层

如果你是第一次接触这类仓库，不要被 `.claude/` 和 `02_素材库/` 这两个目录名吓到。

你真正需要安装和保留的，也就这两块。

---

## 你安装完以后，Agent 实际会读什么

如果你只是正常使用这个 skill，最关键的入口是这几个文件：

- `/.claude/skills/writing-clone-starter/SKILL.md`
- `/.claude/skills/writing-clone-starter/README.md`
- `/.claude/skills/writing-clone-starter/references/runtime-closure.md`
- `/.claude/skills/writing-clone-starter/references/evaluation/`
- `/.claude/skills/writing-clone-starter/references/content-archetypes/`
- `/.claude/skills/writing-clone-starter/references/built-in-profiles/`
- `/02_素材库/writing-clone-starter-material-library/README.md`

如果你是维护者，再继续看：

- `references/profile-distillation/`
- `references/profile-probe/`

---

## 安装前提

开始前，你至少需要下面这两个条件：

1. 你有一个会被 Claude Code 或兼容 Agent 当作工作区的目录
2. 这个工作区允许你创建下面两个相对路径

```text
.claude/skills/writing-clone-starter/
02_素材库/writing-clone-starter-material-library/
```

最省心的安装方式，是**保持这两个路径原样**。

你当然可以改路径，但那会引入额外适配工作。这个仓库默认已经把路径收口好了，直接照着放，摩擦最低。

### 兼容场景

这份 README 默认按下面场景来写：

- 你在用 Claude Code
- 或者你在用一个能读文件、复制目录、执行基础 git 操作的兼容 Agent
- 你的工作区允许保留 `.claude/` 和 `02_素材库/` 这两个目录

如果你根本不用这类 Agent 工作流，这个仓库对你的价值会明显下降。

---

## 安装方式 A：自己手动安装

如果你打算自己装，按这个顺序做。

### 第 1 步：拉下仓库

```bash
git clone https://github.com/zjp1997720/writing-clone-starter.git
```

如果你不想用 git，也可以在 GitHub 页面直接下载 ZIP，然后手动解压。

### 第 2 步：把两块内容复制到你的工作区

你真正需要复制的，只有这两块：

```text
.claude/skills/writing-clone-starter/
02_素材库/writing-clone-starter-material-library/
```

如果你的工作区还没有 `.claude/skills/` 或 `02_素材库/`，直接创建即可。

### 第 3 步：确认目录结构

装完后，你的工作区至少应该长这样：

```text
<your-workspace>/
├── .claude/
│   └── skills/
│       └── writing-clone-starter/
└── 02_素材库/
    └── writing-clone-starter-material-library/
```

### 第 4 步：做最小验证

验证方式很简单：

- 打开 `/.claude/skills/writing-clone-starter/SKILL.md`
- 打开 `/02_素材库/writing-clone-starter-material-library/README.md`
- 确认这两个路径都存在

只要这两块在，仓库结构就对了。

### 第 5 步：做一次真正的试用

安装完成后，别停在“目录存在”。

直接给你的 Agent 一句最小测试话术：

```text
帮我写一篇关于 AI 内容获客的文章
```

如果它能正确进入强文章模式，并开始围绕正文组织内容，说明 starter 已经真正接上了。

---

## 安装方式 B：把仓库链接直接丢给你的 Agent

这是我更推荐的安装方式。

很多用户不是自己手动 copy，而是会把 GitHub 链接直接发给 Agent，让 Agent 帮自己装。这个仓库就是按这种场景写的。

你可以直接把下面这段 prompt 复制给你的 Agent：

如果你不想从 README 里复制长 prompt，也可以直接让 Agent 读取仓库根目录下这个文件：

- `AGENT_INSTALL_PROMPT.md`

```text
请帮我把这个仓库安装到我当前工作区：
https://github.com/zjp1997720/writing-clone-starter

安装要求：

1. clone 这个仓库到临时目录，不要直接污染我当前工作区
2. 只把下面两块内容安装到我当前工作区：
   - .claude/skills/writing-clone-starter/
   - 02_素材库/writing-clone-starter-material-library/
3. 如果我当前工作区里没有 .claude/skills/ 或 02_素材库/，请直接创建
4. 保持这两个相对路径原样，不要自作主张改成别的目录名
5. 安装完成后，请检查：
   - .claude/skills/writing-clone-starter/SKILL.md 是否存在
   - 02_素材库/writing-clone-starter-material-library/README.md 是否存在
6. 最后告诉我：
   - 你安装到了哪些路径
   - 是否发现冲突文件
   - 现在我可以怎样开始使用
```

如果你的 Agent 足够靠谱，这段 prompt 已经足够把仓库装好。

如果你的 Agent 比较笨，我建议你直接把：

1. 仓库链接
2. 这份 README
3. `AGENT_INSTALL_PROMPT.md`

三样一起丢给它。

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

### 你第一次使用时，推荐这样试

建议你按这个顺序试，不容易误判：

1. **先试强文章模式**
   - 例：`帮我写一篇关于 AI 内容获客的文章`
2. **再试高拟态模式**
   - 例：`像 Dan Koe 那样写一篇关于一人公司内容策略的文章`
3. **最后再试边界题**
   - 看它会不会自动降级，而不是硬装像

---

## 你大概会得到什么输出

默认情况下，最重要的交付是：

- `response.md`：正文成品

说明性材料通常会放在：

- `run_summary.md`：模式选择、带宽判断、降级原因等辅助说明

你可以把它理解成：

- `response.md` 是给读者看的
- `run_summary.md` 是给你自己和维护者看的

---

## 成熟度说明

这部分我不想藏着掖着，直接写清楚。

当前 6 个内置作者的成熟度并不完全相同：

- **Dan Koe、粥左罗**：更成熟
- **Justin Welsh**：已经到可试用 draft 水位
- **刘润、梁宁、薛辉**：在各自核心带宽内可用，但更窄

这不影响你安装和使用，只影响你对“像到什么程度”的预期。

---

## 如果你是维护者，而不是普通用户

你可能还会关心两件事：

1. **怎么新增或更新一个作者 profile**
2. **怎么验证一个 profile 到底稳不稳**

那你应该继续看：

- `references/profile-distillation/`
- `references/profile-probe/`

普通用户先不用碰这两块。

---

## 常见安装错误

如果你装完以后觉得“不像装好了”，通常是下面几种原因：

### 1. 只复制了 skill，没有复制素材库

结果就是：

- 规则在
- 外部材料不在
- 高拟态相关内容会明显变弱

### 2. 自作主张改了目录名

比如把：

- `.claude/skills/writing-clone-starter/`
- `02_素材库/writing-clone-starter-material-library/`

改成了别的名字。

这会直接增加路径适配成本。

### 3. 仓库放对了，但没有真的试跑一句话

“目录在”不等于“已经会用”。

最小验证永远不是看文件树，而是让 Agent 真写一句。

### 4. 把维护者模块当成普通用户入口

普通用户先用主入口，不要一上来就钻 `profile-distillation/` 或 `profile-probe/`。

那两块是维护工具，不是新手入口。

---

## 更新这个仓库时怎么做

如果后面这个仓库有新版本，你的更新方式也很简单：

1. 拉取仓库最新版本
2. 用新版覆盖这两块：
   - `.claude/skills/writing-clone-starter/`
   - `02_素材库/writing-clone-starter-material-library/`
3. 再跑一次最小验证

如果你是让 Agent 帮你更新，最稳的方式也是复用 `AGENT_INSTALL_PROMPT.md`，只是在 prompt 里把“安装”改成“更新”。

---

## 最后你该先看哪 3 个文件

如果你刚拿到仓库，只看这 3 个文件就够了：

1. `/.claude/skills/writing-clone-starter/SKILL.md`
2. `/.claude/skills/writing-clone-starter/README.md`
3. `/02_素材库/writing-clone-starter-material-library/README.md`

看完这三个，你就会知道：

- 这是什么
- 它怎么工作
- 它从哪儿取料
- 你该怎么开始用

如果你准备把仓库直接丢给 Agent，再加看第 4 个文件：

4. `/AGENT_INSTALL_PROMPT.md`

---

## License

MIT
