# Profile Probe｜通过标准

## stable 90 readiness

只有当下面条件同时成立，才算某个 built-in profile 达到 `stable 90 readiness`：

1. **至少 2 个不同 probe 题目独立冷评都 >= 90**
2. 两个 probe 都不命中 veto
3. 两个 probe 的像度差异主要落在正文动作链，不靠说明层补解释

## 不算通过的情况

- 某一篇 probe 单篇过 90
- 同一题目润很多轮才过 90
- 只能靠 `run_summary.md` 解释为什么像
- 过线主要来自题材好运，而不是 profile 稳定性

## 何时可判阶段性通过

如果还没达到 `stable 90 readiness`，但出现下面情况，可以判为“阶段性通过”：

- 多个 probe 稳定进入高 80 分段
- 失败模式已被锁定到单一薄层
- 后续主要工作已经转向 corpus 或 generation channel
