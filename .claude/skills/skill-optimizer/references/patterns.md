# Skill Design Patterns for Optimization Work

这份文件不是大全，只保留对“优化已有 Skill”最有用的模式判断。

---

## 1. Inversion

适用于：

- 需要先理解用户真正需求
- 不能靠猜测直接改写

在这个 Skill 里，Inversion 的作用是：

- 先还原原 Skill 的真实目的
- 先区分“核心合同”与“当前写法”

如果不做这一步，优化很容易跑偏。

---

## 2. Reviewer

适用于：

- 需要按清单审查现状
- 需要把“看什么”和“怎么判断”分开

在这个 Skill 里，Reviewer 主要用来做诊断，而不是直接做改写。

---

## 3. Pipeline

适用于：

- 顺序很重要
- 中途需要确认点

在这个 Skill 里，Pipeline 的顺序应该固定为：

1. freeze baseline
2. review
3. propose
4. approval gate
5. apply
6. preservation check

不要跳步骤。

---

## 4. Experiment Spine

适用于：

- 想把“建议”升级成“可验证的提案”
- 需要 before / after 证据
- 不想直接走全自动 Darwin 式循环

在这个 Skill 里，Experiment Spine 的作用是：

1. 明确失败模式
2. 设计代表性 prompt
3. 定义核心假设
4. 单轮只改一个主要杠杆
5. 用 replay / dry-run / human review 看差异
6. 决定 keep / revise / revert

它的作用不是追求“科学感”，而是降低幻觉式优化。

---

## 5. Generator

适用于：

- 需要稳定地输出模板化结果

在这个 Skill 里，Generator 只在两个地方出现：

- 生成 baseline contract
- 生成 optimization proposal

以及在用户批准后，生成改写后的 Skill 草稿。

---

## 6. Explain Why, Not Just What

如果你发现自己在写：

- ALWAYS
- NEVER
- MUST

先问一句：

这个约束能不能改写成“为什么这样更好”？

优化 Skill 时，解释 why 往往比堆规则更稳。

---

## 7. Proxy Metrics, Not Fake Absolutes

如果任务本身很感性，比如写作、风格、判断感、用户偏好，不要假装一个总分能解决一切。

更稳的做法是：

- 先定义合同型指标：有没有跑偏
- 再定义代理型指标：有没有更贴近目标输出
- 最后把真实用户反馈留给人工判断或长期校准

优化器需要的是**分层验证**，不是伪装成“完全客观”。

---

## 8. Preserve the Baseline

优化不是重做。

如果某轮优化：

- 只是看起来更规范
- 但没有明显提升 trigger / clarity / maintainability
- 或者需要靠改合同才能显得更好

那就应该保留 baseline，而不是硬改。
