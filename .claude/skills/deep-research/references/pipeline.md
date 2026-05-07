# 7 步流水线执行指引（Production 模式）

本文档是 SKILL.md 中 7 步流程的详细执行指引。按需读取，不要一次性加载。

改编自 Feynman CLI `prompts/deepresearch.md`，100% 覆盖其核心流程设计。

---

## Step 1: Plan

### 行动

**立即**创建 `01_项目/调研/.plans/<slug>.md`。不要先解释，不要问确认，第一步就是工具调用创建目录和写计划文件。

### 计划内容

```markdown
# 调研计划：<主题>

## 核心问题
1. ...
2. ...

## 所需证据
- [ ] 证据类型 1
- [ ] 证据类型 2

## Scale 决策
simple / medium / complex

## 理由
（为什么选这个级别）

## 任务账本
| # | 任务 | 负责 | 状态 | 输出文件 |
|---|------|------|------|---------|
| T1 | ... | lead / researcher-N | pending | ... |

## 验证日志
| 时间 | 检查项 | 结果 |
|------|--------|------|
| ... | ... | pass / fail / blocked |

## 决策日志
| 时间 | 决策 | 理由 |
|------|------|------|
| ... | ... | ... |
```

### Scale 决策标准

在分配任务之前决定 Scale。Scale 决策影响后续所有步骤的执行方式。

**直接搜索**（simple/medium）：
- 单一事实或狭窄问题，包括「X 是什么」类解释器
- 3-10 次工具调用可覆盖
- **禁止**把简单解释器膨胀成多 agent 调研
- 「X 是什么」类问题**必须不** spawn researcher，除非用户明确要求全面覆盖、当前格局、benchmark 或生产部署

**Subagent**（complex）：
- 2-3 项直接对比 → 2 个 researcher
- 广泛调研或多面主题 → 3-4 个 researcher
- 复杂多领域研究 → 4-6 个 researcher

### 记忆存储

用 `mcp__Nowledge_Mem__memory_add` 存储计划，key 为 `deepresearch.<slug>.plan`，以便后续会话可恢复。

### Gate

输出计划后暂停。等用户确认。用户说「继续」「按这个来」「直接开始」视为已确认。用户可能调整方向、追加子问题、指定信源。

---

## Step 2: Scale

根据计划中的 Scale 决策执行：

### 直接搜索模式（simple/medium）

不 spawn 任何 subagent。主 agent 完成所有步骤。
- simple：2-3 次搜索
- medium：5-8 次搜索，多轮

### Subagent 模式（complex）

1. 先写 per-researcher brief（如 `01_项目/调研/.plans/<slug>-T1.md`）
2. 每个 brief 包含：该研究员负责的子问题、搜索方向、输出文件路径
3. 用 `Agent` tool 派生 researcher，每个读自己的 brief 文件
4. Agent 调用模式：

```
Agent({
  description: "Research <sub-topic>",
  prompt: "你是调研研究员。读 `01_项目/调研/.plans/<slug>-T1.md`，按指示搜索并将发现写入 `<slug>-research-web.md>`。角色定义见 `agents/researcher.md`。",
  subagent_type: "general-purpose"
})
```

5. 研究员角色定义见 `agents/researcher.md`
6. 设置 `failFast: false`
7. 研究员之间可以并行

---

## Step 3: Gather Evidence

### PDF 避险规则

**避免 PDF 解析崩溃**。不调用 `alpha_get_paper`，不抓取 `.pdf` URL，除非用户明确要求。优先用：
- 论文元数据和摘要
- HTML 页面
- 官方文档
- 网页摘要

如果只有 PDF 存在，从搜索元数据中引用 PDF URL，标注「全文 PDF 解析已 block」。

### 直接搜索执行规则

- 最少 3 组不同角度的查询：
  - 定义/历史
  - 机制/原理
  - 当前用法/对比（如适用）
- 记录使用的搜索词到 `<slug>-research-direct.md`
- 中英文关键词都要搜
- 搜索 10+ 结果时先按标题/摘要筛选

### 搜索工具选择

按以下优先级：

1. `WebSearch` — 通用搜索（主力）
2. `mcp__web_reader__webReader` — 深度抓取重要 URL
3. `WebSearch "topic site:arxiv.org"` + `alpha get <ID>` — 论文搜索
4. `mcp__Nowledge_Mem__memory_search` — 历史调研记忆

### 证据记录格式

