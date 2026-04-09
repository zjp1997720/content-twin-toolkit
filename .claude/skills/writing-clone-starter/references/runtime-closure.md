# writing-clone-starter｜运行时收口协议

## 目的

这份文件不负责补新能力。

它只负责把 starter 已有资产组织成一条统一运行链，避免模型每次都靠临场理解自己拼接流程。

## 一、总原则

starter 只有两条路径：

1. **强文章主路径**
2. **高拟态显式分支**

其中：

- 强文章是默认主工作模式
- 高拟态只在用户显式指定作者时才尝试进入
- 高拟态一旦超带宽，立刻降级回强文章

## 二、统一判定顺序

每次处理请求时，默认按下面顺序执行：

### Step 1：先判用户是否显式指定作者

- 明确说“按 Dan Koe 写”“像 Dan Koe 那样写” → 进入 Dan Koe 高拟态候选
- 明确说“按粥左罗写”“像粥左罗那样写” → 进入粥左罗高拟态候选
- 明确说“按 Justin Welsh 写”“像 Justin Welsh 那样写” → 进入 Justin Welsh 高拟态候选
- 明确说“按刘润写”“像刘润那样写” → 进入刘润高拟态候选
- 明确说“按梁宁写”“像梁宁那样写” → 进入梁宁高拟态候选
- 明确说“按薛辉写”“像薛辉那样写” → 进入薛辉高拟态候选
- 没有显式指定作者 → 直接进入强文章主路径

### Step 2：如果进入高拟态候选，先判带宽

按对应作者的 `topic-bandwidth.md` 判断：

- Dan Koe → `references/built-in-profiles/dankoe/topic-bandwidth.md`
- 粥左罗 → `references/built-in-profiles/zhouzuoluo/topic-bandwidth.md`
- Justin Welsh → `references/built-in-profiles/justinwelsh/topic-bandwidth.md`
- 刘润 → `references/built-in-profiles/liurun/topic-bandwidth.md`
- 梁宁 → `references/built-in-profiles/liangning/topic-bandwidth.md`
- 薛辉 → `references/built-in-profiles/xuehui/topic-bandwidth.md`

统一规则：

- 核心带宽：可直接进入高拟态
- 邻近带宽：可进入高拟态，但正文要更谨慎
- 弱带宽：直接降级到强文章

### Step 3：如果降级，先收口呈现方式

- 降级原因默认写入 `run_summary.md`
- `response.md` 默认直接交付干净的强文章成稿
- 不把“我现在按规则降级”写成正文第一句

### Step 4：进入强文章主路径后，再判原型

按 `references/archetype-router.md` 判断：

1. 方法教程型
2. 案例复盘型
3. 观点拆解型
4. 认知升级型

拿不准时，只问一个关键问题：

> 这篇文章最重要的是让读者改变判断、学会方法、看懂案例，还是升级理解框架？

### Step 5：原型确定后，再组织取料与正文

顺序固定为：

1. 读共同标准
2. 读命中的原型正文合同
3. 按原型取料策略决定素材库介入方式
4. 用 anti-bleed 规则检查是否串味

不要反过来先取一堆素材，再临场决定文章骨架。

## 三、强文章主路径

### 强文章不是 fallback

强文章不是“写不成作者拟态时的退路”，而是 starter 的默认主工作模式。

未指定作者时，直接走：

1. `strong-article-rubric.md`
2. `archetype-router.md`
3. `content-archetypes/<命中的原型>.md`
4. `library-first-retrieval.md`
5. `archetype-anti-bleed.md`

### 强文章的主目标

- 正文成立
- 原型清楚
- 素材不空
- 不串味到作者拟态

## 四、高拟态显式分支

### 进入条件

- 用户显式指定作者
- 且主题没有命中弱带宽降级条件

### 默认读取顺序（Dan Koe）

1. `high-likeness-rubric.md`
2. `dankoe/profile-card.md`
3. `dankoe/worldview.md`
4. `dankoe/recurring-moves.md`
5. `dankoe/taboo-moves.md`
6. `dankoe/snippet-bank.md`
7. `dankoe/topic-bandwidth.md`
8. `dankoe/hard-signals.md`
9. `dankoe/contrastive-pairs.md`
10. `dankoe/false-positive-signals.md`
11. `dankoe/acceptance-checklist.md`
12. `dankoe/raw-corpus/README.md`

### 默认读取顺序（粥左罗）

1. `high-likeness-rubric.md`
2. `zhouzuoluo/profile-card.md`
3. `zhouzuoluo/worldview.md`
4. `zhouzuoluo/recurring-moves.md`
5. `zhouzuoluo/taboo-moves.md`
6. `zhouzuoluo/snippet-bank.md`
7. `zhouzuoluo/topic-bandwidth.md`
8. `zhouzuoluo/hard-signals.md`
9. `zhouzuoluo/contrastive-pairs.md`
10. `zhouzuoluo/false-positive-signals.md`
11. `zhouzuoluo/acceptance-checklist.md`
12. `zhouzuoluo/raw-corpus/README.md`

