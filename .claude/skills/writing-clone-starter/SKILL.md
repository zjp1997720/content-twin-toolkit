---
name: writing-clone-starter
description: |
  新手写作双模式 Skill。面向学员和用户，不要求先有个人 profile、长期记忆沉淀或代表作。
  当用户想“先写出一篇很强的文章”，但自己没有足够素材、经历或风格资产时，优先使用这个 skill。
  当用户明确说想“像某个内置作者写”，尤其是当前内置作者 Dan Koe、粥左罗、Justin Welsh、刘润、梁宁、薛辉时，也应使用这个 skill。
  即使用户没有直接说“强文章模式”或“高拟态模式”，只要意图是“低门槛起稿”或“先体验某个作者方向”，都应触发本 skill。
  不要在“用户已经有自己的成熟风格资产、要像自己写”的场景使用它；那是 `writing-clone-profile` 的职责。
  当前已落地范围包括：共同标准、强文章首批原型、Dan Koe / 粥左罗 / Justin Welsh / 刘润 / 梁宁 / 薛辉 正式作者 profile 雏形、runtime 收口协议。硬约束：本 skill 不使用 form-normalized-anchors。
---

# Writing Clone Starter

## 这是什么

这不是对 `writing-clone-profile` 或 `writing-clone-lite` 的覆盖修改。

这是一个新的用户入口，专门处理两类场景：

1. 用户没有自己的代表作、记忆资产、长期沉淀，但想先写出强文章
2. 用户想显式切到某个内置作者方向，先获得高拟态体验

一句话：

**这个 skill 解决的是“先写出来”，不是“先证明你已经有完整个人风格资产”。**

## 什么时候用

出现下面这些信号时，优先使用本 skill：

- 用户只有一个主题、一个方向、一个粗糙想法，但想先写成强稿
- 用户明确说自己没有多少个人经历、素材、记忆沉淀可调
- 用户想先低门槛体验系统能力
- 用户明确说想“按 Dan Koe 那种感觉写”
- 用户明确说想“按粥左罗那种感觉写”
- 用户明确说想“按 Justin Welsh / 刘润 / 梁宁 / 薛辉 那种感觉写”
- 用户要的是“先写出强稿”，不是“先像我自己写”

## 什么时候不用

出现下面这些信号时，不要用本 skill：

- 用户已经有成熟的个人风格资产，要继续像自己写
- 用户已经处在 `writing-clone-profile` / `writing-clone-lite` 的既有流程里
- 当前任务不是写文章，而是继续研究系统或扩素材

这种情况下，优先回到：

- `writing-clone-profile`
- `writing-clone-lite`
- 或对应的研究 / 素材 skill

## 当前已落地范围

当前已落地三层资产：

- `references/evaluation/`：共同标准
- `references/content-archetypes/`：强文章模式首批 4 个原型
- `references/built-in-profiles/dankoe/`：Dan Koe 正式作者 profile 雏形
- `references/built-in-profiles/zhouzuoluo/`：粥左罗正式作者 profile 雏形
- `references/built-in-profiles/justinwelsh/`：Justin Welsh 正式作者 profile 雏形
- `references/built-in-profiles/liurun/`：刘润正式作者 profile 雏形
- `references/built-in-profiles/liangning/`：梁宁正式作者 profile 雏形
- `references/built-in-profiles/xuehui/`：薛辉正式作者 profile 雏形

成熟度说明：

- `dankoe/`、`zhouzuoluo/`：证据层相对更厚，是当前 starter 里更成熟的试点作者
- `justinwelsh/`：已达到当前 starter 架构里的可试用 draft 水位
- `liurun/`、`liangning/`、`xuehui/`：当前仍属于窄带宽 `formal-profile-draft`，更适合在各自核心带宽内试用，不应默认理解为与前两位同成熟度

并已补上一层：

- `references/runtime-closure.md`：统一运行顺序与输出合同
- `references/profile-distillation/`：内置人物 profile 蒸馏模块（维护者路径）

完整动作库和完整运行时自动化仍不在这一轮实现范围内。

## 当前未落地范围

这一版明确**还没有**：

- 完整动作库大全
- 更大规模的多作者 profile 池
- 完整 runtime 自动路由实现
- benchmark 系统升级

