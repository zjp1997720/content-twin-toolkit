# Test Prompt Schema

在进入实验或验证前，先用这张卡设计最小验证集。

目标不是追求“全面测试”，而是用最少的 prompt 看清：

- 当前 Skill 有没有跑偏
- 候选改动有没有真实收益
- 收益是不是建立在边界漂移之上

## 最小集合

默认准备 3 个 prompt，必要时再加第 4 个。

### 1. Happy Path

- 用户最常见、最典型的请求
- 用来验证：Skill 的主能力有没有更清楚、更稳定

格式：

- `prompt`：
- `expected_signals`：
- `failure_signals`：

### 2. Ambiguous / Slightly Complex

- 稍复杂、稍含糊，但仍属于应该处理的范围
- 用来验证：Skill 在真实语境里会不会失去主线

格式：

- `prompt`：
- `expected_signals`：
- `failure_signals`：

### 3. Adjacent Non-Goal

- 看起来接近，但本质上不该被这个 Skill 接管的请求
- 用来验证：优化是否只是把边界做宽

格式：

- `prompt`：
- `expected_signals`：
- `failure_signals`：

### 4. Regression Prompt（可选）

- 当用户提到“之前那一类问题”或该 Skill 有明确历史短板时再加
- 用来验证：这轮改动不会把老问题重新带回来

格式：

- `prompt`：
- `expected_signals`：
- `failure_signals`：

## 设计原则

1. prompt 要像真实用户会说的话，不要写成测试说明书
2. `expected_signals` 写“希望出现什么特征”，不要写“期待逐字输出什么”
3. 至少保留一个 non-goal prompt，防止伪改进
4. 不要堆太多 prompt；优先保证代表性
