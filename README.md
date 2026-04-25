# content-twin-toolkit

> 大鹏开源的 **内容系统 + 分身系统** 工具链。基于 Claude Code 生态，围绕写作分身、素材挖掘与 Skill 持续优化展开。

这不是一个泛泛的「Claude Code 工具箱」。

这个仓库真正开源的，是我在真实工作里长期使用、长期迭代的那套系统：

- **内容系统**：从素材抓取、素材拆解，到文章生成、终稿审计
- **分身系统**：把写作能力、内容判断和审稿机制，沉淀成可复用的 skill / agent 资产

如果你也在做自己的内容系统、写作分身，或者正在用 Claude Code 搭自己的工作流，这个仓库会更有参考价值。

---

## 我是谁

我是大鹏（[@zjp1997720](https://github.com/zjp1997720)）。

我长期在一线真实使用 Claude Code、Agent、Skill、内容系统和分身系统，不是为了演示，而是为了把它们真正接进我的内容创作、商业表达和日常工作流里。

这个仓库里的东西，不是一次性 prompt，也不是漂亮 demo。

它们都是我在真实任务里一轮一轮跑出来、改出来、留下来的资产。

---

## 这个仓库现在包含什么

### 1. 写作系统

围绕内容生产，我现在公开了两条写作链路：

- **`writing-clone-starter`**  
  给还没有完整个人风格资产的人使用。默认先把文章写强，再在明确指定作者时进入高拟态模式。

- **`writing-clone-profile`**  
  给已经有个人风格资产、要按自己的声音写公众号 / 长文 / 自媒体内容的人使用。它不是“一个提示词”，而是一整套带上下文工程、风格资产、断言约束、节奏治理、终稿硬门的写作分身系统。

另外还包含：

- **`writing-gate-checker`**  
  在正式终稿前做独立硬门审计，不让 writer 自己写、自己审、自己放行。

- **`content-goldmine-gemini`**  
  把文章 / Clippings / 长文拆成可复用素材碎片。

- **`web-clipper`**  
  把网页文章抓取为本地 Markdown。

### 2. Skill 优化系统

- **`skill-optimizer`**

它不是把旧 skill 改得更“标准”，而是优先保护原合同，再做诊断、提案和受控优化。

---

## 目录结构

```text
.
├── .claude/
│   ├── skills/
│   │   ├── writing-clone-starter/    # 轻量写作入口：强文章模式 + 高拟态模式
│   │   ├── writing-clone-profile/    # 个人风格写作分身：Profile 驱动长文系统
│   │   ├── writing-gate-checker/     # 终稿前独立硬门审计
│   │   ├── content-goldmine-gemini/  # 素材拆解与金矿沉淀
│   │   ├── web-clipper/              # 网页抓取为本地 Markdown
│   │   └── skill-optimizer/          # Skill 诊断与优化工具
│   └── agents/
│       └── writing-gate-checker.md
├── 02_素材库/
├── assets/
│   └── zhijian-ai-wechat-card.png
├── LICENSE
└── README.md
```

---

## 为什么现在把 `writing-clone-profile` 开源出来

因为我越来越确定一件事：

写作 Skill 真正难的，不是“能不能写出一篇文章”，而是能不能把下面这些东西工程化：

- 文章值不值得读
- 第一屏有没有抓力
- 哪些内容 AI 可以补，哪些必须由人来提供
- 读者为什么愿意一直读下去
- 正式终稿之前，谁来做最后一道硬门审计

`writing-clone-profile` 就是围绕这些问题，一轮一轮迭代出来的。

它里面不是只有一个 `SKILL.md`，而是一整套配套资产：

- `Article Gravity Gate`
- `Human-only Brief Slots`
- `Reader Capture Audit`
- `Reader Momentum Map`
- `Human Feel & Flow Review`
- `Claim Ledger`
- `Module Budget`
- `Gate Check Contract`

如果你自己也在做写作 Skill、内容系统或者 Agent 工作流，这部分会很值得看。

---

## 写作系统怎么分工

### `writing-clone-starter`

适合：

- 还没有完整个人风格资产
- 想先写出一篇强文章
- 想体验某个内置作者方向

### `writing-clone-profile`

适合：

- 已经有自己的表达方向
- 想按自己的声音写
- 不满足于“像教程”，而是希望文章更像真人、更有节奏、更有主线

### `writing-gate-checker`

适合：

- 已经有 candidate 稿
- 准备正式产出 final
- 想让最终稿经过独立硬门，而不是 writer 自放行

---

## 安装

### 方式一：直接 clone

```bash
git clone https://github.com/zjp1997720/content-twin-toolkit.git
```

然后把你需要的目录复制到自己的 Claude Code 工作区。

### 方式二：丢给 Agent

你也可以把仓库链接直接丢给 Claude Code，让它按 README 帮你安装你需要的那部分。

---

## 使用前提

- 需要 [Claude Code](https://claude.ai/code) 或兼容的 Agent 运行时
- `content-goldmine-gemini` 依赖本地 Gemini CLI
- `writing-clone-profile` 推荐配合 `nmem` / Obsidian CLI / 本地素材库一起使用

---

## 路径约定

这个仓库保留了我自己真实使用时的项目结构约定，比如：

- `01_项目/`
- `02_素材库/`
- `03-Reviews/`
- `deepsight_vault`

如果你只是学习思路，直接阅读就可以。

如果你要真正装到自己的工作区里，建议把这些路径和 vault 名替换成你自己的目录结构。

---

## 我对这套仓库的基本看法

> **Skill 是资产，Prompt 是消耗品。**
>
> **上下文厚度 > 提示词技巧。**
>
> **内容输出不是单点 prompt，而是一套系统。**

这个仓库里的工具，都是围绕这三句话长出来的。

---

## 欢迎关注我的公众号：智见AI

如果你对这些方向感兴趣：

- Claude Code
- Agent 工作流
- 分身系统
- 内容系统
- 写作分身
- 自媒体与 AI 的真实结合方式

欢迎关注我的公众号 **「智见AI」**。

我会持续分享：

- 我正在真实使用的 Skill / Agent / 工作流
- 我怎么优化自己的内容系统和分身系统
- 我在一线跑出来的经验、踩坑和判断

![智见AI 公众号二维码](assets/zhijian-ai-wechat-card.png)

---

## License

MIT
