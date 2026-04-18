# Risk Tiering

优化已有 Skill 时，先判断风险等级。

风险等级不是为了显得专业，而是为了决定：

- 这次该停在 Audit / Proposal
- 还是可以进入 Guided Experiment / Iterative Optimization

## 低风险

典型特征：

- 主要是表达层、结构层、引用层问题
- 核心用途和 I/O 很稳定
- 改动容易回滚
- 就算误改，损失也有限

例如：

- description 触发描述过短
- references 没接好
- phase 结构不清楚
- fallback 缺失但边界清晰

默认允许：

- Audit
- Proposal
- Guided Experiment
- 在用户明确同意下进入 Iterative Optimization

## 中风险

典型特征：

- 会影响交互顺序
- 会影响 trigger 边界
- 会改变用户对该 Skill 的使用预期
- 有可能让“能做什么 / 不能做什么”变得模糊

例如：

- 加入新的 gate
- 收紧或放宽触发范围
- 改主要输出协议
- 把静态审查 Skill 改成带自动执行的 Skill

默认允许：

- Audit
- Proposal
- Guided Experiment

默认不要直接进入多轮 Iterative Optimization。

## 高风险

典型特征：

- 可能改变核心职责
- 可能改变主要 I/O
- 可能破坏原 Skill 的真实用途
- 优化对象本身高度感性、争议大、难以离线验证

例如：

- 把“优化”做成“重构职责”
- 把人类确认移除
- 对写作、风格、强人格类 Skill 直接用单一分数驱动自动迭代

默认允许：

- Audit
- Proposal

只有在用户明确批准、且范围非常小的时候，才做一轮 Guided Experiment。

## 判定原则

拿不准时，按更高风险处理，而不是更低风险。
