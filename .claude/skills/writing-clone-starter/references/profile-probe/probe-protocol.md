# Profile Probe｜协议

## 核心目标

probe 的目标不是把某一篇文章磨到高分，而是：

> 用一篇篇探针文章，暴露当前 profile 的薄层与稳定性边界。

## 核心原则

### 1. probe 文章不是优化对象

- 每一轮正文只用于暴露 profile 的优缺点
- 不要围绕某一篇 probe 反复打磨到高分
- 如果同一题连续多轮都卡住，优先判定是 profile 资产没收口，而不是继续润正文

### 2. 评分结果优先回写 profile

- `evaluator_score.md` 的失分项，默认优先回写到：
  - `recurring-moves.md`
  - `hard-signals.md`
  - `contrastive-pairs.md`
  - `snippet-bank.md`
  - `false-positive-signals.md`
  - `acceptance-checklist.md`
- 不默认回写到 probe 正文

### 3. 通过标准是 profile 通过，不是单篇通过

- 某一篇 probe 过 90，不代表 profile 达标
- 只有多个不同 probe 都稳定过线，才代表 profile 达标

### 4. 先停手，再判因果

如果一篇 probe 连续多轮卡在同一位置：

1. 先停掉正文优化
2. 回看 profile 资产
3. 再判断是 corpus 不够、profile 不够，还是 generation channel 不够

## 推荐最小流程

1. 选题
2. 生成正文
3. 独立冷评
4. 抽失分项
5. 回写 profile
6. 换题再测

## 何时该停止继续 probe

出现下面任一情况，先暂停 probe，改动 profile 或 corpus：

- 连续两轮卡在同一类中段解释腔
- 同一题目只能靠润正文提分
- run summary 比 response 更像作者
- 分数波动主要来自题材运气，而不是 profile 稳定性
