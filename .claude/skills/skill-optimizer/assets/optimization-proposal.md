# Optimization Proposal

在用户确认前，先用这个模板输出提案。

## 1. Diagnosis Summary

- 当前 Skill 的核心问题：
- 当前 Skill 的优势：
- 当前最重要的失败模式：

## 2. Must-Fix Issues

- 会直接影响 trigger / clarity / reliability 的问题：

## 3. Recommended Improvements

- 值得优化，但不属于必须修的问题：

## 4. Sensitive Areas

- 这些地方最容易因为“优化”而改变原 Skill 的意图或 I/O：

## 5. Validation Setup

- 本轮代表性测试 prompt：
- 本轮重点观察的 proxy signals：
- 评估方式：replay / dry_run / human review
- 如果只能 dry-run，原因是什么：

## 6. Option A — Conservative

- 改动范围：
- 核心假设：
- 主要验证方式：
- 预期收益：
- 风险：
- rollback trigger：
- 是否影响原合同：否 / 低 / 中 / 高

## 7. Option B — Balanced

- 改动范围：
- 核心假设：
- 主要验证方式：
- 预期收益：
- 风险：
- rollback trigger：
- 是否影响原合同：否 / 低 / 中 / 高

## 8. Option C — Deep (Only if warranted)

- 改动范围：
- 核心假设：
- 主要验证方式：
- 预期收益：
- 风险：
- rollback trigger：
- 是否影响原合同：否 / 低 / 中 / 高

## 9. Recommendation

- 我推荐哪一版：
- 为什么：
- 为什么它比 baseline 更值得试：

## 10. Approval Gate

- 是否进入 apply：等待用户确认
- 如果进入 apply，本轮只批准哪一个方案：

## 11. Evidence Needed Before Keep

- 哪些结果出现后才建议 keep：
- 哪些结果出现后应建议 revise：
- 哪些结果出现后应建议 revert：
