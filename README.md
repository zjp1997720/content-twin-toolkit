# claude-code-toolkit

> A content-output and digital-twin toolkit built for Claude Code.

大鹏（[@zjp1997720](https://github.com/zjp1997720)）在 Claude Code 生态下真实使用并持续维护的一套**内容输出 + 分身系统**工具链。

它不是泛泛的“Claude Code 工具箱”，而是围绕三件事展开：

- **写作分身**：把想法、素材和个人表达能力，收束成可直接产出的写作系统
- **顾问天团**：把不同顾问视角接进决策与内容前置思考
- **Skill 优化器**：让整套 skill 体系可以持续维护、诊断、优化，而不是越用越乱

这不是教程，是可以直接装进你的 Claude Code 工作区运行的资产。

---

## 它解决什么问题

### 1. 写作分身

你没有完整的个人风格资产，但现在就想写出一篇结构清晰、可以直接发布的文章。

### 2. 顾问天团

你面对一个商业 / 产品 / 人生决策，想同时听到芒格、乔布斯、刘润、Naval……这些人会怎么分析。

### 3. Skill 持续优化

当你自己的 skill 越来越多时，你需要一套**不改坏原合同、又能逐轮优化**的方法，去维护 trigger、结构、边界和表现。

这三层可以独立使用，也可以串起来：

```text
顾问天团 → 写作分身 → Skill 优化器
```

先把问题想清楚，再把洞察写出来，最后把整套系统继续优化下去。

---

## 目录结构

```text
.
├── .claude/
│   ├── skills/
│   │   ├── writing-clone-starter/    # 写作分身主入口
│   │   ├── content-goldmine-gemini/  # 素材挖掘工具
│   │   ├── web-clipper/              # 网页抓取工具
│   │   ├── consult/                  # 顾问天团主入口
│   │   ├── consult-team-rules/       # 圆桌模式协作规则
│   │   ├── nuwa-consult-advisor/     # 新顾问蒸馏工具
│   │   └── skill-optimizer/          # Skill 诊断与优化工具
│   └── agents/
│       ├── consult-munger.md         # 查理·芒格
│       ├── consult-jobs.md           # 史蒂夫·乔布斯
│       ├── consult-naval.md          # Naval Ravikant
│       ├── consult-liurun.md         # 刘润
│       ├── consult-liangning.md      # 梁宁
│       ├── consult-luozhenyu.md      # 罗振宇
│       ├── consult-xuehui.md         # 薛辉
│       └── consult-runyu.md          # 润宇
├── 02_素材库/                        # writing-clone-starter 运行时素材库
├── LICENSE
└── README.md
```

---

## 写作分身

### 包含什么

| 工具 | 说明 |
| --- | --- |
| `writing-clone-starter` | 主入口：强文章模式 + 高拟态模式（内置 6 个作者） |
| `content-goldmine-gemini` | 把文章 / Clippings 拆成可复用素材碎片 |
| `web-clipper` | 把网页文章抓取为本地 Markdown |

### 两种写作模式

**强文章模式**（默认）：不指定作者，按 4 种内容原型自动路由：观点拆解型 / 方法教程型 / 案例复盘型 / 认知升级型。目标是写出能站住脚、结构清晰、可直接发布的文章。

**高拟态模式**：指定内置作者，按其方向写。内置 6 位作者：Dan Koe、粥左罗、Justin Welsh、刘润、梁宁、薛辉。如果题目超出作者带宽，自动降级回强文章模式，不硬凹。

### 快速试用

```text
帮我写一篇关于 AI 内容获客的文章
```

```text
像 Dan Koe 那样写一篇关于一人公司内容策略的文章
```

### 维护者工具链

如果你想扩充作者 profile，完整维护链是：

```text
web-clipper → content-goldmine-gemini → writing-clone-starter（profile 蒸馏模式）
```

> `content-goldmine-gemini` 依赖本地 Gemini CLI，首次使用需要安装并登录。

---

## 顾问天团

### 包含什么

| 工具 | 说明 |
| --- | --- |
| `consult` | 主入口：支持单聊、并行汇总、圆桌辩论三种模式 |
| `consult-team-rules` | 圆桌模式的协作规则（`discuss` 模式专用） |
| `nuwa-consult-advisor` | 蒸馏新顾问的工具：输入公开资料，输出可接入 `consult` 的 subagent |

### 8 位内置顾问

| 顾问 | 核心视角 |
| --- | --- |
| 查理·芒格 | 多元思维模型、逆向思考、激励分析 |
| 史蒂夫·乔布斯 | 产品哲学、聚焦、颠覆性决策 |
| Naval Ravikant | 杠杆思维、长期游戏、个人战略 |
| 刘润 | 商业模式、定价策略、交易结构 |
| 梁宁 | 产品思维、用户需求洞察、AI 产品策略 |
| 罗振宇 | 宏观趋势判断、AI 时代定位 |
| 薛辉 | 短视频运营、流量获取、账号变现 |
| 润宇 | 自媒体战略、IP 商业化、私域运营 |

### 三种使用模式

**单聊**：和某一位顾问深入对话。

```text
/consult @芒格 我现在的定价策略是否合理？
```

**并行汇总**：同一个问题，多位顾问同时给出独立观点，汇总对比。

```text
/consult @芒格 @刘润 @Naval 帮我分析这个商业模式的核心风险
```

**圆桌讨论**：顾问之间互相辩论，观点碰撞。

```text
/consult --discuss @芒格 @乔布斯 @梁宁 关于 AI 产品是否应该先做 B 端
```

### 新增顾问

用 `nuwa-consult-advisor` 蒸馏任何人：

```text
帮我把段永平蒸馏成一个新的 consult advisor
```

输入公开资料（文章、演讲、书籍），输出即可直接接入 consult 系统的 subagent 文件。

---

## Skill 优化器

### 包含什么

| 工具 | 说明 |
| --- | --- |
| `skill-optimizer` | 合同优先、带验证层的 Skill 优化器，用于诊断、提案、实验和保守保留 |

### 它做什么

`skill-optimizer` 不是把旧 skill 一股脑“改标准化”，而是：

1. 先冻结原 Skill 的核心合同
2. 再识别真正的 failure mode
3. 再给出 hypothesis-driven proposal
4. 经批准后做单轮受控优化
5. 最后用 replay / dry-run / human review 做保守验证

它适合：

- skill 触发不准
- 结构越来越乱
- 想优化但不想把原意改坏
- 想给自己的 skill 系统加一层持续维护能力

### 快速试用

```text
帮我优化这个 skill，但不要改掉它原本的核心用途
```

```text
先诊断这个 skill 的问题，再给我两套带验证思路的优化方案
```

### 这和 Darwin 式自动优化的区别

这个仓库里的 `skill-optimizer` 走的是：

- **contract-first**
- **proposal before apply**
- **evidence before keep**

它会使用验证层，但不会假装一个总分能替代复杂判断，尤其是写作、风格、人格类 skill。

---

## 安装

### 方式一：手动复制

```bash
git clone https://github.com/zjp1997720/claude-code-toolkit.git
```

把你需要的目录复制到你的 Claude Code 工作区：

- 写作分身：`.claude/skills/writing-clone-starter/` + `02_素材库/writing-clone-starter-material-library/`
- 顾问天团：`.claude/skills/consult/` + `.claude/skills/consult-team-rules/` + `.claude/agents/consult-*.md`
- 蒸馏新顾问：`.claude/skills/nuwa-consult-advisor/`
- Skill 优化器：`.claude/skills/skill-optimizer/`

### 方式二：丢给 Agent

把仓库链接丢给你的 Claude Code Agent，让它按 README 自动安装到你的工作区。

---

## 使用前提

- 需要 [Claude Code](https://claude.ai/code) 或兼容的 Agent 运行时
- `content-goldmine-gemini` 需要本地安装 Gemini CLI 并完成登录

---

## 设计理念

> **Skill 是资产，Prompt 是消耗品。**
> **上下文厚度 > 提示词技巧。**
> **内容输出不是单点 prompt，而是分身系统。**

这里的每个工具都是从真实任务中跑出来的，不是为了演示而造的。你用的越多，上下文积累越厚，工具越顺手。

---

## 这个仓库更准确的名字是什么

`claude-code-toolkit` 作为当前仓库名能用，但偏笼统。

如果按这套仓库真实在做的事来命名，我更推荐：

### `content-twin-toolkit`

原因：

- `content`：点明它主要围绕内容输出，不是泛工具集合
- `twin`：点明它不是单个 prompt，而是分身系统
- `toolkit`：保留“可组合、可扩展”的工具链感

如果你之后准备正式改仓库名，我建议优先考虑这个名字。

可选备选名：

- `content-clone-toolkit`
- `digital-twin-content-kit`
- `content-agent-workbench`

---

## 持续更新

这个仓库随我个人工具链演进持续同步。

关注进展：Watch 这个仓库，或关注公众号 **「智见AI」**。

---

## License

MIT
