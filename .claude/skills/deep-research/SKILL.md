---
name: deep-research
description: 深度联网调研。对一个主题进行多源搜索、证据采集、对抗式验证，输出带引用的研究报告。触发词：「深度调研」「深度研究」「deep research」「帮我调研一下」「全面了解」「系统梳理」「文献综述」。不触发：简单问答、单次搜索、已知信息的总结、纯代码问题。
---

# 深度调研（Production 模式）

对任意主题进行多源搜索、证据采集、对抗式验证，输出带引用的研究报告。

改编自 Feynman CLI 的 7 步深度调研流水线，100% 覆盖其核心流程设计。

## 触发场景

- 用户说「帮我深度调研/研究/分析一下 X」
- 需要对一个陌生领域做系统性了解
- 需要产出有引用支撑的研究报告
- `/deep-research <topic>`

不触发：简单问答、单次搜索能回答的问题、已知信息的复述。

## 必需产出

每次运行必须在磁盘上留下以下文件：

| 文件 | 路径 | 说明 |
|------|------|------|
| 调研计划 | `01_项目/调研/.plans/<slug>.md` | 核心问题、搜索策略、任务账本、验证日志 |
| 草稿 | `01_项目/调研/.drafts/<slug>-draft.md` | 初始报告草稿 |
| 引用版 | `01_项目/调研/.drafts/<slug>-cited.md` | 含内联引用和验证后参考文献 |
| 最终报告 | `01_项目/调研/<YYYY-MM-DD>-<slug>.md` | 交付版本 |
| provenance | 报告末尾附带 | 来源清单 + 验证状态 |

slug 规则：从主题提取，小写短横线，去虚词，最多 5 个词。如 `ai-coding-tools-landscape`。

**降级规则**：任何环节失败，仍然写入 BLOCKED 或 partial 的最终产出和 provenance。永远不要只输出聊天文字。验证无法完成时用 `Verification: BLOCKED`。

## 7 步流程

详细执行指引见 `references/pipeline.md`。Agent 角色定义见 `agents/`。

### Step 1: Plan（规划）

**立即创建** `01_项目/调研/.plans/<slug>.md`，包含：
- 核心问题拆解
- 所需证据
- Scale 决策（simple / medium / complex）
- 任务账本（每个子任务的状态跟踪）
- 验证日志（逐步更新）
- 决策日志（关键判断的记录）

Scale 决策在分配任务前完成。狭窄的「X 是什么」类问题，必须用 lead-owned 直接搜索，**不要分配 researcher subagent**。

用 `mcp__Nowledge_Mem__memory_add` 存储计划（key: `deepresearch.<slug>.plan`），以便后续会话可恢复。

**Gate**：输出计划后暂停，等用户确认方向再继续。用户说「继续」「按这个来」「直接开始」视为已确认。

### Step 2: Scale（扩缩）

**直接搜索**适用于：
- 单一事实或狭窄问题（包括「X 是什么」类解释）
- 3-10 次工具调用可覆盖
- **禁止**把简单解释器膨胀成多 agent 调研

**Subagent** 仅在分解明显有帮助时使用：
- 2-3 项直接对比：2 个 researcher
- 广泛调研或多面主题：3-4 个 researcher
- 复杂多领域研究：4-6 个 researcher

### Step 3: Gather Evidence（采集证据）

**避免 PDF 解析崩溃**。不调用 `alpha_get_paper` 不抓取 `.pdf` URL，除非用户明确要求。优先用论文元数据、摘要、HTML 页面、官方文档和网页摘要。

**直接搜索模式**：
- 不 spawn researcher，自己搜索
- 最少 3 组不同角度的查询（定义/历史、机制/原理、现状/对比）
- 记录使用的搜索词到 `<slug>-research-direct.md`

**Subagent 模式**：
- 先写 per-researcher brief（如 `01_项目/调研/.plans/<slug>-T1.md`）
- 用 `Agent` tool 派生，每个 agent 读自己的 brief 文件
- 研究员角色定义见 `agents/researcher.md`
- 设置 `failFast: false`
- 研究员将发现写入磁盘文件，返回一句话摘要

### Step 4: Draft（起草）

**主 agent 自己写报告，不委托综合。** 保存到 `01_项目/调研/.drafts/<slug>-draft.md`。

包含：
- 执行摘要
- 按问题/主题组织的发现
- 有证据支撑的注意事项和分歧
- 开放问题
- **不编造**来源、结果、数据、benchmark、图片、图表、表格

**引用前清扫**：
- 每个关键断言、数字、图表必须映射到一个来源 URL、研究笔记、原始产物路径
- 移除或降级无支撑断言
- 标注推断为推断

### Step 5: Cite（引用核查）

**直接搜索模式**：自己做引用，验证 URL 可达，写入 `01_项目/调研/.drafts/<slug>-cited.md`。不 spawn verifier。

**Subagent 模式**：在草稿存在后运行 verifier agent。此步骤**必须**在 reviewer 之前完成。verifier 和 reviewer **不能**并行。

verifier 角色定义见 `agents/verifier.md`。

输出：`01_项目/调研/.drafts/<slug>-cited.md`。验证文件存在于磁盘。

### Step 6: Review（对抗审查）

**直接搜索模式**：自己审查引用版草稿。写 `<slug>-verification.md` 含 FATAL/MAJOR/MINOR。修正 FATAL。不 spawn reviewer。

**Subagent 模式**：只在 `<slug>-cited.md` 存在后运行 reviewer agent。

reviewer 角色定义见 `agents/reviewer.md`。

**FATAL 处理**：
- 修正后额外运行一轮 review
- MAJOR 记录在开放问题
- MINOR 接受

**修正方式**：不做一个巨大的 edit 调用做多个替换。小修正（1-3 处）用局部 edit。段落下重写或 >3 处实质性修正 → 读完整文件后 write 全文到 `<slug>-revised.md`。

最终候选：`<slug>-revised.md`（如存在），否则 `<slug>-cited.md`。

### Step 7: Deliver（交付）

1. 将最终候选复制到 `01_项目/调研/<YYYY-MM-DD>-<slug>.md`
2. 报告末尾附 provenance（格式见 `references/provenance-template.md`）
3. 给出 3-5 个备选标题
4. `mcp__Nowledge_Mem__memory_add` 存储关键发现（标签：`research,调研`）
5. 交付前验证所有必需产出存在于磁盘

## Agent 调用模式

| 级别 | Researcher | Verifier | Reviewer |
|------|-----------|----------|----------|
| simple | 不 spawn | 不 spawn | 不 spawn |
| medium | 不 spawn | 不 spawn | 不 spawn |
| complex | 2-6 个并行 | 1 个串行 | 1 个串行 |

所有 subagent 通过文件交接，不回传全文到上下文。

## 质量门控

交付前按 `evals/output-quality-check.md` 自检：
- 所有事实断言有引用
- 无孤立引用 / 无孤立来源
- FATAL = 0
- provenance 验证状态不为空

## 关键约束

- 所有产出写入 vault，遵循 workspace-boundary
- 事实断言必须有引用；无来源的断言标注为「主观判断」
- 不编造数据、案例、项目结果、引用来源
- Plan Gate 是强制环节，不能跳过
- 永远不要只输出聊天文字，必须有磁盘文件产出
