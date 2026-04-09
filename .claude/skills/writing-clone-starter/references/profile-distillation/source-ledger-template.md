# 人物 Profile 蒸馏｜证据账本模板

## 目的

这份模板负责保证：

- 每条正式 profile 特征可追溯
- 每次 profile 更新可复查
- 不同人物 profile 可横向比较质量

没有 ledger 的正式特征，不应进入 profile。

## 文件定位

每个新人物 profile 都必须生成：

`references/built-in-profiles/<author-id>/source-ledger.md`

## 推荐结构

### 条目 1

```md
## Feature: <特征名>

- 类型：worldview / move / signal / taboo / snippet / bandwidth
- 状态：formal / secondary / rejected
- 来源层：长文与著作层 / 长对话与访谈层 / 表达碎片层 / 决策与行为层 / 外部评价与批评层

### 证据来源

1. <文件或来源名>
   - 片段：...
   - 为什么相关：...
2. <文件或来源名>
   - 片段：...
   - 为什么相关：...

### 过门理由

- 跨场景复现：<为什么通过 / 未通过>
- 生成力：<为什么通过 / 未通过>
- 排他性：<为什么通过 / 未通过>

### 最终判断

- 是否进入正式资产：是 / 否
- 落在哪个文件：<worldview.md / recurring-moves.md / ...>
- 如果没进正式资产，为什么：...
```

## 必填字段

- 特征名
- 特征类型
- 来源层
- 至少 2 条证据（如果是 formal）
- 三重门判断
- 最终去向

## 使用规则

- `formal` 条目必须能回链到正式 profile 文件
- `rejected` 条目也保留，避免未来重复误收
- 更新 profile 时，先更新 ledger，再改正式文件

## 最低验收

如果 reviewer 随机点任意一条正式特征，必须能回答三件事：

1. 它来自哪里
2. 为什么它不是公共特征
3. 它最后进入了哪个正式资产文件