```markdown
## 证据表

| # | 来源 | URL | 关键断言 | 类型 | 可信度 |
|---|------|-----|---------|------|--------|
| 1 | 作者/标题 | URL | 1-3 句 | 一手/二手/自报 | 高/中/低 |
```

可信度判断：
- **高**：官方文档、论文、权威媒体
- **中**：博客、技术社区、KOL 观点
- **低**：论坛帖子、无署名文章

### 信源质量分级（改编自 Feynman researcher）

| 等级 | 类型 | 处理 |
|------|------|------|
| 优先 | 学术论文、官方文档、一手数据集、验证过的 benchmark、政府文件、权威新闻、专家技术博客、官方厂商页面 | 直接引用 |
| 接受（附说明） | 有引用的二手来源、行业出版物 | 标注「二手来源」 |
| 降低优先级 | SEO 列表文、无日期博客、内容聚合器、无一手链接的社交媒体 | 仅在无更优来源时使用 |
| 拒绝 | 无作者无日期、AI 生成无一手支撑 | 不引用 |

初始结果偏向低质量时，用 domainFilter 重新搜索权威域名。

### 证据采集后

更新计划中的任务账本和验证日志。如果研究失败，记录具体什么失败了，继续写 BLOCKED 或 partial 草稿。

---

## Step 4: Draft

### 行动

**主 agent 自己写报告，不委托综合。** 保存到 `01_项目/调研/.drafts/<slug>-draft.md`。

### 报告结构

```markdown
# [标题]

> 摘要：200 字以内的核心发现概述。读完摘要就能知道全文要点。

## 1. 背景
为什么这个主题值得调研。调研范围界定。

## 2. 核心发现

### 2.1 [子问题 1]
基于证据的论述。每个事实断言标注 [^N]。

### 2.2 [子问题 2]
...

## 3. 关键争议 / 不同观点
如果存在争议，呈现各方观点及其依据。不偏袒。

## 4. 开放问题
证据不足以回答的问题。

## 5. 结论与建议
基于发现的结论。可执行的下一步建议。

---

## 参考文献
[^1]: 作者/机构, "标题", URL
[^2]: ...
```

### 引用前清扫

写完草稿后、进入 Cite 阶段前，先做一轮自清扫：
- 每个关键断言、数字、图表、表格、benchmark 必须映射到一个来源 URL、研究笔记、原始产物路径或命令输出
- 移除或降级无支撑断言
- 标注推断为推断
- **不编造**来源、结果、数据、benchmark、图片、图表、表格

### 降级模式

部分研究员任务失败时：
- 在对应章节标注 `[数据缺失]`
- 在开放问题中说明缺了什么
- 不用其他章节的内容填充

---

## Step 5: Cite

### 直接搜索模式

自己做引用：
- 验证可达的 HTML/文档 URL
- 将 `<slug>-draft.md` 复制/改写为 `<slug>-cited.md`
- 添加内联引用和 Sources 章节
- **不 spawn verifier**

### Subagent 模式

在草稿存在后运行 verifier agent。此步骤**必须在 reviewer 之前完成**。

```
Agent({
  description: "Verify citations",
  prompt: "你是引用核查员。给 `01_项目/调研/.drafts/<slug>-draft.md` 添加内联引用，验证每个 URL，将完整引用版写入 `01_项目/调研/.drafts/<slug>-cited.md`。研究文件在 `01_项目/调研/` 目录下。角色定义见 `agents/verifier.md`。",
  subagent_type: "general-purpose"
})
```

**verifier 和 reviewer 不能并行。**

### Verifier 完成后

验证 `<slug>-cited.md` 存在于磁盘。如果 verifier 写到了其他位置，找到并移动到正确路径。

### Verifier 核心规则（摘要）

- 每个事实断言锚定到具体来源
- 验证每个 URL 可达且内容匹配
- 构建统一编号的 Sources 章节
- 移除无法溯源的断言
- 验证含义而非主题匹配
- 不使用「已验证」「已确认」等词除非有实际证据

详细规则见 `agents/verifier.md`。

---

## Step 6: Review

### 直接搜索模式

自己审查引用版草稿：
- 写 `<slug>-verification.md` 含 FATAL / MAJOR / MINOR
- 修正 FATAL
- **不 spawn reviewer**

### Subagent 模式

只在 `<slug>-cited.md` 存在后运行 reviewer agent：

