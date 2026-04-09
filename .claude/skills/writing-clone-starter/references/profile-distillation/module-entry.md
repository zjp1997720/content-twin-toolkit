# 人物 Profile 蒸馏｜模块入口

## 这是什么

这是 `writing-clone-starter` 的**维护者内置模块**。

它的职责不是帮普通用户直接写文章，而是：

- 新增一个大 IP 的内置作者 profile
- 更新已有作者 profile
- 审计某个作者 profile 的证据质量

## 什么时候调用

只在下面场景调用：

1. 要新增一个内置作者
2. 要更新已有作者资产
3. 要检查某个作者 profile 是否证据不足、结构失衡或素材断层

## 什么时候不要调用

- 用户只是想写一篇文章
- 用户只是想切到已有作者方向写一稿
- 用户只是想继续补普通素材库，而不是蒸馏人物 profile

这些情况应该继续走 starter 的正常写作路径，而不是进这个重模块。

## 输入

最低输入通常包括：

- 人物名 / author-id
- 希望蒸馏的范围（全面画像 or 聚焦某维度）
- 当前已有材料范围（若有）

## 输出

一次完整调用，默认至少产出：

1. `references/built-in-profiles/<author-id>/` 下的正式 profile 资产
2. `source-ledger.md`
3. `02_素材库/` 下的同步素材资产

## 默认执行思路

1. 按 `research-layers.md` 收证据
2. 用 `extraction-gates.md` 过门
3. 按 `profile-output-template.md` 生成资产
4. 用 `material-sync.md` 完成素材库联动
5. 按 `profile-validation.md` 做最小验证

## 边界提醒

- 这是维护者路径，不是普通学员默认触发路径
- 优先工具链可以弹性替换，但最终闭环不能变
- profile 资产和素材资产必须一起完成，不能只交一半