### 默认读取顺序（Justin Welsh）

1. `high-likeness-rubric.md`
2. `justinwelsh/profile-card.md`
3. `justinwelsh/worldview.md`
4. `justinwelsh/recurring-moves.md`
5. `justinwelsh/taboo-moves.md`
6. `justinwelsh/snippet-bank.md`
7. `justinwelsh/topic-bandwidth.md`
8. `justinwelsh/hard-signals.md`
9. `justinwelsh/contrastive-pairs.md`
10. `justinwelsh/false-positive-signals.md`
11. `justinwelsh/acceptance-checklist.md`
12. `justinwelsh/raw-corpus/README.md`

### 默认读取顺序（刘润）

1. `high-likeness-rubric.md`
2. `liurun/profile-card.md`
3. `liurun/worldview.md`
4. `liurun/recurring-moves.md`
5. `liurun/taboo-moves.md`
6. `liurun/snippet-bank.md`
7. `liurun/topic-bandwidth.md`
8. `liurun/hard-signals.md`
9. `liurun/contrastive-pairs.md`
10. `liurun/false-positive-signals.md`
11. `liurun/acceptance-checklist.md`
12. `liurun/raw-corpus/README.md`

### 默认读取顺序（梁宁）

1. `high-likeness-rubric.md`
2. `liangning/profile-card.md`
3. `liangning/worldview.md`
4. `liangning/recurring-moves.md`
5. `liangning/taboo-moves.md`
6. `liangning/snippet-bank.md`
7. `liangning/topic-bandwidth.md`
8. `liangning/hard-signals.md`
9. `liangning/contrastive-pairs.md`
10. `liangning/false-positive-signals.md`
11. `liangning/acceptance-checklist.md`
12. `liangning/raw-corpus/README.md`

### 默认读取顺序（薛辉）

1. `high-likeness-rubric.md`
2. `xuehui/profile-card.md`
3. `xuehui/worldview.md`
4. `xuehui/recurring-moves.md`
5. `xuehui/taboo-moves.md`
6. `xuehui/snippet-bank.md`
7. `xuehui/topic-bandwidth.md`
8. `xuehui/hard-signals.md`
9. `xuehui/contrastive-pairs.md`
10. `xuehui/false-positive-signals.md`
11. `xuehui/acceptance-checklist.md`
12. `xuehui/raw-corpus/README.md`

### 分支提醒

- 高拟态不是默认主入口
- 不要因为题目“听起来很像某作者会写”就主动切过去
- 作者像度主要看动作链，不看公共词表

## 五、输出合同

### `response.md`

这是主成品，也是模式质量主证据。

默认应满足：

- 直接从标题或正文第一段开始
- 不出现 system note 风格说明
- 不默认解释模式选择、带宽判断、读取依据

### `run_summary.md`

这是辅助说明层，不是正文的补丁层。

默认只记录：

- 最终模式
- 是否命中原型 / 命中哪个原型
- 是否命中带宽限制
- 读取了哪些关键资产
- 若发生降级，为什么降级

### 总判断

先看 `response.md`，再看 `run_summary.md`。

如果模式差异主要靠 summary 才能看出来，说明 runtime 仍没收口成功。

## 六、降级呈现合同

如果任一高拟态作者触发降级：

1. 模式切回强文章
2. 原因留在 `run_summary.md`
3. `response.md` 直接按强文章正文合同交付
4. 只有用户明确追问原因时，才单独解释

## 七、最小回归锚点

`evals/evals.json` 中现有 15 条 eval，不只是测试样例，也是 starter 当前运行协议的最小回归锚点：

1. **强文章默认进入** 是否成立
2. **Dan Koe 高拟态进入** 是否成立
3. **Dan Koe 超带宽降级** 是否成立
4. **粥左罗高拟态进入** 是否成立
5. **粥左罗超带宽降级** 是否成立
6. **粥左罗正文级高拟态进入** 是否成立
7. **粥左罗正文差异对照** 是否成立
8. **Justin Welsh 高拟态进入** 是否成立
9. **Justin Welsh 超带宽降级** 是否成立
10. **刘润高拟态进入** 是否成立
11. **刘润超带宽降级** 是否成立
12. **梁宁高拟态进入** 是否成立
13. **梁宁超带宽降级** 是否成立
14. **薛辉高拟态进入** 是否成立
15. **薛辉超带宽降级** 是否成立

未来任何 runtime 改动，至少不能破坏这些作者入口与降级主链。

## 八、运行前自检

正式生成前，至少快速自检 5 个问题：

1. 我现在走的是强文章还是高拟态？
2. 如果是高拟态，我先做过带宽判断了吗？
3. 如果是强文章，我已经判定原型了吗？
4. 我现在的正文骨架，是先定原型再取料，还是先取料再拼结构？
5. 我有没有把内部决策过程误写进正文？