也就是说，这一版已经把边界、标准、强文章原型初版和首批内置作者 profile 放到本地了，但还不是完整功能版。

## 模式定义

### 模式 A：强文章模式

- 默认模式
- 不绑定作者
- 优先回答：这篇文章怎样最容易写得强、完整、可发
- 是 starter 的默认主工作路径
- 当前阶段以共同标准为验收基线

### 模式 B：高拟态模式

- 只有用户明确指定作者时才进入
- 优先回答：这篇文章怎样尽量像指定作者本人
- 当前内置作者：Dan Koe、粥左罗、Justin Welsh、刘润、梁宁、薛辉
- 如果主题超出作者原生议题带宽，必须提醒并自动降级到强文章模式

## 运行时统一判定顺序

运行时默认按下面顺序处理，不要跳步：

1. 先看用户是否显式指定作者
2. 如果指定作者，先尝试进入高拟态模式
3. 进入高拟态前，必须先做带宽判断
4. 如果命中弱带宽或触发降级条件，直接切回强文章模式
5. 如果未指定作者，直接进入强文章模式
6. 进入强文章模式后，再判原型
7. 命中原型后，再按取料规则和 anti-bleed 约束组织正文

更详细的运行协议见：`references/runtime-closure.md`

## 最小路由原则

### 默认路由

- 用户没有指定作者：默认按**强文章模式**理解
- 用户明确指定 Dan Koe：进入**高拟态模式**
- 用户明确指定粥左罗：进入**高拟态模式**
- 用户明确指定 Justin Welsh：进入**高拟态模式**
- 用户明确指定刘润：进入**高拟态模式**
- 用户明确指定梁宁：进入**高拟态模式**
- 用户明确指定薛辉：进入**高拟态模式**

其中要牢记：

- 强文章不是降级 fallback，而是默认主路径
- 高拟态是显式分支，不是默认并列主入口

### 降级原则

如果主题明显超出指定作者的原生议题带宽：

1. 明确提醒
2. 自动切回强文章模式
3. 不硬装像，不输出伪拟态稿

## 文章级输出合同

### 交付优先级

默认先交付：

- `response.md`：可直接发布或直接评估的正文成品

说明性材料只放在：

- `run_summary.md`：记录模式选择、带宽判断、读取依据、降级原因

不要反过来让 `run_summary.md` 比 `response.md` 更能体现模式差异。

### 正文与说明的边界

默认不要把下面这些内容写进正文：

- “我现在按 skill 规则切到某模式”
- “因为 topic-bandwidth 这样规定，所以……”
- “我读取了哪些 profile 资产”
- 任何 system note 风格的解释

默认情况下，降级提醒也不要进入 `response.md`。优先把降级原因留在 `run_summary.md`。

只有在任务本身明确要求“向用户解释为什么没有继续按该作者写”时，才允许在正文外提供单独说明；默认的文件交付仍应是干净成稿。正文应直接从标题或正文第一段开始，而不是从系统解释开始。

### 模式差异必须落在正文层

最终验收不要只看 `run_summary.md`。

更重要的问题是：

> 只看 `response.md`，能不能感到这篇稿子走的是哪类模式。

如果正文几乎看不出模式差异，只能靠说明文件解释为什么不同，那说明输出合同还没真正成立。

## References 读取顺序

### 强文章模式

1. `references/runtime-closure.md`
2. `references/evaluation/strong-article-rubric.md`
3. `references/archetype-router.md`
4. `references/content-archetypes/<命中的原型>.md`
5. `references/library-first-retrieval.md`
6. `references/archetype-anti-bleed.md`
7. 用户当前主题与限制条件

### 高拟态模式（指定作者）

1. `references/runtime-closure.md`
2. `references/evaluation/high-likeness-rubric.md`
3. `references/built-in-profiles/<指定作者>/profile-card.md`
4. `references/built-in-profiles/<指定作者>/worldview.md`
5. `references/built-in-profiles/<指定作者>/recurring-moves.md`
6. `references/built-in-profiles/<指定作者>/taboo-moves.md`
7. `references/built-in-profiles/<指定作者>/snippet-bank.md`
8. `references/built-in-profiles/<指定作者>/topic-bandwidth.md`
9. `references/built-in-profiles/<指定作者>/hard-signals.md`
10. `references/built-in-profiles/<指定作者>/contrastive-pairs.md`
11. `references/built-in-profiles/<指定作者>/false-positive-signals.md`
12. `references/built-in-profiles/<指定作者>/acceptance-checklist.md`
13. `references/built-in-profiles/<指定作者>/raw-corpus/README.md`