```
Agent({
  description: "Adversarial review",
  prompt: "你是对抗审查员。审查 `01_项目/调研/.drafts/<slug>-cited.md`，标记无支撑断言、逻辑漏洞、单来源关键断言和过度自信。这是一次验证，不是同行评审。将审查报告写入 `01_项目/调研/<slug>-verification.md`。角色定义见 `agents/reviewer.md`。",
  subagent_type: "general-purpose"
})
```

### FATAL 处理

Reviewer 标记 FATAL 时：
1. 修正 FATAL 问题
2. 额外运行一轮 review
3. MAJOR 记录在开放问题
4. MINOR 接受

**修正方式**：
- 小修正（1-3 处简单修正）→ 局部 edit
- 段落重写、表格重写、>3 处实质性修正 → 读完整文件后 write 全文到 `<slug>-revised.md`

### 最终候选

`<slug>-revised.md`（如存在），否则 `<slug>-cited.md`。

### Reviewer 核心规则（摘要）

- 审查 5 个维度：事实准确性、完整性、逻辑连贯性、信源质量、偏见检测
- 分 3 级：FATAL / MAJOR / MINOR
- FATAL > 0 → FAIL，必须退回
- 不重写报告，只指出问题

详细规则见 `agents/reviewer.md`。

---

## Step 7: Deliver

### 交付步骤

1. 将最终候选复制到 `01_项目/调研/<YYYY-MM-DD>-<slug>.md`
2. 报告末尾附 provenance 清单（格式见 `references/provenance-template.md`）
3. 给出 3-5 个备选标题
4. `mcp__Nowledge_Mem__memory_add` 存储关键发现（标签：`research,调研`）
5. **交付前**验证所有必需产出存在于磁盘

### provenance 清单

```markdown
---

## 来源清单（Provenance）

- **日期：** YYYY-MM-DD
- **研究轮次：** N
- **咨询来源数：** N
- **接受来源数：** N
- **拒绝来源数：** N（死链、不可验证、已移除）
- **验证状态：** PASS / PASS WITH NOTES / BLOCKED
- **计划文件：** 01_项目/调研/.plans/<slug>.md
- **研究文件：** [列出使用的研究文件]

| # | 来源 | URL | 可信度 | 核查状态 |
|---|------|-----|--------|---------|
| [^1] | ... | ... | 高/中/低 | verified / mismatch / broken |

### 核查说明
- verified：URL 可访问，引用内容与原文一致
- mismatch：URL 可访问，但引用内容与原文有出入
- broken：URL 无法访问（已替换或移除）

### 未覆盖的已知局限
- ...
```

### 记忆落库

```bash
mcp__Nowledge_Mem__memory_add:
  content: "关于 [主题] 的调研发现：<3-5 句核心结论>"
  title: "调研：[主题]"
  labels: "research,调研"
  importance: 0.7
```

### 备选标题

给出 3-5 个不同风格的标题：
- 至少 1 个信息型（直接概括）
- 至少 1 个悬念型（引发好奇）
- 至少 1 个观点型（带判断）

### 响应格式

最终回复简洁：链接最终文件、provenance、和任何 blocked 检查项。

---

## 文件命名规范

每次运行的所有文件使用同一个 slug 前缀，防止并发冲突：

| 文件 | 命名 |
|------|------|
| 计划 | `01_项目/调研/.plans/<slug>.md` |
| 研究员 brief | `01_项目/调研/.plans/<slug>-T1.md` |
| 直接搜索笔记 | `<slug>-research-direct.md` |
| 研究员产出 | `<slug>-research-web.md`, `<slug>-research-papers.md` |
| 草稿 | `01_项目/调研/.drafts/<slug>-draft.md` |
| 引用版 | `01_项目/调研/.drafts/<slug>-cited.md` |
| 修正版 | `01_项目/调研/.drafts/<slug>-revised.md` |
| 审查报告 | `<slug>-verification.md` |
| 最终报告 | `01_项目/调研/<YYYY-MM-DD>-<slug>.md` |

**永远不使用** `research.md`、`draft.md`、`brief.md`、`summary.md` 等通用名。并发运行不能冲突。

---

## 交接规则（改编自 Feynman AGENTS.md）

- 主 agent 负责：规划、委托、综合、交付
- 只在分解明显有帮助时使用 subagent，不为琐碎工作 spawn
- 优先文件交接，不把大中间结果回传到上下文
- 主 agent 负责核对任务完成。Subagent 不能静默跳过分配的任务
- 关键断言需要至少一轮对抗验证。交付前修正 FATAL，或明确标注
