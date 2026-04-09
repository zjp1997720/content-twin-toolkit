# Profile Probe｜模块入口

## 这是什么

这是 `writing-clone-starter` 的**维护者内置评测模块**。

它解决的不是“给普通用户写一篇文章”，而是：

- 验证某个 built-in profile 是否真的能稳定产稿
- 判断某个作者 profile 是否达到 `stable 90 readiness`
- 用 blind probe 暴露作者资产的薄层，而不是靠主观感觉下结论

## 什么时候调用

只在下面场景调用：

1. 重测当前 built-in profile
2. 验证某个新 profile 是否过线
3. 做 blind probe / 冷评 / 稳定性验证
4. profile 已经 distill 完，但还不确定能不能真正带出作者味

## 什么时候不要调用

- 用户只是想写一篇文章
- 用户只是想切到某个已有作者方向起稿
- 用户只是想做普通改稿
- 用户只是想继续补素材，而不是验证 profile

这些情况继续走 `starter` 的正常写作路径，不要切进这个模块。

## 输入

最低输入通常包括：

- `author-id`
- 本轮 probe 题目
- 当前验证目标（高拟态 / 稳定 90 / 找薄层）
- 输出目录

## 输出

一次完整调用，默认至少产出：

1. `response.md`
2. `evaluator_score.md`
3. 可选：`run_summary.md`
4. 可选：`round_log.md`

## 默认执行顺序

1. 先读 `probe-protocol.md`
2. 再读 `pass-criteria.md`
3. 生成侧参考 `generator-brief-template.md`
4. 评分侧参考 `evaluator-template.md`
5. 轮次记录参考 `round-log-template.md`
6. 全程遵守 `anti-contamination.md`

## 边界提醒

- 这是维护者路径，不是普通用户默认触发路径
- 它验证 profile，不默认优化 probe 正文
- 它和 `profile-distillation/` 并列，不替代 `profile-distillation/`