原则：

- 强文章模式先读标准，再定原型，再取料
- 高拟态模式先读标准，再读作者资产
- 所有模式共用同一条运行顺序，不要各自临场发挥
- 不读取 `form-normalized-anchors/`
- 不把旧 personal profile 资产混进来

## 当前可用资产

- 运行协议：`references/runtime-closure.md`
- 强文章标准：`references/evaluation/strong-article-rubric.md`
- 强文章原型：`references/content-archetypes/`
- 强文章路由：`references/archetype-router.md`
- 强文章取料：`references/library-first-retrieval.md`
- 强文章防串味：`references/archetype-anti-bleed.md`
- 强文章最小测试集：`references/archetype-evals.md`
- 高拟态标准：`references/evaluation/high-likeness-rubric.md`
- Dan Koe profile：`references/built-in-profiles/dankoe/`
- 粥左罗 profile：`references/built-in-profiles/zhouzuoluo/`
- Justin Welsh profile：`references/built-in-profiles/justinwelsh/`
- 刘润 profile：`references/built-in-profiles/liurun/`
- 梁宁 profile：`references/built-in-profiles/liangning/`
- 薛辉 profile：`references/built-in-profiles/xuehui/`

## Progressive Disclosure

不要一上来把整个 skill 的所有想法都搬进上下文。

当前这版的读取原则非常简单：

- 只读当前模式真正需要的那几份文档
- 先读 runtime-closure，再读当前模式对应资产
- 强文章模式先抓共同标准，再抓原型相关文件
- 高拟态模式才去读对应作者的 profile 资产
- 当前没有实现的模块，不要假装已经存在

## 内置维护模块（非普通用户入口）

starter 当前还内置了一组只服务维护者的内部参考文件：

- `references/profile-distillation/`
- `references/profile-probe/`

它解决的是：

- 新增一个内置作者 profile
- 更新已有作者 profile
- 审计某个作者 profile 的证据质量
- 验证某个 built-in profile 是否真的能稳定产稿
- 用 blind probe / 冷评判断 profile 是否达到 stable 90 readiness

它**不是**普通学员默认触发路径。

不要在用户只是想“写一篇文章”时切进这个模块。

其中要区分：

- `profile-distillation/`：生 profile
- `profile-probe/`：验 profile

## 模式分层要求（surface plane）

### 强文章模式

正文目标是：

- 更像高质量中文强稿
- 把问题讲明白，并推到判断或行动
- 同题不同原型，正文骨架要能明显分开
- 不默认借 Dan Koe 的作者信号包来制造高级感

### 高拟态模式

正文目标是：

- 让作者动作组合出现在正文里
- 不只是出现“系统 / 地图 / 主权 / 复利”这些公共词
- 真正体现开头动作、重定义路径、抽象抬升方式、结尾收束方式
- 至少让一个完整的作者动作链贯穿正文，而不是零散撒点作者信号

### 降级后的强文章

如果触发降级：

- 正文仍然要像一篇完整成稿
- 默认不要把内部决策过程写进 `response.md`
- 默认把降级原因留在 `run_summary.md`
- 赢点应该是“更稳、更可发”，而不是“更会解释自己为什么降级”

## 当前硬约束

1. 不读取 `form-normalized-anchors/`
2. 不要求用户先初始化自己的 profile
3. 不把用户 memory 当默认前提
4. 高拟态模式里，作者资产优先于通用素材库
5. 一旦超出作者议题带宽，直接降级，不硬装像

## 当前阶段的责任边界

这版 skill 的责任，是把：

- runtime 收口协议
- 共同标准
- 强文章首批原型库
- 双模式边界
- Dan Koe、粥左罗、Justin Welsh、刘润、梁宁、薛辉正式作者 profile 雏形

整理成一个更正式、更可触发、更可评测的入口。

它当前**不负责**：

- 完整功能实现
- 多作者并行调用
- 与旧 skill 的深层 runtime 融合
